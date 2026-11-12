// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progression_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetUserProgressionEntityCollection on Isar {
  IsarCollection<UserProgressionEntity> get userProgressionEntitys =>
      this.collection();
}

const UserProgressionEntitySchema = CollectionSchema(
  name: r'UserProgressionEntity',
  id: 262142757709024078,
  properties: {
    r'bestAnswerStreak': PropertySchema(
      id: 0,
      name: r'bestAnswerStreak',
      type: IsarType.long,
    ),
    r'bestDailyStreak': PropertySchema(
      id: 1,
      name: r'bestDailyStreak',
      type: IsarType.long,
    ),
    r'currentDailyStreak': PropertySchema(
      id: 2,
      name: r'currentDailyStreak',
      type: IsarType.long,
    ),
    r'lastPracticeDate': PropertySchema(
      id: 3,
      name: r'lastPracticeDate',
      type: IsarType.string,
    ),
    r'level': PropertySchema(id: 4, name: r'level', type: IsarType.long),
    r'totalCardsAnswered': PropertySchema(
      id: 5,
      name: r'totalCardsAnswered',
      type: IsarType.long,
    ),
    r'totalCorrectAnswers': PropertySchema(
      id: 6,
      name: r'totalCorrectAnswers',
      type: IsarType.long,
    ),
    r'totalSessionsCompleted': PropertySchema(
      id: 7,
      name: r'totalSessionsCompleted',
      type: IsarType.long,
    ),
    r'unlockAllRows': PropertySchema(
      id: 8,
      name: r'unlockAllRows',
      type: IsarType.bool,
    ),
    r'unlockedAchievementsJson': PropertySchema(
      id: 9,
      name: r'unlockedAchievementsJson',
      type: IsarType.string,
    ),
    r'unlockedRowIds': PropertySchema(
      id: 10,
      name: r'unlockedRowIds',
      type: IsarType.stringList,
    ),
    r'xp': PropertySchema(id: 11, name: r'xp', type: IsarType.long),
  },

  estimateSize: _userProgressionEntityEstimateSize,
  serialize: _userProgressionEntitySerialize,
  deserialize: _userProgressionEntityDeserialize,
  deserializeProp: _userProgressionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _userProgressionEntityGetId,
  getLinks: _userProgressionEntityGetLinks,
  attach: _userProgressionEntityAttach,
  version: '3.4.1',
);

