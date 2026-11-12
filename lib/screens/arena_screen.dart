import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/kana_data.dart';
import '../logic/arena_store.dart';
import '../logic/deck_generator.dart';
import '../logic/mastery_analytics.dart';
import '../logic/progression_engine.dart';
import '../models/challenge.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/kana_item.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/lobby_deck_customizer.dart';
import '../widgets/playing_stage.dart';
import '../widgets/session_summary_view.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  final PersistenceService persistence;
  final VoidCallback onDataChanged;
  final ValueChanged<int> onNavigateTab;

  const ArenaScreen({
    super.key,
    required this.persistence,
    required this.onDataChanged,
    required this.onNavigateTab,
  });

  @override
  ConsumerState<ArenaScreen> createState() => ArenaScreenState();
}

class ArenaScreenState extends ConsumerState<ArenaScreen> {
  late final ArenaStore _store;
  Timer? _countdownTimer;

  // Typing inputs
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _store = ArenaStore();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void refreshData() {
    // Data is reactively managed by Riverpod providers
    ref.read(gameSettingsProvider.notifier).reload();
    ref.read(userProgressionProvider.notifier).reload();
    ref.read(characterMasteryProvider.notifier).reload();
  }

  void startWeakLettersSession() {
    _store.setPracticeFocusMode(PracticeFocusMode.weakLetters);
    _store.setPhase(ArenaPhase.lobby);
    startStandardSession();
  }

  List<KanaItem> _getActivePool(
    StoredGameSettings settings,
    Map<String, CharacterMastery> masteryMap,
  ) {
    if (_store.practiceFocusMode == PracticeFocusMode.weakLetters) {
      final analysis = analyzeKanaPerformance(masteryMap);
      if (analysis.weakItems.isNotEmpty) return analysis.weakItems;
      if (analysis.learningItems.isNotEmpty) return analysis.learningItems;
    }
    final selSet = Set<String>.from(settings.selectedRows);
    final pool = kanaItems.where((i) => selSet.contains(i.rowId)).toList();
    return pool.isNotEmpty
        ? pool
        : kanaItems.where((i) => defaultSelectedRows.contains(i.rowId)).toList();
  }

  void _updateSettings(StoredGameSettings newSettings) {
    ref.read(gameSettingsProvider.notifier).updateSettings(newSettings);
  }

  void _toggleRow(StoredGameSettings settings, String rowId) {
    final list = List<String>.from(settings.selectedRows);
    if (list.contains(rowId)) {
      if (list.length > 1) list.remove(rowId);
    } else {
      list.add(rowId);
    }
    _updateSettings(settings.copyWith(selectedRows: list));
  }

  void _selectPreset(StoredGameSettings settings, RowPreset preset) {
    List<String> rows;
    switch (preset) {
      case RowPreset.starter:
        rows = ['row-a', 'row-ka', 'row-sa'];
        break;
      case RowPreset.basic:
        rows = kanaRowGroups
            .where((g) => g.category == KanaCategory.monograph)
            .map((g) => g.id)
            .toList();
        break;
      case RowPreset.dakuten:
        rows = kanaRowGroups
            .where((g) => g.category == KanaCategory.diacritic)
            .map((g) => g.id)
            .toList();
        break;
      case RowPreset.digraph:
        rows = kanaRowGroups
            .where((g) => g.category == KanaCategory.digraph)
            .map((g) => g.id)
            .toList();
        break;
      case RowPreset.all:
        rows = kanaRowGroups.map((g) => g.id).toList();
        break;
    }
    _updateSettings(settings.copyWith(selectedRows: rows));
  }

  void _toggleUnlockAll() {
    ref.read(userProgressionProvider.notifier).toggleUnlockAll();
    widget.onDataChanged();
  }

