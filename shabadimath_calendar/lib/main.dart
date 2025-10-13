import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('kn_IN', null);
  runApp(const ShabadimathCalendarApp());
}

class ShabadimathCalendarApp extends StatelessWidget {
  const ShabadimathCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (BuildContext context, AppState state, _) {
          return MaterialApp(
            title: 'Shabadimath Calendar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