int _userProgressionEntityEstimateSize(
  UserProgressionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastPracticeDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.unlockedAchievementsJson.length * 3;
  bytesCount += 3 + object.unlockedRowIds.length * 3;
  {
    for (var i = 0; i < object.unlockedRowIds.length; i++) {
      final value = object.unlockedRowIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _userProgressionEntitySerialize(
  UserProgressionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bestAnswerStreak);
  writer.writeLong(offsets[1], object.bestDailyStreak);
  writer.writeLong(offsets[2], object.currentDailyStreak);
  writer.writeString(offsets[3], object.lastPracticeDate);
  writer.writeLong(offsets[4], object.level);
  writer.writeLong(offsets[5], object.totalCardsAnswered);
  writer.writeLong(offsets[6], object.totalCorrectAnswers);
  writer.writeLong(offsets[7], object.totalSessionsCompleted);
  writer.writeBool(offsets[8], object.unlockAllRows);
  writer.writeString(offsets[9], object.unlockedAchievementsJson);
  writer.writeStringList(offsets[10], object.unlockedRowIds);
  writer.writeLong(offsets[11], object.xp);
}

UserProgressionEntity _userProgressionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProgressionEntity();
  object.bestAnswerStreak = reader.readLong(offsets[0]);
  object.bestDailyStreak = reader.readLong(offsets[1]);
  object.currentDailyStreak = reader.readLong(offsets[2]);
  object.id = id;
  object.lastPracticeDate = reader.readStringOrNull(offsets[3]);
  object.level = reader.readLong(offsets[4]);
  object.totalCardsAnswered = reader.readLong(offsets[5]);
  object.totalCorrectAnswers = reader.readLong(offsets[6]);
  object.totalSessionsCompleted = reader.readLong(offsets[7]);
  object.unlockAllRows = reader.readBool(offsets[8]);
  object.unlockedAchievementsJson = reader.readString(offsets[9]);
  object.unlockedRowIds = reader.readStringList(offsets[10]) ?? [];
  object.xp = reader.readLong(offsets[11]);
  return object;
}

P _userProgressionEntityDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProgressionEntityGetId(UserProgressionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProgressionEntityGetLinks(
  UserProgressionEntity object,
) {
  return [];
}

void _userProgressionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserProgressionEntity object,
) {
  object.id = id;
}

extension UserProgressionEntityQueryWhereSort
    on QueryBuilder<UserProgressionEntity, UserProgressionEntity, QWhere> {
  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProgressionEntityQueryWhere
    on
        QueryBuilder<
          UserProgressionEntity,
          UserProgressionEntity,
          QWhereClause
        > {
  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterWhereClause>
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

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterWhereClause>
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

extension UserProgressionEntityQueryFilter
    on
        QueryBuilder<
          UserProgressionEntity,
          UserProgressionEntity,
          QFilterCondition
        > {
  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestAnswerStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestAnswerStreak', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestAnswerStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestAnswerStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestAnswerStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestAnswerStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestAnswerStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestAnswerStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestDailyStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestDailyStreak', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestDailyStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestDailyStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestDailyStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestDailyStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  bestDailyStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestDailyStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  currentDailyStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentDailyStreak', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  currentDailyStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentDailyStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  currentDailyStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentDailyStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  currentDailyStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentDailyStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
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
    UserProgressionEntity,
    UserProgressionEntity,
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
    UserProgressionEntity,
    UserProgressionEntity,
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
    UserProgressionEntity,
    UserProgressionEntity,
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
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPracticeDate'),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPracticeDate'),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastPracticeDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPracticeDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPracticeDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPracticeDate',
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
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastPracticeDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastPracticeDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastPracticeDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastPracticeDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPracticeDate', value: ''),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  lastPracticeDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastPracticeDate', value: ''),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  levelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'level', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  levelGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'level',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  levelLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'level',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'level',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCardsAnsweredEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalCardsAnswered', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCardsAnsweredGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalCardsAnswered',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCardsAnsweredLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalCardsAnswered',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCardsAnsweredBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalCardsAnswered',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCorrectAnswersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalCorrectAnswers', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCorrectAnswersGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalCorrectAnswers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCorrectAnswersLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalCorrectAnswers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalCorrectAnswersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalCorrectAnswers',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalSessionsCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalSessionsCompleted',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalSessionsCompletedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalSessionsCompleted',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalSessionsCompletedLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalSessionsCompleted',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  totalSessionsCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalSessionsCompleted',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockAllRowsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlockAllRows', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unlockedAchievementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unlockedAchievementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unlockedAchievementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unlockedAchievementsJson',
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
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unlockedAchievementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unlockedAchievementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unlockedAchievementsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unlockedAchievementsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unlockedAchievementsJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedAchievementsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'unlockedAchievementsJson',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unlockedRowIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unlockedRowIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unlockedRowIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unlockedRowIds',
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
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unlockedRowIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unlockedRowIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unlockedRowIds',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unlockedRowIds',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlockedRowIds', value: ''),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'unlockedRowIds', value: ''),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unlockedRowIds', length, true, length, true);
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unlockedRowIds', 0, true, 0, true);
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unlockedRowIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unlockedRowIds', 0, true, length, include);
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'unlockedRowIds', length, include, 999999, true);
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  unlockedRowIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedRowIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  xpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'xp', value: value),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  xpGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'xp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  xpLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'xp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    UserProgressionEntity,
    UserProgressionEntity,
    QAfterFilterCondition
  >
  xpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'xp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension UserProgressionEntityQueryObject
    on
        QueryBuilder<
          UserProgressionEntity,
          UserProgressionEntity,
          QFilterCondition
        > {}

