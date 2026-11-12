import 'dart:math';
import '../data/kana_data.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/kana_item.dart';
import '../models/user_progression.dart';
import 'mastery_analytics.dart';
import 'progression_engine.dart';

class ScriptPerformanceSummary {
  final KanaScript script;
  final String label;
  final int attempts;
  final int correct;
  final int? accuracyPercent;
  final int practicedCharacterCount;

  const ScriptPerformanceSummary({
    required this.script,
    required this.label,
    required this.attempts,
    required this.correct,
    this.accuracyPercent,
    required this.practicedCharacterCount,
  });
}

class CategoryPerformanceSummary {
  final KanaCategory category;
  final String label;
  final String shortLabel;
  final int totalCount;
  final int practicedCount;
  final int strongCount;
  final int learningCount;
  final int weakCount;
  final int unseenCount;
  final int attempts;
  final int correct;
  final int? accuracyPercent;
  final int masteryPercent;
  final int? averageResponseMilliseconds;

  const CategoryPerformanceSummary({
    required this.category,
    required this.label,
    required this.shortLabel,
    required this.totalCount,
    required this.practicedCount,
    required this.strongCount,
    required this.learningCount,
    required this.weakCount,
    required this.unseenCount,
    required this.attempts,
    required this.correct,
    this.accuracyPercent,
    required this.masteryPercent,
    this.averageResponseMilliseconds,
  });
}

class SpeedBucketSummary {
  final String id;
  final String label;
  final String rangeLabel;
  final int count;
  final int sharePercent;

  const SpeedBucketSummary({
    required this.id,
    required this.label,
    required this.rangeLabel,
    required this.count,
    required this.sharePercent,
  });
}

class ConfusionPairSummary {
  final KanaItem item;
  final String confusedRomaji;
  final int count;

  const ConfusionPairSummary({
    required this.item,
    required this.confusedRomaji,
    required this.count,
  });
}

class SessionTrendPoint {
  final String id;
  final String sessionLabel;
  final String dateLabel;
  final GameMode gameMode;
  final ScriptSelection scriptMode;
  final int score;
  final int accuracy;
  final int cardsCleared;
  final int durationSeconds;
  final int cardsPerMinute;

  const SessionTrendPoint({
    required this.id,
    required this.sessionLabel,
    required this.dateLabel,
    required this.gameMode,
    required this.scriptMode,
    required this.score,
    required this.accuracy,
    required this.cardsCleared,
    required this.durationSeconds,
    required this.cardsPerMinute,
  });
}

enum StudyRecommendationType {
  weakDrill,
  katakanaFocus,
  hiraganaFocus,
  standardPractice;
}

class StudyRecommendation {
  final String id;
  final String title;
  final String description;
  final String priority; // 'high', 'medium', 'positive'
  final String actionLabel;
  final StudyRecommendationType actionType;

  const StudyRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.actionLabel,
    required this.actionType,
  });
}

class DailyActivityDataPoint {
  final DateTime date;
  final String dateKey;
  final String dayName;
  final int lettersPracticed;
  final bool isToday;
  final bool goalReached;

  const DailyActivityDataPoint({
    required this.date,
    required this.dateKey,
    required this.dayName,
    required this.lettersPracticed,
    required this.isToday,
    required this.goalReached,
  });
}

class SpeedPerformancePoint {
  final String sessionLabel;
  final String dateLabel;
  final double secondsPerLetter;
  final int cardsPerMinute;
  final int cardsCleared;
  final int accuracy;
  final String modeName;

  const SpeedPerformancePoint({
    required this.sessionLabel,
    required this.dateLabel,
    required this.secondsPerLetter,
    required this.cardsPerMinute,
    required this.cardsCleared,
    required this.accuracy,
    required this.modeName,
  });
}

class DashboardSummary {
  final KanaPerformanceAnalysis analysis;
  final List<ScriptPerformanceSummary> scriptSummaries;
  final List<CategoryPerformanceSummary> categorySummaries;
  final List<({RowMasterySummary summary, KanaRowGroup group})> rowSummaries;
  final List<SpeedBucketSummary> speedBuckets;
  final List<ConfusionPairSummary> topConfusions;
  final List<SessionTrendPoint> sessionTrend;
  final List<StudyRecommendation> recommendations;
  final List<DailyActivityDataPoint> dailyActivity;
  final List<SpeedPerformancePoint> speedPerformance;
  final int overallProficiencyScore;
  final int coveragePercent;
  final int masteryPercent;

