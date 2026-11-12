// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arena_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ArenaStore on _ArenaStore, Store {
  Computed<FlashcardChallenge?>? _$currentCardComputed;

  @override
  FlashcardChallenge? get currentCard =>
      (_$currentCardComputed ??= Computed<FlashcardChallenge?>(
        () => super.currentCard,
        name: '_ArenaStore.currentCard',
      )).value;
  Computed<bool>? _$isPlayingComputed;

  @override
  bool get isPlaying => (_$isPlayingComputed ??= Computed<bool>(
    () => super.isPlaying,
    name: '_ArenaStore.isPlaying',
  )).value;
  Computed<bool>? _$isSummaryComputed;

  @override
  bool get isSummary => (_$isSummaryComputed ??= Computed<bool>(
    () => super.isSummary,
    name: '_ArenaStore.isSummary',
  )).value;
  Computed<bool>? _$isLobbyComputed;

  @override
  bool get isLobby => (_$isLobbyComputed ??= Computed<bool>(
    () => super.isLobby,
    name: '_ArenaStore.isLobby',
  )).value;
  Computed<int>? _$accuracyComputed;

  @override
  int get accuracy => (_$accuracyComputed ??= Computed<int>(
    () => super.accuracy,
    name: '_ArenaStore.accuracy',
  )).value;
  Computed<double>? _$progressRatioComputed;

  @override
  double get progressRatio => (_$progressRatioComputed ??= Computed<double>(
    () => super.progressRatio,
    name: '_ArenaStore.progressRatio',
  )).value;

  late final _$phaseAtom = Atom(name: '_ArenaStore.phase', context: context);

  @override
  ArenaPhase get phase {
    _$phaseAtom.reportRead();
    return super.phase;
  }

  @override
  set phase(ArenaPhase value) {
    _$phaseAtom.reportWrite(value, super.phase, () {
      super.phase = value;
    });
  }

  late final _$practiceFocusModeAtom = Atom(
    name: '_ArenaStore.practiceFocusMode',
    context: context,
  );

  @override
  PracticeFocusMode get practiceFocusMode {
    _$practiceFocusModeAtom.reportRead();
    return super.practiceFocusMode;
  }

  @override
  set practiceFocusMode(PracticeFocusMode value) {
    _$practiceFocusModeAtom.reportWrite(value, super.practiceFocusMode, () {
      super.practiceFocusMode = value;
    });
  }

  late final _$deckAtom = Atom(name: '_ArenaStore.deck', context: context);

  @override
  ObservableList<FlashcardChallenge> get deck {
    _$deckAtom.reportRead();
    return super.deck;
  }

  @override
  set deck(ObservableList<FlashcardChallenge> value) {
    _$deckAtom.reportWrite(value, super.deck, () {
      super.deck = value;
    });
  }

  late final _$currentIndexAtom = Atom(
    name: '_ArenaStore.currentIndex',
    context: context,
  );

  @override
  int get currentIndex {
    _$currentIndexAtom.reportRead();
    return super.currentIndex;
  }

  @override
  set currentIndex(int value) {
    _$currentIndexAtom.reportWrite(value, super.currentIndex, () {
      super.currentIndex = value;
    });
  }

  late final _$scoreAtom = Atom(name: '_ArenaStore.score', context: context);

  @override
  int get score {
    _$scoreAtom.reportRead();
    return super.score;
  }

  @override
  set score(int value) {
    _$scoreAtom.reportWrite(value, super.score, () {
      super.score = value;
    });
  }

  late final _$streakAtom = Atom(name: '_ArenaStore.streak', context: context);

  @override
  int get streak {
    _$streakAtom.reportRead();
    return super.streak;
  }

  @override
  set streak(int value) {
    _$streakAtom.reportWrite(value, super.streak, () {
      super.streak = value;
    });
  }

  late final _$bestStreakAtom = Atom(
    name: '_ArenaStore.bestStreak',
    context: context,
  );

  @override
  int get bestStreak {
    _$bestStreakAtom.reportRead();
    return super.bestStreak;
  }

  @override
  set bestStreak(int value) {
    _$bestStreakAtom.reportWrite(value, super.bestStreak, () {
      super.bestStreak = value;
    });
  }

  late final _$correctCountAtom = Atom(
    name: '_ArenaStore.correctCount',
    context: context,
  );

  @override
  int get correctCount {
    _$correctCountAtom.reportRead();
    return super.correctCount;
  }

  @override
  set correctCount(int value) {
    _$correctCountAtom.reportWrite(value, super.correctCount, () {
      super.correctCount = value;
    });
  }

  late final _$attemptCountAtom = Atom(
    name: '_ArenaStore.attemptCount',
    context: context,
  );

  @override
  int get attemptCount {
    _$attemptCountAtom.reportRead();
    return super.attemptCount;
  }

  @override
  set attemptCount(int value) {
    _$attemptCountAtom.reportWrite(value, super.attemptCount, () {
      super.attemptCount = value;
    });
  }

  late final _$remainingSecondsAtom = Atom(
    name: '_ArenaStore.remainingSeconds',
    context: context,
  );

  @override
  int get remainingSeconds {
    _$remainingSecondsAtom.reportRead();
    return super.remainingSeconds;
  }

  @override
  set remainingSeconds(int value) {
    _$remainingSecondsAtom.reportWrite(value, super.remainingSeconds, () {
      super.remainingSeconds = value;
    });
  }

  late final _$feedbackAtom = Atom(
    name: '_ArenaStore.feedback',
    context: context,
  );

  @override
  FeedbackState? get feedback {
    _$feedbackAtom.reportRead();
    return super.feedback;
  }

  @override
  set feedback(FeedbackState? value) {
    _$feedbackAtom.reportWrite(value, super.feedback, () {
      super.feedback = value;
    });
  }

  late final _$showHintAtom = Atom(
    name: '_ArenaStore.showHint',
    context: context,
  );

  @override
  bool get showHint {
    _$showHintAtom.reportRead();
    return super.showHint;
  }

  @override
  set showHint(bool value) {
    _$showHintAtom.reportWrite(value, super.showHint, () {
      super.showHint = value;
    });
  }

  late final _$missedItemsAtom = Atom(
    name: '_ArenaStore.missedItems',
    context: context,
  );

  @override
  ObservableList<KanaItem> get missedItems {
    _$missedItemsAtom.reportRead();
    return super.missedItems;
  }

  @override
  set missedItems(ObservableList<KanaItem> value) {
    _$missedItemsAtom.reportWrite(value, super.missedItems, () {
      super.missedItems = value;
    });
  }

  late final _$lastSessionResultAtom = Atom(
    name: '_ArenaStore.lastSessionResult',
    context: context,
  );

  @override
  SessionProgressionResult? get lastSessionResult {
    _$lastSessionResultAtom.reportRead();
    return super.lastSessionResult;
  }

  @override
  set lastSessionResult(SessionProgressionResult? value) {
    _$lastSessionResultAtom.reportWrite(value, super.lastSessionResult, () {
      super.lastSessionResult = value;
    });
  }

  late final _$_ArenaStoreActionController = ActionController(
    name: '_ArenaStore',
    context: context,
  );

  @override
  void setPhase(ArenaPhase newPhase) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.setPhase',
    );
    try {
      return super.setPhase(newPhase);
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPracticeFocusMode(PracticeFocusMode mode) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.setPracticeFocusMode',
    );
    try {
      return super.setPracticeFocusMode(mode);
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleHint() {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.toggleHint',
    );
    try {
      return super.toggleHint();
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startSession(List<FlashcardChallenge> newDeck) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.startSession',
    );
    try {
      return super.startSession(newDeck);
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementTimer() {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.decrementTimer',
    );
    try {
      return super.decrementTimer();
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void recordCorrect({
    required int points,
    required String chosenRomaji,
    required String expectedRomaji,
    required bool isRedemption,
    required int responseTime,
    required SpeedTier speedTier,
  }) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.recordCorrect',
    );
    try {
      return super.recordCorrect(
        points: points,
        chosenRomaji: chosenRomaji,
        expectedRomaji: expectedRomaji,
        isRedemption: isRedemption,
        responseTime: responseTime,
        speedTier: speedTier,
      );
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void recordWrong({
    required KanaItem item,
    required String chosenRomaji,
    required String expectedRomaji,
    required int responseTime,
    required ScriptSelection scriptMode,
  }) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.recordWrong',
    );
    try {
      return super.recordWrong(
        item: item,
        chosenRomaji: chosenRomaji,
        expectedRomaji: expectedRomaji,
        responseTime: responseTime,
        scriptMode: scriptMode,
      );
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool advanceCard({
    required bool isInfiniteMode,
    required List<KanaItem> activePool,
    required ScriptSelection scriptMode,
    required Map<String, CharacterMastery> masteryMap,
  }) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.advanceCard',
    );
    try {
      return super.advanceCard(
        isInfiniteMode: isInfiniteMode,
        activePool: activePool,
        scriptMode: scriptMode,
        masteryMap: masteryMap,
      );
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void finishSession(SessionProgressionResult result) {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.finishSession',
    );
    try {
      return super.finishSession(result);
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetToLobby() {
    final _$actionInfo = _$_ArenaStoreActionController.startAction(
      name: '_ArenaStore.resetToLobby',
    );
    try {
      return super.resetToLobby();
    } finally {
      _$_ArenaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
phase: ${phase},
practiceFocusMode: ${practiceFocusMode},
deck: ${deck},
currentIndex: ${currentIndex},
score: ${score},
streak: ${streak},
bestStreak: ${bestStreak},
correctCount: ${correctCount},
attemptCount: ${attemptCount},
remainingSeconds: ${remainingSeconds},
feedback: ${feedback},
showHint: ${showHint},
missedItems: ${missedItems},
lastSessionResult: ${lastSessionResult},
currentCard: ${currentCard},
isPlaying: ${isPlaying},
isSummary: ${isSummary},
isLobby: ${isLobby},
accuracy: ${accuracy},
progressRatio: ${progressRatio}
    ''';
  }
}
