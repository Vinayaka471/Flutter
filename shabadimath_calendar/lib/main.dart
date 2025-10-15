import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'models/reminder.dart';
import 'providers/app_state.dart';
import 'providers/reminder_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

import 'services/reminder_scheduler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('kn_IN', null);
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ReminderRepeatAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ReminderAdapter());
  }
  await Hive.openBox<Reminder>('reminders');
  final ReminderScheduler scheduler = ReminderScheduler(navigatorKey);
  await scheduler.initialize();
  runApp(ShabadimathCalendarApp(reminderScheduler: scheduler, navigatorKey: navigatorKey));
}

class ShabadimathCalendarApp extends StatelessWidget {
  const ShabadimathCalendarApp({super.key, required this.reminderScheduler, required this.navigatorKey});

  final ReminderScheduler reminderScheduler;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<ReminderProvider>(create: (_) => ReminderProvider(reminderScheduler)),
      ],
      child: Consumer<AppState>(
        builder: (BuildContext context, AppState state, _) {
          return MaterialApp(
            title: 'Shabadimath Calendar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            navigatorKey: navigatorKey,
            locale: const Locale('kn', 'IN'),
            supportedLocales: const <Locale>[
              Locale('kn', 'IN'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomeScreen(),
            routes: <String, WidgetBuilder>{
              CalendarScreen.routeName: (_) => const CalendarScreen(),
            },
          );
        },
      ),
    );
  }
}
