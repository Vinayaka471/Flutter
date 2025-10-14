import 'dart:collection';

import 'package:flutter/material.dart';

import '../data/panchanga_data.dart';
import '../models/mantra.dart';
import '../models/panchanga_day.dart';

class PanchangaDataUtils {
  PanchangaDataUtils._();

  static const Map<int, String> kannadaWeekdayMap = <int, String>{
    DateTime.monday: 'ಸೋಮವಾರ',
    DateTime.tuesday: 'ಮಂಗಳವಾರ',
    DateTime.wednesday: 'ಬುಧವಾರ',
    DateTime.thursday: 'ಗುರುವಾರ',
    DateTime.friday: 'ಶುಕ್ರವಾರ',
    DateTime.saturday: 'ಶನಿವಾರ',
    DateTime.sunday: 'ಭಾನುವಾರ',
  };

  static const List<String> kannadaWeekdayShort = <String>['ಭಾನು', 'ಸೋಮ', 'ಮಂಗಳ', 'ಬುಧ', 'ಗುರು', 'ಶುಕ್ರ', 'ಶನಿ'];

  static const Map<int, String> kannadaMonths = <int, String>{
    1: 'ಜನವರಿ',
    2: 'ಫೆಬ್ರವರಿ',
    3: 'ಮಾರ್ಚ್',
    4: 'ಏಪ್ರಿಲ್',
    5: 'ಮೇ',
    6: 'ಜೂನ್',
    7: 'ಜುಲೈ',
    8: 'ಆಗಸ್ಟ್',
    9: 'ಸೆಪ್ಟೆಂಬರ್',
    10: 'ಅಕ್ಟೋಬರ್',
    11: 'ನವೆಂಬರ್',
    12: 'ಡಿಸೆಂಬರ್',
  };

  static const Map<int, String> monthlyCalendarImages = <int, String>{
    1: 'assets/images/monthly/2025_01_january.jpg',
    2: 'assets/images/monthly/2025_02_february.jpg',
    3: 'assets/images/monthly/2025_03_march.jpg',
    4: 'assets/images/monthly/2025_04_april.jpg',
    5: 'assets/images/monthly/2025_05_may.jpg',
    6: 'assets/images/monthly/2025_06_june.jpg',
    7: 'assets/images/monthly/2025_07_july.jpg',
    8: 'assets/images/monthly/2025_08_august.jpg',
    9: 'assets/images/monthly/2025_09_september.jpg',
    10: 'assets/images/monthly/2025_10_october.jpg',
    11: 'assets/images/monthly/2025_11_november.jpg',
    12: 'assets/images/monthly/2025_12_december.jpg',
  };

