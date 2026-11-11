enum AchievementCategory {
  streak,
  unlock,
  performance;

  String get label {
    switch (this) {
      case AchievementCategory.streak:
        return 'Streak Milestones';
      case AchievementCategory.unlock:
        return 'Row Unlocks';
      case AchievementCategory.performance:
        return 'Mastery & Speed';
    }
  }
}

class AchievementDefinition {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final String badgeSymbol;
  final int targetValue;
  final int xpReward;

  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.badgeSymbol,
    required this.targetValue,
    required this.xpReward,
  });
}

class AchievementStatus {
  final AchievementDefinition definition;
  final int currentValue;
  final int progressPercent;
  final bool isUnlocked;
  final String? unlockedAtIso;

  const AchievementStatus({
    required this.definition,
    required this.currentValue,
    required this.progressPercent,
    required this.isUnlocked,
    this.unlockedAtIso,
  });

  String get id => definition.id;
  String get title => definition.title;
  String get description => definition.description;
  AchievementCategory get category => definition.category;
  String get badgeSymbol => definition.badgeSymbol;
  int get targetValue => definition.targetValue;
  int get xpReward => definition.xpReward;
}
