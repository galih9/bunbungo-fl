import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/character_mastery.dart';
import '../../models/game_settings.dart';
import '../../models/high_score.dart';
import '../../models/user_progression.dart';
import 'character_mastery_entity.dart';
import 'game_settings_entity.dart';
import 'high_score_entity.dart';
import 'user_progression_entity.dart';

class IsarService {
  final Isar isar;
  final SharedPreferences? prefs;

  // In-memory hot cache for instant zero-latency UI access
  StoredGameSettings _cachedSettings;
  UserProgression _cachedProgression;
  Map<String, CharacterMastery> _cachedMastery;
  List<HighScoreRecord> _cachedHighScores;

  IsarService._({
    required this.isar,
    this.prefs,
    required StoredGameSettings initialSettings,
    required UserProgression initialProgression,
    required Map<String, CharacterMastery> initialMastery,
    required List<HighScoreRecord> initialHighScores,
  })  : _cachedSettings = initialSettings,
        _cachedProgression = initialProgression,
        _cachedMastery = initialMastery,
        _cachedHighScores = initialHighScores;

  static Future<IsarService> openInstance({
    String? customDirectory,
    SharedPreferences? prefs,
  }) async {
    String dbDirectory = customDirectory ?? '';
    if (dbDirectory.isEmpty) {
      try {
        final docDir = await getApplicationDocumentsDirectory()
            .timeout(const Duration(milliseconds: 600));
        dbDirectory = docDir.path;
      } catch (_) {
        final temp = await Directory.systemTemp.createTemp('bunbungo_isar');
        dbDirectory = temp.path;
      }
    }

    // Initialize core if needed in tests/mac
    if (!kIsWeb) {
      try {
        await Isar.initializeIsarCore(download: true);
      } catch (_) {
        // Core might already be initialized
      }
    }

    final isar = Isar.getInstance('bunbungo_offline_db') ??
        await Isar.open(
          [
            GameSettingsEntitySchema,
            UserProgressionEntitySchema,
            CharacterMasteryEntitySchema,
            HighScoreEntitySchema,
          ],
          name: 'bunbungo_offline_db',
          directory: dbDirectory,
          inspector: false,
        );

    final sharedPrefs = prefs ?? await SharedPreferences.getInstance();

    // Load initial values from Isar, or fallback/migrate from SharedPreferences
    StoredGameSettings loadedSettings = const StoredGameSettings();
    final settingsEntity = await isar.gameSettingsEntitys.get(1);
    if (settingsEntity != null) {
      loadedSettings = settingsEntity.toModel();
    } else {
      // Check legacy SharedPreferences for migration
      final legacyRaw = sharedPrefs.getString('bunbungo_offline_settings_v1');
      if (legacyRaw != null && legacyRaw.isNotEmpty) {
        try {
          final decoded = StoredGameSettings.fromJson(
            Map<String, dynamic>.from(sharedPrefs.getString('bunbungo_offline_settings_v1') as dynamic),
          );
          loadedSettings = decoded;
        } catch (_) {}
      }
      // Seed Isar with initial settings
      await isar.writeTxn(() async {
        await isar.gameSettingsEntitys.put(GameSettingsEntity.fromModel(loadedSettings));
      });
    }

    UserProgression loadedProgression = const UserProgression();
    final progressionEntity = await isar.userProgressionEntitys.get(1);
    if (progressionEntity != null) {
      loadedProgression = progressionEntity.toModel();
    } else {
      await isar.writeTxn(() async {
        await isar.userProgressionEntitys.put(UserProgressionEntity.fromModel(loadedProgression));
      });
    }

    Map<String, CharacterMastery> loadedMastery = {};
    final masteryEntities = await isar.characterMasteryEntitys.where().findAll();
    if (masteryEntities.isNotEmpty) {
      for (final m in masteryEntities) {
        loadedMastery[m.kanaId] = m.toModel();
      }
    }

    List<HighScoreRecord> loadedHighScores = [];
    final highScoreEntities = await isar.highScoreEntitys
        .where()
        .sortByScoreDesc()
        .limit(15)
        .findAll();
    if (highScoreEntities.isNotEmpty) {
      loadedHighScores = highScoreEntities.map((e) => e.toModel()).toList();
    }

    return IsarService._(
      isar: isar,
      prefs: sharedPrefs,
      initialSettings: loadedSettings,
      initialProgression: loadedProgression,
      initialMastery: loadedMastery,
      initialHighScores: loadedHighScores,
    );
  }

  // Settings
  StoredGameSettings loadGameSettings() => _cachedSettings;

  Future<void> saveGameSettings(StoredGameSettings settings) async {
    _cachedSettings = settings;
    try {
      await isar.writeTxn(() async {
        await isar.gameSettingsEntitys.put(GameSettingsEntity.fromModel(settings));
      });
    } catch (e) {
      debugPrint('Isar saveGameSettings error: $e');
    }
  }

  // Progression
  UserProgression loadUserProgression() => _cachedProgression;

  Future<void> saveUserProgression(UserProgression progression) async {
    _cachedProgression = progression;
    try {
      await isar.writeTxn(() async {
        await isar.userProgressionEntitys.put(UserProgressionEntity.fromModel(progression));
      });
    } catch (e) {
      debugPrint('Isar saveUserProgression error: $e');
    }
  }

  // Mastery Map
  Map<String, CharacterMastery> loadMasteryMap() => Map.unmodifiable(_cachedMastery);

  Future<void> saveMasteryMap(Map<String, CharacterMastery> mastery) async {
    _cachedMastery = Map.from(mastery);
    try {
      await isar.writeTxn(() async {
        final entities = mastery.entries
            .map((e) => CharacterMasteryEntity.fromModel(e.key, e.value))
            .toList();
        await isar.characterMasteryEntitys.putAll(entities);
      });
    } catch (e) {
      debugPrint('Isar saveMasteryMap error: $e');
    }
  }

  // High Scores
  List<HighScoreRecord> loadHighScores() => List.unmodifiable(_cachedHighScores);

  Future<List<HighScoreRecord>> saveHighScore(HighScoreRecord record) async {
    final updated = [record, ..._cachedHighScores]..sort((a, b) => b.score.compareTo(a.score));
    final trimmed = updated.take(15).toList();
    _cachedHighScores = trimmed;

    try {
      await isar.writeTxn(() async {
        await isar.highScoreEntitys.put(HighScoreEntity.fromModel(record));
        // Keep top 15 in database
        final all = await isar.highScoreEntitys.where().sortByScoreDesc().findAll();
        if (all.length > 15) {
          final toDelete = all.skip(15).map((e) => e.id).toList();
          await isar.highScoreEntitys.deleteAll(toDelete);
        }
      });
    } catch (e) {
      debugPrint('Isar saveHighScore error: $e');
    }

    return trimmed;
  }

  // Clear All
  Future<void> clearAllProgress() async {
    _cachedMastery = {};
    _cachedProgression = const UserProgression();
    _cachedHighScores = [];
    try {
      await isar.writeTxn(() async {
        await isar.characterMasteryEntitys.clear();
        await isar.userProgressionEntitys.clear();
        await isar.highScoreEntitys.clear();
        await isar.userProgressionEntitys.put(UserProgressionEntity.fromModel(const UserProgression()));
      });
    } catch (e) {
      debugPrint('Isar clearAllProgress error: $e');
    }
  }

  Future<void> close() async {
    if (isar.isOpen) {
      await isar.close();
    }
  }
}
