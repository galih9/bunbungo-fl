// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'high_score_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetHighScoreEntityCollection on Isar {
  IsarCollection<HighScoreEntity> get highScoreEntitys => this.collection();
}

const HighScoreEntitySchema = CollectionSchema(
  name: r'HighScoreEntity',
  id: -7590614470484378090,
  properties: {
    r'accuracy': PropertySchema(id: 0, name: r'accuracy', type: IsarType.long),
    r'cardsCleared': PropertySchema(
      id: 1,
      name: r'cardsCleared',
      type: IsarType.long,
    ),
    r'dateIso': PropertySchema(id: 2, name: r'dateIso', type: IsarType.string),
    r'durationSeconds': PropertySchema(
      id: 3,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'gameMode': PropertySchema(
      id: 4,
      name: r'gameMode',
      type: IsarType.string,
    ),
    r'recordId': PropertySchema(
      id: 5,
      name: r'recordId',
      type: IsarType.string,
    ),
    r'score': PropertySchema(id: 6, name: r'score', type: IsarType.long),
    r'scriptMode': PropertySchema(
      id: 7,
      name: r'scriptMode',
      type: IsarType.string,
    ),
  },

  estimateSize: _highScoreEntityEstimateSize,
  serialize: _highScoreEntitySerialize,
  deserialize: _highScoreEntityDeserialize,
  deserializeProp: _highScoreEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'recordId': IndexSchema(
      id: 907839981883940929,
      name: r'recordId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'recordId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'score': IndexSchema(
      id: -359542572601593437,
      name: r'score',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'score',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'dateIso': IndexSchema(
      id: 3899260565642478538,
      name: r'dateIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateIso',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _highScoreEntityGetId,
  getLinks: _highScoreEntityGetLinks,
  attach: _highScoreEntityAttach,
  version: '3.4.1',
);

int _highScoreEntityEstimateSize(
  HighScoreEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dateIso.length * 3;
  bytesCount += 3 + object.gameMode.length * 3;
  bytesCount += 3 + object.recordId.length * 3;
  bytesCount += 3 + object.scriptMode.length * 3;
  return bytesCount;
}

void _highScoreEntitySerialize(
  HighScoreEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accuracy);
  writer.writeLong(offsets[1], object.cardsCleared);
  writer.writeString(offsets[2], object.dateIso);
  writer.writeLong(offsets[3], object.durationSeconds);
  writer.writeString(offsets[4], object.gameMode);
  writer.writeString(offsets[5], object.recordId);
  writer.writeLong(offsets[6], object.score);
  writer.writeString(offsets[7], object.scriptMode);
}

HighScoreEntity _highScoreEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HighScoreEntity();
  object.accuracy = reader.readLong(offsets[0]);
  object.cardsCleared = reader.readLong(offsets[1]);
  object.dateIso = reader.readString(offsets[2]);
  object.durationSeconds = reader.readLong(offsets[3]);
  object.gameMode = reader.readString(offsets[4]);
  object.id = id;
  object.recordId = reader.readString(offsets[5]);
  object.score = reader.readLong(offsets[6]);
  object.scriptMode = reader.readString(offsets[7]);
  return object;
}

P _highScoreEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _highScoreEntityGetId(HighScoreEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _highScoreEntityGetLinks(HighScoreEntity object) {
  return [];
}

void _highScoreEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  HighScoreEntity object,
) {
  object.id = id;
}

extension HighScoreEntityQueryWhereSort
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QWhere> {
  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhere> anyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'score'),
      );
    });
  }
}

extension HighScoreEntityQueryWhere
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QWhereClause> {
  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  recordIdEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'recordId', value: [recordId]),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  recordIdNotEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [],
                upper: [recordId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [recordId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [recordId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [],
                upper: [recordId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  scoreEqualTo(int score) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'score', value: [score]),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  scoreNotEqualTo(int score) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'score',
                lower: [],
                upper: [score],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'score',
                lower: [score],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'score',
                lower: [score],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'score',
                lower: [],
                upper: [score],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  scoreGreaterThan(int score, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'score',
          lower: [score],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  scoreLessThan(int score, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'score',
          lower: [],
          upper: [score],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  scoreBetween(
    int lowerScore,
    int upperScore, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'score',
          lower: [lowerScore],
          includeLower: includeLower,
          upper: [upperScore],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  dateIsoEqualTo(String dateIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateIso', value: [dateIso]),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterWhereClause>
  dateIsoNotEqualTo(String dateIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateIso',
                lower: [],
                upper: [dateIso],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateIso',
                lower: [dateIso],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateIso',
                lower: [dateIso],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateIso',
                lower: [],
                upper: [dateIso],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension HighScoreEntityQueryFilter
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QFilterCondition> {
  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  accuracyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accuracy', value: value),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  accuracyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accuracy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  accuracyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accuracy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  accuracyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accuracy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  cardsClearedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cardsCleared', value: value),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  cardsClearedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cardsCleared',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  cardsClearedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cardsCleared',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  cardsClearedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cardsCleared',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateIso',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dateIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dateIso',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateIso', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  dateIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dateIso', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationSeconds', value: value),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  durationSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  durationSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  gameModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameMode', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  gameModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'gameMode', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recordId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recordId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'score', value: value),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  scoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  scoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
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

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  scriptModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scriptMode', value: ''),
      );
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterFilterCondition>
  scriptModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scriptMode', value: ''),
      );
    });
  }
}

extension HighScoreEntityQueryObject
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QFilterCondition> {}

extension HighScoreEntityQueryLinks
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QFilterCondition> {}

extension HighScoreEntityQuerySortBy
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QSortBy> {
  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByCardsCleared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsCleared', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByCardsClearedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsCleared', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy> sortByDateIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateIso', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByDateIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateIso', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByGameModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByScriptMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  sortByScriptModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.desc);
    });
  }
}

extension HighScoreEntityQuerySortThenBy
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QSortThenBy> {
  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByCardsCleared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsCleared', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByCardsClearedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardsCleared', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy> thenByDateIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateIso', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByDateIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateIso', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByGameModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByScriptMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.asc);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QAfterSortBy>
  thenByScriptModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scriptMode', Sort.desc);
    });
  }
}

extension HighScoreEntityQueryWhereDistinct
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct> {
  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct>
  distinctByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accuracy');
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct>
  distinctByCardsCleared() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardsCleared');
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct> distinctByDateIso({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct>
  distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct> distinctByGameMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct> distinctByRecordId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<HighScoreEntity, HighScoreEntity, QDistinct>
  distinctByScriptMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scriptMode', caseSensitive: caseSensitive);
    });
  }
}

extension HighScoreEntityQueryProperty
    on QueryBuilder<HighScoreEntity, HighScoreEntity, QQueryProperty> {
  QueryBuilder<HighScoreEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HighScoreEntity, int, QQueryOperations> accuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accuracy');
    });
  }

  QueryBuilder<HighScoreEntity, int, QQueryOperations> cardsClearedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardsCleared');
    });
  }

  QueryBuilder<HighScoreEntity, String, QQueryOperations> dateIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateIso');
    });
  }

  QueryBuilder<HighScoreEntity, int, QQueryOperations>
  durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<HighScoreEntity, String, QQueryOperations> gameModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameMode');
    });
  }

  QueryBuilder<HighScoreEntity, String, QQueryOperations> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }

  QueryBuilder<HighScoreEntity, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<HighScoreEntity, String, QQueryOperations> scriptModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scriptMode');
    });
  }
}
