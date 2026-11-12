import 'package:mobx/mobx.dart';
import '../models/challenge.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/kana_item.dart';
import 'deck_generator.dart';

part 'arena_store.g.dart';

enum ArenaPhase { lobby, playing, summary }

class ArenaStore = _ArenaStore with _$ArenaStore;

abstract class _ArenaStore with Store {
  @observable
  ArenaPhase phase = ArenaPhase.lobby;

  @observable
  PracticeFocusMode practiceFocusMode = PracticeFocusMode.standard;

  @observable
  ObservableList<FlashcardChallenge> deck = ObservableList<FlashcardChallenge>();

  @observable
  int currentIndex = 0;

  @observable
  int score = 0;

  @observable
  int streak = 0;

  @observable
  int bestStreak = 0;

  @observable
  int correctCount = 0;

  @observable
  int attemptCount = 0;

  @observable
  int remainingSeconds = 60;

  @observable
  FeedbackState? feedback;

  @observable
  bool showHint = false;

  @observable
  ObservableList<KanaItem> missedItems = ObservableList<KanaItem>();

  @observable
  SessionProgressionResult? lastSessionResult;

  DateTime? cardStartTime;
  DateTime? sessionStartTime;

  @computed
  FlashcardChallenge? get currentCard =>
      (currentIndex >= 0 && currentIndex < deck.length) ? deck[currentIndex] : null;

  @computed
  bool get isPlaying => phase == ArenaPhase.playing;

  @computed
  bool get isSummary => phase == ArenaPhase.summary;

  @computed
  bool get isLobby => phase == ArenaPhase.lobby;

  @computed
  int get accuracy =>
      attemptCount > 0 ? ((correctCount / attemptCount) * 100).round() : 0;

  @computed
  double get progressRatio =>
      deck.isEmpty ? 0.0 : (currentIndex / deck.length).clamp(0.0, 1.0);

  @action
  void setPhase(ArenaPhase newPhase) {
    phase = newPhase;
  }

  @action
  void setPracticeFocusMode(PracticeFocusMode mode) {
    practiceFocusMode = mode;
  }

  @action
  void toggleHint() {
    showHint = !showHint;
  }

  @action
  void startSession(List<FlashcardChallenge> newDeck) {
    if (newDeck.isEmpty) return;
    phase = ArenaPhase.playing;
    deck.clear();
    deck.addAll(newDeck);
    currentIndex = 0;
    score = 0;
    streak = 0;
    bestStreak = 0;
    correctCount = 0;
    attemptCount = 0;
    missedItems.clear();
    feedback = null;
    showHint = false;
    cardStartTime = DateTime.now();
    sessionStartTime = DateTime.now();
    remainingSeconds = 60;
  }

  @action
  void decrementTimer() {
    if (remainingSeconds > 0) {
      remainingSeconds -= 1;
    }
  }

  @action
  void recordCorrect({
    required int points,
    required String chosenRomaji,
    required String expectedRomaji,
    required bool isRedemption,
    required int responseTime,
    required SpeedTier speedTier,
  }) {
    attemptCount += 1;
    correctCount += 1;
    streak += 1;
    if (streak > bestStreak) {
      bestStreak = streak;
    }
    score += points;

    feedback = FeedbackState(
      status: FeedbackStatus.correct,
      pointsEarned: points,
      chosenRomaji: chosenRomaji,
      expectedRomaji: expectedRomaji,
      isRedemptionCleared: isRedemption,
      responseTimeMilliseconds: responseTime,
      speedTier: speedTier,
    );
  }

  @action
  void recordWrong({
    required KanaItem item,
    required String chosenRomaji,
    required String expectedRomaji,
    required int responseTime,
    required ScriptSelection scriptMode,
  }) {
    attemptCount += 1;
    streak = 0;

    if (!missedItems.any((i) => i.id == item.id)) {
      missedItems.add(item);
    }

    final updated = scheduleSpacedRetryInDeck(
      deck.toList(),
      currentIndex,
      item,
      scriptMode,
    );
    deck.clear();
    deck.addAll(updated);

    feedback = FeedbackState(
      status: FeedbackStatus.wrong,
      pointsEarned: 0,
      chosenRomaji: chosenRomaji,
      expectedRomaji: expectedRomaji,
      isRedemptionCleared: false,
      responseTimeMilliseconds: responseTime,
    );
  }

  @action
  bool advanceCard({
    required bool isInfiniteMode,
    required List<KanaItem> activePool,
    required ScriptSelection scriptMode,
    required Map<String, CharacterMastery> masteryMap,
  }) {
    if (currentIndex + 1 >= deck.length) {
      if (isInfiniteMode) {
        final appended = appendDistinctFlashcardToDeck(
          deck.toList(),
          activePool,
          scriptMode,
          masteryMap,
        );
        deck.clear();
        deck.addAll(appended);
        currentIndex += 1;
      } else {
        return false; // Done! Trigger endSession
      }
    } else {
      currentIndex += 1;
    }

    feedback = null;
    showHint = false;
    cardStartTime = DateTime.now();
    return true;
  }

  @action
  void finishSession(SessionProgressionResult result) {
    phase = ArenaPhase.summary;
    lastSessionResult = result;
  }

  @action
  void resetToLobby() {
    phase = ArenaPhase.lobby;
    feedback = null;
    showHint = false;
  }
}
