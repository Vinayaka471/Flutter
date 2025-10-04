import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/screens/screens.dart';
import 'package:ybt_match/services/auth_service.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.authStateChanges().first;
  setupLocator();
  // Seed the database on first run
  await locator<FirestoreService>().seedDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: locator<AuthService>().user,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'YBT Match',
            theme: ThemeData.light(), // Define your light theme
            darkTheme: ThemeData.dark(), // Define your dark theme
            themeMode: themeProvider.themeMode,
            home: const Wrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

