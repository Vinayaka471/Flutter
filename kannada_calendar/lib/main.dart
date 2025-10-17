import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/daily_calendar_screen.dart';
import 'screens/panchanga_screen.dart';
import 'screens/mantra_screen.dart';
import 'screens/account_screen.dart';

void main() {
  runApp(const KannadaCalendarApp());
}

class KannadaCalendarApp extends StatelessWidget {
  const KannadaCalendarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ಕಾಲಸಿರಿ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.black,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
      ),

      // ✅ Kannada Localization setup
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('kn', 'IN'), // Kannada
        Locale('en', 'US'), // English fallback
      ],
      locale: const Locale('kn', 'IN'),

      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [
    DailyCalendarScreen(),
    PanchangaScreen(),
    MantraScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics:
            const PageScrollPhysics(), // ✅ Enables smooth horizontal swiping
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'ದಿನದ ಕ್ಯಾಲೆಂಡರ್',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'ಪಂಚಾಂಗ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'ಮಂತ್ರಗಳು',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ನಿಮ್ಮ ಖಾತೆ',
          ),
        ],
      ),
    );
  }
}
