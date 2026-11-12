import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bunbungo/models/character_mastery.dart';
import 'package:bunbungo/models/game_settings.dart';
import 'package:bunbungo/models/high_score.dart';
import 'package:bunbungo/models/user_data_backup.dart';
import 'package:bunbungo/models/user_progression.dart';
import 'package:bunbungo/services/backup_service.dart';
import 'package:bunbungo/services/persistence_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testDir;
  late PersistenceService persistence;
  late UserDataBackupService backupService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    persistence = PersistenceService(prefs);
    backupService = UserDataBackupService(persistence);

    testDir = await Directory.systemTemp.createTemp('bunbungo_backup_test_');
  });

  tearDown(() async {
    try {
      if (testDir.existsSync()) {
        await testDir.delete(recursive: true);
      }
    } catch (_) {}
  });

  group('UserDataBackup Model Tests', () {
    test('serializes and deserializes complete user data backup correctly', () {
      final progression = const UserProgression(
        xp: 4500,
        level: 6,
        currentDailyStreak: 9,
        bestDailyStreak: 15,
        lastPracticeDate: '2026-11-12',
        bestAnswerStreak: 32,
        totalSessionsCompleted: 45,
        totalCardsAnswered: 450,
        totalCorrectAnswers: 420,
        unlockedRowIds: ['row-a', 'row-ka', 'row-sa', 'row-ta', 'row-na'],
        unlockAllRows: true,
        unlockedAchievements: {
          'first_session': '2026-11-01T10:00:00Z',
          'streak_3': '2026-11-04T12:00:00Z',
          'streak_7': '2026-11-08T15:00:00Z',
        },
      );

      final mastery = {
        'a': const CharacterMastery(
          attempts: 20,
          correct: 19,
          wrong: 1,
          streak: 12,
          bestStreak: 15,
          totalResponseTimeMilliseconds: 15000,
          fastestResponseTimeMilliseconds: 450,
          lastPracticedIso: '2026-11-12T10:00:00Z',
          confusedWith: {'o': 1},
        ),
      };

      final highScores = [
        const HighScoreRecord(
          id: 'score-1',
          gameMode: GameMode.sprint,
          scriptMode: ScriptSelection.hiragana,
          score: 1850,
          accuracy: 95,
          cardsCleared: 20,
          durationSeconds: 25,
          dateIso: '2026-11-12T11:00:00Z',
        ),
      ];

      final backup = UserDataBackup(
        appVersion: '1.1.0+2',
        exportedAt: '2026-11-12T14:30:00Z',
        lastExportedAt: '2026-11-10T08:00:00Z',
        lastImportedAt: '2026-11-05T09:00:00Z',
        deviceInfo: {
          'platform': 'macOS',
          'operatingSystem': 'macos',
          'deviceModel': 'MacBook-Pro',
        },
        progression: progression,
        mastery: mastery,
        highScores: highScores,
      );

      final jsonMap = backup.toJson();
      final restored = UserDataBackup.fromJson(jsonMap);

      expect(restored.appVersion, '1.1.0+2');
      expect(restored.exportedAt, '2026-11-12T14:30:00Z');
      expect(restored.lastExportedAt, '2026-11-10T08:00:00Z');
      expect(restored.lastImportedAt, '2026-11-05T09:00:00Z');
      expect(restored.deviceInfo['platform'], 'macOS');
      expect(restored.progression.xp, 4500);
      expect(restored.progression.currentDailyStreak, 9);
      expect(restored.progression.bestDailyStreak, 15);
      expect(restored.progression.bestAnswerStreak, 32);
      expect(restored.progression.unlockedRowIds.length, 5);
      expect(restored.progression.unlockAllRows, true);
      expect(restored.progression.unlockedAchievements.length, 3);
      expect(restored.progression.unlockedAchievements['streak_7'], isNotNull);
      expect(restored.mastery['a']?.streak, 12);
      expect(restored.highScores.first.score, 1850);
    });
  });

  group('UserDataBackupService Export & Import Tests', () {
    test('exports user data disguised as .bbg file created from json', () async {
      // Seed data in persistence
      final progression = const UserProgression(
        xp: 2200,
        level: 4,
        currentDailyStreak: 5,
        bestDailyStreak: 10,
        unlockedRowIds: ['row-a', 'row-ka', 'row-sa', 'row-ta'],
        unlockedAchievements: {'badge_streak_3': '2026-11-10T12:00:00Z'},
      );
      await persistence.saveUserProgression(progression);

      final mastery = {
        'ka': const CharacterMastery(attempts: 10, correct: 9, streak: 5),
      };
      await persistence.saveMasteryMap(mastery);

      final score = const HighScoreRecord(
        id: 'rec-1',
        gameMode: GameMode.sprint,
        scriptMode: ScriptSelection.hiragana,
        score: 1500,
        accuracy: 90,
        cardsCleared: 20,
        durationSeconds: 30,
        dateIso: '2026-11-11T12:00:00Z',
      );
      await persistence.saveHighScore(score);

      // Perform Export
      final exportedFile = await backupService.exportUserData(
        customDirectory: testDir,
        customFileName: 'test_export',
        appVersionOverride: '1.2.3+4',
        deviceInfoOverride: {
          'deviceModel': 'TestDevicePro',
          'operatingSystem': 'testOS',
        },
      );

      // Verify file is renamed to .bbg for disguise
      expect(exportedFile.path.endsWith('.bbg'), isTrue);
      expect(exportedFile.existsSync(), isTrue);

      // Verify that the underlying content is still valid JSON text
      final content = await exportedFile.readAsString();
      expect(content.contains('"appVersion": "1.2.3+4"'), isTrue);
      expect(content.contains('"TestDevicePro"'), isTrue);
      expect(content.contains('"badge_streak_3"'), isTrue);

      // Verify telemetry recorded in persistence
      expect(persistence.getLastExportDate(), isNotNull);
      expect(persistence.getLastExportDevice()?['deviceModel'], 'TestDevicePro');
      expect(persistence.getLastExportPath(), exportedFile.path);
    });

    test('rejects non-.bbg files on import', () async {
      final invalidFile = File('${testDir.path}/fake_backup.json');
      await invalidFile.writeAsString('{"some": "data"}');

      expect(
        () => backupService.importUserDataFromFile(invalidFile),
        throwsA(isA<FormatException>()),
      );
    });

    test('imports .bbg file: renames to .json, consumes it, and applies to database', () async {
      // 1. Prepare export file with unique data
      final initialProgression = const UserProgression(
        xp: 9999,
        level: 12,
        currentDailyStreak: 21,
        bestDailyStreak: 30,
        unlockedRowIds: ['row-a', 'row-ka', 'row-sa', 'row-ta', 'row-na', 'row-ha'],
        unlockAllRows: true,
        unlockedAchievements: {
          'master_kana': '2026-11-01T00:00:00Z',
          'streak_20': '2026-11-12T00:00:00Z',
        },
      );
      await persistence.saveUserProgression(initialProgression);

      final initialMastery = {
        'shi': const CharacterMastery(attempts: 30, correct: 28, streak: 14),
      };
      await persistence.saveMasteryMap(initialMastery);

      final exportedBbg = await backupService.exportUserData(
        customDirectory: testDir,
        customFileName: 'backup_to_restore',
        appVersionOverride: '2.0.0+99',
        deviceInfoOverride: {'deviceModel': 'SourceMacBook', 'operatingSystem': 'macOS'},
      );

      expect(exportedBbg.path.endsWith('.bbg'), isTrue);

      // 2. Clear current persistence to simulate fresh device or wipe
      await persistence.clearAllProgress();
      expect(persistence.loadUserProgression().xp, 0);
      expect(persistence.loadMasteryMap().isEmpty, isTrue);

      // 3. Inspect backup file before restoring
      final inspected = await backupService.inspectBackupFile(exportedBbg);
      expect(inspected.appVersion, '2.0.0+99');
      expect(inspected.progression.xp, 9999);
      expect(inspected.progression.currentDailyStreak, 21);
      expect(inspected.progression.unlockedAchievements.containsKey('master_kana'), isTrue);

      // 4. Import user data from the .bbg file
      final restoredBackup = await backupService.importUserDataFromFile(exportedBbg);

      // 5. Verify the data has been consumed and applied to the database
      expect(restoredBackup.progression.xp, 9999);
      expect(restoredBackup.progression.level, 12);

      final restoredProg = persistence.loadUserProgression();
      expect(restoredProg.xp, 9999);
      expect(restoredProg.level, 12);
      expect(restoredProg.currentDailyStreak, 21);
      expect(restoredProg.bestDailyStreak, 30);
      expect(restoredProg.unlockAllRows, true);
      expect(restoredProg.unlockedRowIds, contains('row-ha'));
      expect(restoredProg.unlockedAchievements['master_kana'], '2026-11-01T00:00:00Z');
      expect(restoredProg.unlockedAchievements['streak_20'], '2026-11-12T00:00:00Z');

      final restoredMastery = persistence.loadMasteryMap();
      expect(restoredMastery['shi']?.streak, 14);
      expect(restoredMastery['shi']?.correct, 28);

      // Verify import metadata in persistence
      expect(persistence.getLastImportDate(), isNotNull);
      expect(persistence.getLastImportDevice()?['deviceModel'], 'SourceMacBook');

      // Verify that after import processing, the original file is still disguised as .bbg
      expect(exportedBbg.existsSync(), isTrue);
      expect(exportedBbg.path.endsWith('.bbg'), isTrue);
    });
  });
}
