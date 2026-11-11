import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../models/game_settings.dart';
import '../models/kana_item.dart';
import '../theme/app_theme.dart';

class PlayingStage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final comboMultiplier = (1 + (streak ~/ 5)).clamp(1, 4);

    return Column(
      children: [
        // Top Arena Status Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Exit Button
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
              tooltip: 'End Run',
              onPressed: onEndRun,
            ),

            // Mode Progress / Timer / Zen
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: settings.gameMode == GameMode.timeAttack &&
                          remainingSeconds <= 10
                      ? AppColors.rose
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    settings.gameMode == GameMode.timeAttack
                        ? Icons.timer_outlined
                        : Icons.filter_none_rounded,
                    size: 14,
                    color: settings.gameMode == GameMode.timeAttack &&
                            remainingSeconds <= 10
                        ? AppColors.rose
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    settings.gameMode == GameMode.sprint
                        ? '${currentIndex + 1} / $deckLength'
                        : settings.gameMode == GameMode.timeAttack
                            ? '${remainingSeconds}s'
                            : 'Card ${currentIndex + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: settings.gameMode == GameMode.timeAttack &&
                              remainingSeconds <= 10
                          ? AppColors.rose
                          : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),

            // Score & Streak
            Row(
              children: [
                if (streak > 1) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.amber.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${streak}x ($comboMultiplier倍)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  '$score pts',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Main Kana Flashcard
        Expanded(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: feedback != null
                      ? (feedback!.isCorrect ? AppColors.emerald : AppColors.rose)
                      : AppColors.border,
                  width: feedback != null ? 2 : 1,
                ),
                boxShadow: feedback != null
                    ? [
                        BoxShadow(
                          color: (feedback!.isCorrect
                                  ? AppColors.emerald
                                  : AppColors.rose)
                              .withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
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
                          currentCard.script == KanaScript.hiragana
                              ? 'HIRAGANA'
                              : 'KATAKANA',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (currentCard.isRedemption) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.amber.withValues(alpha: 0.4)),
                          ),
                          child: const Text(
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

                  const SizedBox(height: 24),

                  // Giant Kana Character
                  Text(
                    currentCard.displayCharacter,
                    style: const TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Hint Text or Button
                  if (showHint)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentCard.item.hint,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    TextButton.icon(
                      onPressed: onToggleHint,
                      icon: const Icon(Icons.lightbulb_outline_rounded,
                          size: 14, color: AppColors.textMuted),
                      label: const Text(
                        'Show Hint (-25 pts)',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),

                  // Feedback Outcome Message
                  if (feedback != null) ...[
                    const SizedBox(height: 14),
                    if (feedback!.isCorrect)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              size: 16, color: AppColors.emerald),
                          const SizedBox(width: 6),
                          Text(
                            '+${feedback!.pointsEarned} pts',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                          if (feedback!.speedTier != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              feedback!.speedTier!.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel_rounded,
                              size: 16, color: AppColors.rose),
                          const SizedBox(width: 6),
                          Text(
                            'Answer: ${feedback!.expectedRomaji}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.rose,
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Bottom Controls: Choice Buttons OR Typing Field
        if (settings.inputMode == InputMode.choice)
          _ChoiceModeGrid(
            options: currentCard.options,
            feedback: feedback,
            onSelect: onSubmitAnswer,
          )
        else
          _TypingModeInput(
            controller: textController,
            focusNode: textFocusNode,
            feedback: feedback,
            onSubmit: onSubmitAnswer,
            onKeyPress: onVirtualKeyPress,
            onBackspace: onVirtualBackspace,
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

          if (feedback != null) {
            if (isExpected) {
              btnColor = AppColors.emerald.withValues(alpha: 0.2);
              borderColor = AppColors.emerald;
              textColor = AppColors.emerald;
            } else if (isChosen && !feedback!.isCorrect) {
              btnColor = AppColors.rose.withValues(alpha: 0.2);
              borderColor = AppColors.rose;
              textColor = AppColors.rose;
            }
          }

          return InkWell(
            onTap: feedback == null ? () => onSelect(romaji) : null,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.5),
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
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: 'Type romaji...',
              hintStyle: const TextStyle(
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
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.emerald, width: 2),
              ),
            ),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                onSubmit(val.trim());
              }
            },
          ),
          const SizedBox(height: 8),
          // Compact Virtual Romaji Keyboard (row of vowels + consonants)
          Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: [
              ...'a,i,u,e,o,k,s,t,n,h,m,y,r,w,g,z,d,b,p,c,j'.split(',').map(
                    (ch) => InkWell(
                      onTap: () => onKeyPress(ch),
                      borderRadius: BorderRadius.circular(6),
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
              InkWell(
                onTap: onBackspace,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 38,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.backspace_outlined,
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