  void startSessionWithDeck(
    List<FlashcardChallenge> deck,
    StoredGameSettings settings,
  ) {
    if (deck.isEmpty) return;
    _countdownTimer?.cancel();
    _textController.clear();

    _store.startSession(deck);

    if (settings.gameMode == GameMode.timeAttack) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _store.decrementTimer();
        if (_store.remainingSeconds <= 0) {
          timer.cancel();
          _endSession();
        }
      });
    }

    if (settings.inputMode == InputMode.typing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _textFocusNode.requestFocus();
      });
    }
  }

  void startStandardSession() {
    final settings = ref.read(gameSettingsProvider);
    final masteryMap = ref.read(characterMasteryProvider);
    final count = settings.gameMode == GameMode.sprint ? settings.sprintDeckSize : 30;

    List<FlashcardChallenge> deck;
    if (_store.practiceFocusMode == PracticeFocusMode.weakLetters) {
      deck = generateWeakLettersDeck(
        masteryMap,
        settings.scriptMode,
        count,
        settings.selectedRows,
      );
    } else {
      deck = generateChallengeDeck(
        settings.selectedRows,
        settings.scriptMode,
        count,
        masteryMap,
      );
    }
    startSessionWithDeck(deck, settings);
  }

  void startCustomSession(List<KanaItem> items) {
    final settings = ref.read(gameSettingsProvider);
    final masteryMap = ref.read(characterMasteryProvider);
    final deck = generateCustomItemsDeck(
      items,
      settings.scriptMode,
      items.length * 2,
      masteryMap,
    );
    startSessionWithDeck(deck, settings);
  }

  void _submitAnswer(String submittedRomaji) {
    if (_store.feedback != null || _store.currentIndex >= _store.deck.length) return;

    final currentCard = _store.deck[_store.currentIndex];
    final cleanSubmitted = submittedRomaji.trim().toLowerCase();
    final isCorrect = currentCard.item.acceptedRomaji
        .any((acc) => acc.toLowerCase() == cleanSubmitted);

    final now = DateTime.now();
    final responseTime = _store.cardStartTime != null
        ? now.difference(_store.cardStartTime!).inMilliseconds
        : 1200;

    final settings = ref.read(gameSettingsProvider);

    if (isCorrect) {
      final currentStreak = _store.streak + 1;
      final comboMultiplier = (1 + (currentStreak ~/ 5)).clamp(1, 4);
      SpeedTier speedTier = SpeedTier.steady;
      int speedBonus = 0;
      if (responseTime <= 1200) {
        speedTier = SpeedTier.instant;
        speedBonus = 50;
      } else if (responseTime <= 2000) {
        speedTier = SpeedTier.fast;
        speedBonus = 25;
      }

      final redemptionBonus = currentCard.isRedemption ? 50 : 0;
      final points = 100 * comboMultiplier +
          (_store.showHint ? 0 : 25) +
          speedBonus +
          redemptionBonus;

      AudioService.playCorrect(currentStreak, settings.soundEnabled);

      _store.recordCorrect(
        points: points,
        chosenRomaji: cleanSubmitted,
        expectedRomaji: currentCard.item.romaji,
        isRedemption: currentCard.isRedemption,
        responseTime: responseTime,
        speedTier: speedTier,
      );
    } else {
      AudioService.playWrong(settings.soundEnabled);

      _store.recordWrong(
        item: currentCard.item,
        chosenRomaji: cleanSubmitted,
        expectedRomaji: currentCard.item.romaji,
        responseTime: responseTime,
        scriptMode: settings.scriptMode,
      );
    }

    // Persist mastery update through Riverpod notifier to Isar
    ref.read(characterMasteryProvider.notifier).recordAttempt(
      CharacterAttemptPayload(
        kanaId: currentCard.item.id,
        script: currentCard.script,
        isCorrect: isCorrect,
        chosenRomaji: cleanSubmitted,
        responseTimeMilliseconds: responseTime,
      ),
    );

    final delay = isCorrect ? 450 : 1200;
    Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      _advanceCard();
    });
  }

  void _advanceCard() {
    final settings = ref.read(gameSettingsProvider);
    final masteryMap = ref.read(characterMasteryProvider);
    final isInfinite = settings.gameMode == GameMode.zen ||
        settings.gameMode == GameMode.timeAttack;
    final activePool = _getActivePool(settings, masteryMap);

    final hasMore = _store.advanceCard(
      isInfiniteMode: isInfinite,
      activePool: activePool,
      scriptMode: settings.scriptMode,
      masteryMap: masteryMap,
    );

    if (!hasMore) {
      _endSession();
      return;
    }

    _textController.clear();
    if (settings.inputMode == InputMode.typing) {
      _textFocusNode.requestFocus();
    }
  }

  void _endSession() {
    _countdownTimer?.cancel();
    final settings = ref.read(gameSettingsProvider);
    final currentProgression = ref.read(userProgressionProvider);
    final masteryMap = ref.read(characterMasteryProvider);

    final duration = _store.sessionStartTime != null
        ? DateTime.now().difference(_store.sessionStartTime!).inSeconds
        : 30;

    final result = evaluateSessionProgression(
      sessionScore: _store.score,
      sessionCorrect: _store.correctCount,
      sessionAttempts: _store.attemptCount,
      sessionBestStreak: _store.bestStreak,
      durationSeconds: duration,
      masteryMap: masteryMap,
      currentProgression: currentProgression,
    );

    // Persist updated progression to Isar
    ref.read(userProgressionProvider.notifier).applySessionResult(result);

    if (_store.attemptCount > 0) {
      final accuracy = _store.accuracy;
      final highScore = HighScoreRecord(
        id: 'hs-${DateTime.now().millisecondsSinceEpoch}',
        gameMode: settings.gameMode,
        scriptMode: settings.scriptMode,
        score: _store.score,
        accuracy: accuracy,
        cardsCleared: _store.attemptCount,
        durationSeconds: duration,
        dateIso: DateTime.now().toIso8601String(),
      );
      // Persist high score to Isar
      ref.read(highScoresProvider.notifier).addHighScore(highScore);
    }

    AudioService.playVictory(settings.soundEnabled);

    _store.finishSession(result);
    widget.onDataChanged();
  }

  void _onVirtualKeyPress(String ch) {
    _textController.text = _textController.text + ch;
    _checkTypingAutoSubmit(_textController.text);
  }

  void _onVirtualBackspace() {
    if (_textController.text.isNotEmpty) {
      _textController.text =
          _textController.text.substring(0, _textController.text.length - 1);
    }
  }

  void _checkTypingAutoSubmit(String currentText) {
    if (_store.currentIndex >= _store.deck.length) return;
    final item = _store.deck[_store.currentIndex].item;
    final cleaned = currentText.trim().toLowerCase();

    if (item.acceptedRomaji.any((a) => a.toLowerCase() == cleaned)) {
      _submitAnswer(cleaned);
      return;
    }

    final maxLen =
        item.acceptedRomaji.map((a) => a.length).reduce((a, b) => a > b ? a : b);
    final isPrefix =
        item.acceptedRomaji.any((a) => a.toLowerCase().startsWith(cleaned));
    if (cleaned.length >= maxLen && !isPrefix) {
      _submitAnswer(cleaned);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(gameSettingsProvider);
    final progression = ref.watch(userProgressionProvider);
    final masteryMap = ref.watch(characterMasteryProvider);
    final activePool = _getActivePool(settings, masteryMap);
    final analysis = analyzeKanaPerformance(masteryMap);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Observer(
        builder: (_) {
          switch (_store.phase) {
            case ArenaPhase.lobby:
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LobbyDeckCustomizer(
                      settings: settings,
                      progression: progression,
                      onUpdateSettings: _updateSettings,
                      onToggleRow: (rowId) => _toggleRow(settings, rowId),
                      onSelectPreset: (preset) => _selectPreset(settings, preset),
                      onToggleUnlockAll: _toggleUnlockAll,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _store.setPracticeFocusMode(PracticeFocusMode.standard);
                        startStandardSession();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.text,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Start Bun Bun Go Session (${activePool.length} Kana)',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );

            case ArenaPhase.playing:
              if (_store.currentIndex >= _store.deck.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final currentCard = _store.deck[_store.currentIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PlayingStage(
                  currentCard: currentCard,
                  currentIndex: _store.currentIndex,
                  deckLength: _store.deck.length,
                  score: _store.score,
                  streak: _store.streak,
                  remainingSeconds: _store.remainingSeconds,
                  settings: settings,
                  feedback: _store.feedback,
                  showHint: _store.showHint,
                  typedValue: _textController.text,
                  textController: _textController,
                  textFocusNode: _textFocusNode,
                  onSubmitAnswer: _submitAnswer,
                  onToggleHint: _store.toggleHint,
                  onEndRun: _endSession,
                  onVirtualKeyPress: _onVirtualKeyPress,
                  onVirtualBackspace: _onVirtualBackspace,
                ),
              );

            case ArenaPhase.summary:
              final duration = _store.sessionStartTime != null
                  ? DateTime.now().difference(_store.sessionStartTime!).inSeconds
                  : 30;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SessionSummaryView(
                  score: _store.score,
                  accuracy: _store.accuracy,
                  bestStreak: _store.bestStreak,
                  durationSeconds: duration,
                  result: _store.lastSessionResult,
                  missedItems: _store.missedItems.toList(),
                  weakCount: analysis.weakItems.length,
                  onPlayAgain: startStandardSession,
                  onPracticeMissedItems: (items) {
                    startCustomSession(items);
                  },
                  onPracticeWeakLetters: () {
                    _store.setPracticeFocusMode(PracticeFocusMode.weakLetters);
                    startStandardSession();
                  },
                  onCustomizeDeck: _store.resetToLobby,
                ),
              );
          }
        },
      ),
    );
  }
}
