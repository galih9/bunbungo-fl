import 'dart:math';
import '../data/kana_data.dart';
import '../models/challenge.dart';
import '../models/character_mastery.dart';
import '../models/game_settings.dart';
import '../models/kana_item.dart';
import 'mastery_analytics.dart';

final Random _random = Random();

List<T> _shuffle<T>(List<T> items) {
  final list = List<T>.from(items);
  list.shuffle(_random);
  return list;
}

List<String> buildOptionsForItem(KanaItem target, List<KanaItem> pool) {
  final sameCategoryPool = pool
      .where((c) => c.romaji != target.romaji && c.category == target.category)
      .toList();
  final categoryItems = kanaItemsByCategory[target.category] ?? kanaItems;
  final fallbackPool =
      categoryItems.where((c) => c.romaji != target.romaji).toList();
  final sourcePool =
      sameCategoryPool.length >= 3 ? sameCategoryPool : fallbackPool;

  final distractorRomajiSet = <String>{};
  final shuffledDistractors = _shuffle(sourcePool);
  for (final candidate in shuffledDistractors) {
    if (distractorRomajiSet.length >= 3) break;
    if (candidate.romaji != target.romaji) {
      distractorRomajiSet.add(candidate.romaji);
    }
  }

  return _shuffle([target.romaji, ...distractorRomajiSet]);
}

FlashcardChallenge createFlashcardChallenge(
  KanaItem item,
  ScriptSelection scriptMode,
  List<KanaItem> pool,
  int sequenceNumber, [
  bool isRedemption = false,
]) {
  final resolvedScript = scriptMode == ScriptSelection.mixed
      ? (_random.nextBool() ? KanaScript.hiragana : KanaScript.katakana)
      : (scriptMode == ScriptSelection.katakana
          ? KanaScript.katakana
          : KanaScript.hiragana);

  final displayCharacter = resolvedScript == KanaScript.hiragana
      ? item.hiragana
      : item.katakana;

  return FlashcardChallenge(
    cardId: '${item.id}-${resolvedScript.name}-$sequenceNumber',
    item: item,
    script: resolvedScript,
    displayCharacter: displayCharacter,
    options: buildOptionsForItem(item, pool),
    isRedemption: isRedemption,
  );
}

bool areSameOrHomophoneKana(KanaItem? a, KanaItem? b) {
  if (a == null || b == null) return false;
  return a.id == b.id ||
      a.romaji == b.romaji ||
      a.hiragana == b.hiragana ||
      a.katakana == b.katakana;
}

({List<KanaItem> expandedPool, Set<String> primaryIds})
    _ensureMinimumDistinctPool(
  List<KanaItem> targetItems,
  Map<String, CharacterMastery> masteryMap, [
  List<String> fallbackRowIds = defaultSelectedRows,
]) {
  final primaryIds = <String>{};
  final expandedPool = <KanaItem>[];
  final distinctRomajiSet = <String>{};

  for (final item in targetItems) {
    primaryIds.add(item.id);
    if (!expandedPool.any((e) => e.id == item.id)) {
      expandedPool.add(item);
      distinctRomajiSet.add(item.romaji);
    }
  }

  if (distinctRomajiSet.length < 5) {
    final analysis = analyzeKanaPerformance(masteryMap);
    final fallbackRowSet = Set<String>.from(fallbackRowIds);
    final defaultRowSet = Set<String>.from(defaultSelectedRows);

    final candidateSupplements = [
      ...analysis.weakItems,
      ...analysis.learningItems,
      ...kanaItems.where((i) => fallbackRowSet.contains(i.rowId)),
      ...kanaItems.where((i) => defaultRowSet.contains(i.rowId)),
      ...kanaItems,
    ];

    for (final candidate in candidateSupplements) {
      if (!expandedPool.any((e) => areSameOrHomophoneKana(e, candidate))) {
        expandedPool.add(candidate);
        distinctRomajiSet.add(candidate.romaji);
      }
      if (distinctRomajiSet.length >= 5) break;
    }
  }

  return (expandedPool: expandedPool, primaryIds: primaryIds);
}

