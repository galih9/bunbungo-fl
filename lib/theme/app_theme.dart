import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF09090B); // zinc-950
  static const Color surface = Color(0xFF18181B); // zinc-900
  static const Color surfaceElevated = Color(0xFF27272A); // zinc-800
  static const Color border = Color(0xFF27272A); // zinc-800
  static const Color borderLight = Color(0xFF3F3F46); // zinc-700

  static const Color text = Color(0xFFF4F4F5); // zinc-100
  static const Color textSecondary = Color(0xFFA1A1AA); // zinc-400
  static const Color textMuted = Color(0xFF71717A); // zinc-500

  static const Color emerald = Color(0xFF34D399); // emerald-400
  static const Color amber = Color(0xFFFBBF24); // amber-400
  static const Color purple = Color(0xFFA855F7); // purple-500
  static const Color rose = Color(0xFFFB7185); // rose-400
  static const Color sky = Color(0xFF38BDF8); // sky-400
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.emerald,
        secondary: AppColors.amber,
        error: AppColors.rose,
        onSurface: AppColors.text,
      ),
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
