class UserProgression {
  final int xp;
  final int level;
  final int currentDailyStreak;
  final int bestDailyStreak;
  final String? lastPracticeDate;
  final int bestAnswerStreak;
  final int totalSessionsCompleted;
  final int totalCardsAnswered;
  final int totalCorrectAnswers;
  final List<String> unlockedRowIds;
  final bool unlockAllRows;
  final Map<String, String> unlockedAchievements;

  const UserProgression({
    this.xp = 0,
    this.level = 1,
    this.currentDailyStreak = 0,
    this.bestDailyStreak = 0,
    this.lastPracticeDate,
    this.bestAnswerStreak = 0,
    this.totalSessionsCompleted = 0,
    this.totalCardsAnswered = 0,
    this.totalCorrectAnswers = 0,
    this.unlockedRowIds = const ['row-a', 'row-ka', 'row-sa'],
    this.unlockAllRows = false,
    this.unlockedAchievements = const {},
  });

  UserProgression copyWith({
    int? xp,
    int? level,
    int? currentDailyStreak,
    int? bestDailyStreak,
    String? lastPracticeDate,
    int? bestAnswerStreak,
    int? totalSessionsCompleted,
    int? totalCardsAnswered,
    int? totalCorrectAnswers,
    List<String>? unlockedRowIds,
    bool? unlockAllRows,
    Map<String, String>? unlockedAchievements,
  }) {
    return UserProgression(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      currentDailyStreak: currentDailyStreak ?? this.currentDailyStreak,
      bestDailyStreak: bestDailyStreak ?? this.bestDailyStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      bestAnswerStreak: bestAnswerStreak ?? this.bestAnswerStreak,
      totalSessionsCompleted:
          totalSessionsCompleted ?? this.totalSessionsCompleted,
      totalCardsAnswered: totalCardsAnswered ?? this.totalCardsAnswered,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      unlockedRowIds: unlockedRowIds ?? this.unlockedRowIds,
      unlockAllRows: unlockAllRows ?? this.unlockAllRows,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'level': level,
        'currentDailyStreak': currentDailyStreak,
        'bestDailyStreak': bestDailyStreak,
        'lastPracticeDate': lastPracticeDate,
        'bestAnswerStreak': bestAnswerStreak,
        'totalSessionsCompleted': totalSessionsCompleted,
        'totalCardsAnswered': totalCardsAnswered,
        'totalCorrectAnswers': totalCorrectAnswers,
        'unlockedRowIds': unlockedRowIds,
        'unlockAllRows': unlockAllRows,
        'unlockedAchievements': unlockedAchievements,
      };

  factory UserProgression.fromJson(Map<String, dynamic> json) {
    final rawRows = json['unlockedRowIds'];
    List<String> rows = const ['row-a', 'row-ka', 'row-sa'];
    if (rawRows is List) {
      final list = rawRows.map((e) => e.toString()).toList();
      if (list.isNotEmpty) rows = list;
    }

    final rawBadges = json['unlockedAchievements'];
    final Map<String, String> badges = {};
    if (rawBadges is Map) {
      for (final entry in rawBadges.entries) {
        badges[entry.key.toString()] = entry.value.toString();
      }
    }

    return UserProgression(
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentDailyStreak: (json['currentDailyStreak'] as num?)?.toInt() ?? 0,
      bestDailyStreak: (json['bestDailyStreak'] as num?)?.toInt() ?? 0,
      lastPracticeDate: json['lastPracticeDate']?.toString(),
      bestAnswerStreak: (json['bestAnswerStreak'] as num?)?.toInt() ?? 0,
      totalSessionsCompleted:
          (json['totalSessionsCompleted'] as num?)?.toInt() ?? 0,
      totalCardsAnswered: (json['totalCardsAnswered'] as num?)?.toInt() ?? 0,
      totalCorrectAnswers: (json['totalCorrectAnswers'] as num?)?.toInt() ?? 0,
      unlockedRowIds: rows,
      unlockAllRows: json['unlockAllRows'] as bool? ?? false,
      unlockedAchievements: badges,
    );
  }
}
