// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetGameSettingsEntityCollection on Isar {
  IsarCollection<GameSettingsEntity> get gameSettingsEntitys =>
      this.collection();
}

const GameSettingsEntitySchema = CollectionSchema(
  name: r'GameSettingsEntity',
  id: -5599786567106998659,
  properties: {
    r'accentColor': PropertySchema(
      id: 0,
      name: r'accentColor',
      type: IsarType.string,
    ),
    r'autoPlayVoice': PropertySchema(
      id: 1,
      name: r'autoPlayVoice',
      type: IsarType.bool,
    ),
    r'gameMode': PropertySchema(
      id: 2,
      name: r'gameMode',
      type: IsarType.string,
    ),
    r'hapticEnabled': PropertySchema(
      id: 3,
      name: r'hapticEnabled',
      type: IsarType.bool,
    ),
    r'inputMode': PropertySchema(
      id: 4,
      name: r'inputMode',
      type: IsarType.string,
    ),
    r'scriptMode': PropertySchema(
      id: 5,
      name: r'scriptMode',
      type: IsarType.string,
    ),
    r'selectedRows': PropertySchema(
      id: 6,
      name: r'selectedRows',
      type: IsarType.stringList,
    ),
    r'sfxVolume': PropertySchema(
      id: 7,
      name: r'sfxVolume',
      type: IsarType.double,
    ),
    r'showTouchKeyboard': PropertySchema(
      id: 8,
      name: r'showTouchKeyboard',
      type: IsarType.bool,
    ),
    r'soundEnabled': PropertySchema(
      id: 9,
      name: r'soundEnabled',
      type: IsarType.bool,
    ),
    r'sprintDeckSize': PropertySchema(
      id: 10,
      name: r'sprintDeckSize',
      type: IsarType.long,
    ),
    r'themeMode': PropertySchema(
      id: 11,
      name: r'themeMode',
      type: IsarType.string,
    ),
    r'voiceEnabled': PropertySchema(
      id: 12,
      name: r'voiceEnabled',
      type: IsarType.bool,
    ),
    r'voiceSpeed': PropertySchema(
      id: 13,
      name: r'voiceSpeed',
      type: IsarType.double,
    ),
    r'voiceVolume': PropertySchema(
      id: 14,
      name: r'voiceVolume',
      type: IsarType.double,
    ),
  },

  estimateSize: _gameSettingsEntityEstimateSize,
  serialize: _gameSettingsEntitySerialize,
  deserialize: _gameSettingsEntityDeserialize,
  deserializeProp: _gameSettingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _gameSettingsEntityGetId,
  getLinks: _gameSettingsEntityGetLinks,
  attach: _gameSettingsEntityAttach,
  version: '3.4.1',
);

