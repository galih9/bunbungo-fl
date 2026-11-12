import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/challenge.dart';
import '../models/kana_item.dart';
import '../theme/app_theme.dart';
import 'animation_effects.dart';

class SessionSummaryView extends StatelessWidget {
  final int score;
  final int accuracy;
  final int bestStreak;
  final int durationSeconds;
  final SessionProgressionResult? result;
  final List<KanaItem> missedItems;
  final int weakCount;
  final VoidCallback onPlayAgain;
  final ValueChanged<List<KanaItem>> onPracticeMissedItems;
  final VoidCallback onPracticeWeakLetters;
  final VoidCallback onCustomizeDeck;

  const SessionSummaryView({
    super.key,
    required this.score,
    required this.accuracy,
    required this.bestStreak,
    required this.durationSeconds,
    this.result,
    required this.missedItems,
    this.weakCount = 0,
    required this.onPlayAgain,
    required this.onPracticeMissedItems,
    required this.onPracticeWeakLetters,
    required this.onCustomizeDeck,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Festive Confetti burst on session completion
        const Positioned.fill(
          child: ConfettiBurst(),
        ),

        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner with celebratory animations
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.amber.withValues(alpha: 0.4)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🏆', style: TextStyle(fontSize: 28)),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.4, 0.4),
                          end: const Offset(1.0, 1.0),
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        )
                        .then()
                        .shimmer(duration: 1200.ms, color: Colors.white24),
                    const SizedBox(height: 12),
                    Text(
                      'Session Complete!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0.0),
                    const SizedBox(height: 4),
                    Text(
                      'Great job practicing your Japanese syllabary skills.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Metrics Grid with smooth count-up animations
                    Row(
                      children: [
                        _AnimatedMetricCard(
                          label: 'SCORE',
                          targetValue: score,
                          suffix: '',
                          color: AppColors.text,
                        ),
                        const SizedBox(width: 8),
                        _AnimatedMetricCard(
                          label: 'ACCURACY',
                          targetValue: accuracy,
                          suffix: '%',
                          color: accuracy >= 80 ? AppColors.emerald : AppColors.amber,
                        ),
                        const SizedBox(width: 8),
                        _AnimatedMetricCard(
                          label: 'STREAK',
                          targetValue: bestStreak,
                          suffix: 'x',
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 8),
                        _AnimatedMetricCard(
                          label: 'TIME',
                          targetValue: durationSeconds,
                          suffix: 's',
                          color: AppColors.sky,
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0.0),

              const SizedBox(height: 14),

              // Progression Outcome
              if (result != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PROGRESSION EARNED',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            '+${result!.xpEarned} XP',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ],
                      ),
                      if (result!.newLevel > result!.previousLevel) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.emerald.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Text('🎉 ', style: TextStyle(fontSize: 18)),
                              Expanded(
                                child: Text(
                                  'LEVEL UP! You are now Level ${result!.newLevel}!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.emerald,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().scale(curve: Curves.easeOutBack, duration: 400.ms),
                      ],
                      if (result!.newlyUnlockedRows.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.amber.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock_open_rounded,
                                  size: 16, color: AppColors.amber),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Unlocked ${result!.newlyUnlockedRows.length} new Kana row(s)!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (result!.newlyUnlockedAchievements.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.purple.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.military_tech_rounded,
                                  size: 16, color: AppColors.purple),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Unlocked Badges: ${result!.newlyUnlockedAchievements.map((a) => a.title).join(", ")}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
                const SizedBox(height: 14),
              ],

              // Missed Kana Cards
              if (missedItems.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MISSED KANA (${missedItems.length})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: AppColors.rose,
                            ),
                          ),
                          BouncingWidget(
                            scaleFactor: 0.92,
                            onTap: () => onPracticeMissedItems(missedItems),
                            child: Text(
                              'Practice These →',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.rose,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: missedItems.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.rose.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.hiragana,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.romaji,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.rose,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                const SizedBox(height: 14),
              ],

              // Action Buttons with Tactile Bounce
              BouncingWidget(
                scaleFactor: 0.96,
                onTap: onPlayAgain,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.text.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              if (weakCount > 0) ...[
                BouncingWidget(
                  scaleFactor: 0.96,
                  onTap: onPracticeWeakLetters,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.rose, width: 1.5),
                    ),
                    child: Text(
                      'Review $weakCount Weak Kana',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.rose,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              BouncingWidget(
                scaleFactor: 0.96,
                onTap: onCustomizeDeck,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Customize Deck Setup',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedMetricCard extends StatelessWidget {
  final String label;
  final int targetValue;
  final String suffix;
  final Color color;

  const _AnimatedMetricCard({
    required this.label,
    required this.targetValue,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            CountUpText(
              targetValue: targetValue,
              suffix: suffix,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
