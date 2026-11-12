import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/challenge.dart';
import '../models/game_settings.dart';
import '../models/kana_item.dart';
import '../theme/app_theme.dart';
import 'animation_effects.dart';

class PlayingStage extends StatefulWidget {
  final FlashcardChallenge currentCard;
  final int currentIndex;
  final int deckLength;
  final int score;
  final int streak;
  final int remainingSeconds;
  final StoredGameSettings settings;
  final FeedbackState? feedback;
  final bool showHint;
  final String typedValue;
  final TextEditingController textController;
  final FocusNode textFocusNode;
  final ValueChanged<String> onSubmitAnswer;
  final VoidCallback onToggleHint;
  final VoidCallback onEndRun;
  final ValueChanged<String> onVirtualKeyPress;
  final VoidCallback onVirtualBackspace;

  const PlayingStage({
    super.key,
    required this.currentCard,
    required this.currentIndex,
    required this.deckLength,
    required this.score,
    required this.streak,
    required this.remainingSeconds,
    required this.settings,
    required this.feedback,
    required this.showHint,
    required this.typedValue,
    required this.textController,
    required this.textFocusNode,
    required this.onSubmitAnswer,
    required this.onToggleHint,
    required this.onEndRun,
    required this.onVirtualKeyPress,
    required this.onVirtualBackspace,
  });

  @override
  State<PlayingStage> createState() => _PlayingStageState();
}

class _PlayingStageState extends State<PlayingStage> {
  final GlobalKey<ShakeWidgetState> _shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void didUpdateWidget(covariant PlayingStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake on new incorrect feedback
    if (oldWidget.feedback == null &&
        widget.feedback != null &&
        !widget.feedback!.isCorrect) {
      _shakeKey.currentState?.shake();
    }
  }

