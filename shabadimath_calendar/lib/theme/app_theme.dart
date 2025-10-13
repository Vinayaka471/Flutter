import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = _baseTheme(Brightness.light).copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF674AEF),
      secondary: Color(0xFFFB7185),
      tertiary: Color(0xFF38BDF8),
      surface: Colors.white,
      surfaceContainerHighest: Color(0xFFF5F6FB),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: Color(0xFF111827),
    ),
  );

  static ThemeData darkTheme = _baseTheme(Brightness.dark).copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFFF97316),
      tertiary: Color(0xFF38BDF8),
      surface: Color(0xFF1F2937),
      surfaceContainerHighest: Color(0xFF0F172A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: Colors.white,
    ),
  );

  static ThemeData _baseTheme(Brightness brightness) {
    final colorScheme = brightness == Brightness.dark
        ? const ColorScheme.dark()
        : const ColorScheme.light();

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface.withValues(alpha: brightness == Brightness.dark ? 0.6 : 0.7),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
