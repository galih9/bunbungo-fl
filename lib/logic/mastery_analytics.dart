import 'dart:math';
import '../data/kana_data.dart';
import '../models/character_mastery.dart';
import '../models/kana_item.dart';

int? getCharacterAccuracy(CharacterMastery? stats) {
  if (stats == null || stats.attempts <= 0) return null;
  return ((stats.correct / stats.attempts) * 100).round();
}

int? getCharacterAverageResponseMilliseconds(CharacterMastery? stats) {
  if (stats == null ||
      stats.attempts <= 0 ||
      stats.totalResponseTimeMilliseconds <= 0) {
    return null;
  }
  return (stats.totalResponseTimeMilliseconds / stats.attempts).round();
}

LetterPerformanceTier getCharacterPerformanceTier(CharacterMastery? stats) {
  if (stats == null || stats.attempts <= 0) {
    return LetterPerformanceTier.unseen;
  }
  final accuracyRatio = stats.correct / stats.attempts;
  final avgMs = getCharacterAverageResponseMilliseconds(stats);

  if (accuracyRatio < 0.7 ||
      (stats.attempts >= 2 && stats.streak == 0 && accuracyRatio < 0.85) ||
      (stats.attempts >= 2 && avgMs != null && avgMs > 4500 && accuracyRatio < 0.9)) {
    return LetterPerformanceTier.weak;
  }

  if (stats.attempts >= 2 && accuracyRatio >= 0.8 && stats.streak >= 2) {
    return LetterPerformanceTier.strong;
  }

  return LetterPerformanceTier.learning;
}

int getCharacterProficiencyScore(CharacterMastery? stats) {
  if (stats == null || stats.attempts <= 0) return 0;
  final accuracyScore = (stats.correct / stats.attempts) * 70;
  final streakBonus = min(20, stats.streak * 5);
  final avgMs = getCharacterAverageResponseMilliseconds(stats);
  double speedBonus = 5;
  if (avgMs != null) {
    if (avgMs <= 1500) {
      speedBonus = 10;
    } else if (avgMs <= 2800) {
      speedBonus = 7;
    } else if (avgMs > 4500) {
      speedBonus = 2;
    }
  }
  return min(100, (accuracyScore + streakBonus + speedBonus).round());
}

List<MapEntry<String, int>> getTopConfusedRomaji(CharacterMastery? stats) {
  if (stats == null || stats.confusedWith.isEmpty) return [];
  final list = stats.confusedWith.entries.where((e) => e.value > 0).toList();
  list.sort((a, b) => b.value.compareTo(a.value));
  return list.take(3).toList();
}

class KanaPerformanceAnalysis {
  final List<KanaItem> weakItems;
  final List<KanaItem> strongItems;
  final List<KanaItem> learningItems;
  final List<KanaItem> unseenItems;
  final int? overallAccuracy;
  final int? averageResponseMilliseconds;
  final int totalAttempts;
  final int totalCorrect;
  final int redeemedCount;
  final int fastStrongCount;

  const KanaPerformanceAnalysis({
    required this.weakItems,
    required this.strongItems,
    required this.learningItems,
    required this.unseenItems,
    this.overallAccuracy,
    this.averageResponseMilliseconds,
    required this.totalAttempts,
    required this.totalCorrect,
    required this.redeemedCount,
    required this.fastStrongCount,
  });
}

