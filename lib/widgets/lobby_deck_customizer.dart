import 'package:flutter/material.dart';
import '../data/kana_data.dart';
import '../models/game_settings.dart';
import '../models/user_progression.dart';
import '../theme/app_theme.dart';

enum RowPreset { starter, basic, dakuten, digraph, all }

class LobbyDeckCustomizer extends StatelessWidget {
  final StoredGameSettings settings;
  final UserProgression progression;
  final PracticeFocusMode practiceFocusMode;
  final ValueChanged<StoredGameSettings> onUpdateSettings;
  final ValueChanged<String> onToggleRow;
  final ValueChanged<RowPreset> onSelectPreset;
  final VoidCallback? onToggleUnlockAll;

  const LobbyDeckCustomizer({
    super.key,
    required this.settings,
    required this.progression,
    this.practiceFocusMode = PracticeFocusMode.standard,
    required this.onUpdateSettings,
    required this.onToggleRow,
    required this.onSelectPreset,
    this.onToggleUnlockAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Script Mode
        Text(
          'SCRIPT SELECTION',
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
            _PillButton(
              label: 'Hiragana (あ)',
              isSelected: settings.scriptMode == ScriptSelection.hiragana,
              onTap: () => onUpdateSettings(
                settings.copyWith(scriptMode: ScriptSelection.hiragana),
              ),
            ),
            const SizedBox(width: 8),
            _PillButton(
              label: 'Katakana (ア)',
              isSelected: settings.scriptMode == ScriptSelection.katakana,
              onTap: () => onUpdateSettings(
                settings.copyWith(scriptMode: ScriptSelection.katakana),
              ),
            ),
            const SizedBox(width: 8),
            _PillButton(
              label: 'Mixed',
              isSelected: settings.scriptMode == ScriptSelection.mixed,
              onTap: () => onUpdateSettings(
                settings.copyWith(scriptMode: ScriptSelection.mixed),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Section 2: Game Mode & Input Mode
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GAME MODE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _PillButton(
                        label: 'Sprint (20)',
                        isSelected: settings.gameMode == GameMode.sprint,
                        onTap: () => onUpdateSettings(
                          settings.copyWith(gameMode: GameMode.sprint),
                        ),
                      ),
                      _PillButton(
                        label: 'Timed (60s)',
                        isSelected: settings.gameMode == GameMode.timeAttack,
                        onTap: () => onUpdateSettings(
                          settings.copyWith(gameMode: GameMode.timeAttack),
                        ),
                      ),
                      _PillButton(
                        label: 'Zen',
                        isSelected: settings.gameMode == GameMode.zen,
                        onTap: () => onUpdateSettings(
                          settings.copyWith(gameMode: GameMode.zen),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INPUT METHOD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _PillButton(
                        label: 'Choice (4)',
                        isSelected: settings.inputMode == InputMode.choice,
                        onTap: () => onUpdateSettings(
                          settings.copyWith(inputMode: InputMode.choice),
                        ),
                      ),
                      _PillButton(
                        label: 'Typing',
                        isSelected: settings.inputMode == InputMode.typing,
                        onTap: () => onUpdateSettings(
                          settings.copyWith(inputMode: InputMode.typing),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Section 3: Row Presets
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRACTICE ROWS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _PresetButton(
                label: 'Starter (A, Ka, Sa)',
                onTap: () => onSelectPreset(RowPreset.starter),
              ),
              const SizedBox(width: 6),
              _PresetButton(
                label: 'Basic (46)',
                onTap: () => onSelectPreset(RowPreset.basic),
              ),
              const SizedBox(width: 6),
              _PresetButton(
                label: 'Dakuten (25)',
                onTap: () => onSelectPreset(RowPreset.dakuten),
              ),
              const SizedBox(width: 6),
              _PresetButton(
                label: 'Digraphs (33)',
                onTap: () => onSelectPreset(RowPreset.digraph),
              ),
              const SizedBox(width: 6),
              _PresetButton(
                label: 'All (104)',
                onTap: () => onSelectPreset(RowPreset.all),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Grid of Row Selection Cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kanaRowGroups.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final group = kanaRowGroups[index];
            final isUnlocked = progression.unlockAllRows ||
                progression.unlockedRowIds.contains(group.id);
            final isSelected = settings.selectedRows.contains(group.id);

            return InkWell(
              onTap: isUnlocked ? () => onToggleRow(group.id) : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceElevated
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.emerald.withValues(alpha: 0.5)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    // Sample Character Badge
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        settings.scriptMode == ScriptSelection.katakana
                            ? group.sampleKatakana
                            : group.sampleHiragana,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? AppColors.text : AppColors.textMuted,
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
                                group.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isUnlocked
                                      ? AppColors.text
                                      : AppColors.textMuted,
                                ),
                              ),
                              if (!isUnlocked) ...[
                                const SizedBox(width: 6),
                                Icon(Icons.lock_outline,
                                    size: 13, color: AppColors.textMuted),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            group.romajiSummary,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUnlocked)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.emerald : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.emerald
                                : AppColors.borderLight,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 14, color: Colors.black)
                            : null,
                      )
                    else
                      Text(
                        'Locked',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.borderLight : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.text : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
