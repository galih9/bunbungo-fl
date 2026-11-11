import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/kana_item.dart';
import '../models/user_progression.dart';
import '../logic/mastery_analytics.dart';
import '../logic/progression_engine.dart';
import 'persistence_service.dart';

class SeededData {
  final Map<String, CharacterMastery> masteryMap;
  final UserProgression progression;
  final List<HighScoreRecord> highScores;

  const SeededData({
    required this.masteryMap,
    required this.progression,
    required this.highScores,
  });
}

class SampleDataSeeder {
  static SeededData seed(PersistenceService persistence) {
    Map<String, CharacterMastery> mastery = {};

    final sampleEntries = [
      ('a', KanaScript.hiragana, 8, 8, 920, ''),
      ('i', KanaScript.hiragana, 7, 7, 980, ''),
      ('u', KanaScript.katakana, 6, 6, 1120, ''),
      ('e', KanaScript.hiragana, 6, 6, 1250, ''),
      ('o', KanaScript.katakana, 7, 6, 1340, ''),
      ('ka', KanaScript.hiragana, 6, 6, 1080, ''),
      ('ki', KanaScript.hiragana, 5, 5, 1420, ''),
      ('ku', KanaScript.katakana, 5, 4, 1650, ''),
      ('ke', KanaScript.hiragana, 5, 5, 1390, ''),
      ('ko', KanaScript.katakana, 6, 6, 1150, ''),
      ('shi', KanaScript.katakana, 6, 3, 2850, 'chi'),
      ('tsu', KanaScript.hiragana, 6, 3, 2980, 'su'),
      ('sa', KanaScript.hiragana, 5, 5, 1220, ''),
      ('su', KanaScript.hiragana, 4, 4, 1450, ''),
      ('se', KanaScript.hiragana, 4, 3, 1950, ''),
      ('so', KanaScript.katakana, 5, 3, 2750, 'n'),
      ('ta', KanaScript.hiragana, 4, 4, 1380, ''),
      ('chi', KanaScript.hiragana, 5, 4, 1620, ''),
      ('te', KanaScript.hiragana, 4, 4, 1290, ''),
      ('to', KanaScript.hiragana, 4, 4, 1310, ''),
      ('na', KanaScript.hiragana, 3, 3, 1480, ''),
      ('ni', KanaScript.hiragana, 3, 3, 1350, ''),
      ('nu', KanaScript.hiragana, 4, 2, 3420, 'me'),
      ('ne', KanaScript.hiragana, 4, 2, 3250, 'wa'),
      ('no', KanaScript.hiragana, 5, 5, 890, ''),
      ('ha', KanaScript.hiragana, 3, 3, 1420, ''),
      ('hi', KanaScript.hiragana, 3, 3, 1510, ''),
      ('fu', KanaScript.hiragana, 4, 2, 3100, 'hu'),
      ('he', KanaScript.hiragana, 4, 4, 990, ''),
      ('ho', KanaScript.hiragana, 3, 3, 1620, ''),
      ('ma', KanaScript.hiragana, 2, 2, 1720, ''),
      ('mi', KanaScript.hiragana, 2, 2, 1650, ''),
      ('mu', KanaScript.hiragana, 2, 1, 2900, ''),
      ('me', KanaScript.hiragana, 3, 2, 2800, 'nu'),
      ('mo', KanaScript.hiragana, 2, 2, 1580, ''),
      ('ya', KanaScript.hiragana, 2, 2, 1690, ''),
      ('yu', KanaScript.hiragana, 2, 2, 1750, ''),
      ('yo', KanaScript.hiragana, 2, 2, 1620, ''),
      ('ra', KanaScript.hiragana, 2, 2, 1820, ''),
      ('ri', KanaScript.hiragana, 2, 2, 1450, ''),
      ('ru', KanaScript.hiragana, 3, 1, 3350, 'ro'),
      ('re', KanaScript.hiragana, 2, 2, 1890, ''),
      ('ro', KanaScript.hiragana, 3, 1, 3210, 'ru'),
      ('wa', KanaScript.hiragana, 2, 2, 1740, ''),
      ('wo', KanaScript.hiragana, 2, 2, 1650, ''),
      ('n', KanaScript.hiragana, 4, 4, 910, ''),
      ('ga', KanaScript.hiragana, 2, 2, 1550, ''),
      ('gi', KanaScript.hiragana, 2, 2, 1620, ''),
      ('gu', KanaScript.hiragana, 2, 2, 1710, ''),
      ('ge', KanaScript.hiragana, 2, 2, 1590, ''),
      ('go', KanaScript.hiragana, 2, 2, 1480, ''),
      ('za', KanaScript.hiragana, 2, 1, 2750, ''),
      ('ji', KanaScript.hiragana, 2, 2, 1850, ''),
      ('zu', KanaScript.hiragana, 2, 1, 2950, ''),
      ('ze', KanaScript.hiragana, 2, 2, 1920, ''),
      ('zo', KanaScript.hiragana, 2, 1, 2850, ''),
    ];

    final now = DateTime.now();

    for (final entry in sampleEntries) {
      final kanaId = entry.$1;
      final script = entry.$2;
      final attempts = entry.$3;
      final correct = entry.$4;
      final avgMs = entry.$5;
      final confused = entry.$6;

      for (int i = 0; i < attempts; i++) {
        final isCorrect = i < correct;
        mastery = updateCharacterMastery(
          mastery,
          CharacterAttemptPayload(
            kanaId: kanaId,
            script: script,
            isCorrect: isCorrect,
            chosenRomaji: isCorrect ? '' : (confused.isNotEmpty ? confused : 'x'),
            responseTimeMilliseconds: isCorrect ? avgMs : (avgMs + 800),
            timestampIso: now.subtract(Duration(hours: 48 - i)).toIso8601String(),
          ),
        );
      }
    }

    final highScores = [
      HighScoreRecord(
        id: 'seed-run-1',
        gameMode: GameMode.sprint,
        scriptMode: ScriptSelection.hiragana,
        score: 2450,
        accuracy: 90,
        cardsCleared: 20,
        durationSeconds: 42,
        dateIso: now.subtract(const Duration(days: 3)).toIso8601String(),
      ),
      HighScoreRecord(
        id: 'seed-run-2',
        gameMode: GameMode.sprint,
        scriptMode: ScriptSelection.mixed,
        score: 2850,
        accuracy: 95,
        cardsCleared: 20,
        durationSeconds: 38,
        dateIso: now.subtract(const Duration(days: 2)).toIso8601String(),
      ),
      HighScoreRecord(
        id: 'seed-run-3',
        gameMode: GameMode.timeAttack,
        scriptMode: ScriptSelection.hiragana,
        score: 3620,
        accuracy: 92,
        cardsCleared: 34,
        durationSeconds: 60,
        dateIso: now.subtract(const Duration(days: 1)).toIso8601String(),
      ),
      HighScoreRecord(
        id: 'seed-run-4',
        gameMode: GameMode.sprint,
        scriptMode: ScriptSelection.katakana,
        score: 3100,
        accuracy: 95,
        cardsCleared: 20,
        durationSeconds: 35,
        dateIso: now.toIso8601String(),
      ),
    ];

    final progression = evaluateSessionProgression(
      sessionScore: 3100,
      sessionCorrect: 19,
      sessionAttempts: 20,
      sessionBestStreak: 16,
      durationSeconds: 35,
      masteryMap: mastery,
      currentProgression: UserProgression(
        xp: 1420,
        level: calculateLevelFromXp(1420),
        currentDailyStreak: 3,
        bestDailyStreak: 3,
        lastPracticeDate: formatDateKey(now.subtract(const Duration(days: 1))),
        bestAnswerStreak: 16,
        totalSessionsCompleted: 4,
        totalCardsAnswered: 94,
        totalCorrectAnswers: 86,
        unlockedRowIds: const [
          'row-a',
          'row-ka',
          'row-sa',
          'row-ta',
          'row-na',
          'row-ha',
          'row-ma',
          'row-ga',
        ],
        unlockAllRows: false,
        unlockedAchievements: const {},
      ),
      nowDate: now,
    ).updatedProgression;

    persistence.saveMasteryMap(mastery);
    persistence.saveUserProgression(progression);
    for (final s in highScores) {
      persistence.saveHighScore(s);
    }

    return SeededData(
      masteryMap: mastery,
      progression: progression,
      highScores: highScores,
    );
  }
}
