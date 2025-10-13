import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/panchanga_day.dart';
import '../providers/app_state.dart';
import '../utils/data_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import 'mantra_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _MantraTabContent extends StatelessWidget {
  const _MantraTabContent();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFFFF7E6), Color(0xFFFFF1D0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: PanchangaDataUtils.mantras.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (BuildContext context, int index) {
          final mantra = PanchangaDataUtils.mantras[index];
          return GlassCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[mantra.primaryColor, mantra.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: mantra.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mantra.title,
                      style: GoogleFonts.notoSansKannada(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ...mantra.lines.map(
                      (String line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          line,
                          style: GoogleFonts.notoSansKannada(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FestivalsComingSoonContent extends StatelessWidget {
  const _FestivalsComingSoonContent();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFE0F2FE), Color(0xFFDBEAFE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: GlassCard(
          borderRadius: 28,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.event_available_rounded, size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'ಉತ್ಸವಗಳ ವಿಭಾಗ ಶೀಘ್ರದಲ್ಲೇ',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'ಪೂರ್ಣ ಮಾಸದ ಉತ್ಸವ ಮತ್ತು ವಿಶೇಷ ದಿನಗಳ ವಿವರಗಳನ್ನು ಇಲ್ಲಿ ನೋಡಬಹುದು. تازهಪಡಿಸುತ್ತಿದ್ದೇವೆ!',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansKannada(fontSize: 14.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _HomeSection { daily, monthly, mantra, festivals }

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _months;
  late DateTime _dailyMonth;
  late DateTime _monthlyMonth;
  late PageController _pageController;
  int _navIndex = 0;
  _HomeSection _section = _HomeSection.daily;
  late Timer _clockTimer;
  late DateTime _headerDateTime;
  late DateTime _calendarDate;

  @override
  void initState() {
    super.initState();
    final AppState state = Provider.of<AppState>(context, listen: false);
    final DateTime selectedDay = state.selectedDay;
    _months = PanchangaDataUtils.monthsForYear(selectedDay.year);
    _dailyMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    _monthlyMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    _tabController = TabController(length: _months.length, vsync: this, initialIndex: _monthlyMonth.month - 1);
    _tabController.addListener(_handleTabChange);
    _pageController = PageController(initialPage: _section.index);
    _headerDateTime = DateTime.now();
    _calendarDate = DateUtils.dateOnly(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      setState(() {
        _headerDateTime = DateTime.now();
      });
    });
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      return;
    }
    setState(() {
      _monthlyMonth = _months[_tabController.index];
    });
  }

  void _loadCalendar(DateTime date) {
    setState(() {
      _calendarDate = DateUtils.dateOnly(date);
      _dailyMonth = DateTime(_calendarDate.year, _calendarDate.month, 1);
    });
  }

  void _loadYesterdayCalendar() {
    _loadCalendar(_calendarDate.subtract(const Duration(days: 1)));
  }

  void _loadTodayCalendar() {
    _loadCalendar(DateTime.now());
  }

  void _loadTomorrowCalendar() {
    _loadCalendar(_calendarDate.add(const Duration(days: 1)));
  }

  void _goToPreviousMonth() {
    setState(() {
      _dailyMonth = DateTime(_dailyMonth.year, _dailyMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _dailyMonth = DateTime(_dailyMonth.year, _dailyMonth.month + 1, 1);
    });
  }

  String _formattedKannadaDate(DateTime date) {
    final String day = DateFormat('EEEE', 'kn_IN').format(date);
    final String month = DateFormat('MMMM', 'kn_IN').format(date);
    final String dayNumber = DateFormat('d').format(date);
    final String year = DateFormat('yyyy').format(date);
    return '$day $dayNumber $month $year';
  }

  String _formattedTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  String _calendarImageUrl(DateTime date) {
    final String day = DateFormat('dd').format(date);
    final String month = DateFormat('MM').format(date);
    final String year = DateFormat('yyyy').format(date);
    return 'https://kannadacalendar.in/wp-content/kannada/daily/$year/$month/$day-$month-$year.jpg';
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _pageController.dispose();
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = Provider.of<AppState>(context);
    final DateTime today = state.selectedDay;
    final List<DateTime?> monthCells = PanchangaDataUtils.monthCells(_dailyMonth);
    final DateTime headerMonth = _section == _HomeSection.monthly ? _monthlyMonth : _dailyMonth;
    final Widget dailyContent = _DailyContent(
      selectedMonth: _dailyMonth,
      today: today,
      monthCells: monthCells,
      calendarDate: _calendarDate,
      formattedDate: _formattedKannadaDate(_calendarDate),
      formattedTime: _formattedTime(_headerDateTime),
      calendarImageUrl: _calendarImageUrl(_calendarDate),
      onDaySheet: (DateTime date) => _openDaySheet(context, date, state),
      onYesterday: _loadYesterdayCalendar,
      onToday: _loadTodayCalendar,
      onTomorrow: _loadTomorrowCalendar,
      onPrevMonth: _goToPreviousMonth,
      onNextMonth: _goToNextMonth,
    );

    final Widget monthlyContent = _MonthlyContent(month: _monthlyMonth);
    final Widget mantraContent = const _MantraTabContent();
    final Widget festivalsContent = const _FestivalsComingSoonContent();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const _TempleBackdrop(),
          SafeArea(
            child: Column(
              children: <Widget>[
                _HeaderStrip(year: headerMonth.year),
                const SizedBox(height: 10),
                if (_section == _HomeSection.monthly) ...<Widget>[
                  _MonthTabBar(controller: _tabController, months: _months),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      if (page >= _HomeSection.values.length) {
                        return;
                      }
                      setState(() {
                        _section = _HomeSection.values[page];
                        _navIndex = page;
                      });
                    },
                    children: <Widget>[
                      dailyContent,
                      monthlyContent,
                      mantraContent,
                      festivalsContent,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _navIndex,
        onTap: (int index) async {
          if (index == _navIndex) {
            return;
          }
          switch (index) {
            case 0:
              setState(() {
                _section = _HomeSection.daily;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case 1:
              setState(() {
                _section = _HomeSection.monthly;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case 2:
              setState(() {
                _section = _HomeSection.mantra;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case 3:
              setState(() {
                _section = _HomeSection.festivals;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            default:
              setState(() {
                _section = _HomeSection.daily;
                _navIndex = index;
              });
          }
        },
      ),
    );
  }

  void _openDaySheet(BuildContext context, DateTime date, AppState state) {
    final ThemeData theme = Theme.of(context);
    final PanchangaDay? details = PanchangaDataUtils.dayFor(date);
    final LinkedHashSet<String> events = LinkedHashSet<String>.from(PanchangaDataUtils.festivalsFor(date));
    final String dayNameKannada = DateFormat('EEEE', 'kn_IN').format(date);
    final String monthNameKannada = DateFormat('MMMM', 'kn_IN').format(date);
    final String formattedDateLabel = '$dayNameKannada, ${date.day} $monthNameKannada ${date.year}';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 64,
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    formattedDateLabel,
                    style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  _detailRow(theme, 'ತಿಥಿ', details?.tithi ?? '—'),
                  _detailRow(theme, 'ಪಕ್ಷ', details?.paksha ?? '—'),
                  _detailRow(theme, 'ನಕ್ಷತ್ರ', details?.nakshatra ?? '—'),
                  _detailRow(theme, 'ಯೋಗ', details?.yoga ?? '—'),
                  _detailRow(theme, 'ಕರಣ', details?.karana ?? '—'),
                  if (events.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 18),
                    Text(
                      'ಉತ್ಸವಗಳು',
                      style: GoogleFonts.notoSansKannada(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...events.map(
                      (String festival) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $festival', style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text('ದಿನದ ಶಬ್ದ', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(state.dailyShabad.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(state.dailyShabad.gurmukhi, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: GoogleFonts.notoSansKannada(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.notoSansKannada(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavIcon extends StatelessWidget {
  const _CalendarNavIcon({required this.icon, required this.onTap, required this.background});

  final IconData icon;
  final VoidCallback onTap;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: background.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _HeaderStrip extends StatelessWidget {
  const _HeaderStrip({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF0F4AA3), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x400F4AA3), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ಸನಾತನ ಪಂಚಾಂಗ',
                style: GoogleFonts.notoSansKannada(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Sanātana Panchanga • $year',
                style: GoogleFonts.notoSansKannada(fontSize: 14.5, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.82)),
              ),
            ],
          ),
          const Icon(Icons.temple_hindu, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}

class _MonthTabBar extends StatelessWidget {
  const _MonthTabBar({required this.controller, required this.months});

  final TabController controller;
  final List<DateTime> months;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = months
        .map(
          (DateTime month) => Tab(
            child: Text(
              PanchangaDataUtils.kannadaMonthLabel(month),
              style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        )
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F4AA3), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: const Color(0xFF0F4AA3),
        unselectedLabelColor: const Color(0xFF64748B),
        indicator: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0F4AA3), width: 1.2),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        tabs: tabs,
      ),
    );
  }
}

class _DailyContent extends StatelessWidget {
  const _DailyContent({
    required this.selectedMonth,
    required this.today,
    required this.monthCells,
    required this.calendarDate,
    required this.formattedDate,
    required this.formattedTime,
    required this.calendarImageUrl,
    required this.onDaySheet,
    required this.onYesterday,
    required this.onToday,
    required this.onTomorrow,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime selectedMonth;
  final DateTime today;
  final List<DateTime?> monthCells;
  final DateTime calendarDate;
  final String formattedDate;
  final String formattedTime;
  final String calendarImageUrl;
  final ValueChanged<DateTime> onDaySheet;
  final VoidCallback onYesterday;
  final VoidCallback onToday;
  final VoidCallback onTomorrow;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: <Widget>[
          _DailyCalendarCard(
            date: calendarDate,
            formattedDate: formattedDate,
            currentTime: formattedTime,
            imageUrl: calendarImageUrl,
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(child: _CalendarNavButton(label: 'ನಿನ್ನೆ', onTap: onYesterday, color: const Color(0xFF166534))),
              const SizedBox(width: 12),
              Expanded(child: _CalendarNavButton(label: 'ಇಂದು', onTap: onToday, color: const Color(0xFFF97316))),
              const SizedBox(width: 12),
              Expanded(child: _CalendarNavButton(label: 'ನಾಳೆ', onTap: onTomorrow, color: const Color(0xFFE11D48))),
            ],
          ),
          const SizedBox(height: 18),
          _CalendarBoard(
            month: selectedMonth,
            today: today,
            cells: monthCells,
            onDayTap: (DateTime date) => onDaySheet(date),
            onPrevMonth: onPrevMonth,
            onNextMonth: onNextMonth,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _MonthlyContent extends StatelessWidget {
  const _MonthlyContent({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final String? monthImage = PanchangaDataUtils.monthImageAsset(month);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (monthImage != null) ...<Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x140F172A), blurRadius: 14, offset: Offset(0, 8)),
                  ],
                ),
                child: Image.asset(
                  monthImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 320,
                    color: const Color(0xFFE2E8F0),
                    alignment: Alignment.center,
                    child: Text(
                      'ಚಿತ್ರ ಲಭ್ಯವಿಲ್ಲ',
                      style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF64748B)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          _MonthlyHighlights(month: month),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _DailyCalendarCard extends StatelessWidget {
  const _DailyCalendarCard({
    required this.date,
    required this.formattedDate,
    required this.currentTime,
    required this.imageUrl,
  });

  final DateTime date;
  final String formattedDate;
  final String currentTime;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF1E88E5).withValues(alpha: 0.18), width: 1.3),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x1A0F4AA3), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            formattedDate,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F4AA3)),
          ),
          const SizedBox(height: 4),
          Text(
            currentTime,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F4AA3).withValues(alpha: 0.75)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              width: double.infinity,
              child: _CalendarImage(imageUrl: imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarImage extends StatelessWidget {
  const _CalendarImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Container(
          color: const Color(0xFFE2E8F0),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.broken_image_outlined, size: 32, color: Color(0xFF64748B)),
              const SizedBox(height: 8),
              Text('ಚಿತ್ರ ನೋಡಲು ಸಾಧ್ಯವಾಗುತ್ತಿಲ್ಲ', style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  const _CalendarNavButton({required this.label, required this.onTap, required this.color});

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
      child: Text(label),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String monthLabelKannada = PanchangaDataUtils.kannadaMonthLabel(month);
    final String monthLabelEnglish = DateFormat('MMMM').format(month);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFF6DA), Color(0xFFFFEDD5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF3C969), width: 1.4),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x28F59E0B), blurRadius: 20, offset: Offset(0, 12)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _HeroInfoBox(
              title: 'ಮಾಸ ಮಾಹಾತ್ಮ್ಯ',
              bulletPoints: const <String>[
                'ವ್ರತ ಮತ್ತು ಹಬ್ಬಗಳ ವೈಶಿಷ್ಟ್ಯಗಳು',
                'ದೈನಂದಿನ ಆಚರಣೆಗಳಿಗೆ ಸೂಚನೆಗಳು',
                'ಪರಂಪರೆಯ ಮಾಂತ್ರಿಕ ವಾಕ್ಯಗಳು',
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 130,
                  width: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFFFD166), Color(0xFFF97316)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/devi.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.brightness_5, color: Colors.white.withValues(alpha: 0.9), size: 68),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$monthLabelKannada - $monthLabelEnglish',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF9C2F00)),
                ),
                const SizedBox(height: 6),
                Text(
                  'ಶ್ಲೋಕ, ಸಂತೋಚಿತ ಪದಗಳು ಹಾಗೂ ದೇವಿಯ ಆರಾಧನೆಗಾಗಿ ಮಾಸಿಕ ಮಾರ್ಗದರ್ಶಿ.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF7C4200)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _HeroInfoBox(
              title: 'ದಿನಚರ್ಯೆ',
              bulletPoints: const <String>[
                'ಪ್ರಾತಃಕಾಲದ ಜಪ ಮತ್ತು ಪಾರಾಯಣ',
                'ಪರಮಾತ್ಮನಿಗೆ ನೈವೇದ್ಯ ಸೂಚನೆ',
                'ಸಂಜೆ ದೀಪಾರಾಧನೆಯ ಮುಖ್ಯ ವಿಧಿ',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoBox extends StatelessWidget {
  const _HeroInfoBox({required this.title, required this.bulletPoints});

  final String title;
  final List<String> bulletPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF9C74F).withValues(alpha: 0.6), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFFB45309)),
          ),
          const SizedBox(height: 10),
          ...bulletPoints.map(
            (String point) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('• ', style: TextStyle(fontSize: 12, color: Color(0xFFB45309))),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.notoSansKannada(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF734200)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarBoard extends StatelessWidget {
  const _CalendarBoard({
    required this.month,
    required this.today,
    required this.cells,
    required this.onDayTap,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final DateTime today;
  final List<DateTime?> cells;
  final ValueChanged<DateTime> onDayTap;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final String kannadaMonth = PanchangaDataUtils.kannadaMonthLabel(month);
    final String englishMonth = DateFormat('MMMM').format(month);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 14, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: <Widget>[
                _CalendarNavIcon(
                  icon: Icons.chevron_left,
                  onTap: onPrevMonth,
                  background: const Color(0xFF1D4ED8),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$kannadaMonth - ${month.year}',
                        style: GoogleFonts.notoSansKannada(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${PanchangaDataUtils.kannadaMonthLabel(month)} • $englishMonth',
                        style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _CalendarNavIcon(
                  icon: Icons.chevron_right,
                  onTap: onNextMonth,
                  background: const Color(0xFF1D4ED8),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(color: Color(0xFFEFF6FF)),
            child: Row(
              children: PanchangaDataUtils.kannadaWeekdayShort
                  .map(
                    (String label) => Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: GridView.builder(
              itemCount: cells.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (BuildContext context, int index) {
                final DateTime? date = cells[index];
                if (date == null) {
                  return const SizedBox.shrink();
                }

                final bool isCurrentMonth = date.month == month.month;
                final bool isToday = DateUtils.isSameDay(date, today);
                final bool isSunday = date.weekday == DateTime.sunday;
                final List<String> festivals = PanchangaDataUtils.festivalsFor(date);
                final PanchangaDay? info = PanchangaDataUtils.dayFor(date);

                return _CalendarCell(
                  date: date,
                  info: info,
                  festivals: festivals,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isSunday: isSunday,
                  onTap: () => onDayTap(date),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.date,
    required this.info,
    required this.festivals,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSunday,
    required this.onTap,
  });

  final DateTime date;
  final PanchangaDay? info;
  final List<String> festivals;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSunday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFestival = festivals.isNotEmpty;
    final Color baseAccent = isToday
        ? const Color(0xFF16A34A)
        : (hasFestival ? const Color(0xFFB91C1C) : (isSunday ? const Color(0xFFDC2626) : const Color(0xFF0F172A)));
    final Color background = !isCurrentMonth
        ? const Color(0xFFF1F5F9)
        : (isToday
            ? const Color(0xFFD1FAE5)
            : (hasFestival
                ? const Color(0xFFFEE2E2)
                : (isSunday ? const Color(0xFFFEE2E2) : Colors.white)));
    final Color borderColor = isCurrentMonth
        ? (isToday ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0))
        : const Color(0xFFE2E8F0);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isCurrentMonth ? 1 : 0.45,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${date.day}',
                  style: GoogleFonts.notoSansKannada(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isCurrentMonth ? baseAccent : const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const Spacer(),
              if (hasFestival)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFFB91C1C), shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyHighlights extends StatelessWidget {
  const _MonthlyHighlights({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PanchangaDay> days = PanchangaDataUtils.daysForMonth(month);
    final List<PanchangaDay> festivalDays = days.where((PanchangaDay day) => (day.festivals?.isNotEmpty ?? false)).take(3).toList();

    final PanchangaDay? amavasyaDay = _matchTithi(days, 'amavasya');
    final PanchangaDay? purnimaDay = _matchTithi(days, 'purnima');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ಪ್ರಮುಖ ಸಂಭ್ರಮಗಳು',
            style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F4AA3)),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: <Widget>[
              if (festivalDays.isNotEmpty)
                ...festivalDays.map(
                  (PanchangaDay day) => _HighlightCard(
                    title: day.festivals!.first,
                    subtitle: DateFormat('d MMMM', 'kn_IN').format(day.date),
                    accent: const Color(0xFFEA580C),
                  ),
                ),
              if (amavasyaDay != null)
                _HighlightCard(
                  title: amavasyaDay.tithi,
                  subtitle: DateFormat('d MMMM', 'kn_IN').format(amavasyaDay.date),
                  accent: const Color(0xFF6366F1),
                ),
              if (purnimaDay != null)
                _HighlightCard(
                  title: purnimaDay.tithi,
                  subtitle: DateFormat('d MMMM', 'kn_IN').format(purnimaDay.date),
                  accent: const Color(0xFF22C55E),
                ),
              if (festivalDays.isEmpty && amavasyaDay == null && purnimaDay == null)
                _HighlightCard(
                  title: 'ಈ ತಿಂಗಳಲ್ಲಿิเศษ ಹಬ್ಬಗಳಿಲ್ಲ',
                  subtitle: 'ಪಂಚಾಂಗ ವಿಷಯವನ್ನು ಅಪ್ಡೇಟ್ ಮಾಡಿ',
                  accent: theme.colorScheme.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  PanchangaDay? _matchTithi(List<PanchangaDay> days, String keyword) {
    final String search = keyword.toLowerCase();
    for (final PanchangaDay day in days) {
      if (day.tithi.toLowerCase().contains(search)) {
        return day;
      }
    }
    return null;
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.title, required this.subtitle, required this.accent});

  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: <Color>[accent.withValues(alpha: 0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.32), width: 1.1),
        boxShadow: <BoxShadow>[
          BoxShadow(color: accent.withValues(alpha: 0.18), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w800, color: _darken(accent, 0.15)),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w600, color: accent.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Color _darken(Color color, double amount) {
    final double factor = 1 - amount;
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFFEA580C),
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.today_rounded), label: 'ದೈನಂದಿನ'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್'),
        BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'ಧ್ಯಾನ / ಮಂತ್ರಗಳು'),
        BottomNavigationBarItem(icon: Icon(Icons.event_available_outlined), label: 'ಉತ್ಸವಗಳು'),
      ],
    );
  }
}

class _TempleBackdrop extends StatelessWidget {
  const _TempleBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const GradientBackground(),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  const Color(0xFFFEE8C8).withValues(alpha: 0.65),
                  const Color(0xFFFFF5E6).withValues(alpha: 0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/patterns/sanskrit_texture.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
