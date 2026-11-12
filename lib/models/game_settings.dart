import 'package:flutter/material.dart';

enum ScriptSelection {
  hiragana,
  katakana,
  mixed;

  String get label {
    switch (this) {
      case ScriptSelection.hiragana:
        return 'Hiragana';
      case ScriptSelection.katakana:
        return 'Katakana';
      case ScriptSelection.mixed:
        return 'Mixed Script';
    }
  }
}

enum AppThemeMode {
  system,
  dark,
  light,
  oled;

  String get label {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.dark:
        return 'Dark Zinc';
      case AppThemeMode.light:
        return 'Light Zen';
      case AppThemeMode.oled:
        return 'Midnight OLED';
    }
  }

  String get subtitle {
    switch (this) {
      case AppThemeMode.system:
        return 'Match device OS display appearance';
      case AppThemeMode.dark:
        return 'Modern zinc dark aesthetic with neon accents';
      case AppThemeMode.light:
        return 'Clean paper white aesthetic with crisp contrast';
      case AppThemeMode.oled:
        return 'Pure pitch black mode for OLED displays';
    }
  }
}

enum AppAccentColor {
  emerald,
  sky,
  purple,
  amber,
  rose;

  String get label {
    switch (this) {
      case AppAccentColor.emerald:
        return 'Emerald';
      case AppAccentColor.sky:
        return 'Sky Blue';
      case AppAccentColor.purple:
        return 'Neon Purple';
      case AppAccentColor.amber:
        return 'Cyber Amber';
      case AppAccentColor.rose:
        return 'Sakura Rose';
    }
  }

  Color get color {
    switch (this) {
      case AppAccentColor.emerald:
        return const Color(0xFF34D399);
      case AppAccentColor.sky:
        return const Color(0xFF38BDF8);
      case AppAccentColor.purple:
        return const Color(0xFFA855F7);
      case AppAccentColor.amber:
        return const Color(0xFFFBBF24);
      case AppAccentColor.rose:
        return const Color(0xFFFB7185);
    }
  }
}

enum GameMode {
  sprint,
  timeAttack,
  zen;

  String get label {
    switch (this) {
      case GameMode.sprint:
        return 'Sprint (20)';
      case GameMode.timeAttack:
        return 'Time-Attack (60s)';
      case GameMode.zen:
        return 'Zen (Infinite)';
    }
  }

  String get description {
    switch (this) {
      case GameMode.sprint:
        return 'Clear a deck of 20 cards with optimal accuracy & speed.';
      case GameMode.timeAttack:
        return 'Answer as many Kana as possible within 60 seconds.';
      case GameMode.zen:
        return 'Endless relaxed practice without time or card limits.';
    }
  }
}

enum InputMode {
  choice,
  typing;

  String get label {
    switch (this) {
      case InputMode.choice:
        return 'Choice (Buttons)';
      case InputMode.typing:
        return 'Typing (Romaji)';
    }
  }
}

enum PracticeFocusMode {
  standard,
  weakLetters;

  String get label {
    switch (this) {
      case PracticeFocusMode.standard:
        return 'Selected Rows';
      case PracticeFocusMode.weakLetters:
        return 'Weak Letters Only';
    }
  }
}

class StoredGameSettings {
  final ScriptSelection scriptMode;
  final GameMode gameMode;
  final InputMode inputMode;
  final List<String> selectedRows;
  final bool soundEnabled;
  final bool voiceEnabled;
  final bool showTouchKeyboard;
  final int sprintDeckSize;
  final AppThemeMode themeMode;
  final AppAccentColor accentColor;
  final bool hapticEnabled;
  final double sfxVolume;
  final bool autoPlayVoice;
  final double voiceSpeed;
  final double voiceVolume;

  const StoredGameSettings({
    this.scriptMode = ScriptSelection.hiragana,
    this.gameMode = GameMode.sprint,
    this.inputMode = InputMode.choice,
    this.selectedRows = const ['row-a', 'row-ka', 'row-sa'],
    this.soundEnabled = true,
    this.voiceEnabled = true,
    this.showTouchKeyboard = true,
    this.sprintDeckSize = 20,
    this.themeMode = AppThemeMode.dark,
    this.accentColor = AppAccentColor.emerald,
    this.hapticEnabled = true,
    this.sfxVolume = 1.0,
    this.autoPlayVoice = false,
    this.voiceSpeed = 1.0,
    this.voiceVolume = 1.0,
  });

