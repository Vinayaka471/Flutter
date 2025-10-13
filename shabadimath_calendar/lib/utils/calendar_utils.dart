import 'package:intl/intl.dart';

import '../models/calendar_event.dart';
import '../models/shabad.dart';
import '../data/sample_data.dart';

class CalendarUtils {
  static final DateFormat _kannadaDayFormatter = DateFormat.EEEE('kn_IN');
  static final DateFormat _kannadaMonthFormatter = DateFormat.MMMM('kn_IN');

  static String formattedMonthYear(DateTime date) {
    final String monthName = _kannadaMonthFormatter.format(date);
    return '$monthName ${date.year}';
  }

  static String formattedDay(DateTime date, {bool includeYear = false}) {
    final String dayName = _kannadaDayFormatter.format(date);
    final String monthName = _kannadaMonthFormatter.format(date);
    final String baseLabel = '$dayName, ${date.day} $monthName';
    return includeYear ? '$baseLabel ${date.year}' : baseLabel;
  }

  static List<CalendarEvent> eventsForDay(List<CalendarEvent> events, DateTime day) {
    return events.where((CalendarEvent event) => _isSameDay(event.date, day)).toList();
  }

  static CalendarEvent? nextGurpurab(DateTime from, List<CalendarEvent> events) {
    final List<CalendarEvent> sorted = events
        .where((CalendarEvent event) =>
            event.date.isAfter(from.subtract(const Duration(days: 1))) &&
            event.isGurpurab)
        .toList()
      ..sort((CalendarEvent a, CalendarEvent b) => a.date.compareTo(b.date));
    return sorted.isNotEmpty ? sorted.first : null;
  }

  static Shabad dailyShabad(DateTime day) {
    final int index = day.difference(DateTime(2023, 1, 1)).inDays;
    return SampleData.shabads[index.abs() % SampleData.shabads.length];
  }

  static Map<DateTime, List<CalendarEvent>> eventMap(List<CalendarEvent> events) {
    final Map<DateTime, List<CalendarEvent>> value = <DateTime, List<CalendarEvent>>{};
    for (final CalendarEvent event in events) {
      final DateTime key = DateTime(event.date.year, event.date.month, event.date.day);
      value.putIfAbsent(key, () => <CalendarEvent>[]).add(event);
    }
    return value;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