int _gameSettingsEntityEstimateSize(
  GameSettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accentColor.length * 3;
  bytesCount += 3 + object.gameMode.length * 3;
  bytesCount += 3 + object.inputMode.length * 3;
  bytesCount += 3 + object.scriptMode.length * 3;
  bytesCount += 3 + object.selectedRows.length * 3;
  {
    for (var i = 0; i < object.selectedRows.length; i++) {
      final value = object.selectedRows[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.themeMode.length * 3;
  return bytesCount;
}

void _gameSettingsEntitySerialize(
  GameSettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accentColor);
  writer.writeBool(offsets[1], object.autoPlayVoice);
  writer.writeString(offsets[2], object.gameMode);
  writer.writeBool(offsets[3], object.hapticEnabled);
  writer.writeString(offsets[4], object.inputMode);
  writer.writeString(offsets[5], object.scriptMode);
  writer.writeStringList(offsets[6], object.selectedRows);
  writer.writeDouble(offsets[7], object.sfxVolume);
  writer.writeBool(offsets[8], object.showTouchKeyboard);
  writer.writeBool(offsets[9], object.soundEnabled);
  writer.writeLong(offsets[10], object.sprintDeckSize);
  writer.writeString(offsets[11], object.themeMode);
  writer.writeBool(offsets[12], object.voiceEnabled);
  writer.writeDouble(offsets[13], object.voiceSpeed);
  writer.writeDouble(offsets[14], object.voiceVolume);
}

GameSettingsEntity _gameSettingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameSettingsEntity();
  object.accentColor = reader.readString(offsets[0]);
  object.autoPlayVoice = reader.readBool(offsets[1]);
  object.gameMode = reader.readString(offsets[2]);
  object.hapticEnabled = reader.readBool(offsets[3]);
  object.id = id;
  object.inputMode = reader.readString(offsets[4]);
  object.scriptMode = reader.readString(offsets[5]);
  object.selectedRows = reader.readStringList(offsets[6]) ?? [];
  object.sfxVolume = reader.readDouble(offsets[7]);
  object.showTouchKeyboard = reader.readBool(offsets[8]);
  object.soundEnabled = reader.readBool(offsets[9]);
  object.sprintDeckSize = reader.readLong(offsets[10]);
  object.themeMode = reader.readString(offsets[11]);
  object.voiceEnabled = reader.readBool(offsets[12]);
  object.voiceSpeed = reader.readDouble(offsets[13]);
  object.voiceVolume = reader.readDouble(offsets[14]);
  return object;
}

P _gameSettingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gameSettingsEntityGetId(GameSettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameSettingsEntityGetLinks(
  GameSettingsEntity object,
) {
  return [];
}

void _gameSettingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  GameSettingsEntity object,
) {
  object.id = id;
}

extension GameSettingsEntityQueryWhereSort
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QWhere> {
  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameSettingsEntityQueryWhere
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QWhereClause> {
  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameSettingsEntityQueryFilter
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QFilterCondition> {
  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accentColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accentColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accentColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accentColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accentColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accentColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accentColor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accentColor',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accentColor', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  accentColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accentColor', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  autoPlayVoiceEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoPlayVoice', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'gameMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gameMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gameMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gameMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'gameMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'gameMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'gameMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'gameMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  gameModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'gameMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  hapticEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hapticEnabled', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inputMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'inputMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'inputMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'inputMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'inputMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inputMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  inputModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'inputMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scriptMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scriptMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scriptMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scriptMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scriptMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scriptMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scriptMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scriptMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scriptMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  scriptModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scriptMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'selectedRows',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'selectedRows',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'selectedRows',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'selectedRows',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'selectedRows',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'selectedRows',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'selectedRows',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'selectedRows',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'selectedRows', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'selectedRows', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'selectedRows', length, true, length, true);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'selectedRows', 0, true, 0, true);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'selectedRows', 0, false, 999999, true);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'selectedRows', 0, true, length, include);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'selectedRows', length, include, 999999, true);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  selectedRowsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRows',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sfxVolumeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sfxVolume',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sfxVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sfxVolume',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sfxVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sfxVolume',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sfxVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sfxVolume',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  showTouchKeyboardEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showTouchKeyboard', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  soundEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'soundEnabled', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sprintDeckSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sprintDeckSize', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sprintDeckSizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sprintDeckSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sprintDeckSizeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sprintDeckSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  sprintDeckSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sprintDeckSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themeMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themeMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  themeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themeMode', value: ''),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'voiceEnabled', value: value),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceSpeedEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'voiceSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'voiceSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'voiceSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'voiceSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceVolumeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'voiceVolume',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'voiceVolume',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'voiceVolume',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterFilterCondition>
  voiceVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'voiceVolume',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension GameSettingsEntityQueryObject
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QFilterCondition> {}

extension GameSettingsEntityQueryLinks
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QFilterCondition> {}

extension GameSettingsEntityQuerySortBy
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QSortBy> {
  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByAccentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByAccentColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByAutoPlayVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayVoice', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByAutoPlayVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayVoice', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByGameModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByHapticEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticEnabled', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByHapticEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticEnabled', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByInputMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByInputModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByScriptMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByScriptModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortBySfxVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sfxVolume', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortBySfxVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sfxVolume', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByShowTouchKeyboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showTouchKeyboard', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByShowTouchKeyboardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showTouchKeyboard', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortBySoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortBySoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortBySprintDeckSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprintDeckSize', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortBySprintDeckSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprintDeckSize', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByVoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByVoiceSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceSpeed', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByVoiceSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceSpeed', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByVoiceVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  sortByVoiceVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.desc);
    });
  }
}

