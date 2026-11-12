// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_mastery_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetCharacterMasteryEntityCollection on Isar {
  IsarCollection<CharacterMasteryEntity> get characterMasteryEntitys =>
      this.collection();
}

const CharacterMasteryEntitySchema = CollectionSchema(
  name: r'CharacterMasteryEntity',
  id: -8749599494088597025,
  properties: {
    r'attempts': PropertySchema(id: 0, name: r'attempts', type: IsarType.long),
    r'bestStreak': PropertySchema(
      id: 1,
      name: r'bestStreak',
      type: IsarType.long,
    ),
    r'confusedWithJson': PropertySchema(
      id: 2,
      name: r'confusedWithJson',
      type: IsarType.string,
    ),
    r'correct': PropertySchema(id: 3, name: r'correct', type: IsarType.long),
    r'fastestResponseTimeMilliseconds': PropertySchema(
      id: 4,
      name: r'fastestResponseTimeMilliseconds',
      type: IsarType.long,
    ),
    r'hiraganaAttempts': PropertySchema(
      id: 5,
      name: r'hiraganaAttempts',
      type: IsarType.long,
    ),
    r'hiraganaCorrect': PropertySchema(
      id: 6,
      name: r'hiraganaCorrect',
      type: IsarType.long,
    ),
    r'kanaId': PropertySchema(id: 7, name: r'kanaId', type: IsarType.string),
    r'katakanaAttempts': PropertySchema(
      id: 8,
      name: r'katakanaAttempts',
      type: IsarType.long,
    ),
    r'katakanaCorrect': PropertySchema(
      id: 9,
      name: r'katakanaCorrect',
      type: IsarType.long,
    ),
    r'lastPracticedIso': PropertySchema(
      id: 10,
      name: r'lastPracticedIso',
      type: IsarType.string,
    ),
    r'streak': PropertySchema(id: 11, name: r'streak', type: IsarType.long),
    r'totalResponseTimeMilliseconds': PropertySchema(
      id: 12,
      name: r'totalResponseTimeMilliseconds',
      type: IsarType.long,
    ),
    r'wasWeak': PropertySchema(id: 13, name: r'wasWeak', type: IsarType.bool),
    r'wrong': PropertySchema(id: 14, name: r'wrong', type: IsarType.long),
  },

  estimateSize: _characterMasteryEntityEstimateSize,
  serialize: _characterMasteryEntitySerialize,
  deserialize: _characterMasteryEntityDeserialize,
  deserializeProp: _characterMasteryEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'kanaId': IndexSchema(
      id: 7150744454680028273,
      name: r'kanaId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'kanaId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _characterMasteryEntityGetId,
  getLinks: _characterMasteryEntityGetLinks,
  attach: _characterMasteryEntityAttach,
  version: '3.4.1',
);

int _characterMasteryEntityEstimateSize(
  CharacterMasteryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.confusedWithJson.length * 3;
  bytesCount += 3 + object.kanaId.length * 3;
  {
    final value = object.lastPracticedIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _characterMasteryEntitySerialize(
  CharacterMasteryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attempts);
  writer.writeLong(offsets[1], object.bestStreak);
  writer.writeString(offsets[2], object.confusedWithJson);
  writer.writeLong(offsets[3], object.correct);
  writer.writeLong(offsets[4], object.fastestResponseTimeMilliseconds);
  writer.writeLong(offsets[5], object.hiraganaAttempts);
  writer.writeLong(offsets[6], object.hiraganaCorrect);
  writer.writeString(offsets[7], object.kanaId);
  writer.writeLong(offsets[8], object.katakanaAttempts);
  writer.writeLong(offsets[9], object.katakanaCorrect);
  writer.writeString(offsets[10], object.lastPracticedIso);
  writer.writeLong(offsets[11], object.streak);
  writer.writeLong(offsets[12], object.totalResponseTimeMilliseconds);
  writer.writeBool(offsets[13], object.wasWeak);
  writer.writeLong(offsets[14], object.wrong);
}

CharacterMasteryEntity _characterMasteryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CharacterMasteryEntity();
  object.attempts = reader.readLong(offsets[0]);
  object.bestStreak = reader.readLong(offsets[1]);
  object.confusedWithJson = reader.readString(offsets[2]);
  object.correct = reader.readLong(offsets[3]);
  object.fastestResponseTimeMilliseconds = reader.readLongOrNull(offsets[4]);
  object.hiraganaAttempts = reader.readLong(offsets[5]);
  object.hiraganaCorrect = reader.readLong(offsets[6]);
  object.id = id;
  object.kanaId = reader.readString(offsets[7]);
  object.katakanaAttempts = reader.readLong(offsets[8]);
  object.katakanaCorrect = reader.readLong(offsets[9]);
  object.lastPracticedIso = reader.readStringOrNull(offsets[10]);
  object.streak = reader.readLong(offsets[11]);
  object.totalResponseTimeMilliseconds = reader.readLong(offsets[12]);
  object.wasWeak = reader.readBool(offsets[13]);
  object.wrong = reader.readLong(offsets[14]);
  return object;
}

P _characterMasteryEntityDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _characterMasteryEntityGetId(CharacterMasteryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _characterMasteryEntityGetLinks(
  CharacterMasteryEntity object,
) {
  return [];
}

void _characterMasteryEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  CharacterMasteryEntity object,
) {
  object.id = id;
}

extension CharacterMasteryEntityByIndex
    on IsarCollection<CharacterMasteryEntity> {
  Future<CharacterMasteryEntity?> getByKanaId(String kanaId) {
    return getByIndex(r'kanaId', [kanaId]);
  }

  CharacterMasteryEntity? getByKanaIdSync(String kanaId) {
    return getByIndexSync(r'kanaId', [kanaId]);
  }

  Future<bool> deleteByKanaId(String kanaId) {
    return deleteByIndex(r'kanaId', [kanaId]);
  }

  bool deleteByKanaIdSync(String kanaId) {
    return deleteByIndexSync(r'kanaId', [kanaId]);
  }

  Future<List<CharacterMasteryEntity?>> getAllByKanaId(
    List<String> kanaIdValues,
  ) {
    final values = kanaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'kanaId', values);
  }

  List<CharacterMasteryEntity?> getAllByKanaIdSync(List<String> kanaIdValues) {
    final values = kanaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'kanaId', values);
  }

  Future<int> deleteAllByKanaId(List<String> kanaIdValues) {
    final values = kanaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'kanaId', values);
  }

  int deleteAllByKanaIdSync(List<String> kanaIdValues) {
    final values = kanaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'kanaId', values);
  }

  Future<Id> putByKanaId(CharacterMasteryEntity object) {
    return putByIndex(r'kanaId', object);
  }

  Id putByKanaIdSync(CharacterMasteryEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'kanaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKanaId(List<CharacterMasteryEntity> objects) {
    return putAllByIndex(r'kanaId', objects);
  }

  List<Id> putAllByKanaIdSync(
    List<CharacterMasteryEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'kanaId', objects, saveLinks: saveLinks);
  }
}

