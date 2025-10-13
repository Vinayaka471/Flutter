import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/panchanga_day.dart';
import '../providers/app_state.dart';
import '../utils/data_utils.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  static const String routeName = '/calendar';

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDay;
  late TimeOfDay _displayTime;
  late _SunTimes _sunTimes;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateUtils.dateOnly(now);
    _displayTime = TimeOfDay.fromDateTime(now);
    _sunTimes = _sunTimesFor(_selectedDay);
  }

  void _applySelection(DateTime date, AppState appState, {TimeOfDay? time}) {
    final DateTime normalized = DateUtils.dateOnly(date);
    setState(() {
      _focusedMonth = DateTime(normalized.year, normalized.month, 1);
      _selectedDay = normalized;
      _displayTime = time ?? _displayTime;
      _sunTimes = _sunTimesFor(normalized);
    });
    appState.onPageChanged(_focusedMonth);
    appState.onDaySelected(_selectedDay, _focusedMonth);
  }

  void _changeMonth(int offset, AppState appState) {
    _applySelection(DateTime(_focusedMonth.year, _focusedMonth.month + offset, 1), appState);
  }

  void _shiftDay(int offset, AppState appState) {
    _applySelection(_selectedDay.add(Duration(days: offset)), appState);
  }

  void _selectToday(AppState appState) {
    final DateTime now = DateTime.now();
    _applySelection(now, appState, time: TimeOfDay.fromDateTime(now));
  }

  List<List<DateTime>> _triangularRowsFor(DateTime month) {
    final List<DateTime> days = PanchangaDataUtils
        .monthGridDays(month)
        .where((DateTime day) => day.month == month.month)
        .toList();

    final List<List<DateTime>> rows = <List<DateTime>>[];
    int index = 0;
    int rowLength = 1;

    while (index < days.length) {
      final int remaining = days.length - index;
      final int length = math.min(rowLength, remaining);
      rows.add(days.sublist(index, index + length));
      index += length;
      rowLength += 1;
    }

    return rows;
  }

  _SunTimes _sunTimesFor(DateTime date) {
    final List<_SunTimes> base = <_SunTimes>[
      _SunTimes(const TimeOfDay(hour: 6, minute: 38), const TimeOfDay(hour: 17, minute: 58)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 30), const TimeOfDay(hour: 18, minute: 8)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 18), const TimeOfDay(hour: 18, minute: 18)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 2), const TimeOfDay(hour: 18, minute: 27)),
      _SunTimes(const TimeOfDay(hour: 5, minute: 52), const TimeOfDay(hour: 18, minute: 33)),
      _SunTimes(const TimeOfDay(hour: 5, minute: 49), const TimeOfDay(hour: 18, minute: 37)),
      _SunTimes(const TimeOfDay(hour: 5, minute: 55), const TimeOfDay(hour: 18, minute: 37)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 1), const TimeOfDay(hour: 18, minute: 28)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 6), const TimeOfDay(hour: 18, minute: 13)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 11), const TimeOfDay(hour: 17, minute: 58)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 19), const TimeOfDay(hour: 17, minute: 49)),
      _SunTimes(const TimeOfDay(hour: 6, minute: 27), const TimeOfDay(hour: 17, minute: 47)),
    ];
    final int index = (date.month - 1).clamp(0, base.length - 1);
    final _SunTimes pivot = base[index];
    final int delta = (date.day % 4) - 1;
    return _SunTimes(_shiftTime(pivot.sunrise, -delta), _shiftTime(pivot.sunset, delta));
  }

  TimeOfDay _shiftTime(TimeOfDay time, int delta) {
    final int total = time.hour * 60 + time.minute + delta;
    final int clamped = total.clamp(0, 1439);
    return TimeOfDay(hour: clamped ~/ 60, minute: clamped % 60);
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final List<List<DateTime>> triangularRows = _triangularRowsFor(_focusedMonth);
    final PanchangaDay? info = PanchangaDataUtils.dayFor(_selectedDay);
    final List<String> festivals = PanchangaDataUtils.festivalsFor(_selectedDay);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFFF8EC), Color(0xFFFFEFD6), Color(0xFFFCE3BD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _ScreenHeader(onToggleTheme: appState.toggleTheme),
                      const SizedBox(height: 18),
                      _HeroPanel(
                        date: _selectedDay,
                        time: _displayTime,
                        sun: _sunTimes,
                        info: info,
                      ),
                      const SizedBox(height: 16),
                      _DaySwitcherRow(
                        onYesterday: () => _shiftDay(-1, appState),
                        onToday: () => _selectToday(appState),
                        onTomorrow: () => _shiftDay(1, appState),
                      ),
                      const SizedBox(height: 16),
                      _MonthBanner(
                        month: _focusedMonth,
                        onPrevious: () => _changeMonth(-1, appState),
                        onNext: () => _changeMonth(1, appState),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _TriangularCalendar(
                    rows: triangularRows,
                    month: _focusedMonth,
                    selectedDay: _selectedDay,
                    onDayTap: (DateTime date) => _applySelection(date, appState),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                sliver: SliverToBoxAdapter(
                  child: _PanchangaInfoCard(
                    date: _selectedDay,
                    panchangaDay: info,
                    festivals: festivals,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ಸನಾತನ ಪಂಚಾಂಗ',
                style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w800, color: _Palette.accent),
              ),
              const SizedBox(height: 4),
              Text(
                'ಶ್ರೀ ಶಬ್ದಿಮಠ ಕನ್ನಡ ಪಂಚಾಂಗ',
                style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: _Palette.textPrimary),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onToggleTheme,
          icon: const Icon(Icons.brightness_6_rounded),
          color: _Palette.accent,
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.date, required this.time, required this.sun, required this.info});

  final DateTime date;
  final TimeOfDay time;
  final _SunTimes sun;
  final PanchangaDay? info;

  String _format(TimeOfDay value) {
    final int hour = value.hourOfPeriod == 0 ? 12 : value.hourOfPeriod;
    final String minute = value.minute.toString().padLeft(2, '0');
    final String suffix = value.period == DayPeriod.am ? 'ಪೂರ್ವಾಹ್ನ' : 'ಅಪರಾಹ್ನ';
    return '$hour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final String kannadaDay = PanchangaDataUtils.kannadaWeekdayLabel(date);
    final String formattedDate = DateFormat('d MMMM yyyy').format(date);
    final List<String> festivals = PanchangaDataUtils.festivalsFor(date);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(colors: <Color>[Color(0xFFF97316), Color(0xFFFACC15)]),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x33F97316), blurRadius: 22, offset: Offset(0, 12)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('ಇಂದು', style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9))),
                const SizedBox(height: 4),
                Text(kannadaDay, style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 6),
                Text(formattedDate, style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.92))),
                const SizedBox(height: 10),
                Text('ಸಮಯ: ${_format(time)}', style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.92))),
                Text('ಸೂರ್ಯೋದಯ: ${_format(sun.sunrise)}', style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.92))),
                Text('ಸೂರ್ಯಾಸ್ತ: ${_format(sun.sunset)}', style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.92))),
                if (info != null) ...<Widget>[
                  const SizedBox(height: 10),
                  Text('ತಿಥಿ: ${info!.tithi}', style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text('ನಕ್ಷತ್ರ: ${info!.nakshatra}', style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text('ಯೋಗ: ${info!.yoga}', style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
                if (festivals.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Text('ಇಂದಿನ ಹಬ್ಬಗಳು', style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF2D1B00))),
                  const SizedBox(height: 4),
                  ...festivals.take(3).map((String name) => Text('• $name', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.notoSansKannada(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF2D1B00)))),
                  if (festivals.length > 3)
                    Text('+${festivals.length - 3}', style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF2D1B00))),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/images/devi.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white.withValues(alpha: 0.18),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySwitcherRow extends StatelessWidget {
  const _DaySwitcherRow({required this.onYesterday, required this.onToday, required this.onTomorrow});

  final VoidCallback onYesterday;
  final VoidCallback onToday;
  final VoidCallback onTomorrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _SwitcherButton(label: 'ನಿನ್ನೆ', color: const Color(0xFF166534), onTap: onYesterday)),
        const SizedBox(width: 12),
        Expanded(child: _SwitcherButton(label: 'ಇಂದು', color: const Color(0xFFF97316), onTap: onToday)),
        const SizedBox(width: 12),
        Expanded(child: _SwitcherButton(label: 'ನಾಳೆ', color: const Color(0xFFE11D48), onTap: onTomorrow)),
      ],
    );
  }
}

