import 'kana_item.dart';

enum LetterPerformanceTier {
  unseen,
  weak,
  learning,
  strong;

  String get label {
    switch (this) {
      case LetterPerformanceTier.unseen:
        return 'Unseen';
      case LetterPerformanceTier.weak:
        return 'Weak';
      case LetterPerformanceTier.learning:
        return 'Learning';
      case LetterPerformanceTier.strong:
        return 'Strong';
    }
  }
}

class CharacterMastery {
  final int attempts;
  final int correct;
  final int wrong;
  final int streak;
  final int bestStreak;
  final int totalResponseTimeMilliseconds;
  final int? fastestResponseTimeMilliseconds;
  final String? lastPracticedIso;
  final int hiraganaAttempts;
  final int hiraganaCorrect;
  final int katakanaAttempts;
  final int katakanaCorrect;
  final Map<String, int> confusedWith;
  final bool wasWeak;

  const CharacterMastery({
    this.attempts = 0,
    this.correct = 0,
    this.wrong = 0,
    this.streak = 0,
    this.bestStreak = 0,
    this.totalResponseTimeMilliseconds = 0,
    this.fastestResponseTimeMilliseconds,
    this.lastPracticedIso,
    this.hiraganaAttempts = 0,
    this.hiraganaCorrect = 0,
    this.katakanaAttempts = 0,
    this.katakanaCorrect = 0,
    this.confusedWith = const {},
    this.wasWeak = false,
  });

  Map<String, dynamic> toJson() => {
        'attempts': attempts,
        'correct': correct,
        'wrong': wrong,
        'streak': streak,
        'bestStreak': bestStreak,
        'totalResponseTimeMilliseconds': totalResponseTimeMilliseconds,
        'fastestResponseTimeMilliseconds': fastestResponseTimeMilliseconds,
        'lastPracticedIso': lastPracticedIso,
        'hiraganaAttempts': hiraganaAttempts,
        'hiraganaCorrect': hiraganaCorrect,
        'katakanaAttempts': katakanaAttempts,
        'katakanaCorrect': katakanaCorrect,
        'confusedWith': confusedWith,
        'wasWeak': wasWeak,
      };

  factory CharacterMastery.fromJson(Map<String, dynamic> json) {
    final rawConfused = json['confusedWith'];
    final Map<String, int> confused = {};
    if (rawConfused is Map) {
      for (final entry in rawConfused.entries) {
        confused[entry.key.toString()] = (entry.value as num).toInt();
      }
    }

    final attempts = (json['attempts'] as num?)?.toInt() ?? 0;
    final correct = (json['correct'] as num?)?.toInt() ?? 0;
    final wrong = (json['wrong'] as num?)?.toInt() ?? (attempts - correct).clamp(0, 999999);

    return CharacterMastery(
      attempts: attempts,
      correct: correct,
      wrong: wrong,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      totalResponseTimeMilliseconds:
          (json['totalResponseTimeMilliseconds'] as num?)?.toInt() ?? 0,
      fastestResponseTimeMilliseconds:
          (json['fastestResponseTimeMilliseconds'] as num?)?.toInt(),
      lastPracticedIso: json['lastPracticedIso']?.toString(),
      hiraganaAttempts: (json['hiraganaAttempts'] as num?)?.toInt() ?? 0,
      hiraganaCorrect: (json['hiraganaCorrect'] as num?)?.toInt() ?? 0,
      katakanaAttempts: (json['katakanaAttempts'] as num?)?.toInt() ?? 0,
      katakanaCorrect: (json['katakanaCorrect'] as num?)?.toInt() ?? 0,
      confusedWith: confused,
      wasWeak: json['wasWeak'] as bool? ?? false,
    );
  }
}

class CharacterAttemptPayload {
  final String kanaId;
  final KanaScript script;
  final bool isCorrect;
  final String chosenRomaji;
  final int responseTimeMilliseconds;
  final String? timestampIso;

  const CharacterAttemptPayload({
    required this.kanaId,
    required this.script,
    required this.isCorrect,
    required this.chosenRomaji,
    required this.responseTimeMilliseconds,
    this.timestampIso,
  });
}
