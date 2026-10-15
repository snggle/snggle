// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_logout_settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAutoLogoutSettingsEntityCollection on Isar {
  IsarCollection<AutoLogoutSettingsEntity> get autoLogoutSettings =>
      this.collection();
}

const AutoLogoutSettingsEntitySchema = CollectionSchema(
  name: r'AutoLogoutSettingsEntity',
  id: -4497747896893334149,
  properties: {
    r'automaticLogoutModeName': PropertySchema(
      id: 0,
      name: r'automaticLogoutModeName',
      type: IsarType.string,
    ),
    r'inactivityLogoutEnabledBool': PropertySchema(
      id: 1,
      name: r'inactivityLogoutEnabledBool',
      type: IsarType.bool,
    ),
    r'inactivityLogoutTimeoutName': PropertySchema(
      id: 2,
      name: r'inactivityLogoutTimeoutName',
      type: IsarType.string,
    ),
  },

  estimateSize: _autoLogoutSettingsEntityEstimateSize,
  serialize: _autoLogoutSettingsEntitySerialize,
  deserialize: _autoLogoutSettingsEntityDeserialize,
  deserializeProp: _autoLogoutSettingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _autoLogoutSettingsEntityGetId,
  getLinks: _autoLogoutSettingsEntityGetLinks,
  attach: _autoLogoutSettingsEntityAttach,
  version: '3.3.2',
);

int _autoLogoutSettingsEntityEstimateSize(
  AutoLogoutSettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.automaticLogoutModeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.inactivityLogoutTimeoutName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _autoLogoutSettingsEntitySerialize(
  AutoLogoutSettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.automaticLogoutModeName);
  writer.writeBool(offsets[1], object.inactivityLogoutEnabledBool);
  writer.writeString(offsets[2], object.inactivityLogoutTimeoutName);
}

AutoLogoutSettingsEntity _autoLogoutSettingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AutoLogoutSettingsEntity();
  object.automaticLogoutModeName = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.inactivityLogoutEnabledBool = reader.readBool(offsets[1]);
  object.inactivityLogoutTimeoutName = reader.readStringOrNull(offsets[2]);
  return object;
}

P _autoLogoutSettingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _autoLogoutSettingsEntityGetId(AutoLogoutSettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _autoLogoutSettingsEntityGetLinks(
  AutoLogoutSettingsEntity object,
) {
  return [];
}

void _autoLogoutSettingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  AutoLogoutSettingsEntity object,
) {
  object.id = id;
}

extension AutoLogoutSettingsEntityQueryWhereSort
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QWhere
        > {
  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AutoLogoutSettingsEntityQueryWhere
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QWhereClause
        > {
  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
}

extension AutoLogoutSettingsEntityQueryFilter
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QFilterCondition
        > {
  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'automaticLogoutModeName'),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'automaticLogoutModeName'),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'automaticLogoutModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'automaticLogoutModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'automaticLogoutModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'automaticLogoutModeName',
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'automaticLogoutModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'automaticLogoutModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'automaticLogoutModeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'automaticLogoutModeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'automaticLogoutModeName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  automaticLogoutModeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'automaticLogoutModeName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutEnabledBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inactivityLogoutEnabledBool',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'inactivityLogoutTimeoutName'),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'inactivityLogoutTimeoutName',
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inactivityLogoutTimeoutName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inactivityLogoutTimeoutName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inactivityLogoutTimeoutName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inactivityLogoutTimeoutName',
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
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'inactivityLogoutTimeoutName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'inactivityLogoutTimeoutName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'inactivityLogoutTimeoutName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'inactivityLogoutTimeoutName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inactivityLogoutTimeoutName',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    AutoLogoutSettingsEntity,
    AutoLogoutSettingsEntity,
    QAfterFilterCondition
  >
  inactivityLogoutTimeoutNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'inactivityLogoutTimeoutName',
          value: '',
        ),
      );
    });
  }
}

extension AutoLogoutSettingsEntityQueryObject
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QFilterCondition
        > {}

extension AutoLogoutSettingsEntityQueryLinks
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QFilterCondition
        > {}

extension AutoLogoutSettingsEntityQuerySortBy
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QSortBy
        > {
  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  sortByAutomaticLogoutModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  sortByAutomaticLogoutModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.desc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  sortByInactivityLogoutEnabledBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  sortByInactivityLogoutEnabledBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.desc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  sortByInactivityLogoutTimeoutName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  sortByInactivityLogoutTimeoutNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.desc);
    });
  }
}

extension AutoLogoutSettingsEntityQuerySortThenBy
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QSortThenBy
        > {
  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByAutomaticLogoutModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByAutomaticLogoutModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.desc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByInactivityLogoutEnabledBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByInactivityLogoutEnabledBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.desc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByInactivityLogoutTimeoutName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.asc);
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QAfterSortBy>
  thenByInactivityLogoutTimeoutNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.desc);
    });
  }
}

extension AutoLogoutSettingsEntityQueryWhereDistinct
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QDistinct
        > {
  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QDistinct>
  distinctByAutomaticLogoutModeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'automaticLogoutModeName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QDistinct>
  distinctByInactivityLogoutEnabledBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inactivityLogoutEnabledBool');
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, AutoLogoutSettingsEntity, QDistinct>
  distinctByInactivityLogoutTimeoutName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'inactivityLogoutTimeoutName',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension AutoLogoutSettingsEntityQueryProperty
    on
        QueryBuilder<
          AutoLogoutSettingsEntity,
          AutoLogoutSettingsEntity,
          QQueryProperty
        > {
  QueryBuilder<AutoLogoutSettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, String?, QQueryOperations>
  automaticLogoutModeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'automaticLogoutModeName');
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, bool, QQueryOperations>
  inactivityLogoutEnabledBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inactivityLogoutEnabledBool');
    });
  }

  QueryBuilder<AutoLogoutSettingsEntity, String?, QQueryOperations>
  inactivityLogoutTimeoutNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inactivityLogoutTimeoutName');
    });
  }
}
