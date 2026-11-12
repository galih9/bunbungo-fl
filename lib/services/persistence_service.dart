import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/isar/isar_service.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/user_progression.dart';

class PersistenceService {
  static const String _settingsKey = 'bunbungo_offline_settings_v1';
  static const String _masteryKey = 'bunbungo_offline_mastery_v1';
  static const String _highScoresKey = 'bunbungo_offline_highscores_v1';
  static const String _progressionKey = 'bunbungo_offline_progression_v1';
  static const String _lastExportDateKey = 'bunbungo_last_export_date_v1';
  static const String _lastExportDeviceKey = 'bunbungo_last_export_device_v1';
  static const String _lastImportDateKey = 'bunbungo_last_import_date_v1';
  static const String _lastImportDeviceKey = 'bunbungo_last_import_device_v1';
  static const String _lastExportPathKey = 'bunbungo_last_export_path_v1';

  final SharedPreferences _prefs;
  final IsarService? _isarService;

  PersistenceService(this._prefs, [this._isarService]);

  IsarService? get isarService => _isarService;

  static Future<PersistenceService> getInstance({
    String? customDirectory,
    bool? enableIsar,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    IsarService? isarService;

    // In FakeAsync widget tests, native async FFI locks unless customDirectory is provided
    final isWidgetTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
    final shouldEnableIsar =
        enableIsar ?? (!isWidgetTest || customDirectory != null);

    if (shouldEnableIsar) {
      try {
        isarService = await IsarService.openInstance(
          customDirectory: customDirectory,
          prefs: prefs,
        );
      } catch (e) {
        debugPrint('Could not initialize IsarService: $e. Falling back to SharedPreferences.');
      }
    }

    return PersistenceService(prefs, isarService);
  }

  StoredGameSettings loadGameSettings() {
    if (_isarService != null) {
      return _isarService.loadGameSettings();
    }
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
    if (_isarService != null) {
      await _isarService.saveGameSettings(settings);
    }
    try {
      await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    } catch (_) {}
  }

  Map<String, CharacterMastery> loadMasteryMap() {
    if (_isarService != null) {
      return _isarService.loadMasteryMap();
    }
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
    if (_isarService != null) {
      await _isarService.saveMasteryMap(mastery);
    }
    try {
      final map = {
        for (final entry in mastery.entries) entry.key: entry.value.toJson(),
      };
      await _prefs.setString(_masteryKey, jsonEncode(map));
    } catch (_) {}
  }

  UserProgression loadUserProgression() {
    if (_isarService != null) {
      return _isarService.loadUserProgression();
    }
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
    if (_isarService != null) {
      await _isarService.saveUserProgression(progression);
    }
    try {
      await _prefs.setString(_progressionKey, jsonEncode(progression.toJson()));
    } catch (_) {}
  }

  List<HighScoreRecord> loadHighScores() {
    if (_isarService != null) {
      return _isarService.loadHighScores();
    }
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
    List<HighScoreRecord> trimmed = [];
    if (_isarService != null) {
      trimmed = await _isarService.saveHighScore(record);
    } else {
      final list = loadHighScores();
      final updated = [record, ...list]..sort((a, b) => b.score.compareTo(a.score));
      trimmed = updated.take(15).toList();
    }
    try {
      await _prefs.setString(
        _highScoresKey,
        jsonEncode(trimmed.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
    return trimmed;
  }

  Future<void> restoreAllHighScores(List<HighScoreRecord> records) async {
    if (_isarService != null) {
      await _isarService.restoreAllHighScores(records);
    }
    final updated = List<HighScoreRecord>.from(records)
      ..sort((a, b) => b.score.compareTo(a.score));
    final trimmed = updated.take(15).toList();
    try {
      await _prefs.setString(
        _highScoresKey,
        jsonEncode(trimmed.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
  }

  String? getLastExportDate() => _prefs.getString(_lastExportDateKey);

  Future<void> setLastExportDate(String dateIso) async {
    try {
      await _prefs.setString(_lastExportDateKey, dateIso);
    } catch (_) {}
  }

  String? getLastImportDate() => _prefs.getString(_lastImportDateKey);

  Future<void> setLastImportDate(String dateIso) async {
    try {
      await _prefs.setString(_lastImportDateKey, dateIso);
    } catch (_) {}
  }

  Map<String, dynamic>? getLastExportDevice() {
    try {
      final raw = _prefs.getString(_lastExportDeviceKey);
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> setLastExportDevice(Map<String, dynamic> device) async {
    try {
      await _prefs.setString(_lastExportDeviceKey, jsonEncode(device));
    } catch (_) {}
  }

  Map<String, dynamic>? getLastImportDevice() {
    try {
      final raw = _prefs.getString(_lastImportDeviceKey);
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> setLastImportDevice(Map<String, dynamic> device) async {
    try {
      await _prefs.setString(_lastImportDeviceKey, jsonEncode(device));
    } catch (_) {}
  }

  String? getLastExportPath() => _prefs.getString(_lastExportPathKey);

  Future<void> setLastExportPath(String path) async {
    try {
      await _prefs.setString(_lastExportPathKey, path);
    } catch (_) {}
  }

  Future<void> clearAllProgress() async {
    if (_isarService != null) {
      await _isarService.clearAllProgress();
    }
    try {
      await _prefs.remove(_masteryKey);
      await _prefs.remove(_highScoresKey);
      await _prefs.remove(_progressionKey);
    } catch (_) {}
  }
}
