import 'dart:math';
import '../data/achievements_data.dart';
import '../data/kana_data.dart';
import '../models/achievement.dart';
import '../models/challenge.dart';
import '../models/character_mastery.dart';
import '../models/kana_item.dart';
import '../models/user_progression.dart';
import 'mastery_analytics.dart';

int calculateLevelFromXp(int xp) {
  return max(1, (sqrt(max(0, xp) / 120)).floor() + 1);
}

int getXpThresholdForLevel(int level) {
  if (level <= 1) return 0;
  return (pow(level - 1, 2) * 120).round();
}

String getRankTitleForLevel(int level) {
  if (level >= 15) return 'Kana Grandmaster';
  if (level >= 10) return 'Kana Sensei';
  if (level >= 7) return 'Script Scholar';
  if (level >= 4) return 'Fluent Reader';
  if (level >= 2) return 'Kana Apprentice';
  return 'Novice Learner';
}

String formatDateKey(DateTime date) {
  final year = date.year;
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

bool _isYesterdayDateKey(String previousDateKey, DateTime currentDate) {
  final yesterday = currentDate.subtract(const Duration(days: 1));
  return formatDateKey(yesterday) == previousDateKey;
}

List<AchievementStatus> getAchievementProgressList(
  UserProgression progression,
  Map<String, CharacterMastery> masteryMap,
) {
  final analysis = analyzeKanaPerformance(masteryMap);
  final effectiveUnlockedCount = progression.unlockAllRows
      ? kanaRowGroups.length
      : progression.unlockedRowIds.length;

  return achievementDefinitions.map((def) {
    int currentValue = 0;
    switch (def.id) {
      case 'streak-5':
      case 'streak-15':
      case 'streak-30':
        currentValue = progression.bestAnswerStreak;
        break;
      case 'daily-3':
        currentValue = progression.bestDailyStreak;
        break;
      case 'unlock-row-4':
      case 'unlock-monographs':
      case 'unlock-dakuten':
      case 'unlock-all-rows':
        currentValue = effectiveUnlockedCount;
        break;
      case 'first-session':
        currentValue = progression.totalSessionsCompleted;
        break;
      case 'strong-5':
      case 'strong-15':
      case 'strong-46':
        currentValue = analysis.strongItems.length;
        break;
      case 'weakness-redeemed':
        currentValue = analysis.redeemedCount;
        break;
      case 'speed-reflex':
        currentValue = analysis.fastStrongCount;
        break;
      default:
        currentValue = 0;
    }

    final unlockedAtIso = progression.unlockedAchievements[def.id];
    final isUnlocked = unlockedAtIso != null || currentValue >= def.targetValue;
    final progressPercent =
        min(100, ((currentValue / def.targetValue) * 100).round());

    return AchievementStatus(
      definition: def,
      currentValue: currentValue,
      progressPercent: progressPercent,
      isUnlocked: isUnlocked,
      unlockedAtIso: unlockedAtIso,
    );
  }).toList();
}

SessionProgressionResult evaluateSessionProgression({
  required int sessionScore,
  required int sessionCorrect,
  required int sessionAttempts,
  required int sessionBestStreak,
  required int durationSeconds,
  required Map<String, CharacterMastery> masteryMap,
  required UserProgression currentProgression,
  DateTime? nowDate,
}) {
  final now = nowDate ?? DateTime.now();
  final todayKey = formatDateKey(now);
  final nowIso = now.toIso8601String();
  final previous = currentProgression;

  // 1. Daily streak
  int nextDailyStreak = previous.currentDailyStreak;
  String? nextLastPracticeDate = previous.lastPracticeDate;
  if (sessionAttempts > 0) {
    if (previous.lastPracticeDate == todayKey) {
      nextDailyStreak = max(1, previous.currentDailyStreak);
    } else if (previous.lastPracticeDate != null &&
        _isYesterdayDateKey(previous.lastPracticeDate!, now)) {
      nextDailyStreak = previous.currentDailyStreak + 1;
    } else {
      nextDailyStreak = 1;
    }
    nextLastPracticeDate = todayKey;
  }
  final nextBestDailyStreak = max(previous.bestDailyStreak, nextDailyStreak);

  // 2. Base XP
  final accuracyRatio =
      sessionAttempts > 0 ? sessionCorrect / sessionAttempts : 0.0;
  final baseSessionXp = sessionAttempts > 0
      ? (sessionCorrect * 12 +
          sessionBestStreak * 5 +
          (accuracyRatio >= 0.85 ? 45 : accuracyRatio >= 0.7 ? 20 : 10))
      : 0;

  final nextBestAnswerStreak = max(previous.bestAnswerStreak, sessionBestStreak);
  final nextSessionsCompleted =
      previous.totalSessionsCompleted + (sessionAttempts > 0 ? 1 : 0);
  final nextTotalAnswered = previous.totalCardsAnswered + sessionAttempts;
  final nextTotalCorrect = previous.totalCorrectAnswers + sessionCorrect;

  // 3. Row unlocks
  final unlockedSet = Set<String>.from(previous.unlockedRowIds);
  final newlyUnlockedRows = <KanaRowGroup>[];
  final masteredRowSet = <String>{};

  for (final group in kanaRowGroups) {
    if (getRowMasterySummary(group.id, masteryMap).isMastered) {
      masteredRowSet.add(group.id);
    }
  }

  final tentativeLevel = calculateLevelFromXp(previous.xp + baseSessionXp);
  final guaranteedRowCount =
      min(kanaRowGroups.length, max(defaultSelectedRows.length, 2 + tentativeLevel));

  for (int i = 0; i < kanaRowGroups.length; i++) {
    final rowGroup = kanaRowGroups[i];
    if (unlockedSet.contains(rowGroup.id)) continue;

    final previousRow = i > 0 ? kanaRowGroups[i - 1] : null;
    final previousRowMastered =
        previousRow != null ? masteredRowSet.contains(previousRow.id) : true;

    final allPriorUnlockedAndPracticed = kanaRowGroups
        .sublist(0, i)
        .every((p) => unlockedSet.contains(p.id) && masteredRowSet.contains(p.id));

    if (i < guaranteedRowCount ||
        (previousRow != null &&
            unlockedSet.contains(previousRow.id) &&
            previousRowMastered) ||
        allPriorUnlockedAndPracticed) {
      unlockedSet.add(rowGroup.id);
      newlyUnlockedRows.add(rowGroup);
    }
  }

  final nextUnlockedRowIds =
      kanaRowGroups.where((g) => unlockedSet.contains(g.id)).map((g) => g.id).toList();

  // 4. Achievements
  final interimProgression = UserProgression(
    xp: previous.xp + baseSessionXp,
    level: tentativeLevel,
    currentDailyStreak: nextDailyStreak,
    bestDailyStreak: nextBestDailyStreak,
    lastPracticeDate: nextLastPracticeDate,
    bestAnswerStreak: nextBestAnswerStreak,
    totalSessionsCompleted: nextSessionsCompleted,
    totalCardsAnswered: nextTotalAnswered,
    totalCorrectAnswers: nextTotalCorrect,
    unlockedRowIds: nextUnlockedRowIds,
    unlockAllRows: previous.unlockAllRows,
    unlockedAchievements: Map.from(previous.unlockedAchievements),
  );

  final statuses = getAchievementProgressList(interimProgression, masteryMap);
  final newlyUnlockedAchievements = <AchievementDefinition>[];
  final nextUnlockedAchievements =
      Map<String, String>.from(previous.unlockedAchievements);
  int achievementBonusXp = 0;

  for (final status in statuses) {
    if (status.currentValue >= status.targetValue &&
        !nextUnlockedAchievements.containsKey(status.id)) {
      nextUnlockedAchievements[status.id] = nowIso;
      newlyUnlockedAchievements.add(status.definition);
      achievementBonusXp += status.xpReward;
    }
  }

  final totalXpEarned = baseSessionXp + achievementBonusXp;
  final finalXp = previous.xp + totalXpEarned;
  final finalLevel = calculateLevelFromXp(finalXp);

  final updatedProgression = interimProgression.copyWith(
    xp: finalXp,
    level: finalLevel,
    unlockedAchievements: nextUnlockedAchievements,
  );

  return SessionProgressionResult(
    updatedProgression: updatedProgression,
    xpEarned: totalXpEarned,
    previousLevel: previous.level,
    newLevel: finalLevel,
    newlyUnlockedRows: newlyUnlockedRows,
    newlyUnlockedAchievements: newlyUnlockedAchievements,
  );
}