  const DashboardSummary({
    required this.analysis,
    required this.scriptSummaries,
    required this.categorySummaries,
    required this.rowSummaries,
    required this.speedBuckets,
    required this.topConfusions,
    required this.sessionTrend,
    required this.recommendations,
    required this.dailyActivity,
    required this.speedPerformance,
    required this.overallProficiencyScore,
    required this.coveragePercent,
    required this.masteryPercent,
  });
}

DashboardSummary buildDashboardSummary(
  Map<String, CharacterMastery> masteryMap,
  UserProgression progression,
  List<HighScoreRecord> highScores,
) {
  final analysis = analyzeKanaPerformance(masteryMap);
  final totalKanaCount = kanaItems.length;
  final practicedCharacterCount =
      analysis.strongItems.length + analysis.learningItems.length + analysis.weakItems.length;

  final coveragePercent = totalKanaCount > 0
      ? ((practicedCharacterCount / totalKanaCount) * 100).round()
      : 0;
  final masteryPercent = totalKanaCount > 0
      ? ((analysis.strongItems.length / totalKanaCount) * 100).round()
      : 0;

  int totalProficiencySum = 0;
  int hiraganaAttempts = 0;
  int hiraganaCorrect = 0;
  int hiraganaPracticedCount = 0;
  int katakanaAttempts = 0;
  int katakanaCorrect = 0;
  int katakanaPracticedCount = 0;

  int instantCount = 0;
  int fastCount = 0;
  int steadyCount = 0;
  int slowCount = 0;

  final confusionEntries = <ConfusionPairSummary>[];

  for (final item in kanaItems) {
    final stats = masteryMap[item.id];
    totalProficiencySum += getCharacterProficiencyScore(stats);

    final itemHiraAtt = stats?.hiraganaAttempts ?? 0;
    final itemHiraCor = stats?.hiraganaCorrect ?? 0;
    final itemKataAtt = stats?.katakanaAttempts ?? 0;
    final itemKataCor = stats?.katakanaCorrect ?? 0;

    if (itemHiraAtt > 0) {
      hiraganaAttempts += itemHiraAtt;
      hiraganaCorrect += itemHiraCor;
      hiraganaPracticedCount += 1;
    }
    if (itemKataAtt > 0) {
      katakanaAttempts += itemKataAtt;
      katakanaCorrect += itemKataCor;
      katakanaPracticedCount += 1;
    }

    final avgResp = getCharacterAverageResponseMilliseconds(stats);
    if (avgResp != null) {
      if (avgResp <= 1200) {
        instantCount += 1;
      } else if (avgResp <= 1800) {
        fastCount += 1;
      } else if (avgResp <= 3000) {
        steadyCount += 1;
      } else {
        slowCount += 1;
      }
    }

    final itemConfusions = getTopConfusedRomaji(stats);
    for (final conf in itemConfusions) {
      confusionEntries.add(
        ConfusionPairSummary(
          item: item,
          confusedRomaji: conf.key,
          count: conf.value,
        ),
      );
    }
  }

  confusionEntries.sort((a, b) => b.count.compareTo(a.count));
  final topConfusions = confusionEntries.take(6).toList();

  final overallProficiencyScore = practicedCharacterCount > 0
      ? (totalProficiencySum / practicedCharacterCount).round()
      : 0;

  final scriptSummaries = [
    ScriptPerformanceSummary(
      script: KanaScript.hiragana,
      label: 'Hiragana (あ)',
      attempts: hiraganaAttempts,
      correct: hiraganaCorrect,
      accuracyPercent: hiraganaAttempts > 0
          ? ((hiraganaCorrect / hiraganaAttempts) * 100).round()
          : null,
      practicedCharacterCount: hiraganaPracticedCount,
    ),
    ScriptPerformanceSummary(
      script: KanaScript.katakana,
      label: 'Katakana (ア)',
      attempts: katakanaAttempts,
      correct: katakanaCorrect,
      accuracyPercent: katakanaAttempts > 0
          ? ((katakanaCorrect / katakanaAttempts) * 100).round()
          : null,
      practicedCharacterCount: katakanaPracticedCount,
    ),
  ];

  final categorySummaries = [
    _summarizeCategory(KanaCategory.monograph, 'Monographs (Gojūon)', 'Monographs', masteryMap),
    _summarizeCategory(KanaCategory.diacritic, 'Diacritics (Dakuten)', 'Diacritics', masteryMap),
    _summarizeCategory(KanaCategory.digraph, 'Digraphs (Yōon)', 'Digraphs', masteryMap),
  ];

  final rowSummaries = kanaRowGroups
      .map((g) => (summary: getRowMasterySummary(g.id, masteryMap), group: g))
      .toList();

  final speedMeasuredTotal =
      max(1, instantCount + fastCount + steadyCount + slowCount);
  final speedBuckets = [
    SpeedBucketSummary(
      id: 'instant',
      label: 'Instant Reflex',
      rangeLabel: '≤ 1.2s',
      count: instantCount,
      sharePercent: practicedCharacterCount > 0
          ? ((instantCount / speedMeasuredTotal) * 100).round()
          : 0,
    ),
    SpeedBucketSummary(
      id: 'fast',
      label: 'Fast Recall',
      rangeLabel: '1.2s – 1.8s',
      count: fastCount,
      sharePercent: practicedCharacterCount > 0
          ? ((fastCount / speedMeasuredTotal) * 100).round()
          : 0,
    ),
    SpeedBucketSummary(
      id: 'steady',
      label: 'Steady Recognition',
      rangeLabel: '1.8s – 3.0s',
      count: steadyCount,
      sharePercent: practicedCharacterCount > 0
          ? ((steadyCount / speedMeasuredTotal) * 100).round()
          : 0,
    ),
    SpeedBucketSummary(
      id: 'slow',
      label: 'Needs Speed Drill',
      rangeLabel: '> 3.0s',
      count: slowCount,
      sharePercent: practicedCharacterCount > 0
          ? ((slowCount / speedMeasuredTotal) * 100).round()
          : 0,
    ),
  ];

  final chronologicalScores = List<HighScoreRecord>.from(highScores)
    ..sort((a, b) => a.dateIso.compareTo(b.dateIso));

  final sessionTrend = chronologicalScores.asMap().entries.map((entry) {
    final idx = entry.key;
    final r = entry.value;
    DateTime? dt;
    try {
      dt = DateTime.parse(r.dateIso);
    } catch (_) {}
    final dateLabel = dt != null ? '${dt.month}/${dt.day}' : 'Run ${idx + 1}';
    final durationMins = max(0.1, r.durationSeconds / 60.0);
    return SessionTrendPoint(
      id: r.id,
      sessionLabel: 'S${idx + 1}',
      dateLabel: dateLabel,
      gameMode: r.gameMode,
      scriptMode: r.scriptMode,
      score: r.score,
      accuracy: r.accuracy,
      cardsCleared: r.cardsCleared,
      durationSeconds: r.durationSeconds,
      cardsPerMinute: (r.cardsCleared / durationMins).round(),
    );
  }).toList();

  final recommendations = <StudyRecommendation>[];
  if (analysis.weakItems.isNotEmpty) {
    final sampleWeak = analysis.weakItems
        .take(4)
        .map((i) => '${i.hiragana} (${i.romaji})')
        .join(', ');
    recommendations.add(
      StudyRecommendation(
        id: 'rec-weak-kana',
        title: '${analysis.weakItems.length} Kana Need Targeted Review',
        description:
            'Target $sampleWeak to raise recognition accuracy above 80% and build active recall.',
        priority: 'high',
        actionLabel: 'Drill ${analysis.weakItems.length} Weak Kana',
        actionType: StudyRecommendationType.weakDrill,
      ),
    );
  }

  if (hiraganaAttempts >= 5 && katakanaAttempts < hiraganaAttempts * 0.4) {
    recommendations.add(
      StudyRecommendation(
        id: 'rec-katakana-balance',
        title: 'Boost Katakana Script Balance',
        description:
            'You have $hiraganaAttempts Hiragana attempts vs $katakanaAttempts Katakana attempts. Balance your script fluency with a Katakana session.',
        priority: 'medium',
        actionLabel: 'Practice Katakana',
        actionType: StudyRecommendationType.katakanaFocus,
      ),
    );
  } else if (katakanaAttempts >= 5 && hiraganaAttempts < katakanaAttempts * 0.4) {
    recommendations.add(
      StudyRecommendation(
        id: 'rec-hiragana-balance',
        title: 'Boost Hiragana Script Balance',
        description:
            'You have $katakanaAttempts Katakana attempts vs $hiraganaAttempts Hiragana attempts. Switch to Hiragana to balance script retention.',
        priority: 'medium',
        actionLabel: 'Practice Hiragana',
        actionType: StudyRecommendationType.hiraganaFocus,
      ),
    );
  }

  final nextLockedRow = kanaRowGroups.firstWhere(
    (g) =>
        !progression.unlockAllRows && !progression.unlockedRowIds.contains(g.id),
    orElse: () => const KanaRowGroup(
      id: '',
      label: '',
      sampleHiragana: '',
      sampleKatakana: '',
      romajiSummary: '',
      category: KanaCategory.monograph,
    ),
  );
  if (nextLockedRow.id.isNotEmpty) {
    recommendations.add(
      StudyRecommendation(
        id: 'rec-next-row',
        title: 'Next Unlock: ${nextLockedRow.label}',
        description:
            'Achieve 70%+ accuracy across your current unlocked rows to unlock ${nextLockedRow.sampleHiragana} ${nextLockedRow.label} (${nextLockedRow.romajiSummary}).',
        priority: 'positive',
        actionLabel: 'Continue Row Progression',
        actionType: StudyRecommendationType.standardPractice,
      ),
    );
  }

  if (recommendations.isEmpty) {
    recommendations.add(
      StudyRecommendation(
        id: 'rec-general',
        title: analysis.totalAttempts > 0
            ? 'Strong Momentum — Keep Up Your Streak'
            : 'Ready for Your First Telemetry Session',
        description: analysis.totalAttempts > 0
            ? 'Your accuracy and script balance look strong! Challenge yourself with a 60-second Timed Run or Mixed Script session.'
            : 'Complete your first flashcard sprint to populate character telemetry, response speed distributions, and mastery charts.',
        priority: 'positive',
        actionLabel: 'Start Sprint Session',
        actionType: StudyRecommendationType.standardPractice,
      ),
    );
  }

  // Calculate Daily Activity (Last 7 Days - Duolingo Style)
  final now = DateTime.now();
  final todayKey = formatDateKey(now);
  const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final dailyActivity = <DailyActivityDataPoint>[];

  for (int i = 6; i >= 0; i--) {
    final dayDate = now.subtract(Duration(days: i));
    final key = formatDateKey(dayDate);
    final dayName = dayLabels[dayDate.weekday - 1];

    int totalLetters = 0;
    for (final score in highScores) {
      if (score.dateIso.startsWith(key)) {
        totalLetters += score.cardsCleared;
      }
    }

    if (totalLetters == 0) {
      for (final m in masteryMap.values) {
        if (m.lastPracticedIso != null && m.lastPracticedIso!.startsWith(key)) {
          totalLetters += (m.hiraganaAttempts + m.katakanaAttempts);
        }
      }
    }

    dailyActivity.add(
      DailyActivityDataPoint(
        date: dayDate,
        dateKey: key,
        dayName: dayName,
        lettersPracticed: totalLetters,
        isToday: key == todayKey,
        goalReached: totalLetters >= 20,
      ),
    );
  }

  // Calculate Speed Performance Series (Response Time per letter across sessions)
  final sortedHighScores = List<HighScoreRecord>.from(highScores)
    ..sort((a, b) => a.dateIso.compareTo(b.dateIso));

  final recentScores = sortedHighScores.length > 10
      ? sortedHighScores.sublist(sortedHighScores.length - 10)
      : sortedHighScores;

  final speedPerformance = recentScores.asMap().entries.map((entry) {
    final idx = entry.key;
    final r = entry.value;
    DateTime? dt;
    try {
      dt = DateTime.parse(r.dateIso);
    } catch (_) {}
    final dateLabel = dt != null ? '${dt.month}/${dt.day}' : 'S${idx + 1}';
    final durationSeconds = max(1, r.durationSeconds);
    final cardsCleared = max(1, r.cardsCleared);
    final secondsPerLetter = double.parse((durationSeconds / cardsCleared).toStringAsFixed(2));
    final cpm = (cardsCleared / (durationSeconds / 60.0)).round();

    return SpeedPerformancePoint(
      sessionLabel: 'S${idx + 1}',
      dateLabel: dateLabel,
      secondsPerLetter: secondsPerLetter,
      cardsPerMinute: cpm,
      cardsCleared: r.cardsCleared,
      accuracy: r.accuracy,
      modeName: r.gameMode.name,
    );
  }).toList();

  return DashboardSummary(
    analysis: analysis,
    scriptSummaries: scriptSummaries,
    categorySummaries: categorySummaries,
    rowSummaries: rowSummaries,
    speedBuckets: speedBuckets,
    topConfusions: topConfusions,
    sessionTrend: sessionTrend,
    recommendations: recommendations,
    dailyActivity: dailyActivity,
    speedPerformance: speedPerformance,
    overallProficiencyScore: overallProficiencyScore,
    coveragePercent: coveragePercent,
    masteryPercent: masteryPercent,
  );
}

