import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../models/kana_item.dart';
import '../theme/app_theme.dart';

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.4)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🏆', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(height: 12),
                Text(
                  'Session Complete!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Great job practicing your Japanese syllabary skills.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                // Metrics Grid
                Row(
                  children: [
                    _MetricCard(
                      label: 'SCORE',
                      value: '$score',
                      color: AppColors.text,
                    ),
                    const SizedBox(width: 8),
                    _MetricCard(
                      label: 'ACCURACY',
                      value: '$accuracy%',
                      color: accuracy >= 80 ? AppColors.emerald : AppColors.amber,
                    ),
                    const SizedBox(width: 8),
                    _MetricCard(
                      label: 'STREAK',
                      value: '${bestStreak}x',
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 8),
                    _MetricCard(
                      label: 'TIME',
                      value: '${durationSeconds}s',
                      color: AppColors.sky,
                    ),
                  ],
                ),
              ],
            ),
          ),

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
                    ),
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
            ),
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
                      InkWell(
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
            ),
            const SizedBox(height: 14),
          ],

          // Action Buttons
          ElevatedButton(
            onPressed: onPlayAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.text,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          if (weakCount > 0) ...[
            OutlinedButton(
              onPressed: onPracticeWeakLetters,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.rose,
                side: BorderSide(color: AppColors.rose),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Review $weakCount Weak Kana',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
          ],

          OutlinedButton(
            onPressed: onCustomizeDeck,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Customize Deck Setup',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
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
            Text(
              value,
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
