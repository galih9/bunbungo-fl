import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../logic/dashboard_analytics.dart';
import '../theme/app_theme.dart';

/// Duolingo-style Daily Practice Activity Chart (Letters Practiced per Day)
class DuolingoDailyActivityChart extends StatelessWidget {
  final List<DailyActivityDataPoint> dailyActivity;
  final int streakDays;
  final int dailyGoal;

  const DuolingoDailyActivityChart({
    super.key,
    required this.dailyActivity,
    this.streakDays = 0,
    this.dailyGoal = 20,
  });

  @override
  Widget build(BuildContext context) {
    final maxPracticed = dailyActivity.isEmpty
        ? 0
        : dailyActivity.map((d) => d.lettersPracticed).reduce(max);
    final maxY = max(dailyGoal.toDouble() + 5.0, (maxPracticed * 1.25).ceilToDouble());
    final totalThisWeek =
        dailyActivity.fold<int>(0, (sum, d) => sum + d.lettersPracticed);
    final todayData = dailyActivity.firstWhere(
      (d) => d.isToday,
      orElse: () => dailyActivity.isNotEmpty
          ? dailyActivity.last
          : DailyActivityDataPoint(
              date: DateTime.now(),
              dateKey: '',
              dayName: 'Today',
              lettersPracticed: 0,
              isToday: true,
              goalReached: false,
            ),
    );

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bar_chart_rounded, size: 16, color: AppColors.emerald),
                      const SizedBox(width: 6),
                      Text(
                        'DAILY ACTIVITY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Letters Practiced',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),

