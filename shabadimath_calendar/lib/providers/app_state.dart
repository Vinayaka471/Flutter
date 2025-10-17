import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../data/sample_data.dart';
import '../models/calendar_event.dart';
import '../models/day_annotation.dart';
import '../models/shabad.dart';
import '../utils/calendar_utils.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime(_selectedDay.year, _selectedDay.month, 1);
    _allEvents = SampleData.events;
    _eventsByDay = CalendarUtils.eventMap(_allEvents);
    _dailyShabad = CalendarUtils.dailyShabad(_selectedDay);
    _nextGurpurab = CalendarUtils.nextGurpurab(DateTime.now(), _allEvents);
    _initAnnotationStore();
  }

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Shabad _dailyShabad;
  late CalendarEvent? _nextGurpurab;
  late Map<DateTime, List<CalendarEvent>> _eventsByDay;
  late final List<CalendarEvent> _allEvents;
  bool _isDarkMode = false;
  final Map<DateTime, DayAnnotation> _dayAnnotations = <DateTime, DayAnnotation>{};
  Box<Map<dynamic, dynamic>>? _annotationBox;

  Future<void> _initAnnotationStore() async {
    _annotationBox = await Hive.openBox<Map<dynamic, dynamic>>('day_annotations');
    _loadStoredAnnotations();
  }

  void _loadStoredAnnotations() {
    final Box<Map<dynamic, dynamic>>? box = _annotationBox;
    if (box == null) {
      return;
    }
    final Map<DateTime, DayAnnotation> loaded = <DateTime, DayAnnotation>{};
    for (final MapEntry<dynamic, Map<dynamic, dynamic>> entry in box.toMap().entries) {
      final dynamic key = entry.key;
      final Map<dynamic, dynamic> rawValue = entry.value;
      if (key is String) {
        final DateTime? parsed = DateTime.tryParse(key);
        if (parsed != null) {
          loaded[DateTime(parsed.year, parsed.month, parsed.day)] = DayAnnotation.fromJson(rawValue.cast<String, dynamic>());
        }
      }
    }
    if (loaded.isNotEmpty) {
      _dayAnnotations
        ..clear()
        ..addAll(loaded);
      notifyListeners();
    }
  }

  Future<void> _persistAnnotation(DateTime day, DayAnnotation? annotation) async {
    final Box<Map<dynamic, dynamic>>? box = _annotationBox;
    if (box == null) {
      return;
    }
    final String key = _normalized(day).toIso8601String();
    if (annotation == null || !annotation.hasContent) {
      if (box.containsKey(key)) {
        await box.delete(key);
      }
      return;
    }
    await box.put(key, annotation.toJson());
  }

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  Shabad get dailyShabad => _dailyShabad;
  CalendarEvent? get nextGurpurab => _nextGurpurab;
  Map<DateTime, List<CalendarEvent>> get eventsByDay => _eventsByDay;
  List<CalendarEvent> get allEvents => _allEvents;
  bool get isDarkMode => _isDarkMode;
  UnmodifiableMapView<DateTime, DayAnnotation> get dayAnnotations => UnmodifiableMapView<DateTime, DayAnnotation>(_dayAnnotations);

  List<CalendarEvent> eventsForDay(DateTime day) {
    return _eventsByDay[DateTime(day.year, day.month, day.day)] ?? <CalendarEvent>[];
  }

  String formattedSelectedDay() {
    return CalendarUtils.formattedDay(_selectedDay);
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    _dailyShabad = CalendarUtils.dailyShabad(selected);
    _nextGurpurab = CalendarUtils.nextGurpurab(DateTime.now(), _allEvents);
    notifyListeners();
  }

  void onPageChanged(DateTime focused) {
    _focusedDay = focused;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  List<CalendarEvent> upcomingEvents() {
    final DateTime today = DateTime.now();
    final DateTime todayStart = DateTime(today.year, today.month, today.day);
    final List<CalendarEvent> filtered = _allEvents
        .where((CalendarEvent event) => !event.date.isBefore(todayStart))
        .toList()
      ..sort((CalendarEvent a, CalendarEvent b) => a.date.compareTo(b.date));
    return filtered.take(5).toList();
  }

  String sunriseTime() {
    return DateFormat('hh:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 5, 35));
  }

  String sunsetTime() {
    return DateFormat('hh:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 15));
  }

  String tithiInfo() {
    return 'Panchami';
  }

  String nakshatraInfo() {
    return 'Rohini';
  }

  String muhurtaInfo() {
    return 'Amrit Vela';
  }

  DayAnnotation? annotationForDay(DateTime day) {
    return _dayAnnotations[_normalized(day)];
  }

  void saveAnnotation(DateTime day, DayAnnotation annotation) {
    final DateTime key = _normalized(day);
    if (!annotation.hasContent) {
      if (_dayAnnotations.remove(key) != null) {
        notifyListeners();
      }
      _persistAnnotation(day, null);
      return;
    }
    _dayAnnotations[key] = annotation;
    notifyListeners();
    _persistAnnotation(day, annotation);
  }

  void clearAnnotation(DateTime day) {
    final DateTime key = _normalized(day);
    if (_dayAnnotations.remove(key) != null) {
      notifyListeners();
    }
    _persistAnnotation(day, null);
  }

  Shabad? shabadById(String id) {
    try {
      return SampleData.shabads.firstWhere((Shabad shabad) => shabad.id == id);
    } catch (_) {
      return null;
    }
  }

  DateTime _normalized(DateTime day) => DateTime(day.year, day.month, day.day);
}