KanaItem pickNextDistinctKanaItem(
  List<KanaItem> pool,
  Map<String, CharacterMastery> masteryMap, [
  KanaItem? previousItem,
  KanaItem? secondPreviousItem,
  Set<String>? priorityIds,
]) {
  final ensured = _ensureMinimumDistinctPool(pool, masteryMap);
  final expandedPool = ensured.expandedPool;

  final weightedPool = <KanaItem>[];
  for (final item in expandedPool) {
    final stats = masteryMap[item.id];
    final tier = getCharacterPerformanceTier(stats);
    int weight = 2;
    if (tier == LetterPerformanceTier.weak) {
      weight = 5;
    } else if (tier == LetterPerformanceTier.learning ||
        tier == LetterPerformanceTier.unseen) {
      weight = 3;
    } else {
      weight = 1;
    }
    if (priorityIds?.contains(item.id) ?? false) {
      weight += 3;
    }
    for (int r = 0; r < weight; r++) {
      weightedPool.add(item);
    }
  }

  final nonRepeatingPrevious = weightedPool
      .where((c) => !areSameOrHomophoneKana(c, previousItem))
      .toList();
  final nonRepeatingWindow = nonRepeatingPrevious
      .where((c) => !areSameOrHomophoneKana(c, secondPreviousItem))
      .toList();

  final activeCandidates = nonRepeatingWindow.isNotEmpty
      ? nonRepeatingWindow
      : (nonRepeatingPrevious.isNotEmpty
          ? nonRepeatingPrevious
          : expandedPool
              .where((c) => !areSameOrHomophoneKana(c, previousItem))
              .toList());

  if (activeCandidates.isNotEmpty) {
    return activeCandidates[_random.nextInt(activeCandidates.length)];
  }

  return kanaItems.firstWhere(
    (c) => !areSameOrHomophoneKana(c, previousItem),
    orElse: () => kanaItems.first,
  );
}

List<FlashcardChallenge> appendDistinctFlashcardToDeck(
  List<FlashcardChallenge> currentDeck,
  List<KanaItem> sourcePool,
  ScriptSelection scriptMode,
  Map<String, CharacterMastery> masteryMap,
) {
  final lastCard = currentDeck.isNotEmpty ? currentDeck.last : null;
  final secondLastCard =
      currentDeck.length >= 2 ? currentDeck[currentDeck.length - 2] : null;

  final nextItem = pickNextDistinctKanaItem(
    sourcePool,
    masteryMap,
    lastCard?.item,
    secondLastCard?.item,
  );

  final nextChallenge = createFlashcardChallenge(
    nextItem,
    scriptMode,
    kanaItems,
    currentDeck.length + 1,
  );

  return [...currentDeck, nextChallenge];
}

List<FlashcardChallenge> scheduleSpacedRetryInDeck(
  List<FlashcardChallenge> currentDeck,
  int currentIndex,
  KanaItem missedItem,
  ScriptSelection scriptMode,
) {
  final upcomingSlice = currentDeck.sublist(
    min(currentIndex + 1, currentDeck.length),
    min(currentIndex + 5, currentDeck.length),
  );
  if (upcomingSlice.any((c) => areSameOrHomophoneKana(c.item, missedItem))) {
    return currentDeck;
  }

  int insertIndex = min(currentDeck.length, currentIndex + 3);
  while (insertIndex <= currentDeck.length) {
    final beforeCard = insertIndex > 0 ? currentDeck[insertIndex - 1] : null;
    final afterCard =
        insertIndex < currentDeck.length ? currentDeck[insertIndex] : null;
    final conflictsWithBefore =
        areSameOrHomophoneKana(beforeCard?.item, missedItem);
    final conflictsWithAfter =
        areSameOrHomophoneKana(afterCard?.item, missedItem);
    if (!conflictsWithBefore && !conflictsWithAfter) {
      break;
    }
    insertIndex += 1;
  }

  if (insertIndex > currentDeck.length) {
    return currentDeck;
  }

  final redemptionCard = createFlashcardChallenge(
    missedItem,
    scriptMode,
    kanaItems,
    currentDeck.length + 100 + currentIndex,
    true,
  );

  return [
    ...currentDeck.sublist(0, insertIndex),
    redemptionCard,
    ...currentDeck.sublist(insertIndex),
  ];
}

