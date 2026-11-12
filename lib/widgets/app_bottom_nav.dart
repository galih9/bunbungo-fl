import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'animation_effects.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final int weakCount;
  final int masteredCount;
  final int totalKanaCount;
  final int unlockedAchievements;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.weakCount = 0,
    this.masteredCount = 0,
    this.totalKanaCount = 104,
    this.unlockedAchievements = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            index: 0,
            currentIndex: currentIndex,
            label: 'Arena',
            icon: Icons.flash_on_rounded,
            activeColor: AppColors.emerald,
            onTap: () => onTabSelected(0),
          ),
          _NavItem(
            index: 1,
            currentIndex: currentIndex,
            label: 'Dashboard',
            icon: Icons.insights_rounded,
            activeColor: AppColors.sky,
            badge: weakCount > 0 ? '$weakCount' : null,
            badgeColor: AppColors.rose,
            onTap: () => onTabSelected(1),
          ),
          _NavItem(
            index: 2,
            currentIndex: currentIndex,
            label: 'Chart',
            icon: Icons.grid_view_rounded,
            activeColor: AppColors.amber,
            badge: masteredCount > 0 ? '$masteredCount' : null,
            badgeColor: AppColors.amber,
            onTap: () => onTabSelected(2),
          ),
          _NavItem(
            index: 3,
            currentIndex: currentIndex,
            label: 'Stats',
            icon: Icons.emoji_events_rounded,
            activeColor: AppColors.purple,
            badge: unlockedAchievements > 0 ? '$unlockedAchievements' : null,
            badgeColor: AppColors.purple,
            onTap: () => onTabSelected(3),
          ),
          _NavItem(
            index: 4,
            currentIndex: currentIndex,
            label: 'Settings',
            icon: Icons.tune_rounded,
            activeColor: AppColors.rose,
            onTap: () => onTabSelected(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData icon;
  final Color activeColor;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.activeColor,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final iconColor = isSelected ? activeColor : AppColors.textSecondary;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: Tooltip(
        message: label,
        child: BouncingWidget(
          scaleFactor: 0.92,
          onTap: () {
            try {
              HapticFeedback.lightImpact();
            } catch (_) {}
            onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? (AppColors.isMinimal
                      ? AppColors.surfaceElevated
                      : activeColor.withValues(alpha: 0.12))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    icon,
                    size: 24,
                    color: iconColor,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: badgeColor ?? AppColors.rose,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: AppColors.isMinimal
                              ? null
                              : [
                                  BoxShadow(
                                    color: (badgeColor ?? AppColors.rose).withValues(alpha: 0.35),
                                    blurRadius: 4,
                                  ),
                                ],
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