extension UserProgressionEntityQueryLinks
    on
        QueryBuilder<
          UserProgressionEntity,
          UserProgressionEntity,
          QFilterCondition
        > {}

extension UserProgressionEntityQuerySortBy
    on QueryBuilder<UserProgressionEntity, UserProgressionEntity, QSortBy> {
  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByBestAnswerStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestAnswerStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByBestAnswerStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestAnswerStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByBestDailyStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDailyStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByBestDailyStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDailyStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByCurrentDailyStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByCurrentDailyStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByLastPracticeDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticeDate', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByLastPracticeDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticeDate', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByTotalCardsAnswered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCardsAnswered', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByTotalCardsAnsweredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCardsAnswered', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByTotalCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrectAnswers', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByTotalCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrectAnswers', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByTotalSessionsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessionsCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByTotalSessionsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessionsCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByUnlockAllRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockAllRows', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByUnlockAllRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockAllRows', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByUnlockedAchievementsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAchievementsJson', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByUnlockedAchievementsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAchievementsJson', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  sortByXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.desc);
    });
  }
}

extension UserProgressionEntityQuerySortThenBy
    on QueryBuilder<UserProgressionEntity, UserProgressionEntity, QSortThenBy> {
  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByBestAnswerStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestAnswerStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByBestAnswerStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestAnswerStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByBestDailyStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDailyStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByBestDailyStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestDailyStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByCurrentDailyStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByCurrentDailyStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByLastPracticeDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticeDate', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByLastPracticeDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticeDate', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByTotalCardsAnswered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCardsAnswered', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByTotalCardsAnsweredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCardsAnswered', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByTotalCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrectAnswers', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByTotalCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrectAnswers', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByTotalSessionsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessionsCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByTotalSessionsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessionsCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByUnlockAllRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockAllRows', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByUnlockAllRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockAllRows', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByUnlockedAchievementsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAchievementsJson', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByUnlockedAchievementsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAchievementsJson', Sort.desc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.asc);
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QAfterSortBy>
  thenByXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.desc);
    });
  }
}

extension UserProgressionEntityQueryWhereDistinct
    on QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct> {
  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByBestAnswerStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestAnswerStreak');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByBestDailyStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestDailyStreak');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByCurrentDailyStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentDailyStreak');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByLastPracticeDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastPracticeDate',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByTotalCardsAnswered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCardsAnswered');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByTotalCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCorrectAnswers');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByTotalSessionsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSessionsCompleted');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByUnlockAllRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockAllRows');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByUnlockedAchievementsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'unlockedAchievementsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByUnlockedRowIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedRowIds');
    });
  }

  QueryBuilder<UserProgressionEntity, UserProgressionEntity, QDistinct>
  distinctByXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xp');
    });
  }
}

extension UserProgressionEntityQueryProperty
    on
        QueryBuilder<
          UserProgressionEntity,
          UserProgressionEntity,
          QQueryProperty
        > {
  QueryBuilder<UserProgressionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations>
  bestAnswerStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestAnswerStreak');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations>
  bestDailyStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestDailyStreak');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations>
  currentDailyStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentDailyStreak');
    });
  }

  QueryBuilder<UserProgressionEntity, String?, QQueryOperations>
  lastPracticeDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPracticeDate');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations>
  totalCardsAnsweredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCardsAnswered');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations>
  totalCorrectAnswersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCorrectAnswers');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations>
  totalSessionsCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSessionsCompleted');
    });
  }

  QueryBuilder<UserProgressionEntity, bool, QQueryOperations>
  unlockAllRowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockAllRows');
    });
  }

  QueryBuilder<UserProgressionEntity, String, QQueryOperations>
  unlockedAchievementsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAchievementsJson');
    });
  }

  QueryBuilder<UserProgressionEntity, List<String>, QQueryOperations>
  unlockedRowIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedRowIds');
    });
  }

  QueryBuilder<UserProgressionEntity, int, QQueryOperations> xpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xp');
    });
  }
}
