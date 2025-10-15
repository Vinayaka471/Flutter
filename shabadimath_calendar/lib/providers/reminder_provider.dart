import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/reminder.dart';
import '../services/reminder_scheduler.dart';

class ReminderProvider extends ChangeNotifier {
  ReminderProvider(this._scheduler) {
    _box = Hive.box<Reminder>(_boxName);
    _reminders = <Reminder>[..._box.values]..sort(_byDueDate);
    scheduleMicrotask(() async {
      for (final Reminder reminder in _reminders) {
        await _scheduler.schedule(reminder);
      }
    });
  }

  static const String _boxName = 'reminders';

  final ReminderScheduler _scheduler;
  late final Box<Reminder> _box;
  late List<Reminder> _reminders;
  final Uuid _uuid = const Uuid();

  List<Reminder> get reminders => List<Reminder>.unmodifiable(_reminders);

  List<Reminder> get upcomingReminders {
    final DateTime now = DateTime.now();
    final List<Reminder> filtered = _reminders
        .where((Reminder reminder) => reminder.dueDateTime().isAfter(now) || reminder.repeat != ReminderRepeat.none)
        .toList()
      ..sort(_byDueDate);
    return filtered;
  }

  Future<Reminder> addReminder({
    required String title,
    required DateTime date,
    TimeOfDay? time,
    ReminderRepeat repeat = ReminderRepeat.none,
    String? description,
  }) async {
    final Reminder reminder = Reminder(
      id: _uuid.v4(),
      title: title,
      date: date,
      hour: time?.hour,
      minute: time?.minute,
      repeat: repeat,
      description: description,
    );
    await _box.put(reminder.id, reminder);
    _reminders = <Reminder>[..._box.values]..sort(_byDueDate);
    await _scheduler.schedule(reminder);
    notifyListeners();
    return reminder;
  }

  Future<void> updateReminder(
    Reminder reminder, {
    required String title,
    required DateTime date,
    TimeOfDay? time,
    ReminderRepeat repeat = ReminderRepeat.none,
    String? description,
  }) async {
    reminder
      ..title = title
      ..date = date
      ..hour = time?.hour
      ..minute = time?.minute
      ..repeat = repeat
      ..description = description;
    await reminder.save();
    _reminders = <Reminder>[..._box.values]..sort(_byDueDate);
    await _scheduler.schedule(reminder);
    notifyListeners();
  }

  Future<void> deleteReminder(Reminder reminder) async {
    await _scheduler.cancel(reminder.id);
    await reminder.delete();
    _reminders = <Reminder>[..._box.values]..sort(_byDueDate);
    notifyListeners();
  }

  Comparator<Reminder> get _byDueDate => (Reminder a, Reminder b) => a.dueDateTime().compareTo(b.dueDateTime());
}
