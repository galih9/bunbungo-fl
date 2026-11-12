import 'dart:async';
import 'package:flutter/material.dart';
import '../data/kana_data.dart';
import '../logic/deck_generator.dart';
import '../logic/mastery_analytics.dart';
import '../logic/progression_engine.dart';
import '../models/challenge.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/high_score.dart';
import '../models/kana_item.dart';
import '../models/user_progression.dart';
import '../services/audio_service.dart';
import '../services/persistence_service.dart';
import '../theme/app_theme.dart';
import '../widgets/lobby_deck_customizer.dart';
import '../widgets/lobby_progression_banner.dart';
import '../widgets/playing_stage.dart';
import '../widgets/session_summary_view.dart';

enum ArenaPhase { lobby, playing, summary }

class ArenaScreen extends StatefulWidget {
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
  State<ArenaScreen> createState() => ArenaScreenState();
}

class ArenaScreenState extends State<ArenaScreen> {
  ArenaPhase _phase = ArenaPhase.lobby;
  late StoredGameSettings _settings;
  late UserProgression _progression;
  late Map<String, CharacterMastery> _masteryMap;

  PracticeFocusMode _practiceFocusMode = PracticeFocusMode.standard;

  // Active game session state
  List<FlashcardChallenge> _deck = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _correctCount = 0;
  int _attemptCount = 0;
  DateTime? _cardStartTime;
  DateTime? _sessionStartTime;
  Timer? _countdownTimer;
  int _remainingSeconds = 60;
  FeedbackState? _feedback;
  bool _showHint = false;
  final List<KanaItem> _missedItems = [];
  SessionProgressionResult? _lastSessionResult;

  // Typing inputs
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _loadState() {
    setState(() {
      _settings = widget.persistence.loadGameSettings();
      _progression = widget.persistence.loadUserProgression();
      _masteryMap = widget.persistence.loadMasteryMap();
    });
  }

  void refreshData() {
    _loadState();
  }

  List<KanaItem> get _activePool {
    if (_practiceFocusMode == PracticeFocusMode.weakLetters) {
      final analysis = analyzeKanaPerformance(_masteryMap);
      if (analysis.weakItems.isNotEmpty) return analysis.weakItems;
      if (analysis.learningItems.isNotEmpty) return analysis.learningItems;
    }
    final selSet = Set<String>.from(_settings.selectedRows);
    final pool = kanaItems.where((i) => selSet.contains(i.rowId)).toList();
    return pool.isNotEmpty
        ? pool
        : kanaItems.where((i) => defaultSelectedRows.contains(i.rowId)).toList();
  }

  void _updateSettings(StoredGameSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.persistence.saveGameSettings(newSettings);
  }

  void _toggleRow(String rowId) {
    final list = List<String>.from(_settings.selectedRows);
    if (list.contains(rowId)) {
      if (list.length > 1) list.remove(rowId);
    } else {
      list.add(rowId);
    }
    _updateSettings(_settings.copyWith(selectedRows: list));
  }

  void _selectPreset(RowPreset preset) {
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
    _updateSettings(_settings.copyWith(selectedRows: rows));
  }

  void _toggleUnlockAll() {
    final updated = _progression.copyWith(unlockAllRows: !_progression.unlockAllRows);
    setState(() {
      _progression = updated;
    });
    widget.persistence.saveUserProgression(updated);
    widget.onDataChanged();
  }