extension CharacterMasteryEntityQueryWhereSort
    on QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QWhere> {
  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CharacterMasteryEntityQueryWhere
    on
        QueryBuilder<
          CharacterMasteryEntity,
          CharacterMasteryEntity,
          QWhereClause
        > {
  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
  kanaIdEqualTo(String kanaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'kanaId', value: [kanaId]),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterWhereClause
  >
  kanaIdNotEqualTo(String kanaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'kanaId',
                lower: [],
                upper: [kanaId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'kanaId',
                lower: [kanaId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'kanaId',
                lower: [kanaId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'kanaId',
                lower: [],
                upper: [kanaId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CharacterMasteryEntityQueryFilter
    on
        QueryBuilder<
          CharacterMasteryEntity,
          CharacterMasteryEntity,
          QFilterCondition
        > {
  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  attemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'attempts', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  attemptsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'attempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  attemptsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'attempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  attemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'attempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  bestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestStreak', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  bestStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  bestStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  bestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'confusedWithJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'confusedWithJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'confusedWithJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'confusedWithJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'confusedWithJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'confusedWithJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'confusedWithJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'confusedWithJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'confusedWithJson', value: ''),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  confusedWithJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'confusedWithJson', value: ''),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  correctEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'correct', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  correctGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'correct',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  correctLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'correct',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  correctBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'correct',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  fastestResponseTimeMillisecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'fastestResponseTimeMilliseconds',
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  fastestResponseTimeMillisecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'fastestResponseTimeMilliseconds',
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  fastestResponseTimeMillisecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fastestResponseTimeMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  fastestResponseTimeMillisecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fastestResponseTimeMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  fastestResponseTimeMillisecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fastestResponseTimeMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  fastestResponseTimeMillisecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fastestResponseTimeMilliseconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaAttemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hiraganaAttempts', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaAttemptsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hiraganaAttempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaAttemptsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hiraganaAttempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaAttemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hiraganaAttempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaCorrectEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hiraganaCorrect', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaCorrectGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hiraganaCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaCorrectLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hiraganaCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  hiraganaCorrectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hiraganaCorrect',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'kanaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kanaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kanaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kanaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'kanaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'kanaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'kanaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'kanaId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kanaId', value: ''),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  kanaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'kanaId', value: ''),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaAttemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'katakanaAttempts', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaAttemptsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'katakanaAttempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaAttemptsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'katakanaAttempts',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaAttemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'katakanaAttempts',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaCorrectEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'katakanaCorrect', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaCorrectGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'katakanaCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaCorrectLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'katakanaCorrect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  katakanaCorrectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'katakanaCorrect',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPracticedIso'),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPracticedIso'),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastPracticedIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPracticedIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPracticedIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPracticedIso',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastPracticedIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastPracticedIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastPracticedIso',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastPracticedIso',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPracticedIso', value: ''),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  lastPracticedIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastPracticedIso', value: ''),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  streakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'streak', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  streakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'streak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  streakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'streak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  streakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'streak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  totalResponseTimeMillisecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalResponseTimeMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  totalResponseTimeMillisecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalResponseTimeMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  totalResponseTimeMillisecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalResponseTimeMilliseconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  totalResponseTimeMillisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalResponseTimeMilliseconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  wasWeakEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wasWeak', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  wrongEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wrong', value: value),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  wrongGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'wrong',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  wrongLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'wrong',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CharacterMasteryEntity,
    CharacterMasteryEntity,
    QAfterFilterCondition
  >
  wrongBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'wrong',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CharacterMasteryEntityQueryObject
    on
        QueryBuilder<
          CharacterMasteryEntity,
          CharacterMasteryEntity,
          QFilterCondition
        > {}

extension CharacterMasteryEntityQueryLinks
    on
        QueryBuilder<
          CharacterMasteryEntity,
          CharacterMasteryEntity,
          QFilterCondition
        > {}

extension CharacterMasteryEntityQuerySortBy
    on QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QSortBy> {
  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByConfusedWithJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confusedWithJson', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByConfusedWithJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confusedWithJson', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByFastestResponseTimeMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fastestResponseTimeMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByFastestResponseTimeMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fastestResponseTimeMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByHiraganaAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaAttempts', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByHiraganaAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaAttempts', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByHiraganaCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaCorrect', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByHiraganaCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaCorrect', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByKanaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanaId', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByKanaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanaId', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByKatakanaAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaAttempts', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByKatakanaAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaAttempts', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByKatakanaCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaCorrect', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByKatakanaCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaCorrect', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByLastPracticedIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedIso', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByLastPracticedIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedIso', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByTotalResponseTimeMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalResponseTimeMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByTotalResponseTimeMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalResponseTimeMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByWasWeak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasWeak', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByWasWeakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasWeak', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByWrong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  sortByWrongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.desc);
    });
  }
}

