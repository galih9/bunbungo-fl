import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bunbungo/data/isar/isar_service.dart';
import 'package:bunbungo/data/kana_data.dart';
import 'package:bunbungo/logic/arena_store.dart';
import 'package:bunbungo/logic/deck_generator.dart';
import 'package:bunbungo/models/challenge.dart';
import 'package:bunbungo/models/character_mastery.dart';
import 'package:bunbungo/models/game_settings.dart';
import 'package:bunbungo/models/high_score.dart';
import 'package:bunbungo/models/kana_item.dart';
import 'package:bunbungo/models/user_progression.dart';
import 'package:bunbungo/providers/app_providers.dart';
import 'package:bunbungo/services/persistence_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testDbDir;
  late IsarService isarService;
  late PersistenceService persistence;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    testDbDir = await Directory.systemTemp.createTemp('bunbungo_test_db');
    final prefs = await SharedPreferences.getInstance();
    isarService = await IsarService.openInstance(
      customDirectory: testDbDir.path,
      prefs: prefs,
    );
    persistence = PersistenceService(prefs, isarService);
  });

  tearDown(() async {
    await isarService.close();
    if (await testDbDir.exists()) {
      await testDbDir.delete(recursive: true);
    }
  });

  group('Isar Offline-First Persistence Tests', () {
    test('Saves and loads GameSettings in Isar', () async {
      const newSettings = StoredGameSettings(
        soundEnabled: false,
        voiceEnabled: false,
        themeMode: AppThemeMode.oled,
        accentColor: AppAccentColor.purple,
        gameMode: GameMode.timeAttack,
      );

      await persistence.saveGameSettings(newSettings);
      final loaded = persistence.loadGameSettings();

      expect(loaded.soundEnabled, isFalse);
      expect(loaded.voiceEnabled, isFalse);
      expect(loaded.themeMode, AppThemeMode.oled);
      expect(loaded.accentColor, AppAccentColor.purple);
      expect(loaded.gameMode, GameMode.timeAttack);
    });

    test('Saves and loads UserProgression in Isar', () async {
      const progression = UserProgression(
        xp: 450,
        level: 3,
        currentDailyStreak: 5,
        bestDailyStreak: 7,
        totalSessionsCompleted: 12,
        totalCardsAnswered: 240,
        unlockedRowIds: ['row-a', 'row-ka', 'row-sa', 'row-ta'],
      );

      await persistence.saveUserProgression(progression);
      final loaded = persistence.loadUserProgression();

      expect(loaded.xp, 450);
      expect(loaded.level, 3);
      expect(loaded.currentDailyStreak, 5);
      expect(loaded.bestDailyStreak, 7);
      expect(loaded.unlockedRowIds, contains('row-ta'));
    });

    test('Saves, queries, and updates CharacterMastery in Isar', () async {
      final masteryMap = {
        'a': const CharacterMastery(
          attempts: 10,
          correct: 9,
          streak: 4,
          fastestResponseTimeMilliseconds: 750,
          confusedWith: {'o': 1},
        ),
        'ka': const CharacterMastery(
          attempts: 6,
          correct: 6,
          streak: 6,
          fastestResponseTimeMilliseconds: 820,
        ),
      };

      await persistence.saveMasteryMap(masteryMap);
      final loaded = persistence.loadMasteryMap();

      expect(loaded.length, 2);
      expect(loaded['a']?.attempts, 10);
      expect(loaded['a']?.correct, 9);
      expect(loaded['a']?.streak, 4);
      expect(loaded['a']?.fastestResponseTimeMilliseconds, 750);
      expect(loaded['a']?.confusedWith['o'], 1);
      expect(loaded['ka']?.streak, 6);
    });

    test('Saves, limits to 15, and sorts HighScoreRecord descending by score', () async {
      for (int i = 1; i <= 20; i++) {
        await persistence.saveHighScore(
          HighScoreRecord(
            id: 'hs-$i',
            gameMode: GameMode.sprint,
            scriptMode: ScriptSelection.hiragana,
            score: i * 100,
            accuracy: 90,
            cardsCleared: 20,
            durationSeconds: 30,
            dateIso: DateTime.now().toIso8601String(),
          ),
        );
      }

      final topScores = persistence.loadHighScores();
      expect(topScores.length, 15);
      expect(topScores.first.score, 2000);
      expect(topScores.last.score, 600);
    });

    test('clearAllProgress clears Isar collections', () async {
      await persistence.saveMasteryMap({'a': const CharacterMastery(attempts: 1)});
      await persistence.saveHighScore(
        HighScoreRecord(
          id: 'test',
          gameMode: GameMode.sprint,
          scriptMode: ScriptSelection.hiragana,
          score: 500,
          accuracy: 100,
          cardsCleared: 5,
          durationSeconds: 10,
          dateIso: DateTime.now().toIso8601String(),
        ),
      );

      await persistence.clearAllProgress();

      expect(persistence.loadMasteryMap(), isEmpty);
      expect(persistence.loadHighScores(), isEmpty);
      expect(persistence.loadUserProgression().xp, 0);
    });
  });

  group('Riverpod Providers Tests', () {
    test('Providers reactively notify state changes and persist to Isar', () async {
      final container = ProviderContainer(
        overrides: [
          persistenceProvider.overrideWithValue(persistence),
        ],
      );
      addTearDown(container.dispose);

      // Verify initial state
      expect(container.read(gameSettingsProvider).soundEnabled, isTrue);

      // Mutate GameSettings via notifier
      container.read(gameSettingsProvider.notifier).toggleSound();
      expect(container.read(gameSettingsProvider).soundEnabled, isFalse);
      expect(persistence.loadGameSettings().soundEnabled, isFalse);

      // Mutate UserProgression via notifier
      container.read(userProgressionProvider.notifier).updateProgression(
            const UserProgression(xp: 600, level: 3),
          );
      expect(container.read(userProgressionProvider).xp, 600);
      expect(persistence.loadUserProgression().xp, 600);

      // Mutate CharacterMastery via notifier
      container.read(characterMasteryProvider.notifier).recordAttempt(
            const CharacterAttemptPayload(
              kanaId: 'i',
              script: KanaScript.hiragana,
              isCorrect: true,
              chosenRomaji: 'i',
              responseTimeMilliseconds: 650,
            ),
          );
      expect(container.read(characterMasteryProvider)['i']?.attempts, 1);
      expect(persistence.loadMasteryMap()['i']?.correct, 1);

      // Test computed providers
      final analysis = container.read(kanaPerformanceAnalysisProvider);
      expect(analysis.weakItems.length + analysis.strongItems.length + analysis.learningItems.length, greaterThanOrEqualTo(1));

      final dashboard = container.read(dashboardSummaryProvider);
      expect(dashboard.recommendations.isNotEmpty, isTrue);
      expect(dashboard.overallProficiencyScore, greaterThanOrEqualTo(0));
    });
  });

  group('MobX ArenaStore Tests', () {
    test('ArenaStore manages real-time game loop and computed properties', () {
      final store = ArenaStore();

      expect(store.isLobby, isTrue);
      expect(store.isPlaying, isFalse);

      final deck = generateChallengeDeck(
        ['row-a'],
        ScriptSelection.hiragana,
        5,
        {},
      );

      store.startSession(deck);

      expect(store.isPlaying, isTrue);
      expect(store.deck.length, 5);
      expect(store.currentIndex, 0);
      expect(store.score, 0);
      expect(store.remainingSeconds, 60);

      // Decrement timer
      store.decrementTimer();
      expect(store.remainingSeconds, 59);

      // Submit correct answer
      store.recordCorrect(
        points: 150,
        chosenRomaji: 'a',
        expectedRomaji: 'a',
        isRedemption: false,
        responseTime: 800,
        speedTier: SpeedTier.instant,
      );

      expect(store.score, 150);
      expect(store.streak, 1);
      expect(store.bestStreak, 1);
      expect(store.correctCount, 1);
      expect(store.attemptCount, 1);
      expect(store.accuracy, 100);
      expect(store.feedback?.isCorrect, isTrue);

      // Advance card
      final hasNext = store.advanceCard(
        isInfiniteMode: false,
        activePool: kanaItems,
        scriptMode: ScriptSelection.hiragana,
        masteryMap: {},
      );

      expect(hasNext, isTrue);
      expect(store.currentIndex, 1);
      expect(store.feedback, isNull);

      // Record wrong answer
      final secondCard = store.currentCard!;
      store.recordWrong(
        item: secondCard.item,
        chosenRomaji: 'wrong',
        expectedRomaji: secondCard.item.romaji,
        responseTime: 1500,
        scriptMode: ScriptSelection.hiragana,
      );

      expect(store.streak, 0);
      expect(store.bestStreak, 1);
      expect(store.correctCount, 1);
      expect(store.attemptCount, 2);
      expect(store.accuracy, 50);
      expect(store.missedItems.length, 1);
      expect(store.feedback?.isCorrect, isFalse);

      // Reset to lobby
      store.resetToLobby();
      expect(store.isLobby, isTrue);
    });
  });
}
