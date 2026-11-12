import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/kana_data.dart';
import '../logic/mastery_analytics.dart';
import '../logic/progression_engine.dart';
import '../models/achievement.dart';
import '../models/character_mastery.dart';
import '../models/high_score.dart';
import '../models/user_progression.dart';
import '../providers/app_providers.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/character_detail_sheet.dart';

enum StatsSubTab { analytics, achievements, leaderboard }

class StatsScreen extends ConsumerStatefulWidget {
  final PersistenceService persistence;
  final VoidCallback onDataChanged;
  final ValueChanged<int> onNavigateTab;

  const StatsScreen({
    super.key,
    required this.persistence,
    required this.onDataChanged,
    required this.onNavigateTab,
  });

  @override
  ConsumerState<StatsScreen> createState() => StatsScreenState();
}

class StatsScreenState extends ConsumerState<StatsScreen> {
  StatsSubTab _subTab = StatsSubTab.analytics;
  late UserProgression _progression;
  late Map<String, CharacterMastery> _masteryMap;
  late List<HighScoreRecord> _highScores;

  @override
  void initState() {
    super.initState();
    _progression = widget.persistence.loadUserProgression();
    _masteryMap = widget.persistence.loadMasteryMap();
    _highScores = widget.persistence.loadHighScores();
  }

  void refreshData() {
    ref.read(userProgressionProvider.notifier).reload();
    ref.read(characterMasteryProvider.notifier).reload();
    ref.read(highScoresProvider.notifier).reload();
  }

  @override
  Widget build(BuildContext context) {
    _progression = ref.watch(userProgressionProvider);
    _masteryMap = ref.watch(characterMasteryProvider);
    _highScores = ref.watch(highScoresProvider);
    final achievements = getAchievementProgressList(_progression, _masteryMap);
    final unlockedBadges = achievements.where((a) => a.isUnlocked).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // Player Profile Hero Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.purple.withValues(alpha: 0.4)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🎓', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            getRankTitleForLevel(_progression.level),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              'Lv.${_progression.level}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unlockedBadges/${achievements.length} Badges Unlocked · ${_progression.bestAnswerStreak}x Best Streak',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Sub-Tab Switcher
          Row(
            children: [
              _SubTabButton(
                label: 'Codex Analytics',
                isSelected: _subTab == StatsSubTab.analytics,
                onTap: () {
                  setState(() {
                    _subTab = StatsSubTab.analytics;
                  });
                },
              ),
              const SizedBox(width: 8),
              _SubTabButton(
                label: 'Badges ($unlockedBadges)',
                isSelected: _subTab == StatsSubTab.achievements,
                onTap: () {
                  setState(() {
                    _subTab = StatsSubTab.achievements;
                  });
                },
              ),
              const SizedBox(width: 8),
              _SubTabButton(
                label: 'Leaderboard',
                isSelected: _subTab == StatsSubTab.leaderboard,
                onTap: () {
                  setState(() {
                    _subTab = StatsSubTab.leaderboard;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sub-View Content
          Expanded(
            child: () {
              switch (_subTab) {
                case StatsSubTab.analytics:
                  return _buildAnalyticsView();
                case StatsSubTab.achievements:
                  return _buildAchievementsView(achievements);
                case StatsSubTab.leaderboard:
                  return _buildLeaderboardView();
              }
            }(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView() {
    final practicedItems = kanaItems
        .where((i) => (_masteryMap[i.id]?.attempts ?? 0) > 0)
        .toList();

    practicedItems.sort((a, b) {
      final sA = _masteryMap[a.id];
      final sB = _masteryMap[b.id];
      final accA = getCharacterAccuracy(sA) ?? 0;
      final accB = getCharacterAccuracy(sB) ?? 0;
      return accA.compareTo(accB); // lowest accuracy first
    });

    if (practicedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'No Practice Telemetry Yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete your first arena sprint or seed demo data in the Dashboard.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => widget.onNavigateTab(0),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.text,
                foregroundColor: AppColors.background,
              ),
              child: const Text('Start Arena Session'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: practicedItems.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = practicedItems[index];
        final stats = _masteryMap[item.id];
        final tier = getCharacterPerformanceTier(stats);
        final accuracy = getCharacterAccuracy(stats);
        final avgMs = getCharacterAverageResponseMilliseconds(stats);

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

        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => CharacterDetailSheet(
                item: item,
                stats: stats,
                onPracticeCharacter: () => widget.onNavigateTab(0),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.hiragana,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.romaji,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: tierColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tier.label,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: tierColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${stats?.attempts ?? 0} attempts · ${stats?.streak ?? 0}x streak',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      accuracy != null ? '$accuracy%' : '—',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: accuracy != null && accuracy >= 80
                            ? AppColors.emerald
                            : AppColors.amber,
                      ),
                    ),
                    Text(
                      avgMs != null ? '${(avgMs / 1000).toStringAsFixed(1)}s' : '—',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsView(List<AchievementStatus> achievements) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: achievements.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = achievements[index];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.isUnlocked
                  ? AppColors.purple.withValues(alpha: 0.4)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.isUnlocked
                      ? AppColors.purple.withValues(alpha: 0.2)
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: item.isUnlocked
                        ? AppColors.purple
                        : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  item.badgeSymbol,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: item.isUnlocked
                        ? AppColors.purple
                        : AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: item.isUnlocked
                                ? AppColors.text
                                : AppColors.textSecondary,
                          ),
                        ),
                        if (item.isUnlocked) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle_rounded,
                              size: 13, color: AppColors.purple),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: item.progressPercent / 100.0,
                        minHeight: 4,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          item.isUnlocked ? AppColors.purple : AppColors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+${item.xpReward} XP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardView() {
    if (_highScores.isEmpty) {
      return Center(
        child: Text(
          'No arcade high scores yet.\nComplete sessions to rank on the local leaderboard!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _highScores.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final record = _highScores[index];
        final rank = index + 1;

        Color rankColor = AppColors.textSecondary;
        if (rank == 1) rankColor = AppColors.amber;
        if (rank == 2) rankColor = const Color(0xFFE2E8F0);
        if (rank == 3) rankColor = const Color(0xFFCD7F32);

        DateTime? dt;
        try {
          dt = DateTime.parse(record.dateIso);
        } catch (_) {}
        final dateStr = dt != null ? '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, "0")}' : '';

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record.gameMode.label} · ${record.scriptMode.label}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${record.cardsCleared} cards · ${record.accuracy}% acc · ${record.durationSeconds}s · $dateStr',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${record.score} pts',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.purple.withValues(alpha: 0.5) : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.purple : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
