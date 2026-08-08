import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/constants/app_constants.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/chat/data/models/message_model.dart';
import 'core/providers/config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MessageModelAdapter());
  await Hive.openBox<MessageModel>(AppConstants.chatBox);
  await Hive.openBox(AppConstants.settingsBox);

  final container = ProviderContainer();
  // Pre-fetch remote config
  print('Starting app: Fetching remote config...');
  try {
    await container.read(remoteConfigProvider.notifier).fetchConfig();
    print('Initial config fetch attempt finished.');
  } catch (e) {
    print('CRITICAL: Unexpected error during main config fetch: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const KannadaAIApp(),
    ),
  );
}

class KannadaAIApp extends ConsumerWidget {
  const KannadaAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
