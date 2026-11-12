import 'package:flutter/material.dart';
import '../logic/mastery_analytics.dart';
import '../models/character_mastery.dart';
import '../models/kana_item.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import 'animation_effects.dart';

class CharacterDetailSheet extends StatelessWidget {
  final KanaItem item;
  final CharacterMastery? stats;
  final VoidCallback? onPracticeCharacter;

  const CharacterDetailSheet({
    super.key,
    required this.item,
    this.stats,
    this.onPracticeCharacter,
  });

  @override
  Widget build(BuildContext context) {
    final tier = getCharacterPerformanceTier(stats);
    final accuracy = getCharacterAccuracy(stats);
    final avgMs = getCharacterAverageResponseMilliseconds(stats);
    final confusions = getTopConfusedRomaji(stats);

    Color tierColor;
    switch (tier) {
      case LetterPerformanceTier.strong:
        tierColor = AppColors.emerald;
        break;
      case LetterPerformanceTier.learning:
        tierColor = AppColors.amber;
        break;
      case LetterPerformanceTier.weak:
        tierColor = AppColors.rose;
        break;
      case LetterPerformanceTier.unseen:
        tierColor = AppColors.textMuted;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Main Header: Dual Glyphs
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.hiragana,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.katakana,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.romaji,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: tierColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: tierColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            tier.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: tierColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Alt: ${item.acceptedRomaji.join(", ")}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category.label,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Memory Hint Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 16, color: AppColors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.hint,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Mastery Metrics
          Text(
            'PERFORMANCE METRICS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _MetricTile(
                label: 'Attempts',
                value: '${stats?.attempts ?? 0}',
              ),
              const SizedBox(width: 8),
              _MetricTile(
                label: 'Accuracy',
                value: accuracy != null ? '$accuracy%' : '—',
                valueColor: accuracy != null && accuracy >= 80
                    ? AppColors.emerald
                    : AppColors.text,
              ),
              const SizedBox(width: 8),
              _MetricTile(
                label: 'Streak',
                value: '${stats?.streak ?? 0}x',
              ),
              const SizedBox(width: 8),
              _MetricTile(
                label: 'Avg Speed',
                value: avgMs != null ? '${(avgMs / 1000).toStringAsFixed(1)}s' : '—',
              ),
            ],
          ),

          if (confusions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'OFTEN CONFUSED WITH',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.rose,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: confusions.map((c) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.rose.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${c.key} (${c.value}x)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.rose,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 20),

          // Action Button
          Row(
            children: [
              BouncingWidget(
                scaleFactor: 0.88,
                onTap: () {
                  AudioService.playCorrect(1, true);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(Icons.volume_up_rounded, color: AppColors.text, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BouncingWidget(
                  scaleFactor: 0.96,
                  onTap: () {
                    Navigator.pop(context);
                    onPracticeCharacter?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.text,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.text.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Practice "${item.romaji}" Kana',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