  void startSessionWithDeck(List<FlashcardChallenge> deck) {
    if (deck.isEmpty) return;
    _countdownTimer?.cancel();

    setState(() {
      _phase = ArenaPhase.playing;
      _deck = deck;
      _currentIndex = 0;
      _score = 0;
      _streak = 0;
      _bestStreak = 0;
      _correctCount = 0;
      _attemptCount = 0;
      _missedItems.clear();
      _feedback = null;
      _showHint = false;
      _cardStartTime = DateTime.now();
      _sessionStartTime = DateTime.now();
      _textController.clear();
      _remainingSeconds = 60;
    });

    if (_settings.gameMode == GameMode.timeAttack) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          _remainingSeconds -= 1;
        });
        if (_remainingSeconds <= 0) {
          timer.cancel();
          _endSession();
        }
      });
    }

    if (_settings.inputMode == InputMode.typing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _textFocusNode.requestFocus();
      });
    }
  }

  void startStandardSession() {
    final count = _settings.gameMode == GameMode.sprint ? _settings.sprintDeckSize : 30;
    List<FlashcardChallenge> deck;
    if (_practiceFocusMode == PracticeFocusMode.weakLetters) {
      deck = generateWeakLettersDeck(
        _masteryMap,
        _settings.scriptMode,
        count,
        _settings.selectedRows,
      );
    } else {
      deck = generateChallengeDeck(
        _settings.selectedRows,
        _settings.scriptMode,
        count,
        _masteryMap,
      );
    }
    startSessionWithDeck(deck);
  }

  void startCustomSession(List<KanaItem> items) {
    final deck = generateCustomItemsDeck(
      items,
      _settings.scriptMode,
      items.length * 2,
      _masteryMap,
    );
    startSessionWithDeck(deck);
  }

  void _submitAnswer(String submittedRomaji) {
    if (_feedback != null || _currentIndex >= _deck.length) return;

    final currentCard = _deck[_currentIndex];
    final cleanSubmitted = submittedRomaji.trim().toLowerCase();
    final isCorrect = currentCard.item.acceptedRomaji
        .any((acc) => acc.toLowerCase() == cleanSubmitted);

    final now = DateTime.now();
    final responseTime = _cardStartTime != null
        ? now.difference(_cardStartTime!).inMilliseconds
        : 1200;

    _attemptCount += 1;
    if (isCorrect) {
      _correctCount += 1;
      _streak += 1;
      if (_streak > _bestStreak) _bestStreak = _streak;

      final comboMultiplier = (1 + (_streak ~/ 5)).clamp(1, 4);
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
          (_showHint ? 0 : 25) +
          speedBonus +
          redemptionBonus;
      _score += points;

      AudioService.playCorrect(_streak, _settings.soundEnabled);

      _feedback = FeedbackState(
        status: FeedbackStatus.correct,
        pointsEarned: points,
        chosenRomaji: cleanSubmitted,
        expectedRomaji: currentCard.item.romaji,
        isRedemptionCleared: currentCard.isRedemption,
        responseTimeMilliseconds: responseTime,
        speedTier: speedTier,
      );
    } else {
      _streak = 0;
      AudioService.playWrong(_settings.soundEnabled);

      if (!_missedItems.any((i) => i.id == currentCard.item.id)) {
        _missedItems.add(currentCard.item);
      }

      // Schedule spaced redemption
      _deck = scheduleSpacedRetryInDeck(
        _deck,
        _currentIndex,
        currentCard.item,
        _settings.scriptMode,
      );

      _feedback = FeedbackState(
        status: FeedbackStatus.wrong,
        pointsEarned: 0,
        chosenRomaji: cleanSubmitted,
        expectedRomaji: currentCard.item.romaji,
        isRedemptionCleared: false,
        responseTimeMilliseconds: responseTime,
      );
    }

    // Update character mastery
    _masteryMap = updateCharacterMastery(
      _masteryMap,
      CharacterAttemptPayload(
        kanaId: currentCard.item.id,
        script: currentCard.script,
        isCorrect: isCorrect,
        chosenRomaji: cleanSubmitted,
        responseTimeMilliseconds: responseTime,
      ),
    );
    widget.persistence.saveMasteryMap(_masteryMap);

    setState(() {});

    final delay = isCorrect ? 450 : 1200;
    Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      _advanceCard();
    });
  }

  void _advanceCard() {
    if (_currentIndex + 1 >= _deck.length) {
      if (_settings.gameMode == GameMode.zen ||
          _settings.gameMode == GameMode.timeAttack) {
        // In zen or time-attack, append more cards infinitely
        _deck = appendDistinctFlashcardToDeck(
          _deck,
          _activePool,
          _settings.scriptMode,
          _masteryMap,
        );
        _currentIndex += 1;
      } else {
        _endSession();
        return;
      }
    } else {
      _currentIndex += 1;
    }

    setState(() {
      _feedback = null;
      _showHint = false;
      _cardStartTime = DateTime.now();
      _textController.clear();
    });

    if (_settings.inputMode == InputMode.typing) {
      _textFocusNode.requestFocus();
    }
  }

  void _endSession() {
    _countdownTimer?.cancel();
    final duration = _sessionStartTime != null
        ? DateTime.now().difference(_sessionStartTime!).inSeconds
        : 30;

    final result = evaluateSessionProgression(
      sessionScore: _score,
      sessionCorrect: _correctCount,
      sessionAttempts: _attemptCount,
      sessionBestStreak: _bestStreak,
      durationSeconds: duration,
      masteryMap: _masteryMap,
      currentProgression: _progression,
    );

    _progression = result.updatedProgression;
    widget.persistence.saveUserProgression(_progression);

    if (_attemptCount > 0) {
      final accuracy = ((_correctCount / _attemptCount) * 100).round();
      final highScore = HighScoreRecord(
        id: 'hs-${DateTime.now().millisecondsSinceEpoch}',
        gameMode: _settings.gameMode,
        scriptMode: _settings.scriptMode,
        score: _score,
        accuracy: accuracy,
        cardsCleared: _attemptCount,
        durationSeconds: duration,
        dateIso: DateTime.now().toIso8601String(),
      );
      widget.persistence.saveHighScore(highScore);
    }

    AudioService.playVictory(_settings.soundEnabled);

    setState(() {
      _phase = ArenaPhase.summary;
      _lastSessionResult = result;
    });

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
    if (_currentIndex >= _deck.length) return;
    final item = _deck[_currentIndex].item;
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
    final analysis = analyzeKanaPerformance(_masteryMap);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: () {
        switch (_phase) {
          case ArenaPhase.lobby:
            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LobbyProgressionBanner(
                    progression: _progression,
                    analysis: analysis,
                    practiceFocusMode: _practiceFocusMode,
                    onToggleFocusMode: () {
                      setState(() {
                        _practiceFocusMode =
                            _practiceFocusMode == PracticeFocusMode.standard
                                ? PracticeFocusMode.weakLetters
                                : PracticeFocusMode.standard;
                      });
                    },
                    onStartWeakLetters: () {
                      setState(() {
                        _practiceFocusMode = PracticeFocusMode.weakLetters;
                      });
                      startStandardSession();
                    },
                    onOpenAchievements: () => widget.onNavigateTab(3),
                  ),

                  const SizedBox(height: 20),

                  LobbyDeckCustomizer(
                    settings: _settings,
                    progression: _progression,
                    practiceFocusMode: _practiceFocusMode,
                    onUpdateSettings: _updateSettings,
                    onToggleRow: _toggleRow,
                    onSelectPreset: _selectPreset,
                    onToggleUnlockAll: _toggleUnlockAll,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: startStandardSession,
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
                      _practiceFocusMode == PracticeFocusMode.weakLetters
                          ? 'Start Weak Letters Drill (${analysis.weakItems.length} Kana)'
                          : 'Start Bun Bun Go Session (${_activePool.length} Kana)',
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
            if (_currentIndex >= _deck.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: PlayingStage(
                currentCard: _deck[_currentIndex],
                currentIndex: _currentIndex,
                deckLength: _deck.length,
                score: _score,
                streak: _streak,
                remainingSeconds: _remainingSeconds,
                settings: _settings,
                feedback: _feedback,
                showHint: _showHint,
                typedValue: _textController.text,
                textController: _textController,
                textFocusNode: _textFocusNode,
                onSubmitAnswer: _submitAnswer,
                onToggleHint: () {
                  setState(() {
                    _showHint = !_showHint;
                  });
                },
                onEndRun: _endSession,
                onVirtualKeyPress: _onVirtualKeyPress,
                onVirtualBackspace: _onVirtualBackspace,
              ),
            );

          case ArenaPhase.summary:
            final duration = _sessionStartTime != null
                ? DateTime.now().difference(_sessionStartTime!).inSeconds
                : 30;
            final accuracy = _attemptCount > 0
                ? ((_correctCount / _attemptCount) * 100).round()
                : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SessionSummaryView(
                score: _score,
                accuracy: accuracy,
                bestStreak: _bestStreak,
                durationSeconds: duration,
                result: _lastSessionResult,
                missedItems: _missedItems,
                weakCount: analysis.weakItems.length,
                onPlayAgain: startStandardSession,
                onPracticeMissedItems: (items) {
                  startCustomSession(items);
                },
                onPracticeWeakLetters: () {
                  setState(() {
                    _practiceFocusMode = PracticeFocusMode.weakLetters;
                  });
                  startStandardSession();
                },
                onCustomizeDeck: () {
                  setState(() {
                    _phase = ArenaPhase.lobby;
                  });
                },
              ),
            );
        }
      }(),
    );
  }
}
