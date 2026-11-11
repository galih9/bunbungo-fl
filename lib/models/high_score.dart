import 'game_settings.dart';

class HighScoreRecord {
  final String id;
  final GameMode gameMode;
  final ScriptSelection scriptMode;
  final int score;
  final int accuracy;
  final int cardsCleared;
  final int durationSeconds;
  final String dateIso;

  const HighScoreRecord({
    required this.id,
    required this.gameMode,
    required this.scriptMode,
    required this.score,
    required this.accuracy,
    required this.cardsCleared,
    required this.durationSeconds,
    required this.dateIso,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameMode': gameMode.name,
        'scriptMode': scriptMode.name,
        'score': score,
        'accuracy': accuracy,
        'cardsCleared': cardsCleared,
        'durationSeconds': durationSeconds,
        'dateIso': dateIso,
      };

  factory HighScoreRecord.fromJson(Map<String, dynamic> json) {
    GameMode parseGameMode(String? val) {
      if (val == 'timeAttack' || val == 'time-attack') return GameMode.timeAttack;
      if (val == 'zen') return GameMode.zen;
      return GameMode.sprint;
    }

    ScriptSelection parseScript(String? val) {
      for (final s in ScriptSelection.values) {
        if (s.name == val) return s;
      }
      return ScriptSelection.hiragana;
    }

    return HighScoreRecord(
      id: json['id']?.toString() ?? '',
      gameMode: parseGameMode(json['gameMode']?.toString()),
      scriptMode: parseScript(json['scriptMode']?.toString()),
      score: (json['score'] as num?)?.toInt() ?? 0,
      accuracy: (json['accuracy'] as num?)?.toInt() ?? 0,
      cardsCleared: (json['cardsCleared'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      dateIso: json['dateIso']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}