extension CharacterMasteryEntityQuerySortThenBy
    on
        QueryBuilder<
          CharacterMasteryEntity,
          CharacterMasteryEntity,
          QSortThenBy
        > {
  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attempts', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByConfusedWithJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confusedWithJson', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByConfusedWithJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confusedWithJson', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByFastestResponseTimeMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fastestResponseTimeMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByFastestResponseTimeMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fastestResponseTimeMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByHiraganaAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaAttempts', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByHiraganaAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaAttempts', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByHiraganaCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaCorrect', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByHiraganaCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hiraganaCorrect', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByKanaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanaId', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByKanaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kanaId', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByKatakanaAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaAttempts', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByKatakanaAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaAttempts', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByKatakanaCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaCorrect', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByKatakanaCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'katakanaCorrect', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByLastPracticedIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedIso', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByLastPracticedIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticedIso', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByTotalResponseTimeMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalResponseTimeMilliseconds', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByTotalResponseTimeMillisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalResponseTimeMilliseconds', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByWasWeak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasWeak', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByWasWeakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasWeak', Sort.desc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByWrong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.asc);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QAfterSortBy>
  thenByWrongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.desc);
    });
  }
}

extension CharacterMasteryEntityQueryWhereDistinct
    on QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct> {
  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attempts');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestStreak');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByConfusedWithJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'confusedWithJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correct');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByFastestResponseTimeMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fastestResponseTimeMilliseconds');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByHiraganaAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hiraganaAttempts');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByHiraganaCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hiraganaCorrect');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByKanaId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kanaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByKatakanaAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'katakanaAttempts');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByKatakanaCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'katakanaCorrect');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByLastPracticedIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastPracticedIso',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streak');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByTotalResponseTimeMilliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalResponseTimeMilliseconds');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByWasWeak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasWeak');
    });
  }

  QueryBuilder<CharacterMasteryEntity, CharacterMasteryEntity, QDistinct>
  distinctByWrong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrong');
    });
  }
}

extension CharacterMasteryEntityQueryProperty
    on
        QueryBuilder<
          CharacterMasteryEntity,
          CharacterMasteryEntity,
          QQueryProperty
        > {
  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  attemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attempts');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  bestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestStreak');
    });
  }

  QueryBuilder<CharacterMasteryEntity, String, QQueryOperations>
  confusedWithJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confusedWithJson');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  correctProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correct');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int?, QQueryOperations>
  fastestResponseTimeMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fastestResponseTimeMilliseconds');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  hiraganaAttemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hiraganaAttempts');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  hiraganaCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hiraganaCorrect');
    });
  }

  QueryBuilder<CharacterMasteryEntity, String, QQueryOperations>
  kanaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kanaId');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  katakanaAttemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'katakanaAttempts');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  katakanaCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'katakanaCorrect');
    });
  }

  QueryBuilder<CharacterMasteryEntity, String?, QQueryOperations>
  lastPracticedIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPracticedIso');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations> streakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streak');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations>
  totalResponseTimeMillisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalResponseTimeMilliseconds');
    });
  }

  QueryBuilder<CharacterMasteryEntity, bool, QQueryOperations>
  wasWeakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasWeak');
    });
  }

  QueryBuilder<CharacterMasteryEntity, int, QQueryOperations> wrongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrong');
    });
  }
}
