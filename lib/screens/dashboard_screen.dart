import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/dashboard_analytics.dart';
import '../logic/mastery_analytics.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/user_progression.dart';
import '../providers/app_providers.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/character_detail_sheet.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/lobby_progression_banner.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final PersistenceService persistence;
  final VoidCallback onDataChanged;
  final ValueChanged<int> onNavigateTab;
  final VoidCallback? onStartWeakLetters;

  const DashboardScreen({
    super.key,
    required this.persistence,
    required this.onDataChanged,
    required this.onNavigateTab,
    this.onStartWeakLetters,
  });

  @override
  ConsumerState<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  late UserProgression _progression;
  late Map<String, CharacterMastery> _masteryMap;

  @override
  void initState() {
    super.initState();
    _progression = widget.persistence.loadUserProgression();
    _masteryMap = widget.persistence.loadMasteryMap();
  }

  void refreshData() {
    ref.read(gameSettingsProvider.notifier).reload();
    ref.read(userProgressionProvider.notifier).reload();
    ref.read(characterMasteryProvider.notifier).reload();
    ref.read(highScoresProvider.notifier).reload();
  }

  void _handleRecommendation(StudyRecommendation rec) {
    final currentSettings = ref.read(gameSettingsProvider);
    if (rec.actionType == StudyRecommendationType.katakanaFocus) {
      ref.read(gameSettingsProvider.notifier).updateSettings(
        currentSettings.copyWith(scriptMode: ScriptSelection.katakana),
      );
    } else if (rec.actionType == StudyRecommendationType.hiraganaFocus) {
      ref.read(gameSettingsProvider.notifier).updateSettings(
        currentSettings.copyWith(scriptMode: ScriptSelection.hiragana),
      );
    }
    widget.onNavigateTab(0);
  }

  @override
  Widget build(BuildContext context) {
    _progression = ref.watch(userProgressionProvider);
    _masteryMap = ref.watch(characterMasteryProvider);
    final summary = ref.watch(dashboardSummaryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Screen Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PERFORMANCE DASHBOARD',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.sky,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Learner Telemetry & Analytics',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Real-time accuracy distributions, mastery coverage, and smart study recommendations.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Learner Progression & Weak Kana Review Banner
          LobbyProgressionBanner(
            progression: _progression,
            analysis: summary.analysis,
            practiceFocusMode: PracticeFocusMode.standard,
            onToggleFocusMode: () {},
            onStartWeakLetters: () {
              widget.onStartWeakLetters?.call();
            },
            onOpenAchievements: () => widget.onNavigateTab(3),
          ),

          const SizedBox(height: 16),

          // Executive Summary Card
          _buildExecutiveSummary(summary),

          const SizedBox(height: 16),

          // Duolingo-style Daily Practice Activity Chart
          DuolingoDailyActivityChart(
            dailyActivity: summary.dailyActivity,
            streakDays: _progression.currentDailyStreak,
            dailyGoal: 20,
          ),

          const SizedBox(height: 16),

          // Speed & Reflex Performance Chart
          RecallSpeedPerformanceChart(
            speedPoints: summary.speedPerformance,
          ),

          const SizedBox(height: 16),

          // Character Spotlight (Weakest & Strongest)
          _buildCharacterSpotlight(summary),

          const SizedBox(height: 16),

          // Study Recommendations
          _buildRecommendations(summary),

          const SizedBox(height: 16),

          // Mastery Distribution
          _buildMasteryDistribution(summary),

          const SizedBox(height: 16),

          // Response Speed Reflex Breakdown
          _buildSpeedBuckets(summary),

          const SizedBox(height: 16),

          // Script & Category Breakdown
          _buildScriptAndCategoryBreakdown(summary),

          const SizedBox(height: 16),

          // Session Trend History
          if (summary.sessionTrend.isNotEmpty) ...[
            _buildSessionTrend(summary),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummary(DashboardSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular Proficiency Score Gauge
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: summary.overallProficiencyScore / 100.0,
                      strokeWidth: 6,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.emerald),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${summary.overallProficiencyScore}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        'SCORE',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proficiency Rating',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${summary.coveragePercent}% Syllabary Coverage (${summary.analysis.totalAttempts} total attempts)',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${summary.masteryPercent}% Kana Mastered (Strong status)',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.emerald,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _buildStatBox(
                'COVERAGE',
                '${summary.coveragePercent}%',
                AppColors.sky,
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                'MASTERY',
                '${summary.masteryPercent}%',
                AppColors.emerald,
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                'ATTEMPTS',
                '${summary.analysis.totalAttempts}',
                AppColors.text,
              ),
              const SizedBox(width: 8),
              _buildStatBox(
                'SESSIONS',
                '${_progression.totalSessionsCompleted}',
                AppColors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
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
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterSpotlight(DashboardSummary summary) {
    final weakItems = summary.analysis.weakItems.take(5).toList();
    final strongItems = summary.analysis.strongItems.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHARACTER SPOTLIGHT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Weakest Kana
          Text(
            'Needs Review (Lowest Accuracy)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.rose),
          ),
          const SizedBox(height: 8),
          if (weakItems.isEmpty)
            Text(
              'No weak characters! Practice more cards to detect trouble spots.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: weakItems.map((item) {
                final stats = _masteryMap[item.id];
                final accuracy = getCharacterAccuracy(stats);
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
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.rose.withValues(alpha: 0.3)),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.romaji,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.rose,
                              ),
                            ),
                            Text(
                              accuracy != null ? '$accuracy%' : '—',
                              style: TextStyle(fontSize: 9, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // Strongest Kana
          Text(
            'Top Mastered (High Reflex Speed)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emerald),
          ),
          const SizedBox(height: 8),
          if (strongItems.isEmpty)
            Text(
              'Complete sprints to build strong mastery tiers.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: strongItems.map((item) {
                final stats = _masteryMap[item.id];
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CharacterDetailSheet(
                        item: item,
                        stats: stats,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
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
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(DashboardSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STUDY RECOMMENDATIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          ...summary.recommendations.map((rec) {
            Color accent = AppColors.emerald;
            if (rec.priority == 'high') accent = AppColors.rose;
            if (rec.priority == 'medium') accent = AppColors.amber;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rec.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _handleRecommendation(rec),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    child: Text(rec.actionLabel),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMasteryDistribution(DashboardSummary summary) {
    final strong = summary.analysis.strongItems.length;
    final learning = summary.analysis.learningItems.length;
    final weak = summary.analysis.weakItems.length;
    final unseen = summary.analysis.unseenItems.length;
    final total = strong + learning + weak + unseen;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MASTERY DISTRIBUTION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Segment Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  if (strong > 0)
                    Expanded(
                      flex: strong,
                      child: Container(color: AppColors.emerald),
                    ),
                  if (learning > 0)
                    Expanded(
                      flex: learning,
                      child: Container(color: AppColors.amber),
                    ),
                  if (weak > 0)
                    Expanded(
                      flex: weak,
                      child: Container(color: AppColors.rose),
                    ),
                  if (unseen > 0)
                    Expanded(
                      flex: unseen,
                      child: Container(color: AppColors.surfaceElevated),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Strong', strong, total, AppColors.emerald),
              _buildLegendItem('Learning', learning, total, AppColors.amber),
              _buildLegendItem('Weak', weak, total, AppColors.rose),
              _buildLegendItem('Unseen', unseen, total, AppColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, int count, int total, Color color) {
    final pct = total > 0 ? ((count / total) * 100).round() : 0;
    return Row(
      children: [
        Container(width: 8, height: 8, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: $count ($pct%)',
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSpeedBuckets(DashboardSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESPONSE SPEED REFLEX',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          ...summary.speedBuckets.map((bucket) {
            Color barColor = AppColors.emerald;
            if (bucket.id == 'fast') barColor = AppColors.sky;
            if (bucket.id == 'steady') barColor = AppColors.amber;
            if (bucket.id == 'slow') barColor = AppColors.rose;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bucket.label} (${bucket.rangeLabel})',
                        style: TextStyle(fontSize: 11, color: AppColors.text),
                      ),
                      Text(
                        '${bucket.count} letters (${bucket.sharePercent}%)',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: bucket.sharePercent / 100.0,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScriptAndCategoryBreakdown(DashboardSummary summary) {
    return Column(
      children: [
        // Script Performance
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
              Text(
                'SCRIPT FLUENCY COMPARISON',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: summary.scriptSummaries.map((s) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Accuracy: ${s.accuracyPercent != null ? "${s.accuracyPercent}%" : "—"}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: s.accuracyPercent != null && s.accuracyPercent! >= 80
                                  ? AppColors.emerald
                                  : AppColors.amber,
                            ),
                          ),
                          Text(
                            '${s.correct} / ${s.attempts} correct (${s.practicedCharacterCount} practiced)',
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Category Breakdown
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
              Text(
                'SYLLABARY CATEGORY MASTERY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              ...summary.categorySummaries.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          cat.shortLabel,
                          style: TextStyle(fontSize: 12, color: AppColors.text),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: cat.masteryPercent / 100.0,
                            minHeight: 6,
                            backgroundColor: AppColors.surfaceElevated,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.emerald),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '${cat.masteryPercent}%',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTrend(DashboardSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT SESSION TRENDS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: summary.sessionTrend.map((run) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        run.sessionLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${run.score}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.amber,
                        ),
                      ),
                      Text(
                        '${run.accuracy}% acc',
                        style: TextStyle(fontSize: 10, color: AppColors.emerald),
                      ),
                      Text(
                        run.dateLabel,
                        style: TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
