import 'package:flutter_test/flutter_test.dart';
import 'package:bunbungo/data/kana_data.dart';
import 'package:bunbungo/logic/dashboard_analytics.dart';
import 'package:bunbungo/logic/deck_generator.dart';
import 'package:bunbungo/logic/mastery_analytics.dart';
import 'package:bunbungo/logic/progression_engine.dart';
import 'package:bunbungo/models/character_mastery.dart';
import 'package:bunbungo/models/game_settings.dart';
import 'package:bunbungo/models/high_score.dart';
import 'package:bunbungo/models/kana_item.dart';
import 'package:bunbungo/models/user_progression.dart';

void main() {
  group('Progression Engine Tests', () {
    test('calculateLevelFromXp calculates correct levels', () {
      expect(calculateLevelFromXp(0), 1);
      expect(calculateLevelFromXp(119), 1);
      expect(calculateLevelFromXp(120), 2);
      expect(calculateLevelFromXp(480), 3);
    });

    test('getXpThresholdForLevel returns quadratic milestones', () {
      expect(getXpThresholdForLevel(1), 0);
      expect(getXpThresholdForLevel(2), 120);
      expect(getXpThresholdForLevel(3), 480);
    });

    test('getRankTitleForLevel assigns appropriate titles', () {
      expect(getRankTitleForLevel(1), 'Novice Learner');
      expect(getRankTitleForLevel(2), 'Kana Apprentice');
      expect(getRankTitleForLevel(5), 'Fluent Reader');
      expect(getRankTitleForLevel(8), 'Script Scholar');
      expect(getRankTitleForLevel(11), 'Kana Sensei');
      expect(getRankTitleForLevel(15), 'Kana Grandmaster');
    });

    test('evaluateSessionProgression calculates XP, streak, and unlocks', () {
      final initial = const UserProgression(
        xp: 100,
        level: 1,
        currentDailyStreak: 1,
        lastPracticeDate: '2026-11-10',
      );

      final result = evaluateSessionProgression(
        sessionScore: 1500,
        sessionCorrect: 10,
        sessionAttempts: 10,
        sessionBestStreak: 10,
        durationSeconds: 20,
        masteryMap: {},
        currentProgression: initial,
        nowDate: DateTime(2026, 11, 11),
      );

      expect(result.xpEarned, greaterThan(0));
      expect(result.updatedProgression.currentDailyStreak, 2);
      expect(result.updatedProgression.totalSessionsCompleted, 1);
      expect(result.updatedProgression.totalCardsAnswered, 10);
    });
  });

  group('Mastery Analytics Tests', () {
    test('getCharacterPerformanceTier classifies correctly', () {
      expect(getCharacterPerformanceTier(null), LetterPerformanceTier.unseen);

      const weakStats = CharacterMastery(attempts: 4, correct: 2, streak: 0);
      expect(getCharacterPerformanceTier(weakStats), LetterPerformanceTier.weak);

      const strongStats = CharacterMastery(attempts: 5, correct: 5, streak: 5);
      expect(getCharacterPerformanceTier(strongStats), LetterPerformanceTier.strong);

      const learningStats = CharacterMastery(attempts: 2, correct: 2, streak: 1);
      expect(getCharacterPerformanceTier(learningStats), LetterPerformanceTier.learning);
    });

    test('updateCharacterMastery records correct and wrong responses', () {
      Map<String, CharacterMastery> map = {};

      map = updateCharacterMastery(
        map,
        const CharacterAttemptPayload(
          kanaId: 'a',
          script: KanaScript.hiragana,
          isCorrect: true,
          chosenRomaji: 'a',
          responseTimeMilliseconds: 900,
        ),
      );

      expect(map['a']?.attempts, 1);
      expect(map['a']?.correct, 1);
      expect(map['a']?.streak, 1);
      expect(map['a']?.fastestResponseTimeMilliseconds, 900);

      // Add a wrong attempt
      map = updateCharacterMastery(
        map,
        const CharacterAttemptPayload(
          kanaId: 'a',
          script: KanaScript.hiragana,
          isCorrect: false,
          chosenRomaji: 'o',
          responseTimeMilliseconds: 1400,
        ),
      );

      expect(map['a']?.attempts, 2);
      expect(map['a']?.correct, 1);
      expect(map['a']?.streak, 0);
      expect(map['a']?.confusedWith['o'], 1);
    });
  });

  group('Deck Generator Tests', () {
    test('buildOptionsForItem produces 4 distinct choices including target', () {
      final target = kanaItems.first;
      final options = buildOptionsForItem(target, kanaItems);

      expect(options.length, 4);
      expect(options.contains(target.romaji), isTrue);
      expect(options.toSet().length, 4); // all distinct
    });

    test('generateChallengeDeck builds non-empty deck with selected rows', () {
      final deck = generateChallengeDeck(
        ['row-a'],
        ScriptSelection.hiragana,
        10,
        {},
      );

      expect(deck.length, 10);
      for (final card in deck) {
        expect(card.item.rowId, 'row-a');
        expect(card.options.length, 4);
      }
    });

    test('scheduleSpacedRetryInDeck inserts redemption card after delay', () {
      final deck = generateChallengeDeck(
        ['row-a'],
        ScriptSelection.hiragana,
        10,
        {},
      );

      final missedItem = deck.first.item;
      final retriedDeck = scheduleSpacedRetryInDeck(
        deck,
        0,
        missedItem,
        ScriptSelection.hiragana,
      );

      expect(retriedDeck.length, deck.length + 1);
      expect(retriedDeck.any((c) => c.isRedemption && c.item.id == missedItem.id), isTrue);
    });
  });

  group('Dashboard Analytics Tests', () {
    test('buildDashboardSummary compiles complete analytics report', () {
      const progression = UserProgression(level: 2, xp: 200);
      final highScores = [
        const HighScoreRecord(
          id: '1',
          gameMode: GameMode.sprint,
          scriptMode: ScriptSelection.hiragana,
          score: 1200,
          accuracy: 90,
          cardsCleared: 20,
          durationSeconds: 40,
          dateIso: '2026-11-10T12:00:00Z',
        ),
      ];

      final summary = buildDashboardSummary({}, progression, highScores);

      expect(summary.coveragePercent, 0);
      expect(summary.scriptSummaries.length, 2);
      expect(summary.categorySummaries.length, 3);
      expect(summary.speedBuckets.length, 4);
      expect(summary.recommendations.isNotEmpty, isTrue);
    });
  });
}
