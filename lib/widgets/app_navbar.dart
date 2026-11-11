import 'package:flutter/material.dart';
import '../logic/progression_engine.dart';
import '../theme/app_theme.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final int level;
  final int totalAchievements;
  final int unlockedAchievements;
  final bool soundEnabled;
  final bool voiceEnabled;
  final VoidCallback onToggleSound;
  final VoidCallback onToggleVoice;

  const AppNavbar({
    super.key,
    required this.level,
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.soundEnabled,
    required this.voiceEnabled,
    required this.onToggleSound,
    required this.onToggleVoice,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo & Level Status
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'あ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Bun Bun Go',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Lv.$level',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${getRankTitleForLevel(level)} · $unlockedAchievements/$totalAchievements Badges',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Audio Controls
          Row(
            children: [
              _AudioToggleButton(
                label: 'SFX',
                enabled: soundEnabled,
                onTap: onToggleSound,
              ),
              const SizedBox(width: 6),
              _AudioToggleButton(
                label: 'Voice',
                enabled: voiceEnabled,
                onTap: onToggleVoice,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudioToggleButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _AudioToggleButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: enabled ? AppColors.surfaceElevated : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled ? AppColors.borderLight : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: enabled ? AppColors.emerald : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: enabled ? AppColors.text : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
