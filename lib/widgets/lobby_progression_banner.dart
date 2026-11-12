import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/progression_engine.dart';
import '../logic/mastery_analytics.dart';
import '../models/game_settings.dart';
import '../models/user_progression.dart';
import '../theme/app_theme.dart';
import 'animation_effects.dart';

class LobbyProgressionBanner extends StatelessWidget {
  final UserProgression progression;
  final KanaPerformanceAnalysis analysis;
  final PracticeFocusMode practiceFocusMode;
  final VoidCallback onToggleFocusMode;
  final VoidCallback onStartWeakLetters;
  final VoidCallback onOpenAchievements;

  const LobbyProgressionBanner({
    super.key,
    required this.progression,
    required this.analysis,
    required this.practiceFocusMode,
    required this.onToggleFocusMode,
    required this.onStartWeakLetters,
    required this.onOpenAchievements,
  });

  @override
  Widget build(BuildContext context) {
    final currentLevel = progression.level;
    final currentThreshold = getXpThresholdForLevel(currentLevel);
    final nextThreshold = getXpThresholdForLevel(currentLevel + 1);
    final xpInLevel = max(0, progression.xp - currentThreshold);
    final levelRange = max(1, nextThreshold - currentThreshold);
    final levelProgress = (xpInLevel / levelRange).clamp(0.0, 1.0);

    final weakCount = analysis.weakItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Level & Streaks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BouncingWidget(
                scaleFactor: 0.94,
                onTap: onOpenAchievements,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 14, color: AppColors.amber),
                      const SizedBox(width: 4),
                      Text(
                        'Lv.$currentLevel ${getRankTitleForLevel(currentLevel)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥 ', style: TextStyle(fontSize: 12)),
                    Text(
                      '${progression.currentDailyStreak}d Streak',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // XP Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XP Progress (${(levelProgress * 100).round()}%)',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              Text(
                '${progression.xp} / $nextThreshold XP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SmoothAnimatedProgressBar(
            progress: levelProgress,
            height: 6,
            fillColor: AppColors.emerald,
            backgroundColor: AppColors.surfaceElevated,
          ),

          if (weakCount > 0) ...[
            const SizedBox(height: 14),
            GlowPulseWidget(
              glowColor: AppColors.rose,
              animate: true,
              minScale: 1.0,
              maxScale: 1.015,
              duration: const Duration(milliseconds: 1400),
              child: BouncingWidget(
                scaleFactor: 0.97,
                onTap: onStartWeakLetters,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.rose.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.rose.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.priority_high_rounded,
                          size: 16, color: AppColors.rose),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Targeted Review: $weakCount weak Kana detected',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.rose,
                          ),
                        ),
                      ),
                      Text(
                        'Drill Now →',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.rose,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