class _TriangularCalendar extends StatelessWidget {
  const _TriangularCalendar({required this.rows, required this.month, required this.selectedDay, required this.onDayTap});

  final List<List<DateTime>> rows;
  final DateTime month;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double rowSpacing = 14;
        const double cellSpacing = 12;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int rowIndex = 0; rowIndex < rows.length; rowIndex++)
              Padding(
                padding: EdgeInsets.only(bottom: rowIndex == rows.length - 1 ? 0 : rowSpacing),
                child: _TriangularRow(
                  dates: rows[rowIndex],
                  month: month,
                  selectedDay: selectedDay,
                  maxWidth: constraints.maxWidth,
                  cellSpacing: cellSpacing,
                  onDayTap: onDayTap,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TriangularRow extends StatelessWidget {
  const _TriangularRow({
    required this.dates,
    required this.month,
    required this.selectedDay,
    required this.maxWidth,
    required this.cellSpacing,
    required this.onDayTap,
  });

  final List<DateTime> dates;
  final DateTime month;
  final DateTime selectedDay;
  final double maxWidth;
  final double cellSpacing;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final double totalSpacing = cellSpacing * (math.max(0, dates.length - 1));
    final double cellWidth = (maxWidth - totalSpacing) / dates.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int index = 0; index < dates.length; index++)
          Padding(
            padding: EdgeInsets.only(right: index == dates.length - 1 ? 0 : cellSpacing),
            child: SizedBox(
              width: cellWidth,
              child: _CalendarCell(
                date: dates[index],
                month: month,
                selectedDay: selectedDay,
                today: DateTime.now(),
                onTap: () => onDayTap(dates[index]),
              ),
            ),
          ),
      ],
    );
  }
}

