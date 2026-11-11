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

  const StoredGameSettings({
    this.scriptMode = ScriptSelection.hiragana,
    this.gameMode = GameMode.sprint,
    this.inputMode = InputMode.choice,
    this.selectedRows = const ['row-a', 'row-ka', 'row-sa'],
    this.soundEnabled = true,
    this.voiceEnabled = true,
    this.showTouchKeyboard = true,
    this.sprintDeckSize = 20,
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
    );
  }
}