  static final Map<String, String> _festivalTranslations = <String, String>{
    'Navodaya': 'ನವೋದಯ',
    'Subhakrutha Samvatsara Arambha': 'ಶುಭಕೃತ ಸಂವತ್ಸರ ಆರಂಭ',
    'Chandra Darshana': 'ಚಂದ್ರ ದರ್ಶನ',
    'Sankashti Chaturthi': 'ಸಂಕಷ್ಟಿ ಚತುರ್ಥಿ',
    'Vaikunta Ekadashi Utsava': 'ವೈಕುಂಟ ಏಕಾದಶಿ ಉತ್ಸವ',
    'Pradosha': 'ಪ್ರದೋಷ',
    'Skanda Sashti': 'ಸ್ಕಂದ ಷಷ್ಠಿ',
    'Putrada Ekadashi': 'ಪುತ್ರದಾ ಏಕಾದಶಿ',
    'Tulasi Damodara Dwadashi': 'ತುಳಸಿ ದಾಮೋದರ ದ್ವಾದಶಿ',
    'Bogi Habba': 'ಬೋಗಿ ಹಬ್ಬ',
    'Makara Sankranti': 'ಮಕರ ಸಂಕ್ರಾಂತಿ',
    'Ellu-Bella Habba': 'ಎಳ್ಳು ಬೆಲ್ಲ ಹಬ್ಬ',
    'Pongal': 'ಪೊಂಗಲ್',
    'Uttarayana Punya Kala': 'ಉತ್ತರಾಯಣ ಪುಣ್ಯ ಕಾಲ',
    'Full Moon Satyanarayana Puja': 'ಪೂರ್ಣಿಮೆ ಸತ್ಯನಾರಾಯಣ ಪೂಜೆ',
    'Karidina': 'ಕರಿದಿನ',
    'Shashthi Vrata': 'ಷಷ್ಠಿ ವ್ರತ',
    'Masika Shivaratri': 'ಮಾಸಿಕ ಶಿವರಾತ್ರಿ',
    'Navaratri Begins': 'ನವರಾತ್ರಿ ಪ್ರಾರಂಭ',
    'Ayudha Pooja': 'ಆಯುಧ ಪೂಜೆ',
    'Vijayadashami': 'ವಿಜಯದಶಮಿ',
    'Deepavali': 'ದೀಪಾವಳಿ',
    'Narak Chaturdashi': 'ನರಕ ಚತುರ್ಧಶಿ',
    'Govardhan Puja': 'ಗೋವರ್ಧನ ಪೂಜೆ',
    'Bhai Dooj': 'ಭಾಯಿ ದೂಜ್',
    'Gandhi Jayanti': 'ಗಾಂಧೀ ಜಯಂತಿ',
    'Kannada Rajyotsava': 'ಕನ್ನಡ ರಾಜ್ಯೋತ್ಸವ',
    'Ugadi': 'ಉಗಾದಿ',
    'Rama Navami': 'ರಾಮನವಮಿ',
    'Hanuman Jayanti': 'ಹನುಮಾನ ಜಯಂತಿ',
    'Sri Krishna Janmashtami': 'ಶ್ರೀ ಕೃಷ್ಣ ಜನ್ಮಾಷ್ಟಮಿ',
    'Ganesh Chaturthi': 'ಗಣೇಶ ಚತುರ್ಥಿ',
    'Maha Shivaratri': 'ಮಹಾ ಶಿವರಾತ್ರಿ',
  };

  static final Map<String, List<String>> _festivalOverrides = <String, List<String>>{
    '2025-02-14': <String>['Maha Shivaratri'],
    '2025-03-30': <String>['Ugadi'],
    '2025-04-08': <String>['Rama Navami'],
    '2025-04-21': <String>['Hanuman Jayanti'],
    '2025-05-09': <String>['Akshaya Tritiya'],
    '2025-08-16': <String>['Sri Krishna Janmashtami'],
    '2025-09-02': <String>['Ganesh Chaturthi'],
    '2025-10-02': <String>['Gandhi Jayanti'],
    '2025-10-11': <String>['Navaratri Begins'],
    '2025-10-12': <String>['Ayudha Pooja'],
    '2025-10-13': <String>['Vijayadashami'],
    '2025-10-21': <String>['Narak Chaturdashi'],
    '2025-10-22': <String>['Deepavali'],
    '2025-10-23': <String>['Govardhan Puja', 'Bhai Dooj'],
    '2025-11-01': <String>['Kannada Rajyotsava'],
  };