class _SwitcherButton extends StatelessWidget {
  const _SwitcherButton({required this.label, required this.color, required this.onTap});

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: Text(label),
    );
  }
}

class _MonthBanner extends StatelessWidget {
  const _MonthBanner({required this.month, required this.onPrevious, required this.onNext});

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final String monthLabel = '${PanchangaDataUtils.kannadaMonthLabel(month)} ${month.year}';
    return Row(
      children: <Widget>[
        _MonthNavButton(icon: Icons.chevron_left, onTap: onPrevious),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFFFFEDD5),
              border: Border.all(color: _Palette.accent, width: 1.2),
            ),
            alignment: Alignment.center,
            child: Text(monthLabel, style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: _Palette.accent)),
          ),
        ),
        _MonthNavButton(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _Palette.accent,
          side: const BorderSide(color: _Palette.accent, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({required this.date, required this.month, required this.selectedDay, required this.today, this.onTap});

  final DateTime date;
  final DateTime month;
  final DateTime selectedDay;
  final DateTime today;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isCurrentMonth = date.month == month.month;
    final bool isSelected = DateUtils.isSameDay(date, selectedDay);
    final bool isToday = DateUtils.isSameDay(date, today);
    final bool isSunday = date.weekday == DateTime.sunday;
    final List<String> festivals = isCurrentMonth ? PanchangaDataUtils.festivalsFor(date) : <String>[];
    final PanchangaDay? info = isCurrentMonth ? PanchangaDataUtils.dayFor(date) : null;

    final Color borderColor = isSelected
        ? _Palette.accent
        : isSunday
            ? _Palette.sunday
            : (isCurrentMonth && festivals.isNotEmpty)
                ? _Palette.festival
                : _Palette.normalDay;
    final Color background = isCurrentMonth ? borderColor.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.35);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1.1),
            color: background,
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${date.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isSelected ? _Palette.accent : _Palette.textPrimary)),
                  if (isToday && isCurrentMonth) const Icon(Icons.star_rate_rounded, size: 16, color: _Palette.accent),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                PanchangaDataUtils.kannadaWeekdayLabel(date),
                style: GoogleFonts.notoSansKannada(fontSize: 10, fontWeight: FontWeight.w700, color: isSunday ? _Palette.sunday : _Palette.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (info != null && info.tithi.trim().isNotEmpty) ...<Widget>[
                const SizedBox(height: 4),
                Text(info.tithi, style: GoogleFonts.notoSansKannada(fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              if (info != null && info.nakshatra.trim().isNotEmpty) ...<Widget>[
                const SizedBox(height: 2),
                Text(info.nakshatra, style: GoogleFonts.notoSansKannada(fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              if (festivals.isNotEmpty) ...<Widget>[
                const SizedBox(height: 4),
                Text(festivals.first, style: GoogleFonts.notoSansKannada(fontSize: 10, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                if (festivals.length > 1)
                  Text('+${festivals.length - 1}', style: GoogleFonts.notoSansKannada(fontSize: 9, fontWeight: FontWeight.w600, color: _Palette.mutedText)),
              ],
              const Spacer(),
              Text(DateFormat('dd MMM').format(date), style: GoogleFonts.notoSansKannada(fontSize: 9, fontWeight: FontWeight.w600, color: _Palette.mutedText)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanchangaInfoCard extends StatelessWidget {
  const _PanchangaInfoCard({required this.date, required this.panchangaDay, required this.festivals});

  final DateTime date;
  final PanchangaDay? panchangaDay;
  final List<String> festivals;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: _Palette.accent);
    final TextStyle bodyStyle = GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: _Palette.textPrimary);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _Palette.accent.withValues(alpha: 0.28), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: _Palette.cardShadow, offset: Offset(0, 4), blurRadius: 12),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(DateFormat('EEEE, d MMMM yyyy').format(date), style: titleStyle),
              if (festivals.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _Palette.festival.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text('ಹಬ್ಬ', style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w700, color: _Palette.festivalDark)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (panchangaDay != null) ...<Widget>[
            Text('ತಿಥಿ: ${panchangaDay!.tithi}', style: bodyStyle),
            Text('ನಕ್ಷತ್ರ: ${panchangaDay!.nakshatra}', style: bodyStyle),
            Text('ಯೋಗ: ${panchangaDay!.yoga}', style: bodyStyle),
            Text('ಕರಣ: ${panchangaDay!.karana}', style: bodyStyle),
            Text('ಪಕ್ಷ: ${panchangaDay!.paksha}', style: bodyStyle),
            const SizedBox(height: 12),
          ],
          if (festivals.isNotEmpty) ...<Widget>[
            Text('ಮುಂದಿನ ಉತ್ಸವಗಳು', style: titleStyle.copyWith(fontSize: 14)),
            const SizedBox(height: 6),
            ...festivals.map((String e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text('• $e', style: bodyStyle),
                )),
          ]
          else
            Text('ಈ ದಿನ ವಿಶೇಷ ಉತ್ಸವಗಳಿಲ್ಲ', style: bodyStyle.copyWith(color: _Palette.mutedText)),
        ],
      ),
    );
  }
}

class _Palette {
  static const Color accent = Color(0xFFF97316);
  static const Color sunday = Color(0xFFE11D48);
  static const Color festival = Color(0xFFFACC15);
  static const Color festivalDark = Color(0xFFB45309);
  static const Color normalDay = Color(0xFF16A34A);
  static const Color textPrimary = Color(0xFF1F1307);
  static const Color mutedText = Color(0xFF94A3B8);
  static const Color cardShadow = Color(0x11000000);
}

class _SunTimes {
  _SunTimes(this.sunrise, this.sunset);

  final TimeOfDay sunrise;
  final TimeOfDay sunset;
}
