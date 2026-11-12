import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../models/character_mastery.dart';

part 'character_mastery_entity.g.dart';

@collection
class CharacterMasteryEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String kanaId;

  int attempts = 0;
  int correct = 0;
  int wrong = 0;
  int streak = 0;
  int bestStreak = 0;
  int totalResponseTimeMilliseconds = 0;
  int? fastestResponseTimeMilliseconds;
  String? lastPracticedIso;
  int hiraganaAttempts = 0;
  int hiraganaCorrect = 0;
  int katakanaAttempts = 0;
  int katakanaCorrect = 0;
  String confusedWithJson = '{}';
  bool wasWeak = false;

  CharacterMastery toModel() {
    Map<String, int> confused = {};
    try {
      final decoded = jsonDecode(confusedWithJson);
      if (decoded is Map) {
        for (final entry in decoded.entries) {
          confused[entry.key.toString()] = (entry.value as num).toInt();
        }
      }
    } catch (_) {}

    return CharacterMastery(
      attempts: attempts,
      correct: correct,
      wrong: wrong,
      streak: streak,
      bestStreak: bestStreak,
      totalResponseTimeMilliseconds: totalResponseTimeMilliseconds,
      fastestResponseTimeMilliseconds: fastestResponseTimeMilliseconds,
      lastPracticedIso: lastPracticedIso,
      hiraganaAttempts: hiraganaAttempts,
      hiraganaCorrect: hiraganaCorrect,
      katakanaAttempts: katakanaAttempts,
      katakanaCorrect: katakanaCorrect,
      confusedWith: confused,
      wasWeak: wasWeak,
    );
  }

  static CharacterMasteryEntity fromModel(String kanaId, CharacterMastery model) {
    final entity = CharacterMasteryEntity();
    entity.kanaId = kanaId;
    entity.attempts = model.attempts;
    entity.correct = model.correct;
    entity.wrong = model.wrong;
    entity.streak = model.streak;
    entity.bestStreak = model.bestStreak;
    entity.totalResponseTimeMilliseconds = model.totalResponseTimeMilliseconds;
    entity.fastestResponseTimeMilliseconds = model.fastestResponseTimeMilliseconds;
    entity.lastPracticedIso = model.lastPracticedIso;
    entity.hiraganaAttempts = model.hiraganaAttempts;
    entity.hiraganaCorrect = model.hiraganaCorrect;
    entity.katakanaAttempts = model.katakanaAttempts;
    entity.katakanaCorrect = model.katakanaCorrect;
    entity.confusedWithJson = jsonEncode(model.confusedWith);
    entity.wasWeak = model.wasWeak;
    return entity;
  }
}