  static final List<Mantra> mantras = <Mantra>[
    Mantra(
      title: 'ಶ್ರೀ ಗಾಯತ್ರಿ ಮಂತ್ರ',
      lines: <String>[
        'ॐ ಭೂರ್ಭುವಸ್ಸುವಃ ।',
        'ತತ್ಸವಿತುರ್ವರೇಣ್ಯಂ ।',
        'ಭರ್ಗೋ ದೇವಸ್ಯ ಧೀಮಹಿ ।',
        'ಧಿಯೋ ಯೋ ನಃ ಪ್ರಚೋದಯಾತ್ ॥',
      ],
      primaryColor: const Color(0xFFD97706),
      secondaryColor: const Color(0xFFEF4444),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಶನೇಶ್ವರ ಸ್ತೋತ್ರ',
      lines: <String>[
        'ನಮಸ್ತೇ ಕೋಣಶಪೀಡಾಯ ನಮನಸ್ತೇ ಬಬ್ರುರುಪಿಣೇ ।',
        'ನಮಸ್ತೇ ಸೂರ್ಯ ಪುತ್ರಾಯ ನಮಸ್ತೇ ಯಮಸೋದರ ॥',
        '',
        'ನಮೋ ಮಂಢಾಯ ಚ ಸ್ಥೂಲಾಯ ನೀಲಾಯ ಚ ಶನಯೇ ನಮಃ ।',
        'ಪ್ರಸಾದಂ ಕುರೂ ದೇವೇಶ ದೀನಸ್ಯ ಕೃಪಯಾ ನಃ ॥',
        '',
        'ನಮಃ ಕ್ರೂರಾಯ ದುಷ್ಟಾಯ ದುಃಖದಾಯ ನಮೋऽಸ್ತು ತೇ ।',
        'ಪ್ರಸಾದಂ ಕುರೂ ಮೇ ಶನೈಃ ಶನೈಃ ಶನೇಶ್ವರ ॥',
      ],
      primaryColor: const Color(0xFF0F172A),
      secondaryColor: const Color(0xFF1E3A8A),
    ),
    Mantra(
      title: 'ಶ್ರೀ ದುರ್ಗಾ ಸ್ತೋತ್ರ',
      lines: <String>[
        'ಸರ್ವಮಂಗಳು ಮಾಂಗಲ್ಯೇ ಶಿವೇ ಸರ್ವಾರ್ಥ ಸಾಧಿಕೇ ।',
        'ಶರಣ್ಯೇ ತ್ರ್ಯಂಬಕೇ ಗೌರಿ ನಾರಾಯಣಿ ನಮೋಸ್ತು ತೇ ॥',
        '',
        'ಯಾ ದೇವೀ ಸರ್ವಭೂತೇಷು ಶಕ್ತಿರೂಪೇಣ ಸಂಸ್ತಿತಾ ।',
        'ನಮಸ್ತಸ್ಯೈ ನಮಸ್ತಸ್ಯೈ ನಮಸ್ತಸ್ಯೈ ನಮೋ ನಮಃ ॥',
        '',
        'ಯಾ ದೇವೀ ಸರ್ವಭೂತೇಷು ಭಕ್ತಿರೂಪೇಣ ಸಂಸ್ತಿತಾ ।',
        'ನಮಸ್ತಸ್ಯೈ ನಮಸ್ತಸ್ಯೈ ನಮಸ್ತಸ್ಯೈ ನಮೋ ನಮಃ ॥',
      ],
      primaryColor: const Color(0xFFFF6B2C),
      secondaryColor: const Color(0xFFFCC419),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಚೌಡೇಶ್ವರಿ ಸ್ತೋತ್ರ',
      lines: <String>[
        'ನಮೋ ದೇವ್ಯೈ ಮಹಾದೇವ್ಯೈ ಚೌಡೇಶ್ವರ್ಯೈ ನಮೋ ನಮಃ ।',
        'ಜಯ ಭದ್ರೇ ಮಹಾಮಾಯೆ ಚಂಡಿಕೇ ಶ್ರುಣು ಸುಪ್ರಿಯೇ ॥',
        '',
        'ದೇವೀಂ ಪ್ರಪದ್ಯೇ ಶರಣಂ ಭಕ್ತಾನಾಂ ರಕ್ಷಣಾಯೈ ।',
        'ಚೌಡೇಶ್ವರಿ ನಮಸ್ತುಭ್ಯಂ ಶರಣಾಗತ ವತ್ಸಲೆ ॥',
      ],
      primaryColor: const Color(0xFF064E3B),
      secondaryColor: const Color(0xFF14532D),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಗುರು ರಾಘವೇಂದ್ರ ಸ್ವಾಮಿ ಪ್ರಾರ್ಥನೆ',
      lines: <String>[
        'ಪಾಲಯ ಮಮ ರಾಘವೇಂದ್ರ ಪಾದ |',
        'ದಾಳಯ ಮಮ ದುಃಖ ಭಾರಮ್ ॥',
        'ಕಾಳಹರಣ ಗುರು ಕರುಣಾಸಾಗರ |',
        'ಜೀವನ ಸಾರ್ಥಕ ತ್ವಮ್ ॥',
        '',
        'ತವ ಪದ ಪಂಕ್ಜ ಸೇವಾ ನಿಶಾ |',
        'ಭವ ಭಯ ನಾಶಕ ಶ್ರೀ ಗುರುರಾಯ ॥',
        'ಅನಂತ ಕೋಟಿ ಬ್ರಹ್ಮಾಂಡ ನಾಯಕ |',
        'ದಯಾಮಯ ರಾಘವೇಂದ್ರಾಯ ನಮಃ ॥',
      ],
      primaryColor: const Color(0xFFB45309),
      secondaryColor: const Color(0xFFF59E0B),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಸೂರ್ಯ ನಾರಾಯಣ ಪ್ರಾರ್ಥನೆ',
      lines: <String>[
        'ಓಂ ಭ್ಯಾಸ್ ಸೂರ್ಯ ನಾರಾಯಣಾಯ ನಮಃ |',
        'ಓಂ ದಿವ್ಯ ಪ್ರಭಾತಾಯ ನಮಃ ॥',
        'ಓಂ ಭಾಸ್ಕರಾಯ ವಿದ್ಮಹಿ |',
        'ದಿವ್ಯ ಜ್ಯೋತಿ ಪ್ರಸಾದಯಾತ್ ॥',
        '',
        'ಓಂ ಸೂರ್ಯ ದೇವಾಯ ನಮಃ |',
        'ಓಂ ಶ್ರೇಯೋಭಿವೃದ್ಧ್ಯೈ ನಮಃ ॥',
        'ಓಂ ಜಯ ಸೂರ್ಯ ನಾರಾಯಣಾಯ ನಮಃ |',
      ],
      primaryColor: const Color(0xFFF97316),
      secondaryColor: const Color(0xFFFACC15),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಗಣೇಶ ಮಂತ್ರ',
      lines: <String>[
        'ಓಂ ಗಣಾನಾಂತ್ವಾ ಗಣಪತಿಂ ಹವಾಮಹೇ',
        'ಕವಿಂ ಕವೀನಾಮುಪಮಶ್ರವಸ್ತಿ',
        'ಜ್ಯೇಷ್ಠರಾಜಂ ಬ್ರಹ್ಮಣಾಂ ಬ್ರಹ್ಮಣಸ್ಪತ ಆ ನಃ',
        'ಶ್ರುಣ್ವನ್ನೂತಿಭಿಃಸೀದ ಸಾದನಂ',
      ],
      primaryColor: const Color(0xFFE11D48),
      secondaryColor: const Color(0xFFF97316),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಹನುಮಾನ್ ಚಾಲಿಸಾ',
      lines: <String>[
        'ಶ್ರೀಗುರು ಚರಣ ಸರೋಜ ರಜ ನಿಜ ಮನ ಮುಖುರೇ ಸುಧಾರ',
        'ಬರನೌ ರಘುವರ ವಿಮಲ ಯಶ ಜೋ ದಾಯಕ ಫಲ ಚಾರ್',
        'ಬುದ್ಧಿಹೀನ್ ತನುವಿಜಾನಿಕೇ ಸುಮಿರೌ ಪವನ ಕುಮಾರ',
        'ಬಲ ಬುದ್ಧಿ ವಿದ್ಯಾ ದೇಹು ಮೋಹಿ ಹರೌ ಕಲೆಶ ವಿಕಾರ್',
      ],
      primaryColor: const Color(0xFFF97316),
      secondaryColor: const Color(0xFFFACC15),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಲಕ್ಷ್ಮೀ ಮಂತ್ರ',
      lines: <String>[
        'ಓಂ ಶ್ರೀಂ ಮಹಾ ಲಕ್ಷ್ಮ್ಯೈ ನಮಃ',
        'ಓಂ ಹ್ರೀಂ ಶ್ರೀಂ ಲಕ್ಷ್ಮೀಭ್ಯೋ ನಮಃ',
        'ಓಂ ಶ್ರೀಂ ಶ್ರೀಯೈ ನಮಃ',
      ],
      primaryColor: const Color(0xFFFACC15),
      secondaryColor: const Color(0xFFFB923C),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಶಿವ ಮಂತ್ರ',
      lines: <String>[
        'ಓಂ ನಮಃ ಶಿವಾಯ',
        'ಓಂ ತ್ರ್ಯಾಂಬಕಂ ಯಜಾಮಹೇ ಸುಗಂಧಿಂ ಪುಷ್ಟಿ ವಧನಂ',
        'ಉರ್ವಾರುಕಮಿವ ಬಂಧನಾನ್ಮೃತ್ಯೋರ್ಮುಕ್ಷೀಯ ಮಾಮೃತಾತ್',
      ],
      primaryColor: const Color(0xFF7C3AED),
      secondaryColor: const Color(0xFF38BDF8),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಸರಸ್ವತಿ ಸ್ತೋತ್ರ',
      lines: <String>[
        'ಯಾ ಕುಂದೇಸು ತುನ್ಬಿತೇ ಸುಪ್ರಭಾತೀ',
        'ಯಾ ಶ್ವೇತಪದ್ಮಾಂಬುಜೇ ಶುಭಂಕರಾ',
        'ಯಾ ವಿದ್ಯಾ ಭಾಸ್ಕರೇಣ ತೇಜೋಮಯೀ',
        'ನಮಸ್ತಸ್ಯೈ ನಮಸ್ತಸ್ಯೈ ನಮಸ್ತಸ್ಯೈ ನಮಃ',
      ],
      primaryColor: const Color(0xFFD6E4FF),
      secondaryColor: const Color(0xFFEDE9FE),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಸಾಯಿಬಾಬಾ ಸ್ತೋತ್ರ',
      lines: <String>[
        'ಶ್ರಿ ಸಾಯಿ ಪ್ರಭೋ ದಯಾನಿಧೇ',
        'ಪಾವನವಿಚಿತ್ರ ಹೃದಯ ಮೋಹನೆ',
        'ಭಕ್ತಪೋಷಕ ಸರ್ವದಾ ಕೃಪಾಮಯ',
        'ನಮೋ ನಮಃ ಸಾಯಿನಾಥಾಯ',
      ],
      primaryColor: const Color(0xFF1F2937),
      secondaryColor: const Color(0xFF312E81),
    ),
    Mantra(
      title: 'ಶ್ರೀ ವಿಷ್ಣು ಸ್ತೋತ್ರ',
      lines: <String>[
        'ಶಾಂತಾಕಾರಂ ಭುಜಗಶಯನಂ ಪದ್ಮನಾಭಂ ಸುರೇಶಂ',
        'ವಿಶ್ವಾಧಾರಂ ಗಗನಸದೃಶಂ ಮೇಘವರ್ಣಂ ಶುಭಾಂಗಂ',
        'ಲಕ್ಷ್ಮೀಕಾಂತಂ ಕಮಲನಯನಂ ಯೋಗಿಭಿರ್ಧ್ಯಾನಗಮ್ಯಂ',
        'ವಂದೇ ವಿಷ್ಣುಂ ಭವಭಯಹರಂ ಸರ್ವಲೋಕೈಕನಾಥಂ',
      ],
      primaryColor: const Color(0xFF38BDF8),
      secondaryColor: const Color(0xFFE0F2FE),
    ),
    Mantra(
      title: 'ಶ್ರೀ ಪದ್ಮಾವತಿ ಸ್ತೋತ್ರ',
      lines: <String>[
        'ಪದ್ಮಾಲಯೇ ಶ್ರೀಪದ್ಮಾವತಿ ದೇವಿ',
        'ಕರೂಣಾಸಾಗರೇ ಭಕ್ತ ಅಡಿಗೇ',
        'ಅಭಯಪ್ರದಾಪಿ ತ್ವಂ ಶರಣಾಗತಾನಾಂ',
        'ಸರ್ವಾನುಗ್ರಹಕಾರಿಣಿ ಪಾಹಿ ಮಾಂ ಸದಾ',
      ],
      primaryColor: const Color(0xFFF472B6),
      secondaryColor: const Color(0xFFFDE5F2),
    ),
   
  ];

