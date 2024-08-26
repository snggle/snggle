// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_group_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNetworkGroupEntityCollection on Isar {
  IsarCollection<NetworkGroupEntity> get networkGroups => this.collection();
}

const NetworkGroupEntitySchema = CollectionSchema(
  name: r'NetworkGroupEntity',
  id: -1011980203888109847,
  properties: {
    r'embeddedNetworkTemplate': PropertySchema(
      id: 0,
      name: r'embeddedNetworkTemplate',
      type: IsarType.object,
      target: r'EmbeddedNetworkTemplateEntity',
    ),
    r'encryptedBool': PropertySchema(
      id: 1,
      name: r'encryptedBool',
      type: IsarType.bool,
    ),
    r'filesystemPathString': PropertySchema(
      id: 2,
      name: r'filesystemPathString',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'pinnedBool': PropertySchema(
      id: 4,
      name: r'pinnedBool',
      type: IsarType.bool,
    )
  },
  estimateSize: _networkGroupEntityEstimateSize,
  serialize: _networkGroupEntitySerialize,
  deserialize: _networkGroupEntityDeserialize,
  deserializeProp: _networkGroupEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'filesystemPathString': IndexSchema(
      id: 4339951643106715750,
      name: r'filesystemPathString',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'filesystemPathString',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'EmbeddedNetworkTemplateEntity': EmbeddedNetworkTemplateEntitySchema
  },
  getId: _networkGroupEntityGetId,
  getLinks: _networkGroupEntityGetLinks,
  attach: _networkGroupEntityAttach,
  version: '3.1.0+1',
);

int _networkGroupEntityEstimateSize(
  NetworkGroupEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      EmbeddedNetworkTemplateEntitySchema.estimateSize(
          object.embeddedNetworkTemplate,
          allOffsets[EmbeddedNetworkTemplateEntity]!,
          allOffsets);
  bytesCount += 3 + object.filesystemPathString.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _networkGroupEntitySerialize(
  NetworkGroupEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<EmbeddedNetworkTemplateEntity>(
    offsets[0],
    allOffsets,
    EmbeddedNetworkTemplateEntitySchema.serialize,
    object.embeddedNetworkTemplate,
  );
  writer.writeBool(offsets[1], object.encryptedBool);
  writer.writeString(offsets[2], object.filesystemPathString);
  writer.writeString(offsets[3], object.name);
  writer.writeBool(offsets[4], object.pinnedBool);
}

NetworkGroupEntity _networkGroupEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NetworkGroupEntity(
    embeddedNetworkTemplate:
        reader.readObjectOrNull<EmbeddedNetworkTemplateEntity>(
              offsets[0],
              EmbeddedNetworkTemplateEntitySchema.deserialize,
              allOffsets,
            ) ??
            EmbeddedNetworkTemplateEntity(),
    encryptedBool: reader.readBool(offsets[1]),
    filesystemPathString: reader.readString(offsets[2]),
    id: id,
    name: reader.readString(offsets[3]),
    pinnedBool: reader.readBool(offsets[4]),
  );
  return object;
}

P _networkGroupEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<EmbeddedNetworkTemplateEntity>(
            offset,
            EmbeddedNetworkTemplateEntitySchema.deserialize,
            allOffsets,
          ) ??
          EmbeddedNetworkTemplateEntity()) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _networkGroupEntityGetId(NetworkGroupEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _networkGroupEntityGetLinks(
    NetworkGroupEntity object) {
  return [];
}

void _networkGroupEntityAttach(
    IsarCollection<dynamic> col, Id id, NetworkGroupEntity object) {}

extension NetworkGroupEntityQueryWhereSort
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QWhere> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NetworkGroupEntityQueryWhere
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QWhereClause> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
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

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
      filesystemPathStringEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'filesystemPathString',
        value: [filesystemPathString],
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterWhereClause>
      filesystemPathStringNotEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filesystemPathString',
              lower: [],
              upper: [filesystemPathString],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filesystemPathString',
              lower: [filesystemPathString],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filesystemPathString',
              lower: [filesystemPathString],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filesystemPathString',
              lower: [],
              upper: [filesystemPathString],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NetworkGroupEntityQueryFilter
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QFilterCondition> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      encryptedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedBool',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filesystemPathString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filesystemPathString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filesystemPathString',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      filesystemPathStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filesystemPathString',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      pinnedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinnedBool',
        value: value,
      ));
    });
  }
}

extension NetworkGroupEntityQueryObject
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QFilterCondition> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterFilterCondition>
      embeddedNetworkTemplate(FilterQuery<EmbeddedNetworkTemplateEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'embeddedNetworkTemplate');
    });
  }
}

extension NetworkGroupEntityQueryLinks
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QFilterCondition> {}

extension NetworkGroupEntityQuerySortBy
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QSortBy> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      sortByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }
}

extension NetworkGroupEntityQuerySortThenBy
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QSortThenBy> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QAfterSortBy>
      thenByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }
}

extension NetworkGroupEntityQueryWhereDistinct
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QDistinct> {
  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QDistinct>
      distinctByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedBool');
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QDistinct>
      distinctByFilesystemPathString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filesystemPathString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QDistinct>
      distinctByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedBool');
    });
  }
}

extension NetworkGroupEntityQueryProperty
    on QueryBuilder<NetworkGroupEntity, NetworkGroupEntity, QQueryProperty> {
  QueryBuilder<NetworkGroupEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NetworkGroupEntity, EmbeddedNetworkTemplateEntity,
      QQueryOperations> embeddedNetworkTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'embeddedNetworkTemplate');
    });
  }

  QueryBuilder<NetworkGroupEntity, bool, QQueryOperations>
      encryptedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedBool');
    });
  }

  QueryBuilder<NetworkGroupEntity, String, QQueryOperations>
      filesystemPathStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filesystemPathString');
    });
  }

  QueryBuilder<NetworkGroupEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<NetworkGroupEntity, bool, QQueryOperations>
      pinnedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedBool');
    });
  }
}