              // Streak & Total Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '$streakDays Day Streak',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Subtitle / Goal Status
          Row(
            children: [
              Expanded(
                child: Text(
                  todayData.goalReached
                      ? 'Daily goal met today! (${todayData.lettersPracticed}/$dailyGoal letters)'
                      : 'Today: ${todayData.lettersPracticed}/$dailyGoal letters to hit daily goal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: todayData.goalReached ? AppColors.emerald : AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                'Weekly: $totalThisWeek Kana',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sky,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Bar Chart
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surfaceElevated,
                    tooltipBorderRadius: BorderRadius.circular(10),
                    tooltipBorder: BorderSide(color: AppColors.borderLight),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex >= dailyActivity.length) return null;
                      final point = dailyActivity[groupIndex];
                      return BarTooltipItem(
                        '${point.dayName}\n',
                        TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: '${point.lettersPracticed} Letters',
                            style: TextStyle(
                              color: point.lettersPracticed > 0
                                  ? AppColors.emerald
                                  : AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: (maxY / 3).clamp(5.0, 50.0),
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= dailyActivity.length) {
                          return const SizedBox.shrink();
                        }
                        final day = dailyActivity[index];
                        final isToday = day.isToday;

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isToday ? 6 : 0,
                              vertical: isToday ? 2 : 0,
                            ),
                            decoration: isToday
                                ? BoxDecoration(
                                    color: AppColors.emerald.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  )
                                : null,
                            child: Text(
                              day.dayName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                                color: isToday ? AppColors.emerald : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY / 3).clamp(5.0, 50.0),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.border.withValues(alpha: 0.4),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: dailyActivity.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  final count = day.lettersPracticed.toDouble();
                  final isToday = day.isToday;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count > 0 ? count : 0.8,
                        width: 18,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        gradient: count > 0
                            ? LinearGradient(
                                colors: day.goalReached
                                    ? [AppColors.emerald, AppColors.sky]
                                    : [
                                        AppColors.emerald.withValues(alpha: 0.7),
                                        AppColors.emerald,
                                      ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )
                            : LinearGradient(
                                colors: [
                                  AppColors.surfaceElevated,
                                  AppColors.surfaceElevated,
                                ],
                              ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: isToday
                              ? AppColors.emerald.withValues(alpha: 0.06)
                              : AppColors.surfaceElevated.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Speed & Reflex Performance Chart (Response Time & Speed per Letter)
class RecallSpeedPerformanceChart extends StatefulWidget {
  final List<SpeedPerformancePoint> speedPoints;

  const RecallSpeedPerformanceChart({
    super.key,
    required this.speedPoints,
  });

  @override
  State<RecallSpeedPerformanceChart> createState() => _RecallSpeedPerformanceChartState();
}

class _RecallSpeedPerformanceChartState extends State<RecallSpeedPerformanceChart> {
  // 0: Response Time (Seconds / Letter), 1: Throughput (Cards / Minute)
  int _viewMode = 0;

  @override
  Widget build(BuildContext context) {
    final points = widget.speedPoints;
    final hasData = points.isNotEmpty;

    double avgSpeed = 0;
    double bestSpeed = 0;
    int avgCpm = 0;

    if (hasData) {
      avgSpeed = points.map((p) => p.secondsPerLetter).reduce((a, b) => a + b) / points.length;
      bestSpeed = points.map((p) => p.secondsPerLetter).reduce(min);
      avgCpm = (points.map((p) => p.cardsPerMinute).reduce((a, b) => a + b) / points.length).round();
    }

    String reflexTier = 'Steady';
    Color reflexColor = AppColors.amber;
    if (avgSpeed > 0 && avgSpeed <= 1.2) {
      reflexTier = 'Instant Reflex';
      reflexColor = AppColors.emerald;
    } else if (avgSpeed > 0 && avgSpeed <= 1.8) {
      reflexTier = 'Fast Recall';
      reflexColor = AppColors.sky;
    }

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
          // Header & Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed_rounded, size: 16, color: AppColors.sky),
                      const SizedBox(width: 6),
                      Text(
                        'PRACTICE PERFORMANCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: AppColors.sky,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Letter Recall Speed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),

              // Segmented Mode Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _ModePill(
                      label: 'Sec/Letter',
                      isSelected: _viewMode == 0,
                      onTap: () => setState(() => _viewMode = 0),
                    ),
                    _ModePill(
                      label: 'Cards/Min',
                      isSelected: _viewMode == 1,
                      onTap: () => setState(() => _viewMode = 1),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Speed KPI Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: _viewMode == 0 ? 'AVG RESPONSE' : 'AVG THROUGHPUT',
                  value: hasData
                      ? (_viewMode == 0 ? '${avgSpeed.toStringAsFixed(2)}s' : '$avgCpm cpm')
                      : '—',
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'BEST SPEED',
                  value: hasData ? '${bestSpeed.toStringAsFixed(2)}s' : '—',
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'REFLEX RATING',
                  value: hasData ? reflexTier : 'Pending',
                  color: reflexColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Chart or Placeholder
          if (!hasData)
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insights_rounded, size: 36, color: AppColors.textMuted),
                  const SizedBox(height: 8),
                  Text(
                    'No session performance recorded yet',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Complete a practice run in the Arena to track speed!',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 180,
              child: _buildLineChart(points),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<SpeedPerformancePoint> points) {
    final spots = <FlSpot>[];
    for (int i = 0; i < points.length; i++) {
      final yVal = _viewMode == 0
          ? points[i].secondsPerLetter
          : points[i].cardsPerMinute.toDouble();
      spots.add(FlSpot(i.toDouble(), yVal));
    }

    final yValues = spots.map((s) => s.y).toList();
    final minY = _viewMode == 0 ? 0.0 : max(0.0, yValues.reduce(min) - 10);
    final maxY = _viewMode == 0
        ? max(3.5, yValues.reduce(max) * 1.2)
        : (yValues.reduce(max) * 1.25).ceilToDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (points.length - 1).toDouble().clamp(1.0, 20.0),
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.surfaceElevated,
            tooltipBorderRadius: BorderRadius.circular(10),
            maxContentWidth: 160,
            tooltipBorder: BorderSide(color: AppColors.borderLight),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final idx = spot.x.toInt();
                if (idx < 0 || idx >= points.length) return null;
                final p = points[idx];
                final valueStr = _viewMode == 0
                    ? '${p.secondsPerLetter}s / letter'
                    : '${p.cardsPerMinute} cards/min';

                return LineTooltipItem(
                  '${p.sessionLabel} (${p.dateLabel})\n',
                  TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: '$valueStr\n',
                      style: TextStyle(
                        color: AppColors.sky,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${p.accuracy}% acc · ${p.cardsCleared} cards',
                      style: TextStyle(
                        color: AppColors.emerald,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _viewMode == 0 ? 1.0 : 15.0,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.border.withValues(alpha: 0.35),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: _viewMode == 0 ? 1.0 : 15.0,
              getTitlesWidget: (value, meta) {
                final str = _viewMode == 0
                    ? '${value.toStringAsFixed(1)}s'
                    : value.toInt().toString();
                return Text(
                  str,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= points.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    points[idx].sessionLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.32,
            gradient: LinearGradient(
              colors: [AppColors.sky, AppColors.emerald],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.sky,
                  strokeWidth: 2,
                  strokeColor: AppColors.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.sky.withValues(alpha: 0.28),
                  AppColors.emerald.withValues(alpha: 0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.sky : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