  static final Map<DateTime, PanchangaDay> _panchangaByDate = UnmodifiableMapView<DateTime, PanchangaDay>(
    Map<DateTime, PanchangaDay>.fromEntries(
      panchangaData.map(
        (PanchangaDay day) => MapEntry<DateTime, PanchangaDay>(_normalized(day.date), day),
      ),
    ),
  );

  static DateTime _normalized(DateTime date) => DateTime(date.year, date.month, date.day);

  static PanchangaDay? dayFor(DateTime date) {
    return _panchangaByDate[_normalized(date)];
  }

  static List<DateTime> monthsForYear(int year) => List<DateTime>.generate(12, (int index) => DateTime(year, index + 1, 1));

  static List<DateTime?> monthCells(DateTime month) {
    final DateTime firstDay = DateTime(month.year, month.month, 1);
    final int leadingEmpty = firstDay.weekday % 7;
    final DateTime gridStart = firstDay.subtract(Duration(days: leadingEmpty));
    return List<DateTime?>.generate(42, (int index) {
      final DateTime current = DateTime(gridStart.year, gridStart.month, gridStart.day + index);
      if (current.month != month.month) {
        return null;
      }
      return current;
    });
  }

  static List<PanchangaDay> daysForMonth(DateTime month) {
    final DateTime firstDay = DateTime(month.year, month.month, 1);
    final DateTime lastDay = DateTime(month.year, month.month + 1, 0);
    final List<PanchangaDay> filtered = panchangaData
        .where((PanchangaDay day) => !day.date.isBefore(firstDay) && !day.date.isAfter(lastDay))
        .toList()
      ..sort((PanchangaDay a, PanchangaDay b) => a.date.compareTo(b.date));
    return filtered;
  }

