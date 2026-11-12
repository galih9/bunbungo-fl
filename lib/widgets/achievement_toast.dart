import 'dart:async';
import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../theme/app_theme.dart';

class AchievementToast {
  static final List<OverlayEntry> _activeEntries = [];

  static void show(
    BuildContext context,
    AchievementDefinition achievement, {
    Duration duration = const Duration(milliseconds: 3800),
  }) {
    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) return;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _AchievementToastWidget(
        achievement: achievement,
        onDismiss: () {
          _removeEntry(entry);
        },
      ),
    );

    _activeEntries.add(entry);
    overlayState.insert(entry);

    Timer(duration, () {
      _removeEntry(entry);
    });
  }

  static void _removeEntry(OverlayEntry entry) {
    if (_activeEntries.contains(entry)) {
      _activeEntries.remove(entry);
      if (entry.mounted) {
        entry.remove();
      }
    }
  }
}

class _AchievementToastWidget extends StatefulWidget {
  final AchievementDefinition achievement;
  final VoidCallback onDismiss;

  const _AchievementToastWidget({
    required this.achievement,
    required this.onDismiss,
  });

  @override
  State<_AchievementToastWidget> createState() => _AchievementToastWidgetState();
}

class _AchievementToastWidgetState extends State<_AchievementToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 12;

    return Positioned(
      top: topPadding,
      right: 12,
      child: Material(
        type: MaterialType.transparency,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.amber.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: AppColors.amber.withValues(alpha: 0.15),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Badge icon avatar
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.amber.withValues(alpha: 0.3),
                              AppColors.amber.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.amber,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.achievement.badgeSymbol,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Text info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.military_tech_rounded,
                                  color: AppColors.amber,
                                  size: 13,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    'ACHIEVEMENT UNLOCKED',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: AppColors.amber,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.achievement.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.emerald.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '+${widget.achievement.xpReward} XP',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.emerald,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.achievement.category.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        onPressed: _dismiss,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