  StoredGameSettings copyWith({
    ScriptSelection? scriptMode,
    GameMode? gameMode,
    InputMode? inputMode,
    List<String>? selectedRows,
    bool? soundEnabled,
    bool? voiceEnabled,
    bool? showTouchKeyboard,
    int? sprintDeckSize,
    AppThemeMode? themeMode,
    AppAccentColor? accentColor,
    bool? hapticEnabled,
    double? sfxVolume,
    bool? autoPlayVoice,
    double? voiceSpeed,
    double? voiceVolume,
  }) {
    return StoredGameSettings(
      scriptMode: scriptMode ?? this.scriptMode,
      gameMode: gameMode ?? this.gameMode,
      inputMode: inputMode ?? this.inputMode,
      selectedRows: selectedRows ?? this.selectedRows,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      showTouchKeyboard: showTouchKeyboard ?? this.showTouchKeyboard,
      sprintDeckSize: sprintDeckSize ?? this.sprintDeckSize,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      autoPlayVoice: autoPlayVoice ?? this.autoPlayVoice,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      voiceVolume: voiceVolume ?? this.voiceVolume,
    );
  }

  Map<String, dynamic> toJson() => {
        'scriptMode': scriptMode.name,
        'gameMode': gameMode.name,
        'inputMode': inputMode.name,
        'selectedRows': selectedRows,
        'soundEnabled': soundEnabled,
        'voiceEnabled': voiceEnabled,
        'showTouchKeyboard': showTouchKeyboard,
        'sprintDeckSize': sprintDeckSize,
        'themeMode': themeMode.name,
        'accentColor': accentColor.name,
        'hapticEnabled': hapticEnabled,
        'sfxVolume': sfxVolume,
        'autoPlayVoice': autoPlayVoice,
        'voiceSpeed': voiceSpeed,
        'voiceVolume': voiceVolume,
      };

  factory StoredGameSettings.fromJson(Map<String, dynamic> json) {
    ScriptSelection parseScript(String? val) {
      for (final s in ScriptSelection.values) {
        if (s.name == val) return s;
      }
      return ScriptSelection.hiragana;
    }

    GameMode parseGameMode(String? val) {
      if (val == 'time-attack' || val == 'timeAttack') return GameMode.timeAttack;
      if (val == 'zen') return GameMode.zen;
      return GameMode.sprint;
    }

    InputMode parseInputMode(String? val) {
      if (val == 'typing') return InputMode.typing;
      return InputMode.choice;
    }

    AppThemeMode parseTheme(String? val) {
      for (final t in AppThemeMode.values) {
        if (t.name == val) return t;
      }
      return AppThemeMode.dark;
    }

    AppAccentColor parseAccent(String? val) {
      for (final a in AppAccentColor.values) {
        if (a.name == val) return a;
      }
      return AppAccentColor.emerald;
    }

    final rawRows = json['selectedRows'];
    List<String> rows = const ['row-a', 'row-ka', 'row-sa'];
    if (rawRows is List) {
      final list = rawRows.map((e) => e.toString()).toList();
      if (list.isNotEmpty) rows = list;
    }

    return StoredGameSettings(
      scriptMode: parseScript(json['scriptMode']?.toString()),
      gameMode: parseGameMode(json['gameMode']?.toString()),
      inputMode: parseInputMode(json['inputMode']?.toString()),
      selectedRows: rows,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      voiceEnabled: json['voiceEnabled'] as bool? ?? true,
      showTouchKeyboard: json['showTouchKeyboard'] as bool? ?? true,
      sprintDeckSize: json['sprintDeckSize'] as int? ?? 20,
      themeMode: parseTheme(json['themeMode']?.toString()),
      accentColor: parseAccent(json['accentColor']?.toString()),
      hapticEnabled: json['hapticEnabled'] as bool? ?? true,
      sfxVolume: (json['sfxVolume'] as num?)?.toDouble() ?? 1.0,
      autoPlayVoice: json['autoPlayVoice'] as bool? ?? false,
      voiceSpeed: (json['voiceSpeed'] as num?)?.toDouble() ?? 1.0,
      voiceVolume: (json['voiceVolume'] as num?)?.toDouble() ?? 1.0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoredGameSettings &&
          runtimeType == other.runtimeType &&
          scriptMode == other.scriptMode &&
          gameMode == other.gameMode &&
          inputMode == other.inputMode &&
          soundEnabled == other.soundEnabled &&
          voiceEnabled == other.voiceEnabled &&
          showTouchKeyboard == other.showTouchKeyboard &&
          sprintDeckSize == other.sprintDeckSize &&
          themeMode == other.themeMode &&
          accentColor == other.accentColor &&
          hapticEnabled == other.hapticEnabled &&
          (sfxVolume - other.sfxVolume).abs() < 0.001 &&
          autoPlayVoice == other.autoPlayVoice &&
          (voiceSpeed - other.voiceSpeed).abs() < 0.001 &&
          (voiceVolume - other.voiceVolume).abs() < 0.001;

  @override
  int get hashCode => Object.hash(
        scriptMode,
        gameMode,
        inputMode,
        soundEnabled,
        voiceEnabled,
        showTouchKeyboard,
        sprintDeckSize,
        themeMode,
        accentColor,
        hapticEnabled,
        sfxVolume,
        autoPlayVoice,
        voiceSpeed,
        voiceVolume,
      );
}
