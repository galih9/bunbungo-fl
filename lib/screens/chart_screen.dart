import 'package:flutter/material.dart';
import '../data/kana_data.dart';
import '../logic/mastery_analytics.dart';
import '../models/character_mastery.dart';
import '../models/kana_item.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/character_detail_sheet.dart';

class ChartScreen extends StatefulWidget {
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
  State<ChartScreen> createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> {
  KanaScript _script = KanaScript.hiragana;
  KanaCategory? _selectedCategory; // null = all
  String _searchQuery = '';
  late Map<String, CharacterMastery> _masteryMap;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() {
    setState(() {
      _masteryMap = widget.persistence.loadMasteryMap();
    });
  }

  void refreshData() {
    _loadState();
  }

  List<KanaItem> get _filteredKana {
    return kanaItems.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYLLABARY MATRIX',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.amber,
                    ),
                  ),
                  Text(
                    'Kana Reference Chart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ],
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
            style: const TextStyle(fontSize: 13, color: AppColors.text),
            decoration: InputDecoration(
              hintText: 'Search by romaji (e.g. "ka", "shi") or kana...',
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.amber),
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

          const SizedBox(height: 12),

          // Status Dot Legend
          Row(
            children: [
              _buildLegendDot(AppColors.emerald, 'Strong'),
              const SizedBox(width: 12),
              _buildLegendDot(AppColors.amber, 'Learning'),
              const SizedBox(width: 12),
              _buildLegendDot(AppColors.rose, 'Weak'),
              const SizedBox(width: 12),
              _buildLegendDot(AppColors.textMuted, 'Unseen'),
            ],
          ),

          const SizedBox(height: 10),

          // Kana Grid
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

                Color dotColor;
                switch (tier) {
                  case LetterPerformanceTier.strong:
                    dotColor = AppColors.emerald;
                    break;
                  case LetterPerformanceTier.learning:
                    dotColor = AppColors.amber;
                    break;
                  case LetterPerformanceTier.weak:
                    dotColor = AppColors.rose;
                    break;
                  case LetterPerformanceTier.unseen:
                    dotColor = AppColors.borderLight;
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
                  borderRadius: BorderRadius.circular(10),
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
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.romaji,
                                style: const TextStyle(
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
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.amber.withValues(alpha: 0.5) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.amber : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
