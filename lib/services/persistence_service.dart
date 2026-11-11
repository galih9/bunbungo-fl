import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/user_progression.dart';

class PersistenceService {
  static const String _settingsKey = 'bunbungo_offline_settings_v1';
  static const String _masteryKey = 'bunbungo_offline_mastery_v1';
  static const String _highScoresKey = 'bunbungo_offline_highscores_v1';
  static const String _progressionKey = 'bunbungo_offline_progression_v1';

  final SharedPreferences _prefs;

  PersistenceService(this._prefs);

  static Future<PersistenceService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return PersistenceService(prefs);
  }

  StoredGameSettings loadGameSettings() {
    try {
      final raw = _prefs.getString(_settingsKey);
      if (raw == null || raw.isEmpty) {
        return const StoredGameSettings();
      }
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return StoredGameSettings.fromJson(decoded);
      }
      return const StoredGameSettings();
    } catch (_) {
      return const StoredGameSettings();
    }
  }

  Future<void> saveGameSettings(StoredGameSettings settings) async {
    try {
      await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    } catch (_) {}
  }

  Map<String, CharacterMastery> loadMasteryMap() {
    try {
      final raw = _prefs.getString(_masteryKey);
      if (raw == null || raw.isEmpty) return {};
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final result = <String, CharacterMastery>{};
        for (final entry in decoded.entries) {
          if (entry.value is Map) {
            result[entry.key.toString()] = CharacterMastery.fromJson(
              Map<String, dynamic>.from(entry.value as Map),
            );
          }
        }
        return result;
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  Future<void> saveMasteryMap(Map<String, CharacterMastery> mastery) async {
    try {
      final map = {
        for (final entry in mastery.entries) entry.key: entry.value.toJson(),
      };
      await _prefs.setString(_masteryKey, jsonEncode(map));
    } catch (_) {}
  }

  UserProgression loadUserProgression() {
    try {
      final raw = _prefs.getString(_progressionKey);
      if (raw == null || raw.isEmpty) return const UserProgression();
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserProgression.fromJson(decoded);
      }
      return const UserProgression();
    } catch (_) {
      return const UserProgression();
    }
  }

  Future<void> saveUserProgression(UserProgression progression) async {
    try {
      await _prefs.setString(_progressionKey, jsonEncode(progression.toJson()));
    } catch (_) {}
  }

  List<HighScoreRecord> loadHighScores() {
    try {
      final raw = _prefs.getString(_highScoresKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => HighScoreRecord.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<HighScoreRecord>> saveHighScore(HighScoreRecord record) async {
    final list = loadHighScores();
    final updated = [record, ...list]..sort((a, b) => b.score.compareTo(a.score));
    final trimmed = updated.take(15).toList();
    try {
      await _prefs.setString(
        _highScoresKey,
        jsonEncode(trimmed.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
    return trimmed;
  }

  Future<void> clearAllProgress() async {
    try {
      await _prefs.remove(_masteryKey);
      await _prefs.remove(_highScoresKey);
      await _prefs.remove(_progressionKey);
    } catch (_) {}
  }
}
