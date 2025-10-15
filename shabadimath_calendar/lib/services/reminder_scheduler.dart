import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder.dart';

class ReminderScheduler with WidgetsBindingObserver {
  ReminderScheduler(this._navigatorKey) : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  tz.Location? _location;
  final GlobalKey<NavigatorState> _navigatorKey;
  final Map<int, Timer> _foregroundTimers = <int, Timer>{};
  Map<String, dynamic>? _pendingDialogData;

  static const MethodChannel _timeZoneChannel = MethodChannel('shabadimath_calendar/timezone');

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final bool? notificationsEnabled = await androidImplementation.areNotificationsEnabled();
      if (notificationsEnabled == false) {
        await androidImplementation.requestNotificationsPermission();
        debugPrint('[ReminderScheduler] Requested notification permission');
      }
      final bool? canScheduleExact = await androidImplementation.canScheduleExactNotifications();
      if (canScheduleExact == false) {
        await androidImplementation.requestExactAlarmsPermission();
        debugPrint('[ReminderScheduler] Requested exact alarm permission');
      }
    }

    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(alert: true, badge: true, sound: true);

    tz_data.initializeTimeZones();
    final tz.Location resolvedLocation = await _resolveLocalLocation();
    _location = resolvedLocation;
    tz.setLocalLocation(resolvedLocation);

    WidgetsBinding.instance.addObserver(this);

    const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      'reminders_channel',
      'Reminders',
      description: 'Festival and personal reminders',
      importance: Importance.high,
    );
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel);

    _initialized = true;
    await _processLaunchDetails();
  }

  Future<void> schedule(Reminder reminder) async {
    if (!_initialized || _location == null) {
      return;
    }
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final bool? notificationsEnabled = await androidImplementation.areNotificationsEnabled();
      final bool? canScheduleExact = await androidImplementation.canScheduleExactNotifications();
      if (notificationsEnabled == false || canScheduleExact == false) {
        debugPrint('[ReminderScheduler] Notifications enabled: $notificationsEnabled, canScheduleExact: $canScheduleExact');
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
        debugPrint('[ReminderScheduler] Re-requested permissions from schedule');
        final bool? notificationsEnabledAfter = await androidImplementation.areNotificationsEnabled();
        final bool? canScheduleExactAfter = await androidImplementation.canScheduleExactNotifications();
        if (notificationsEnabledAfter != true || canScheduleExactAfter != true) {
          debugPrint('[ReminderScheduler] Permissions still missing after request. Notifications enabled: $notificationsEnabledAfter, canScheduleExact: $canScheduleExactAfter');
          return;
        }
      }
    }
    final int notificationId = _idFor(reminder.id);
    await _plugin.cancel(notificationId);
    final tz.TZDateTime? nextInstance = _nextInstance(reminder);
    if (nextInstance == null) {
      return;
    }

    final String body = _bodyFor(reminder);
    debugPrint('[ReminderScheduler] Scheduling ${reminder.id} at ${nextInstance.toIso8601String()} with body: $body');
    _scheduleForegroundDialog(reminder, nextInstance, notificationId);
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Festival and personal reminders',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Reminder',
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.reminder,
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation(body, contentTitle: reminder.title),
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );
    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    DateTimeComponents? matchComponents;
    switch (reminder.repeat) {
      case ReminderRepeat.none:
        matchComponents = null;
        break;
      case ReminderRepeat.daily:
        matchComponents = DateTimeComponents.time;
        break;
      case ReminderRepeat.weekly:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case ReminderRepeat.yearly:
        matchComponents = DateTimeComponents.dateAndTime;
        break;
    }

    await _plugin.zonedSchedule(
      notificationId,
      reminder.title,
      body,
      nextInstance,
      notificationDetails,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: matchComponents,
      payload: jsonEncode(<String, dynamic>{
        'id': reminder.id,
        'title': reminder.title,
        'scheduledAt': nextInstance.toIso8601String(),
        'description': reminder.description,
      }),
    );
  }

  Future<void> cancel(String reminderId) async {
    final int notificationId = _idFor(reminderId);
    await _plugin.cancel(notificationId);
    _foregroundTimers.remove(notificationId)?.cancel();
  }

  int _idFor(String reminderId) => reminderId.hashCode & 0x7FFFFFFF;

  void _scheduleForegroundDialog(Reminder reminder, tz.TZDateTime scheduledAt, int notificationId) {
    _foregroundTimers.remove(notificationId)?.cancel();
    final tz.TZDateTime now = tz.TZDateTime.now(_location!);
    Duration delay = scheduledAt.difference(now);
    if (delay.isNegative) {
      delay = Duration.zero;
    }
    _foregroundTimers[notificationId] = Timer(delay, () async {
      final Map<String, dynamic> payload = _payloadFor(reminder, scheduledAt);
      final bool shown = await _tryShowDialog(payload, cancelNotificationId: notificationId);
      if (!shown) {
        _pendingDialogData = payload;
      }
      final tz.TZDateTime? upcoming = _nextInstance(reminder);
      if (upcoming != null) {
        _scheduleForegroundDialog(reminder, upcoming, notificationId);
      }
    });
  }

  Future<bool> _tryShowDialog(Map<String, dynamic> payload, {int? cancelNotificationId}) async {
    final AppLifecycleState? state = WidgetsBinding.instance.lifecycleState;
    if (state != null && state != AppLifecycleState.resumed) {
      return false;
    }
    final BuildContext? context = _navigatorKey.currentContext ?? _navigatorKey.currentState?.overlay?.context;
    if (context == null) {
      return false;
    }
    if (cancelNotificationId != null) {
      await _plugin.cancel(cancelNotificationId);
    }
    await _showReminderDialog(context, payload);
    return true;
  }

  Future<void> _showReminderDialog(BuildContext context, Map<String, dynamic> payload) async {
    final String title = payload['title'] as String? ?? '';
    final String? description = payload['description'] as String?;
    final String when = _formatScheduledAt(payload['scheduledAt'] as String?);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(title, style: theme.textTheme.headlineSmall),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(when, style: theme.textTheme.bodyMedium),
              if (description != null && description.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Text(description, style: theme.textTheme.bodyLarge),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processLaunchDetails() async {
    final NotificationAppLaunchDetails? details = await _plugin.getNotificationAppLaunchDetails();
    final NotificationResponse? response = details?.notificationResponse;
    if (response?.payload == null) {
      return;
    }
    final Map<String, dynamic>? payload = _parsePayload(response!.payload);
    if (payload == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bool shown = await _tryShowDialog(payload);
      if (!shown) {
        _pendingDialogData = payload;
      }
    });
  }

  void _onNotificationResponse(NotificationResponse response) async {
    final Map<String, dynamic>? payload = _parsePayload(response.payload);
    if (payload == null) {
      return;
    }
    final bool shown = await _tryShowDialog(payload);
    if (!shown) {
      _pendingDialogData = payload;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeShowPendingDialog();
    }
  }

  Future<void> _maybeShowPendingDialog() async {
    if (_pendingDialogData == null) {
      return;
    }
    final Map<String, dynamic> pending = _pendingDialogData!;
    _pendingDialogData = null;
    final bool shown = await _tryShowDialog(pending);
    if (!shown) {
      _pendingDialogData = pending;
    }
  }

  Map<String, dynamic> _payloadFor(Reminder reminder, tz.TZDateTime scheduledAt) {
    return <String, dynamic>{
      'id': reminder.id,
      'title': reminder.title,
      'scheduledAt': scheduledAt.toIso8601String(),
      'description': reminder.description,
    };
  }

  Map<String, dynamic>? _parsePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> decoded = jsonDecode(payload) as Map<String, dynamic>;
      return decoded;
    } catch (_) {
      return null;
    }
  }

  String _formatScheduledAt(String? isoString) {
    if (isoString == null || isoString.isEmpty) {
      return '';
    }
    final DateTime parsed = DateTime.parse(isoString).toLocal();
    final DateFormat formatter = DateFormat('d MMM yyyy, hh:mm a');
    return formatter.format(parsed);
  }

  tz.TZDateTime? _nextInstance(Reminder reminder) {
    final tz.Location location = _location!;
    final tz.TZDateTime now = tz.TZDateTime.now(location);
    tz.TZDateTime scheduled = tz.TZDateTime(
      location,
      reminder.date.year,
      reminder.date.month,
      reminder.date.day,
      reminder.hour ?? 8,
      reminder.minute ?? 0,
    );

    if (reminder.repeat == ReminderRepeat.none && !scheduled.isAfter(now)) {
      return null;
    }

    while (!scheduled.isAfter(now)) {
      switch (reminder.repeat) {
        case ReminderRepeat.none:
          return null;
        case ReminderRepeat.daily:
          scheduled = scheduled.add(const Duration(days: 1));
          break;
        case ReminderRepeat.weekly:
          scheduled = scheduled.add(const Duration(days: 7));
          break;
        case ReminderRepeat.yearly:
          scheduled = tz.TZDateTime(
            location,
            scheduled.year + 1,
            scheduled.month,
            scheduled.day,
            scheduled.hour,
            scheduled.minute,
          );
          break;
      }
    }

    return scheduled;
  }

  String _bodyFor(Reminder reminder) {
    final DateFormat formatter = DateFormat('d MMM yyyy, hh:mm a');
    final String formattedDateTime = formatter.format(reminder.dueDateTime());
    final List<String> segments = <String>['Event time: $formattedDateTime'];
    final String? description = reminder.description?.trim();
    if (description != null && description.isNotEmpty) {
      segments.add(description);
    }
    return segments.join('\n');
  }

  Future<tz.Location> _resolveLocalLocation() async {
    String? timeZoneName;
    try {
      final String? result = await _timeZoneChannel.invokeMethod<String>('getLocalTimezone');
      if (result != null && result.isNotEmpty) {
        timeZoneName = result;
      }
    } catch (_) {
      // ignore and attempt fallback strategies
    }

    if (timeZoneName != null && _isValidTimeZone(timeZoneName)) {
      return tz.getLocation(timeZoneName);
    }

    final Duration offset = DateTime.now().timeZoneOffset;
    final String? offsetMatch = _findTimeZoneByOffset(offset);
    if (offsetMatch != null) {
      return tz.getLocation(offsetMatch);
    }

    return tz.getLocation('UTC');
  }

  bool _isValidTimeZone(String name) => tz.timeZoneDatabase.locations.containsKey(name);

  String? _findTimeZoneByOffset(Duration offset) {
    for (final MapEntry<String, tz.Location> entry in tz.timeZoneDatabase.locations.entries) {
      final tz.TZDateTime now = tz.TZDateTime.now(entry.value);
      if (now.timeZoneOffset == offset) {
        return entry.key;
      }
    }
    return null;
  }
}