KanaPerformanceAnalysis analyzeKanaPerformance(
    Map<String, CharacterMastery> masteryMap) {
  final weak = <KanaItem>[];
  final strong = <KanaItem>[];
  final learning = <KanaItem>[];
  final unseen = <KanaItem>[];
  final scoreByItemId = <String, int>{};

  int totalAttempts = 0;
  int totalCorrect = 0;
  int totalResponseTime = 0;
  int responseTimeAttempts = 0;
  int redeemedCount = 0;
  int fastStrongCount = 0;

  for (final item in kanaItems) {
    final stats = masteryMap[item.id];
    final tier = getCharacterPerformanceTier(stats);
    scoreByItemId[item.id] = getCharacterProficiencyScore(stats);

    switch (tier) {
      case LetterPerformanceTier.unseen:
        unseen.add(item);
        break;
      case LetterPerformanceTier.weak:
        weak.add(item);
        break;
      case LetterPerformanceTier.strong:
        strong.add(item);
        break;
      case LetterPerformanceTier.learning:
        learning.add(item);
        break;
    }

    if (stats != null && stats.attempts > 0) {
      totalAttempts += stats.attempts;
      totalCorrect += stats.correct;
      if (stats.totalResponseTimeMilliseconds > 0) {
        totalResponseTime += stats.totalResponseTimeMilliseconds;
        responseTimeAttempts += stats.attempts;
      }
      if (tier == LetterPerformanceTier.strong && stats.wasWeak) {
        redeemedCount += 1;
      }
      final avgMs = getCharacterAverageResponseMilliseconds(stats);
      if (tier == LetterPerformanceTier.strong && avgMs != null && avgMs <= 1800) {
        fastStrongCount += 1;
      }
    }
  }

  weak.sort((a, b) {
    final sA = scoreByItemId[a.id] ?? 0;
    final sB = scoreByItemId[b.id] ?? 0;
    if (sA != sB) return sA.compareTo(sB);
    final wrongA = (masteryMap[a.id]?.attempts ?? 0) - (masteryMap[a.id]?.correct ?? 0);
    final wrongB = (masteryMap[b.id]?.attempts ?? 0) - (masteryMap[b.id]?.correct ?? 0);
    return wrongB.compareTo(wrongA);
  });

  strong.sort((a, b) {
    final sA = scoreByItemId[a.id] ?? 0;
    final sB = scoreByItemId[b.id] ?? 0;
    if (sA != sB) return sB.compareTo(sA);
    final attA = masteryMap[a.id]?.attempts ?? 0;
    final attB = masteryMap[b.id]?.attempts ?? 0;
    return attB.compareTo(attA);
  });

  learning.sort((a, b) {
    final sA = scoreByItemId[a.id] ?? 0;
    final sB = scoreByItemId[b.id] ?? 0;
    return sA.compareTo(sB);
  });

  final overallAccuracy =
      totalAttempts > 0 ? ((totalCorrect / totalAttempts) * 100).round() : null;
  final avgMs = responseTimeAttempts > 0
      ? (totalResponseTime / responseTimeAttempts).round()
      : null;

  return KanaPerformanceAnalysis(
    weakItems: weak,
    strongItems: strong,
    learningItems: learning,
    unseenItems: unseen,
    overallAccuracy: overallAccuracy,
    averageResponseMilliseconds: avgMs,
    totalAttempts: totalAttempts,
    totalCorrect: totalCorrect,
    redeemedCount: redeemedCount,
    fastStrongCount: fastStrongCount,
  );
}

class RowMasterySummary {
  final String rowId;
  final int attemptedCount;
  final int strongCount;
  final int weakCount;
  final int totalCount;
  final int totalCorrectInRow;
  final int? accuracyPercent;
  final int masteryPercent;
  final bool isMastered;

  const RowMasterySummary({
    required this.rowId,
    required this.attemptedCount,
    required this.strongCount,
    required this.weakCount,
    required this.totalCount,
    required this.totalCorrectInRow,
    this.accuracyPercent,
    required this.masteryPercent,
    required this.isMastered,
  });
}

RowMasterySummary getRowMasterySummary(
    String rowId, Map<String, CharacterMastery> masteryMap) {
  final rowItems = kanaItemsByRow[rowId] ?? const [];
  final totalCount = rowItems.length;
  int attemptedCount = 0;
  int strongCount = 0;
  int weakCount = 0;
  int rowAttempts = 0;
  int rowCorrect = 0;

  for (final item in rowItems) {
    final stats = masteryMap[item.id];
    final tier = getCharacterPerformanceTier(stats);
    if (stats != null && stats.attempts > 0) {
      attemptedCount += 1;
      rowAttempts += stats.attempts;
      rowCorrect += stats.correct;
    }
    if (tier == LetterPerformanceTier.strong) {
      strongCount += 1;
    } else if (tier == LetterPerformanceTier.weak) {
      weakCount += 1;
    }
  }

  final accuracyPercent =
      rowAttempts > 0 ? ((rowCorrect / rowAttempts) * 100).round() : null;

  final coverageRatio = totalCount > 0 ? attemptedCount / totalCount : 0.0;
  final strongRatio = totalCount > 0 ? strongCount / totalCount : 0.0;
  final accuracyRatio = rowAttempts > 0 ? rowCorrect / rowAttempts : 0.0;

  final masteryPercent =
      min(100, (coverageRatio * 40 + accuracyRatio * 40 + strongRatio * 20).round());

  final isMastered = totalCount > 0 &&
      ((attemptedCount >= (totalCount * 0.6).ceil() &&
              accuracyPercent != null &&
              accuracyPercent >= 70) ||
          rowCorrect >= totalCount * 2);

  return RowMasterySummary(
    rowId: rowId,
    attemptedCount: attemptedCount,
    strongCount: strongCount,
    weakCount: weakCount,
    totalCount: totalCount,
    totalCorrectInRow: rowCorrect,
    accuracyPercent: accuracyPercent,
    masteryPercent: masteryPercent,
    isMastered: isMastered,
  );
}

