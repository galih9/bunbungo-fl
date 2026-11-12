import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../logic/arena_store.dart';
import '../logic/dashboard_analytics.dart';
import '../logic/mastery_analytics.dart';
import '../logic/progression_engine.dart';
import '../models/achievement.dart';
import '../models/challenge.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/user_progression.dart';
import '../services/persistence_service.dart';

// Persistence Service Provider
final persistenceProvider = Provider<PersistenceService>((ref) {
  throw UnimplementedError('persistenceProvider must be initialized in ProviderScope overrides');
});

// Active Tab Provider (0: Arena, 1: Dashboard, 2: Chart, 3: Stats, 4: Settings)
final activeTabProvider = StateProvider<int>((ref) => 0);

// Game Settings Notifier & Provider
class GameSettingsNotifier extends StateNotifier<StoredGameSettings> {
  final PersistenceService _persistence;

  GameSettingsNotifier(this._persistence)
      : super(_persistence.loadGameSettings());

  void reload() {
    state = _persistence.loadGameSettings();
  }

  void updateSettings(StoredGameSettings newSettings) {
    state = newSettings;
    _persistence.saveGameSettings(newSettings);
  }

  void toggleSound() {
    final updated = state.copyWith(soundEnabled: !state.soundEnabled);
    updateSettings(updated);
  }

  void toggleVoice() {
    final updated = state.copyWith(voiceEnabled: !state.voiceEnabled);
    updateSettings(updated);
  }

  void toggleHaptics() {
    final updated = state.copyWith(hapticEnabled: !state.hapticEnabled);
    updateSettings(updated);
  }

  void updateSelectedRows(List<String> rows) {
    final updated = state.copyWith(selectedRows: rows);
    updateSettings(updated);
  }

  void setGameMode(GameMode mode) {
    final updated = state.copyWith(gameMode: mode);
    updateSettings(updated);
  }

  void setScriptMode(ScriptSelection script) {
    final updated = state.copyWith(scriptMode: script);
    updateSettings(updated);
  }

  void setInputMode(InputMode input) {
    final updated = state.copyWith(inputMode: input);
    updateSettings(updated);
  }

  void setThemeMode(AppThemeMode theme) {
    final updated = state.copyWith(themeMode: theme);
    updateSettings(updated);
  }

  void setAccentColor(AppAccentColor accent) {
    final updated = state.copyWith(accentColor: accent);
    updateSettings(updated);
  }
}

final gameSettingsProvider =
    StateNotifierProvider<GameSettingsNotifier, StoredGameSettings>((ref) {
  final persistence = ref.watch(persistenceProvider);
  return GameSettingsNotifier(persistence);
});

// User Progression Notifier & Provider
class UserProgressionNotifier extends StateNotifier<UserProgression> {
  final PersistenceService _persistence;

  UserProgressionNotifier(this._persistence)
      : super(_persistence.loadUserProgression());

  void reload() {
    state = _persistence.loadUserProgression();
  }

  void updateProgression(UserProgression newProgression) {
    state = newProgression;
    _persistence.saveUserProgression(newProgression);
  }

  void applySessionResult(SessionProgressionResult result) {
    updateProgression(result.updatedProgression);
  }

  void toggleUnlockAll() {
    final updated = state.copyWith(unlockAllRows: !state.unlockAllRows);
    updateProgression(updated);
  }

  void reset() {
    final initial = const UserProgression();
    updateProgression(initial);
  }
}

final userProgressionProvider =
    StateNotifierProvider<UserProgressionNotifier, UserProgression>((ref) {
  final persistence = ref.watch(persistenceProvider);
  return UserProgressionNotifier(persistence);
});

// Character Mastery Notifier & Provider
class CharacterMasteryNotifier
    extends StateNotifier<Map<String, CharacterMastery>> {
  final PersistenceService _persistence;

  CharacterMasteryNotifier(this._persistence)
      : super(_persistence.loadMasteryMap());

  void reload() {
    state = _persistence.loadMasteryMap();
  }

  void recordAttempt(CharacterAttemptPayload payload) {
    final updated = updateCharacterMastery(state, payload);
    state = updated;
    _persistence.saveMasteryMap(updated);
  }

  void setMasteryMap(Map<String, CharacterMastery> newMap) {
    state = newMap;
    _persistence.saveMasteryMap(newMap);
  }

  void clear() {
    state = {};
    _persistence.saveMasteryMap({});
  }
}

final characterMasteryProvider =
    StateNotifierProvider<CharacterMasteryNotifier, Map<String, CharacterMastery>>(
        (ref) {
  final persistence = ref.watch(persistenceProvider);
  return CharacterMasteryNotifier(persistence);
});

// High Scores Notifier & Provider
class HighScoresNotifier extends StateNotifier<List<HighScoreRecord>> {
  final PersistenceService _persistence;

  HighScoresNotifier(this._persistence)
      : super(_persistence.loadHighScores());

  void reload() {
    state = _persistence.loadHighScores();
  }

  Future<void> addHighScore(HighScoreRecord record) async {
    final updated = await _persistence.saveHighScore(record);
    state = updated;
  }

  void setHighScores(List<HighScoreRecord> scores) {
    state = scores;
  }

  void clear() {
    state = [];
  }
}

final highScoresProvider =
    StateNotifierProvider<HighScoresNotifier, List<HighScoreRecord>>((ref) {
  final persistence = ref.watch(persistenceProvider);
  return HighScoresNotifier(persistence);
});

// Computed Analytics Providers
final kanaPerformanceAnalysisProvider = Provider((ref) {
  final mastery = ref.watch(characterMasteryProvider);
  return analyzeKanaPerformance(mastery);
});

final achievementProgressListProvider = Provider<List<AchievementStatus>>((ref) {
  final progression = ref.watch(userProgressionProvider);
  final mastery = ref.watch(characterMasteryProvider);
  return getAchievementProgressList(progression, mastery);
});

final unlockedAchievementsCountProvider = Provider<int>((ref) {
  final list = ref.watch(achievementProgressListProvider);
  return list.where((a) => a.isUnlocked).length;
});

final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final mastery = ref.watch(characterMasteryProvider);
  final progression = ref.watch(userProgressionProvider);
  final highScores = ref.watch(highScoresProvider);
  return buildDashboardSummary(mastery, progression, highScores);
});

// Arena MobX Store Provider
final arenaStoreProvider = Provider<ArenaStore>((ref) {
  return ArenaStore();
});