  @override
  Widget build(BuildContext context) {
    final comboMultiplier = (1 + (widget.streak ~/ 5)).clamp(1, 4);
    final isTimeAttackUrgent = widget.settings.gameMode == GameMode.timeAttack &&
        widget.remainingSeconds <= 10;

    // Progress computation
    double progressFraction = 1.0;
    if (widget.settings.gameMode == GameMode.sprint && widget.deckLength > 0) {
      progressFraction = ((widget.currentIndex + 1) / widget.deckLength).clamp(0.0, 1.0);
    } else if (widget.settings.gameMode == GameMode.timeAttack) {
      progressFraction = ((60 - widget.remainingSeconds) / 60.0).clamp(0.0, 1.0);
    }

    return Column(
      children: [
        // Top Arena Status Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Exit Button with Bouncing press
            BouncingWidget(
              scaleFactor: 0.88,
              onTap: widget.onEndRun,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
              ),
            ),

            // Mode Progress / Timer / Zen
            GlowPulseWidget(
              glowColor: AppColors.rose,
              animate: isTimeAttackUrgent,
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isTimeAttackUrgent ? AppColors.rose : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.settings.gameMode == GameMode.timeAttack
                          ? Icons.timer_outlined
                          : Icons.filter_none_rounded,
                      size: 14,
                      color: isTimeAttackUrgent ? AppColors.rose : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.settings.gameMode == GameMode.sprint
                          ? '${widget.currentIndex + 1} / ${widget.deckLength}'
                          : widget.settings.gameMode == GameMode.timeAttack
                              ? '${widget.remainingSeconds}s'
                              : 'Card ${widget.currentIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isTimeAttackUrgent ? AppColors.rose : AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Score & Streak with Pulsing Juice
            Row(
              children: [
                if (widget.streak > 1) ...[
                  GlowPulseWidget(
                    glowColor: AppColors.amber,
                    animate: widget.streak >= 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.amber.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.streak}x ($comboMultiplier倍)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  '${widget.score} pts',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Sleek Animated Progress Bar
        SmoothAnimatedProgressBar(
          progress: progressFraction,
          height: 4.5,
          fillColor: AppColors.emerald,
          backgroundColor: AppColors.surfaceElevated,
        ),

        const SizedBox(height: 14),

        // Main Kana Flashcard with Shake & Pop
        Expanded(
          child: Center(
            child: ShakeWidget(
              key: _shakeKey,
              child: AnimatedScale(
                scale: widget.feedback != null && widget.feedback!.isCorrect ? 1.02 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: widget.feedback != null
                          ? (widget.feedback!.isCorrect ? AppColors.emerald : AppColors.rose)
                          : AppColors.border,
                      width: widget.feedback != null ? 2.2 : 1.0,
                    ),
                    boxShadow: widget.feedback != null
                        ? [
                            BoxShadow(
                              color: (widget.feedback!.isCorrect
                                      ? AppColors.emerald
                                      : AppColors.rose)
                                  .withValues(alpha: 0.28),
                              blurRadius: 22,
                              spreadRadius: 3,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badges: Script & Redemption
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                widget.currentCard.script == KanaScript.hiragana
                                    ? 'HIRAGANA'
                                    : 'KATAKANA',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            if (widget.currentCard.isRedemption) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.amber.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: AppColors.amber.withValues(alpha: 0.5)),
                                ),
                                child: Text(
                                  '⚡ REDEMPTION',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: AppColors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Giant Kana Character with Smooth Pop Transition
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 240),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.86, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            widget.currentCard.displayCharacter,
                            key: ValueKey(
                              '${widget.currentCard.item.id}_${widget.currentCard.script}',
                            ),
                            style: TextStyle(
                              fontSize: 88,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                              height: 1.0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Hint Text or Button with tactile bounce
                        if (widget.showHint)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.amber.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              widget.currentCard.item.hint,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.amber,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          BouncingWidget(
                            scaleFactor: 0.94,
                            onTap: widget.onToggleHint,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lightbulb_outline_rounded,
                                      size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Show Hint (-25 pts)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Feedback Outcome Message
                        if (widget.feedback != null) ...[
                          const SizedBox(height: 14),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            builder: (context, val, child) {
                              return Transform.scale(
                                scale: val,
                                child: Opacity(opacity: val.clamp(0.0, 1.0), child: child),
                              );
                            },
                            child: widget.feedback!.isCorrect
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_rounded,
                                          size: 16, color: AppColors.emerald),
                                      const SizedBox(width: 6),
                                      Text(
                                        '+${widget.feedback!.pointsEarned} pts',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.emerald,
                                        ),
                                      ),
                                      if (widget.feedback!.speedTier != null) ...[
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.feedback!.speedTier!.label,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel_rounded,
                                          size: 16, color: AppColors.rose),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Answer: ${widget.feedback!.expectedRomaji}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.rose,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Bottom Controls: Choice Buttons OR Typing Field
        if (widget.settings.inputMode == InputMode.choice)
          _ChoiceModeGrid(
            options: widget.currentCard.options,
            feedback: widget.feedback,
            onSelect: widget.onSubmitAnswer,
          )
        else
          _TypingModeInput(
            controller: widget.textController,
            focusNode: widget.textFocusNode,
            feedback: widget.feedback,
            onSubmit: widget.onSubmitAnswer,
            onKeyPress: widget.onVirtualKeyPress,
            onBackspace: widget.onVirtualBackspace,
          ),
      ],
    );
  }
}

class _ChoiceModeGrid extends StatelessWidget {
  final List<String> options;
  final FeedbackState? feedback;
  final ValueChanged<String> onSelect;

  const _ChoiceModeGrid({
    required this.options,
    required this.feedback,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
        children: options.map((romaji) {
          final isChosen = feedback?.chosenRomaji == romaji;
          final isExpected = feedback?.expectedRomaji == romaji;

          Color btnColor = AppColors.surface;
          Color borderColor = AppColors.border;
          Color textColor = AppColors.text;
          double opacity = 1.0;

          if (feedback != null) {
            if (isExpected) {
              btnColor = AppColors.emerald.withValues(alpha: 0.22);
              borderColor = AppColors.emerald;
              textColor = AppColors.emerald;
            } else if (isChosen && !feedback!.isCorrect) {
              btnColor = AppColors.rose.withValues(alpha: 0.22);
              borderColor = AppColors.rose;
              textColor = AppColors.rose;
            } else {
              opacity = 0.45;
            }
          }

          return BouncingWidget(
            scaleFactor: 0.94,
            onTap: feedback == null ? () => onSelect(romaji) : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: opacity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: btnColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor,
                    width: (isExpected || (isChosen && !feedback!.isCorrect)) ? 2.0 : 1.5,
                  ),
                  boxShadow: (isExpected || (isChosen && !feedback!.isCorrect))
                      ? [
                          BoxShadow(
                            color: (isExpected ? AppColors.emerald : AppColors.rose)
                                .withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  romaji,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TypingModeInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FeedbackState? feedback;
  final ValueChanged<String> onSubmit;
  final ValueChanged<String> onKeyPress;
  final VoidCallback onBackspace;

  const _TypingModeInput({
    required this.controller,
    required this.focusNode,
    required this.feedback,
    required this.onSubmit,
    required this.onKeyPress,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: 'Type romaji...',
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: feedback != null
                      ? (feedback!.isCorrect ? AppColors.emerald : AppColors.rose)
                      : AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: feedback != null
                      ? (feedback!.isCorrect ? AppColors.emerald : AppColors.rose)
                      : AppColors.emerald,
                  width: 2,
                ),
              ),
            ),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                onSubmit(val.trim());
              }
            },
          ),
          const SizedBox(height: 8),
          // Compact Virtual Romaji Keyboard with tactile press buttons
          Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: [
              ...'a,i,u,e,o,k,s,t,n,h,m,y,r,w,g,z,d,b,p,c,j'.split(',').map(
                    (ch) => BouncingWidget(
                      scaleFactor: 0.88,
                      onTap: () {
                        try {
                          HapticFeedback.selectionClick();
                        } catch (_) {}
                        onKeyPress(ch);
                      },
                      child: Container(
                        width: 30,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ch,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
              BouncingWidget(
                scaleFactor: 0.88,
                onTap: () {
                  try {
                    HapticFeedback.selectionClick();
                  } catch (_) {}
                  onBackspace();
                },
                child: Container(
                  width: 38,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.backspace_outlined,
                      size: 14, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
