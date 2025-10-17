import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/day_annotation.dart';
import '../providers/app_state.dart';

// Helper function to compare dates without time
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  static const String routeName = '/calendar';

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void _applySelection(DateTime date, AppState appState) {
    setState(() {
      _selectedDate = date;
      _focusedDay = date;
    });
    appState.onDaySelected(date, date);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendar'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          extendBodyBehindAppBar: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TableCalendar<DayAnnotation>(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const <CalendarFormat, String>{
                CalendarFormat.month: 'Month',
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              rowHeight: 52,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: Theme.of(context).textTheme.titleMedium!,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const BoxDecoration(),
              ),
              daysOfWeekHeight: 28,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                weekendStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                cellMargin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                cellAlignment: Alignment.center,
                isTodayHighlighted: false,
                selectedDecoration: const BoxDecoration(),
                todayDecoration: const BoxDecoration(),
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
                _openAnnotationEditor(selectedDay, appState);
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders<DayAnnotation>(
                defaultBuilder: (context, day, focusedDay) => _buildDayCell(
                  context,
                  day,
                  appState,
                  isSelected: false,
                  isToday: isSameDay(day, DateTime.now()),
                ),
                todayBuilder: (context, day, focusedDay) => _buildDayCell(
                  context,
                  day,
                  appState,
                  isSelected: false,
                  isToday: true,
                ),
                selectedBuilder: (context, day, focusedDay) => _buildDayCell(
                  context,
                  day,
                  appState,
                  isSelected: true,
                  isToday: isSameDay(day, DateTime.now()),
                ),
                outsideBuilder: (context, day, focusedDay) => _buildDayCell(
                  context,
                  day,
                  appState,
                  isSelected: false,
                  isToday: false,
                  isOutside: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    AppState appState, {
    required bool isSelected,
    required bool isToday,
    bool isOutside = false,
  }) {
    final normalized = DateTime(day.year, day.month, day.day);
    final annotation = appState.dayAnnotations[normalized];
    final highlight = annotation?.colorKey != null
        ? _annotationHighlights[annotation!.colorKey!]
        : null;

    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : isToday
            ? theme.colorScheme.primary.withOpacity(0.45)
            : Colors.transparent;

    final bool hasAnnotation = highlight != null;

    final textColor = isOutside
        ? Colors.grey.shade400
        : isSelected
            ? theme.colorScheme.primary
            : Colors.black87;

    return GestureDetector(
      onTap: () => _openAnnotationEditor(day, appState),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: highlight != null
                ? highlight.accent
                : (isSelected
                    ? theme.colorScheme.primary.withOpacity(0.18)
                    : Colors.transparent),
            border: Border.all(
              color: highlight != null
                  ? highlight.accent.withOpacity(0.95)
                  : (isToday && !isSelected
                      ? theme.colorScheme.primary.withOpacity(0.45)
                      : Colors.transparent),
              width: highlight != null ? 1.4 : (isToday && !isSelected ? 1.2 : 0),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: hasAnnotation ? Colors.white : textColor,
                    fontWeight: (isSelected || isToday || hasAnnotation) ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (hasAnnotation)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: highlight!.background,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAnnotationEditor(DateTime date, AppState appState) async {
    _applySelection(date, appState);
    final DayAnnotation? existing = appState.annotationForDay(date);
    final result = await showDialog<_AnnotationEditorResult>(
      context: context,
      builder: (context) => _AnnotationEditorDialog(date: date, initial: existing),
    );

    if (!mounted || result == null) return;

    if (result.shouldClear) {
      appState.clearAnnotation(date);
    } else if (result.annotation != null) {
      final DayAnnotation sanitized = result.annotation!.copyWith(
        note: '',
        emojis: const <String>[],
      );
      appState.saveAnnotation(date, sanitized);
    }
    setState(() {}); // Refresh the UI
  }
}

class _AnnotationHighlight {
  const _AnnotationHighlight({required this.background, required this.accent});

  final Color background;
  final Color accent;
}

const Map<String, _AnnotationHighlight> _annotationHighlights = <String, _AnnotationHighlight>{
  'red': _AnnotationHighlight(
    background: Color(0xFFFFEBEE),
    accent: Color(0xFFD32F2F),
  ),
  'pink': _AnnotationHighlight(
    background: Color(0xFFFCE4EC),
    accent: Color(0xFFC2185B),
  ),
  'purple': _AnnotationHighlight(
    background: Color(0xFFF3E5F5),
    accent: Color(0xFF7B1FA2),
  ),
  'indigo': _AnnotationHighlight(
    background: Color(0xFFE8EAF6),
    accent: Color(0xFF303F9F),
  ),
  'teal': _AnnotationHighlight(
    background: Color(0xFFE0F2F1),
    accent: Color(0xFF00796B),
  ),
  'bronze': _AnnotationHighlight(
    background: Color(0xFFF3E0D7),
    accent: Color(0xFFCC7722),
  ),
  'yellow': _AnnotationHighlight(
    background: Color(0xFFFFF8E1),
    accent: Color(0xFFFFA000),
  ),
  'orange': _AnnotationHighlight(
    background: Color(0xFFFFF3E0),
    accent: Color(0xFFF57C00),
  ),
  'brown': _AnnotationHighlight(
    background: Color(0xFFEFEBE9),
    accent: Color(0xFF5D4037),
  ),
  'blue': _AnnotationHighlight(
    background: Color(0xFFE3F2FD),
    accent: Color(0xFF1976D2),
  ),
};

class _AnnotationEditorResult {
  const _AnnotationEditorResult({
    this.annotation,
    this.shouldClear = false,
  });

  final DayAnnotation? annotation;
  final bool shouldClear;
}

class _AnnotationEditorDialog extends StatefulWidget {
  const _AnnotationEditorDialog({
    required this.date,
    this.initial,
  });

  final DateTime date;
  final DayAnnotation? initial;

  @override
  _AnnotationEditorDialogState createState() => _AnnotationEditorDialogState();
}

class _AnnotationEditorDialogState extends State<_AnnotationEditorDialog> {
  String? _selectedColorKey;

  @override
  void initState() {
    super.initState();
    _selectedColorKey = widget.initial?.colorKey;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> colorKeys = _annotationHighlights.keys.toList();

    return AlertDialog(
      title: Text(
        'Add Annotation',
        style: GoogleFonts.notoSansKannada(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select a color:',
            style: GoogleFonts.notoSansKannada(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colorKeys.map((String key) {
              final palette = _annotationHighlights[key]!;
              final isSelected = _selectedColorKey == key;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedColorKey = key),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: palette.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? palette.accent : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: palette.accent)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _AnnotationEditorResult(shouldClear: true)),
          child: Text('Clear', style: GoogleFonts.notoSansKannada()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.notoSansKannada()),
        ),
        FilledButton(
          onPressed: _selectedColorKey != null
              ? () => Navigator.pop(
                    context,
                    _AnnotationEditorResult(
                      annotation: DayAnnotation(colorKey: _selectedColorKey, note: '', emojis: []),
                    ),
                  )
              : null,
          child: Text('Save', style: GoogleFonts.notoSansKannada()),
        ),
      ],
    );
  }
}