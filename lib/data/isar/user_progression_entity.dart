import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../models/user_progression.dart';

part 'user_progression_entity.g.dart';

@collection
class UserProgressionEntity {
  Id id = 1;

  int xp = 0;
  int level = 1;
  int currentDailyStreak = 0;
  int bestDailyStreak = 0;
  String? lastPracticeDate;
  int bestAnswerStreak = 0;
  int totalSessionsCompleted = 0;
  int totalCardsAnswered = 0;
  int totalCorrectAnswers = 0;
  List<String> unlockedRowIds = ['row-a', 'row-ka', 'row-sa'];
  bool unlockAllRows = false;
  String unlockedAchievementsJson = '{}';

  UserProgression toModel() {
    Map<String, String> badges = {};
    try {
      final decoded = jsonDecode(unlockedAchievementsJson);
      if (decoded is Map) {
        for (final entry in decoded.entries) {
          badges[entry.key.toString()] = entry.value.toString();
        }
      }
    } catch (_) {}

    return UserProgression(
      xp: xp,
      level: level,
      currentDailyStreak: currentDailyStreak,
      bestDailyStreak: bestDailyStreak,
      lastPracticeDate: lastPracticeDate,
      bestAnswerStreak: bestAnswerStreak,
      totalSessionsCompleted: totalSessionsCompleted,
      totalCardsAnswered: totalCardsAnswered,
      totalCorrectAnswers: totalCorrectAnswers,
      unlockedRowIds: unlockedRowIds.isNotEmpty
          ? unlockedRowIds
          : const ['row-a', 'row-ka', 'row-sa'],
      unlockAllRows: unlockAllRows,
      unlockedAchievements: badges,
    );
  }

  static UserProgressionEntity fromModel(UserProgression model) {
    final entity = UserProgressionEntity();
    entity.id = 1;
    entity.xp = model.xp;
    entity.level = model.level;
    entity.currentDailyStreak = model.currentDailyStreak;
    entity.bestDailyStreak = model.bestDailyStreak;
    entity.lastPracticeDate = model.lastPracticeDate;
    entity.bestAnswerStreak = model.bestAnswerStreak;
    entity.totalSessionsCompleted = model.totalSessionsCompleted;
    entity.totalCardsAnswered = model.totalCardsAnswered;
    entity.totalCorrectAnswers = model.totalCorrectAnswers;
    entity.unlockedRowIds = List<String>.from(model.unlockedRowIds);
    entity.unlockAllRows = model.unlockAllRows;
    entity.unlockedAchievementsJson = jsonEncode(model.unlockedAchievements);
    return entity;
  }
}
