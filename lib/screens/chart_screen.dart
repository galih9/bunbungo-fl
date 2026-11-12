import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/kana_data.dart';
import '../logic/mastery_analytics.dart';
import '../models/character_mastery.dart';
import '../models/kana_item.dart';
import '../providers/app_providers.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animation_effects.dart';
import '../widgets/character_detail_sheet.dart';

enum KanaStatusFilter {
  all,
  unlocked,
  perfect,
  weak;

  String get label {
    switch (this) {
      case KanaStatusFilter.all:
        return 'All Status';
      case KanaStatusFilter.unlocked:
        return 'Unlocked';
      case KanaStatusFilter.perfect:
        return 'Perfect (100%)';
      case KanaStatusFilter.weak:
        return 'Weak';
    }
  }
}

class ChartScreen extends ConsumerStatefulWidget {
  final PersistenceService persistence;
  final VoidCallback onDataChanged;
  final ValueChanged<int> onNavigateTab;

  const ChartScreen({
    super.key,
    required this.persistence,
    required this.onDataChanged,
    required this.onNavigateTab,
  });

  @override
  ConsumerState<ChartScreen> createState() => ChartScreenState();
}

class ChartScreenState extends ConsumerState<ChartScreen> {
  KanaScript _script = KanaScript.hiragana;
  KanaCategory? _selectedCategory; // null = all
  KanaStatusFilter _statusFilter = KanaStatusFilter.all;
  String _searchQuery = '';
  late Map<String, CharacterMastery> _masteryMap;

  @override
  void initState() {
    super.initState();
    _masteryMap = widget.persistence.loadMasteryMap();
  }

  void refreshData() {
    ref.read(characterMasteryProvider.notifier).reload();
  }