  static List<DateTime> monthGridDays(DateTime month) {
    final DateTime firstDay = DateTime(month.year, month.month, 1);
    final DateTime lastDay = DateTime(month.year, month.month + 1, 0);

    final int leadingDays = firstDay.weekday % 7;
    final int trailingDays = (7 - lastDay.weekday % 7) % 7;

    final DateTime gridStart = firstDay.subtract(Duration(days: leadingDays));
    final int totalDays = (lastDay.day + leadingDays + trailingDays).clamp(35, 42);

    return List<DateTime>.generate(
      totalDays,
      (int index) => DateTime(gridStart.year, gridStart.month, gridStart.day + index),
    );
  }

  static List<String> festivalsFor(DateTime date) {
    final PanchangaDay? day = dayFor(date);
    final Set<String> mapped = <String>{
      ...?day?.festivals,
      ...?_festivalOverrides[_key(date)] ?? <String>[],
    };
    return mapped
        .map((String festival) => _festivalTranslations[festival] ?? festival)
        .where((String value) => value.trim().isNotEmpty)
        .toList();
  }

  static bool hasFestival(DateTime date) {
    return festivalsFor(date).isNotEmpty;
  }

  static String tithiFor(DateTime date) => dayFor(date)?.tithi ?? '-';

  static String nakshatraFor(DateTime date) => dayFor(date)?.nakshatra ?? '-';

  static String yogaFor(DateTime date) => dayFor(date)?.yoga ?? '-';

  static String karanaFor(DateTime date) => dayFor(date)?.karana ?? '-';

  static String kannadaWeekdayLabel(DateTime date) => kannadaWeekdayMap[date.weekday] ?? '';

  static String kannadaMonthLabel(DateTime date) => kannadaMonths[date.month] ?? '';

  static String? monthImageAsset(DateTime month) => monthlyCalendarImages[month.month];

  static String _key(DateTime date) => '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
