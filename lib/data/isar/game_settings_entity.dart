import 'package:isar_community/isar.dart';
import '../../models/game_settings.dart';

part 'game_settings_entity.g.dart';

@collection
class GameSettingsEntity {
  Id id = 1;

  String scriptMode = 'hiragana';
  String gameMode = 'sprint';
  String inputMode = 'choice';
  List<String> selectedRows = ['row-a', 'row-ka', 'row-sa'];
  bool soundEnabled = true;
  bool voiceEnabled = true;
  bool showTouchKeyboard = true;
  int sprintDeckSize = 20;
  String themeMode = 'dark';
  String accentColor = 'emerald';
  bool hapticEnabled = true;
  double sfxVolume = 1.0;
  bool autoPlayVoice = false;
  double voiceSpeed = 1.0;
  double voiceVolume = 1.0;

  StoredGameSettings toModel() {
    ScriptSelection parseScript(String val) {
      for (final s in ScriptSelection.values) {
        if (s.name == val) return s;
      }
      return ScriptSelection.hiragana;
    }

    GameMode parseGameMode(String val) {
      if (val == 'timeAttack' || val == 'time-attack') return GameMode.timeAttack;
      if (val == 'zen') return GameMode.zen;
      return GameMode.sprint;
    }

    InputMode parseInputMode(String val) {
      if (val == 'typing') return InputMode.typing;
      return InputMode.choice;
    }

    AppThemeMode parseTheme(String val) {
      for (final t in AppThemeMode.values) {
        if (t.name == val) return t;
      }
      return AppThemeMode.dark;
    }

    AppAccentColor parseAccent(String val) {
      for (final a in AppAccentColor.values) {
        if (a.name == val) return a;
      }
      return AppAccentColor.emerald;
    }

    return StoredGameSettings(
      scriptMode: parseScript(scriptMode),
      gameMode: parseGameMode(gameMode),
      inputMode: parseInputMode(inputMode),
      selectedRows: selectedRows.isNotEmpty
          ? selectedRows
          : const ['row-a', 'row-ka', 'row-sa'],
      soundEnabled: soundEnabled,
      voiceEnabled: voiceEnabled,
      showTouchKeyboard: showTouchKeyboard,
      sprintDeckSize: sprintDeckSize,
      themeMode: parseTheme(themeMode),
      accentColor: parseAccent(accentColor),
      hapticEnabled: hapticEnabled,
      sfxVolume: sfxVolume,
      autoPlayVoice: autoPlayVoice,
      voiceSpeed: voiceSpeed,
      voiceVolume: voiceVolume,
    );
  }

  static GameSettingsEntity fromModel(StoredGameSettings model) {
    final entity = GameSettingsEntity();
    entity.id = 1;
    entity.scriptMode = model.scriptMode.name;
    entity.gameMode = model.gameMode.name;
    entity.inputMode = model.inputMode.name;
    entity.selectedRows = List<String>.from(model.selectedRows);
    entity.soundEnabled = model.soundEnabled;
    entity.voiceEnabled = model.voiceEnabled;
    entity.showTouchKeyboard = model.showTouchKeyboard;
    entity.sprintDeckSize = model.sprintDeckSize;
    entity.themeMode = model.themeMode.name;
    entity.accentColor = model.accentColor.name;
    entity.hapticEnabled = model.hapticEnabled;
    entity.sfxVolume = model.sfxVolume;
    entity.autoPlayVoice = model.autoPlayVoice;
    entity.voiceSpeed = model.voiceSpeed;
    entity.voiceVolume = model.voiceVolume;
    return entity;
  }
}
