enum KanaScript {
  hiragana,
  katakana;

  String get label {
    switch (this) {
      case KanaScript.hiragana:
        return 'Hiragana (あ)';
      case KanaScript.katakana:
        return 'Katakana (ア)';
    }
  }

  String get shortLabel {
    switch (this) {
      case KanaScript.hiragana:
        return 'Hiragana';
      case KanaScript.katakana:
        return 'Katakana';
    }
  }
}

enum KanaCategory {
  monograph,
  diacritic,
  digraph;

  String get label {
    switch (this) {
      case KanaCategory.monograph:
        return 'Monographs (Gojūon)';
      case KanaCategory.diacritic:
        return 'Diacritics (Dakuten)';
      case KanaCategory.digraph:
        return 'Digraphs (Yōon)';
    }
  }

  String get shortLabel {
    switch (this) {
      case KanaCategory.monograph:
        return 'Monographs';
      case KanaCategory.diacritic:
        return 'Diacritics';
      case KanaCategory.digraph:
        return 'Digraphs';
    }
  }
}

class KanaItem {
  final String id;
  final String hiragana;
  final String katakana;
  final String romaji;
  final List<String> acceptedRomaji;
  final String rowId;
  final KanaCategory category;
  final String hint;

  const KanaItem({
    required this.id,
    required this.hiragana,
    required this.katakana,
    required this.romaji,
    required this.acceptedRomaji,
    required this.rowId,
    required this.category,
    required this.hint,
  });

  String getCharacter(KanaScript script) {
    return script == KanaScript.hiragana ? hiragana : katakana;
  }
}

class KanaRowGroup {
  final String id;
  final String label;
  final String sampleHiragana;
  final String sampleKatakana;
  final String romajiSummary;
  final KanaCategory category;

  const KanaRowGroup({
    required this.id,
    required this.label,
    required this.sampleHiragana,
    required this.sampleKatakana,
    required this.romajiSummary,
    required this.category,
  });
}