CategoryPerformanceSummary _summarizeCategory(
  KanaCategory category,
  String label,
  String shortLabel,
  Map<String, CharacterMastery> masteryMap,
) {
  final categoryItems = kanaItemsByCategory[category] ?? const [];
  final totalCount = categoryItems.length;
  int practicedCount = 0;
  int strongCount = 0;
  int learningCount = 0;
  int weakCount = 0;
  int unseenCount = 0;
  int attempts = 0;
  int correct = 0;
  int responseTimeSum = 0;
  int responseTimeAttempts = 0;

  for (final item in categoryItems) {
    final stats = masteryMap[item.id];
    final tier = getCharacterPerformanceTier(stats);
    switch (tier) {
      case LetterPerformanceTier.strong:
        strongCount += 1;
        break;
      case LetterPerformanceTier.learning:
        learningCount += 1;
        break;
      case LetterPerformanceTier.weak:
        weakCount += 1;
        break;
      case LetterPerformanceTier.unseen:
        unseenCount += 1;
        break;
    }

    if (stats != null && stats.attempts > 0) {
      practicedCount += 1;
      attempts += stats.attempts;
      correct += stats.correct;
      if (stats.totalResponseTimeMilliseconds > 0) {
        responseTimeSum += stats.totalResponseTimeMilliseconds;
        responseTimeAttempts += stats.attempts;
      }
    }
  }

  final accuracyPercent =
      attempts > 0 ? ((correct / attempts) * 100).round() : null;
  final coverageRatio = totalCount > 0 ? practicedCount / totalCount : 0.0;
  final strongRatio = totalCount > 0 ? strongCount / totalCount : 0.0;
  final accuracyRatio = attempts > 0 ? correct / attempts : 0.0;
  final categoryMasteryPercent =
      min(100, (coverageRatio * 35 + accuracyRatio * 35 + strongRatio * 30).round());

  return CategoryPerformanceSummary(
    category: category,
    label: label,
    shortLabel: shortLabel,
    totalCount: totalCount,
    practicedCount: practicedCount,
    strongCount: strongCount,
    learningCount: learningCount,
    weakCount: weakCount,
    unseenCount: unseenCount,
    attempts: attempts,
    correct: correct,
    accuracyPercent: accuracyPercent,
    masteryPercent: categoryMasteryPercent,
    averageResponseMilliseconds: responseTimeAttempts > 0
        ? (responseTimeSum / responseTimeAttempts).round()
        : null,
  );
}