Map<String, CharacterMastery> updateCharacterMastery(
  Map<String, CharacterMastery> previousMap,
  CharacterAttemptPayload payload,
) {
  final existing = previousMap[payload.kanaId];
  final previousAttempts = existing?.attempts ?? 0;
  final previousCorrect = existing?.correct ?? 0;
  final previousWrong = existing?.wrong ?? max(0, previousAttempts - previousCorrect);
  final previousStreak = existing?.streak ?? 0;
  final previousBestStreak = existing?.bestStreak ?? previousStreak;
  final previousTotalTime = existing?.totalResponseTimeMilliseconds ?? 0;
  final previousFastestTime = existing?.fastestResponseTimeMilliseconds;

  final clampedTime = payload.responseTimeMilliseconds.clamp(120, 30000);

  final nextAttempts = previousAttempts + 1;
  final nextCorrect = previousCorrect + (payload.isCorrect ? 1 : 0);
  final nextWrong = previousWrong + (payload.isCorrect ? 0 : 1);
  final nextStreak = payload.isCorrect ? previousStreak + 1 : 0;
  final nextBestStreak = max(previousBestStreak, nextStreak);
  final nextTotalTime = previousTotalTime + clampedTime;

  int? nextFastestTime = previousFastestTime;
  if (payload.isCorrect) {
    nextFastestTime = previousFastestTime == null
        ? clampedTime
        : min(previousFastestTime, clampedTime);
  }

  final nextHiraganaAttempts =
      (existing?.hiraganaAttempts ?? 0) + (payload.script == KanaScript.hiragana ? 1 : 0);
  final nextHiraganaCorrect = (existing?.hiraganaCorrect ?? 0) +
      (payload.script == KanaScript.hiragana && payload.isCorrect ? 1 : 0);
  final nextKatakanaAttempts =
      (existing?.katakanaAttempts ?? 0) + (payload.script == KanaScript.katakana ? 1 : 0);
  final nextKatakanaCorrect = (existing?.katakanaCorrect ?? 0) +
      (payload.script == KanaScript.katakana && payload.isCorrect ? 1 : 0);

  final nextConfused = Map<String, int>.from(existing?.confusedWith ?? {});
  if (!payload.isCorrect && payload.chosenRomaji.trim().isNotEmpty) {
    final key = payload.chosenRomaji.trim().toLowerCase();
    nextConfused[key] = (nextConfused[key] ?? 0) + 1;
  }

  final nextAccuracyRatio = nextCorrect / nextAttempts;
  final becomesWeak = !payload.isCorrect &&
      (nextAccuracyRatio < 0.7 || (nextAttempts >= 2 && nextAccuracyRatio < 0.85));

  final updatedEntry = CharacterMastery(
    attempts: nextAttempts,
    correct: nextCorrect,
    wrong: nextWrong,
    streak: nextStreak,
    bestStreak: nextBestStreak,
    totalResponseTimeMilliseconds: nextTotalTime,
    fastestResponseTimeMilliseconds: nextFastestTime,
    lastPracticedIso: payload.timestampIso ?? DateTime.now().toIso8601String(),
    hiraganaAttempts: nextHiraganaAttempts,
    hiraganaCorrect: nextHiraganaCorrect,
    katakanaAttempts: nextKatakanaAttempts,
    katakanaCorrect: nextKatakanaCorrect,
    confusedWith: nextConfused,
    wasWeak: existing?.wasWeak == true || becomesWeak,
  );

  return {
    ...previousMap,
    payload.kanaId: updatedEntry,
  };
}