List<FlashcardChallenge> generateCustomItemsDeck(
  List<KanaItem> targetItems,
  ScriptSelection scriptMode,
  int count,
  Map<String, CharacterMastery> masteryMap,
) {
  final ensured = _ensureMinimumDistinctPool(targetItems, masteryMap);
  final expandedPool = ensured.expandedPool;
  final primaryIds = ensured.primaryIds;

  final deck = <FlashcardChallenge>[];
  final remainingInitialQueue = _shuffle(expandedPool);
  KanaItem? previousItem;
  KanaItem? secondPreviousItem;

  for (int i = 0; i < count; i++) {
    KanaItem? chosenItem;

    if (remainingInitialQueue.isNotEmpty) {
      final nonConflictingIndex = remainingInitialQueue.indexWhere(
        (c) =>
            !areSameOrHomophoneKana(c, previousItem) &&
            (remainingInitialQueue.length <= 2 ||
                !areSameOrHomophoneKana(c, secondPreviousItem)),
      );
      final fallbackQueueIndex = nonConflictingIndex != -1
          ? nonConflictingIndex
          : remainingInitialQueue
              .indexWhere((c) => !areSameOrHomophoneKana(c, previousItem));

      if (fallbackQueueIndex != -1) {
        chosenItem = remainingInitialQueue.removeAt(fallbackQueueIndex);
      }
    }

    if (chosenItem == null || areSameOrHomophoneKana(chosenItem, previousItem)) {
      chosenItem = pickNextDistinctKanaItem(
        expandedPool,
        masteryMap,
        previousItem,
        secondPreviousItem,
        primaryIds,
      );
    }

    deck.add(createFlashcardChallenge(chosenItem, scriptMode, kanaItems, i));
    secondPreviousItem = previousItem;
    previousItem = chosenItem;
  }

  return deck;
}

List<FlashcardChallenge> generateWeakLettersDeck(
  Map<String, CharacterMastery> masteryMap,
  ScriptSelection scriptMode,
  int count,
  List<String> fallbackSelectedRows,
) {
  final analysis = analyzeKanaPerformance(masteryMap);
  final targetItems = List<KanaItem>.from(analysis.weakItems);

  if (targetItems.length < 4 && analysis.learningItems.isNotEmpty) {
    for (final item in analysis.learningItems) {
      if (!targetItems.any((e) => e.id == item.id)) {
        targetItems.add(item);
      }
      if (targetItems.length >= 8) break;
    }
  }

  if (targetItems.isEmpty) {
    final fallbackRowSet = Set<String>.from(fallbackSelectedRows);
    final fallbackPool =
        kanaItems.where((i) => fallbackRowSet.contains(i.rowId)).toList();
    targetItems.addAll(
      fallbackPool.isNotEmpty
          ? fallbackPool
          : kanaItems
              .where((i) => defaultSelectedRows.contains(i.rowId))
              .toList(),
    );
  }

  return generateCustomItemsDeck(targetItems, scriptMode, count, masteryMap);
}

List<FlashcardChallenge> generateChallengeDeck(
  List<String> selectedRows,
  ScriptSelection scriptMode,
  int count,
  Map<String, CharacterMastery> masteryMap,
) {
  final selectedRowSet = Set<String>.from(selectedRows);
  final filteredPool =
      kanaItems.where((i) => selectedRowSet.contains(i.rowId)).toList();
  final activePool = filteredPool.isNotEmpty
      ? filteredPool
      : kanaItems
          .where((i) => defaultSelectedRows.contains(i.rowId))
          .toList();

  return generateCustomItemsDeck(activePool, scriptMode, count, masteryMap);
}
