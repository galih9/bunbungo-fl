import 'package:isar_community/isar.dart';
import '../../models/game_settings.dart';
import '../../models/high_score.dart';

part 'high_score_entity.g.dart';

@collection
class HighScoreEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String recordId;

  late String gameMode;
  late String scriptMode;

  @Index()
  late int score;

  late int accuracy;
  late int cardsCleared;
  late int durationSeconds;

  @Index()
  late String dateIso;

  HighScoreRecord toModel() {
    GameMode parseGameMode(String val) {
      if (val == 'timeAttack' || val == 'time-attack') return GameMode.timeAttack;
      if (val == 'zen') return GameMode.zen;
      return GameMode.sprint;
    }

    ScriptSelection parseScript(String val) {
      for (final s in ScriptSelection.values) {
        if (s.name == val) return s;
      }
      return ScriptSelection.hiragana;
    }

    return HighScoreRecord(
      id: recordId,
      gameMode: parseGameMode(gameMode),
      scriptMode: parseScript(scriptMode),
      score: score,
      accuracy: accuracy,
      cardsCleared: cardsCleared,
      durationSeconds: durationSeconds,
      dateIso: dateIso,
    );
  }

  static HighScoreEntity fromModel(HighScoreRecord model) {
    final entity = HighScoreEntity();
    entity.recordId = model.id;
    entity.gameMode = model.gameMode.name;
    entity.scriptMode = model.scriptMode.name;
    entity.score = model.score;
    entity.accuracy = model.accuracy;
    entity.cardsCleared = model.cardsCleared;
    entity.durationSeconds = model.durationSeconds;
    entity.dateIso = model.dateIso;
    return entity;
  }
}
