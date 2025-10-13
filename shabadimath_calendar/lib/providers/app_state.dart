import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/sample_data.dart';
import '../models/calendar_event.dart';
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
  }

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late Shabad _dailyShabad;
  late CalendarEvent? _nextGurpurab;
  late Map<DateTime, List<CalendarEvent>> _eventsByDay;
  late final List<CalendarEvent> _allEvents;
  bool _isDarkMode = false;

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  Shabad get dailyShabad => _dailyShabad;
  CalendarEvent? get nextGurpurab => _nextGurpurab;
  Map<DateTime, List<CalendarEvent>> get eventsByDay => _eventsByDay;
  List<CalendarEvent> get allEvents => _allEvents;
  bool get isDarkMode => _isDarkMode;

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

  Shabad? shabadById(String id) {
    try {
      return SampleData.shabads.firstWhere((Shabad shabad) => shabad.id == id);
    } catch (_) {
      return null;
    }
  }
}
