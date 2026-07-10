// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsEntityCollection on Isar {
  IsarCollection<SettingsEntity> get settings => this.collection();
}

const SettingsEntitySchema = CollectionSchema(
  name: r'SettingsEntity',
  id: -7271317039764597112,
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

  estimateSize: _settingsEntityEstimateSize,
  serialize: _settingsEntitySerialize,
  deserialize: _settingsEntityDeserialize,
  deserializeProp: _settingsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _settingsEntityGetId,
  getLinks: _settingsEntityGetLinks,
  attach: _settingsEntityAttach,
  version: '3.3.2',
);

int _settingsEntityEstimateSize(
  SettingsEntity object,
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

void _settingsEntitySerialize(
  SettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.automaticLogoutModeName);
  writer.writeBool(offsets[1], object.inactivityLogoutEnabledBool);
  writer.writeString(offsets[2], object.inactivityLogoutTimeoutName);
}

SettingsEntity _settingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsEntity();
  object.automaticLogoutModeName = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.inactivityLogoutEnabledBool = reader.readBool(offsets[1]);
  object.inactivityLogoutTimeoutName = reader.readStringOrNull(offsets[2]);
  return object;
}

P _settingsEntityDeserializeProp<P>(
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

Id _settingsEntityGetId(SettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingsEntityGetLinks(SettingsEntity object) {
  return [];
}

void _settingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  SettingsEntity object,
) {
  object.id = id;
}

extension SettingsEntityQueryWhereSort
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhere> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsEntityQueryWhere
    on QueryBuilder<SettingsEntity, SettingsEntity, QWhereClause> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterWhereClause> idBetween(
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

extension SettingsEntityQueryFilter
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  automaticLogoutModeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'automaticLogoutModeName'),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  automaticLogoutModeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'automaticLogoutModeName'),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  inactivityLogoutTimeoutNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'inactivityLogoutTimeoutName'),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
  inactivityLogoutTimeoutNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'inactivityLogoutTimeoutName',
        ),
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterFilterCondition>
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

extension SettingsEntityQueryObject
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQueryLinks
    on QueryBuilder<SettingsEntity, SettingsEntity, QFilterCondition> {}

extension SettingsEntityQuerySortBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByAutomaticLogoutModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByAutomaticLogoutModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByInactivityLogoutEnabledBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByInactivityLogoutEnabledBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByInactivityLogoutTimeoutName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  sortByInactivityLogoutTimeoutNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.desc);
    });
  }
}

extension SettingsEntityQuerySortThenBy
    on QueryBuilder<SettingsEntity, SettingsEntity, QSortThenBy> {
  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByAutomaticLogoutModeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByAutomaticLogoutModeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticLogoutModeName', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByInactivityLogoutEnabledBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByInactivityLogoutEnabledBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutEnabledBool', Sort.desc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByInactivityLogoutTimeoutName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.asc);
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QAfterSortBy>
  thenByInactivityLogoutTimeoutNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inactivityLogoutTimeoutName', Sort.desc);
    });
  }
}

extension SettingsEntityQueryWhereDistinct
    on QueryBuilder<SettingsEntity, SettingsEntity, QDistinct> {
  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByAutomaticLogoutModeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'automaticLogoutModeName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByInactivityLogoutEnabledBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inactivityLogoutEnabledBool');
    });
  }

  QueryBuilder<SettingsEntity, SettingsEntity, QDistinct>
  distinctByInactivityLogoutTimeoutName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'inactivityLogoutTimeoutName',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension SettingsEntityQueryProperty
    on QueryBuilder<SettingsEntity, SettingsEntity, QQueryProperty> {
  QueryBuilder<SettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsEntity, String?, QQueryOperations>
  automaticLogoutModeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'automaticLogoutModeName');
    });
  }

  QueryBuilder<SettingsEntity, bool, QQueryOperations>
  inactivityLogoutEnabledBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inactivityLogoutEnabledBool');
    });
  }

  QueryBuilder<SettingsEntity, String?, QQueryOperations>
  inactivityLogoutTimeoutNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inactivityLogoutTimeoutName');
    });
  }
}