  static Color getChartDotColor(LetterPerformanceTier tier) {
    // Exception for minimalistic themes: preserve distinct semantic indicator colors
    final isDark = !AppColors.isLight;
    switch (tier) {
      case LetterPerformanceTier.strong:
        return isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
      case LetterPerformanceTier.learning:
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
      case LetterPerformanceTier.weak:
        return isDark ? const Color(0xFFFB7185) : const Color(0xFFE11D48);
      case LetterPerformanceTier.unseen:
        return isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4D4D8);
    }
  }

  List<KanaItem> get _filteredKana {
    final progression = ref.read(userProgressionProvider);
    return kanaItems.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      final stats = _masteryMap[item.id];
      if (_statusFilter == KanaStatusFilter.unlocked) {
        final isUnlocked = progression.unlockAllRows ||
            progression.unlockedRowIds.contains(item.rowId) ||
            (stats != null && stats.attempts > 0);
        if (!isUnlocked) return false;
      } else if (_statusFilter == KanaStatusFilter.perfect) {
        final isPerfect =
            stats != null && stats.attempts > 0 && stats.correct == stats.attempts;
        if (!isPerfect) return false;
      } else if (_statusFilter == KanaStatusFilter.weak) {
        final tier = getCharacterPerformanceTier(stats);
        final isWeak = tier == LetterPerformanceTier.weak ||
            (stats != null && stats.attempts > 0 && stats.correct < stats.attempts);
        if (!isWeak) return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        final matchesRomaji = item.romaji.toLowerCase().contains(query);
        final matchesAccepted =
            item.acceptedRomaji.any((a) => a.toLowerCase().contains(query));
        final matchesHira = item.hiragana.contains(query);
        final matchesKata = item.katakana.contains(query);
        if (!matchesRomaji && !matchesAccepted && !matchesHira && !matchesKata) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _masteryMap = ref.watch(characterMasteryProvider);
    final filtered = _filteredKana;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SYLLABARY MATRIX',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),

              // Script Switcher
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _ScriptTab(
                      label: 'あ',
                      isSelected: _script == KanaScript.hiragana,
                      onTap: () {
                        setState(() {
                          _script = KanaScript.hiragana;
                        });
                      },
                    ),
                    _ScriptTab(
                      label: 'ア',
                      isSelected: _script == KanaScript.katakana,
                      onTap: () {
                        setState(() {
                          _script = KanaScript.katakana;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Search Field
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: TextStyle(fontSize: 13, color: AppColors.text),
            decoration: InputDecoration(
              hintText: 'Search kana or romaji...',
              hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
              prefixIcon: Icon(Icons.search, size: 18, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.amber),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(
                  label: 'All (104)',
                  isSelected: _selectedCategory == null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                const SizedBox(width: 6),
                _CategoryChip(
                  label: 'Monographs (46)',
                  isSelected: _selectedCategory == KanaCategory.monograph,
                  onTap: () {
                    setState(() {
                      _selectedCategory = KanaCategory.monograph;
                    });
                  },
                ),
                const SizedBox(width: 6),
                _CategoryChip(
                  label: 'Diacritics (25)',
                  isSelected: _selectedCategory == KanaCategory.diacritic,
                  onTap: () {
                    setState(() {
                      _selectedCategory = KanaCategory.diacritic;
                    });
                  },
                ),
                const SizedBox(width: 6),
                _CategoryChip(
                  label: 'Digraphs (33)',
                  isSelected: _selectedCategory == KanaCategory.digraph,
                  onTap: () {
                    setState(() {
                      _selectedCategory = KanaCategory.digraph;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Status Filters (Unlocked, Perfect, Weak)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatusFilterChip(
                  label: 'All Status',
                  isSelected: _statusFilter == KanaStatusFilter.all,
                  onTap: () {
                    setState(() {
                      _statusFilter = KanaStatusFilter.all;
                    });
                  },
                ),
                const SizedBox(width: 6),
                _StatusFilterChip(
                  label: 'Unlocked Only',
                  icon: Icons.lock_open_rounded,
                  isSelected: _statusFilter == KanaStatusFilter.unlocked,
                  onTap: () {
                    setState(() {
                      _statusFilter = KanaStatusFilter.unlocked;
                    });
                  },
                ),
                const SizedBox(width: 6),
                _StatusFilterChip(
                  label: 'Perfect Only',
                  icon: Icons.stars_rounded,
                  isSelected: _statusFilter == KanaStatusFilter.perfect,
                  onTap: () {
                    setState(() {
                      _statusFilter = KanaStatusFilter.perfect;
                    });
                  },
                ),
                const SizedBox(width: 6),
                _StatusFilterChip(
                  label: 'Weak Only',
                  icon: Icons.priority_high_rounded,
                  isSelected: _statusFilter == KanaStatusFilter.weak,
                  onTap: () {
                    setState(() {
                      _statusFilter = KanaStatusFilter.weak;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Status Dot Legend (Uses semantic colors even in minimal themes)
          Row(
            children: [
              _buildLegendDot(getChartDotColor(LetterPerformanceTier.strong), 'Strong'),
              const SizedBox(width: 12),
              _buildLegendDot(getChartDotColor(LetterPerformanceTier.learning), 'Learning'),
              const SizedBox(width: 12),
              _buildLegendDot(getChartDotColor(LetterPerformanceTier.weak), 'Weak'),
              const SizedBox(width: 12),
              _buildLegendDot(getChartDotColor(LetterPerformanceTier.unseen), 'Unseen'),
            ],
          ),

          const SizedBox(height: 10),

          // Kana Grid or Empty State
          if (filtered.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_list_off_rounded, size: 36, color: AppColors.textMuted),
                    const SizedBox(height: 8),
                    Text(
                      'No kana matching current filters',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final stats = _masteryMap[item.id];
                  final tier = getCharacterPerformanceTier(stats);
                  final dotColor = getChartDotColor(tier);

                  return BouncingWidget(
                    scaleFactor: 0.92,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => CharacterDetailSheet(
                          item: item,
                          stats: stats,
                          script: _script,
                          onPracticeCharacter: () => widget.onNavigateTab(0),
                        ),
                      );
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        // Status dot
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dotColor,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.getCharacter(_script),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.romaji,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ScriptTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScriptTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      scaleFactor: 0.92,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.amber : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      scaleFactor: 0.94,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.borderLight : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.text : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusFilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      scaleFactor: 0.94,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.borderLight : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: isSelected ? AppColors.text : AppColors.textMuted,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.text : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
