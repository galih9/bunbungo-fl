import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class AppColors {
  static AppThemeMode _activeMode = AppThemeMode.dark;
  static bool _isLight = false;

  static void applyTheme(AppThemeMode mode, {bool isPlatformDark = true}) {
    _activeMode = mode;
    if (mode == AppThemeMode.system) {
      _isLight = !isPlatformDark;
    } else if (mode == AppThemeMode.light) {
      _isLight = true;
    } else {
      _isLight = false;
    }
  }

  static AppThemeMode get activeMode => _activeMode;
  static bool get isLight => _isLight;
  static bool get isOled => _activeMode == AppThemeMode.oled;

  // Background
  static Color get background {
    if (_isLight) return const Color(0xFFF4F4F6); // clean slate light
    if (_activeMode == AppThemeMode.oled) return const Color(0xFF000000); // pure pitch black
    return const Color(0xFF09090B); // zinc-950
  }

  // Surface
  static Color get surface {
    if (_isLight) return const Color(0xFFFFFFFF); // pure card white
    if (_activeMode == AppThemeMode.oled) return const Color(0xFF0C0C0E);
    return const Color(0xFF18181B); // zinc-900
  }

  // Surface Elevated
  static Color get surfaceElevated {
    if (_isLight) return const Color(0xFFE4E4E7); // zinc-200
    if (_activeMode == AppThemeMode.oled) return const Color(0xFF16161B);
    return const Color(0xFF27272A); // zinc-800
  }

  // Border
  static Color get border {
    if (_isLight) return const Color(0xFFE4E4E7); // zinc-200
    if (_activeMode == AppThemeMode.oled) return const Color(0xFF1F1F26);
    return const Color(0xFF27272A); // zinc-800
  }

  // Border Light
  static Color get borderLight {
    if (_isLight) return const Color(0xFFD4D4D8); // zinc-300
    if (_activeMode == AppThemeMode.oled) return const Color(0xFF2D2D37);
    return const Color(0xFF3F3F46); // zinc-700
  }

  // Text
  static Color get text {
    if (_isLight) return const Color(0xFF09090B); // zinc-950 deep readable
    return const Color(0xFFF4F4F5); // zinc-100
  }

  // Text Secondary
  static Color get textSecondary {
    if (_isLight) return const Color(0xFF52525B); // zinc-600
    return const Color(0xFFA1A1AA); // zinc-400
  }

  // Text Muted
  static Color get textMuted {
    if (_isLight) return const Color(0xFF71717A); // zinc-500
    return const Color(0xFF71717A); // zinc-500
  }

  // Accent Colors
  static Color get emerald => _isLight ? const Color(0xFF059669) : const Color(0xFF34D399);
  static Color get amber => _isLight ? const Color(0xFFD97706) : const Color(0xFFFBBF24);
  static Color get purple => _isLight ? const Color(0xFF9333EA) : const Color(0xFFA855F7);
  static Color get rose => _isLight ? const Color(0xFFE11D48) : const Color(0xFFFB7185);
  static Color get sky => _isLight ? const Color(0xFF0284C7) : const Color(0xFF38BDF8);

  // Baseline Dark Palette for Static Fallbacks
  static const Color darkBackground = Color(0xFF09090B);
  static const Color darkSurface = Color(0xFF18181B);
  static const Color darkBorder = Color(0xFF27272A);
  static const Color darkText = Color(0xFFF4F4F5);
}

class AppTheme {
  static ThemeData get darkTheme => getTheme(AppThemeMode.dark);
  static ThemeData get oledTheme => getTheme(AppThemeMode.oled);
  static ThemeData get lightTheme => getTheme(AppThemeMode.light);

  static ThemeData getTheme(
    AppThemeMode mode, {
    AppAccentColor accent = AppAccentColor.emerald,
    bool isPlatformDark = true,
  }) {
    final primary = accent.color;

    switch (mode) {
      case AppThemeMode.system:
        return isPlatformDark
            ? _createTheme(
                brightness: Brightness.dark,
                background: const Color(0xFF09090B),
                surface: const Color(0xFF18181B),
                border: const Color(0xFF27272A),
                text: const Color(0xFFF4F4F5),
                primary: primary,
              )
            : _createTheme(
                brightness: Brightness.light,
                background: const Color(0xFFF4F4F6),
                surface: const Color(0xFFFFFFFF),
                border: const Color(0xFFE4E4E7),
                text: const Color(0xFF09090B),
                primary: primary,
              );
      case AppThemeMode.dark:
        return _createTheme(
          brightness: Brightness.dark,
          background: const Color(0xFF09090B),
          surface: const Color(0xFF18181B),
          border: const Color(0xFF27272A),
          text: const Color(0xFFF4F4F5),
          primary: primary,
        );
      case AppThemeMode.oled:
        return _createTheme(
          brightness: Brightness.dark,
          background: const Color(0xFF000000),
          surface: const Color(0xFF0C0C0E),
          border: const Color(0xFF1F1F26),
          text: Colors.white,
          primary: primary,
        );
      case AppThemeMode.light:
        return _createTheme(
          brightness: Brightness.light,
          background: const Color(0xFFF4F4F6),
          surface: const Color(0xFFFFFFFF),
          border: const Color(0xFFE4E4E7),
          text: const Color(0xFF09090B),
          primary: primary,
        );
    }
  }

  static ThemeData _createTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color border,
    required Color text,
    required Color primary,
  }) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: brightness == Brightness.dark
          ? ColorScheme.dark(
              surface: surface,
              primary: primary,
              secondary: const Color(0xFFFBBF24),
              error: const Color(0xFFFB7185),
              onSurface: text,
            )
          : ColorScheme.light(
              surface: surface,
              primary: primary,
              secondary: const Color(0xFFD97706),
              error: const Color(0xFFE11D48),
              onSurface: text,
            ),
      fontFamily: 'sans-serif',
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: text),
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
      ),
    );
  }
}