extension GameSettingsEntityQuerySortThenBy
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QSortThenBy> {
  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByAccentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByAccentColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByAutoPlayVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayVoice', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByAutoPlayVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPlayVoice', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByGameModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByHapticEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticEnabled', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByHapticEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticEnabled', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByInputMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByInputModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByScriptMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByScriptModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenBySfxVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sfxVolume', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenBySfxVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sfxVolume', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByShowTouchKeyboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showTouchKeyboard', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByShowTouchKeyboardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showTouchKeyboard', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenBySoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenBySoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soundEnabled', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenBySprintDeckSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprintDeckSize', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenBySprintDeckSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sprintDeckSize', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByVoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByVoiceSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceSpeed', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByVoiceSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceSpeed', Sort.desc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByVoiceVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.asc);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QAfterSortBy>
  thenByVoiceVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.desc);
    });
  }
}

extension GameSettingsEntityQueryWhereDistinct
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct> {
  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByAccentColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accentColor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByAutoPlayVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoPlayVoice');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByGameMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByHapticEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hapticEnabled');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByInputMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByScriptMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scriptMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctBySelectedRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedRows');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctBySfxVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sfxVolume');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByShowTouchKeyboard() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showTouchKeyboard');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctBySoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'soundEnabled');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctBySprintDeckSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sprintDeckSize');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByThemeMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voiceEnabled');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByVoiceSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voiceSpeed');
    });
  }

  QueryBuilder<GameSettingsEntity, GameSettingsEntity, QDistinct>
  distinctByVoiceVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voiceVolume');
    });
  }
}

extension GameSettingsEntityQueryProperty
    on QueryBuilder<GameSettingsEntity, GameSettingsEntity, QQueryProperty> {
  QueryBuilder<GameSettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameSettingsEntity, String, QQueryOperations>
  accentColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accentColor');
    });
  }

  QueryBuilder<GameSettingsEntity, bool, QQueryOperations>
  autoPlayVoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoPlayVoice');
    });
  }

  QueryBuilder<GameSettingsEntity, String, QQueryOperations>
  gameModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameMode');
    });
  }

  QueryBuilder<GameSettingsEntity, bool, QQueryOperations>
  hapticEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hapticEnabled');
    });
  }

  QueryBuilder<GameSettingsEntity, String, QQueryOperations>
  inputModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputMode');
    });
  }

  QueryBuilder<GameSettingsEntity, String, QQueryOperations>
  scriptModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scriptMode');
    });
  }

  QueryBuilder<GameSettingsEntity, List<String>, QQueryOperations>
  selectedRowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedRows');
    });
  }

  QueryBuilder<GameSettingsEntity, double, QQueryOperations>
  sfxVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sfxVolume');
    });
  }

  QueryBuilder<GameSettingsEntity, bool, QQueryOperations>
  showTouchKeyboardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showTouchKeyboard');
    });
  }

  QueryBuilder<GameSettingsEntity, bool, QQueryOperations>
  soundEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'soundEnabled');
    });
  }

  QueryBuilder<GameSettingsEntity, int, QQueryOperations>
  sprintDeckSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sprintDeckSize');
    });
  }

  QueryBuilder<GameSettingsEntity, String, QQueryOperations>
  themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }

  QueryBuilder<GameSettingsEntity, bool, QQueryOperations>
  voiceEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voiceEnabled');
    });
  }

  QueryBuilder<GameSettingsEntity, double, QQueryOperations>
  voiceSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voiceSpeed');
    });
  }

  QueryBuilder<GameSettingsEntity, double, QQueryOperations>
  voiceVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voiceVolume');
    });
  }
}
