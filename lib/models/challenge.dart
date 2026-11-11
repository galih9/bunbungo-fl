import 'achievement.dart';
import 'kana_item.dart';
import 'user_progression.dart';

class FlashcardChallenge {
  final String cardId;
  final KanaItem item;
  final KanaScript script;
  final String displayCharacter;
  final List<String> options;
  final bool isRedemption;

  const FlashcardChallenge({
    required this.cardId,
    required this.item,
    required this.script,
    required this.displayCharacter,
    required this.options,
    this.isRedemption = false,
  });
}

enum FeedbackStatus {
  correct,
  wrong;
}

enum SpeedTier {
  instant,
  fast,
  steady;

  String get label {
    switch (this) {
      case SpeedTier.instant:
        return '⚡ Instant (<1.2s)';
      case SpeedTier.fast:
        return '🔥 Fast (<2.0s)';
      case SpeedTier.steady:
        return '👍 Steady';
    }
  }
}

class FeedbackState {
  final FeedbackStatus status;
  final int pointsEarned;
  final String chosenRomaji;
  final String expectedRomaji;
  final bool isRedemptionCleared;
  final int responseTimeMilliseconds;
  final SpeedTier? speedTier;

  const FeedbackState({
    required this.status,
    required this.pointsEarned,
    required this.chosenRomaji,
    required this.expectedRomaji,
    required this.isRedemptionCleared,
    required this.responseTimeMilliseconds,
    this.speedTier,
  });

  bool get isCorrect => status == FeedbackStatus.correct;
}

class SessionProgressionResult {
  final UserProgression updatedProgression;
  final int xpEarned;
  final int previousLevel;
  final int newLevel;
  final List<KanaRowGroup> newlyUnlockedRows;
  final List<AchievementDefinition> newlyUnlockedAchievements;

  const SessionProgressionResult({
    required this.updatedProgression,
    required this.xpEarned,
    required this.previousLevel,
    required this.newLevel,
    required this.newlyUnlockedRows,
    required this.newlyUnlockedAchievements,
  });
}
