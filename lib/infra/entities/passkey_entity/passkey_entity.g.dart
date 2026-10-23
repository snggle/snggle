// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passkey_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPasskeyEntityCollection on Isar {
  IsarCollection<PasskeyEntity> get passkeys => this.collection();
}

const PasskeyEntitySchema = CollectionSchema(
  name: r'PasskeyEntity',
  id: -1484046961077806100,
  properties: {
    r'algorithm': PropertySchema(
      id: 0,
      name: r'algorithm',
      type: IsarType.long,
    ),
    r'credentialId': PropertySchema(
      id: 1,
      name: r'credentialId',
      type: IsarType.longList,
    ),
    r'encryptedBool': PropertySchema(
      id: 2,
      name: r'encryptedBool',
      type: IsarType.bool,
    ),
    r'filesystemPathString': PropertySchema(
      id: 3,
      name: r'filesystemPathString',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
    r'pinnedBool': PropertySchema(
      id: 5,
      name: r'pinnedBool',
      type: IsarType.bool,
    ),
    r'rpId': PropertySchema(id: 6, name: r'rpId', type: IsarType.string),
    r'rpName': PropertySchema(id: 7, name: r'rpName', type: IsarType.string),
    r'signCount': PropertySchema(
      id: 8,
      name: r'signCount',
      type: IsarType.long,
    ),
    r'userDisplayName': PropertySchema(
      id: 9,
      name: r'userDisplayName',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(id: 10, name: r'userId', type: IsarType.longList),
    r'userName': PropertySchema(
      id: 11,
      name: r'userName',
      type: IsarType.string,
    ),
  },

  estimateSize: _passkeyEntityEstimateSize,
  serialize: _passkeyEntitySerialize,
  deserialize: _passkeyEntityDeserialize,
  deserializeProp: _passkeyEntityDeserializeProp,
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
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _passkeyEntityGetId,
  getLinks: _passkeyEntityGetLinks,
  attach: _passkeyEntityAttach,
  version: '3.3.2',
);

int _passkeyEntityEstimateSize(
  PasskeyEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.credentialId.length * 8;
  bytesCount += 3 + object.filesystemPathString.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.rpId.length * 3;
  bytesCount += 3 + object.rpName.length * 3;
  bytesCount += 3 + object.userDisplayName.length * 3;
  bytesCount += 3 + object.userId.length * 8;
  bytesCount += 3 + object.userName.length * 3;
  return bytesCount;
}

void _passkeyEntitySerialize(
  PasskeyEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.algorithm);
  writer.writeLongList(offsets[1], object.credentialId);
  writer.writeBool(offsets[2], object.encryptedBool);
  writer.writeString(offsets[3], object.filesystemPathString);
  writer.writeString(offsets[4], object.name);
  writer.writeBool(offsets[5], object.pinnedBool);
  writer.writeString(offsets[6], object.rpId);
  writer.writeString(offsets[7], object.rpName);
  writer.writeLong(offsets[8], object.signCount);
  writer.writeString(offsets[9], object.userDisplayName);
  writer.writeLongList(offsets[10], object.userId);
  writer.writeString(offsets[11], object.userName);
}

PasskeyEntity _passkeyEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PasskeyEntity(
    algorithm: reader.readLong(offsets[0]),
    credentialId: reader.readLongList(offsets[1]) ?? [],
    encryptedBool: reader.readBool(offsets[2]),
    filesystemPathString: reader.readString(offsets[3]),
    id: id,
    name: reader.readString(offsets[4]),
    pinnedBool: reader.readBool(offsets[5]),
    rpId: reader.readString(offsets[6]),
    rpName: reader.readString(offsets[7]),
    signCount: reader.readLong(offsets[8]),
    userDisplayName: reader.readString(offsets[9]),
    userId: reader.readLongList(offsets[10]) ?? [],
    userName: reader.readString(offsets[11]),
  );
  return object;
}

P _passkeyEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLongList(offset) ?? []) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _passkeyEntityGetId(PasskeyEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _passkeyEntityGetLinks(PasskeyEntity object) {
  return [];
}

void _passkeyEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  PasskeyEntity object,
) {}

extension PasskeyEntityQueryWhereSort
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QWhere> {
  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PasskeyEntityQueryWhere
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QWhereClause> {
  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause>
  filesystemPathStringEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'filesystemPathString',
          value: [filesystemPathString],
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterWhereClause>
  filesystemPathStringNotEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [],
                upper: [filesystemPathString],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [filesystemPathString],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [filesystemPathString],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filesystemPathString',
                lower: [],
                upper: [filesystemPathString],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PasskeyEntityQueryFilter
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QFilterCondition> {
  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  algorithmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'algorithm', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  algorithmGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'algorithm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  algorithmLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'algorithm',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  algorithmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'algorithm',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'credentialId', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'credentialId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'credentialId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'credentialId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credentialId', length, true, length, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credentialId', 0, true, 0, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credentialId', 0, false, 999999, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credentialId', 0, true, length, include);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credentialId', length, include, 999999, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  credentialIdLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'credentialId',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  encryptedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedBool', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filesystemPathString',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'filesystemPathString',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'filesystemPathString',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filesystemPathString', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  filesystemPathStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'filesystemPathString',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
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

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  pinnedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pinnedBool', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> rpIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> rpIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rpId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rpId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition> rpIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rpId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpId', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rpId', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rpName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rpName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rpName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rpName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rpName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rpName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rpName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rpName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpName', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  rpNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rpName', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  signCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signCount', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  signCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  signCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  signCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userDisplayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userDisplayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userDisplayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userDisplayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userDisplayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userDisplayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userDisplayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userDisplayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userDisplayName', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userDisplayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userDisplayName', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'userId', length, true, length, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'userId', 0, true, 0, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'userId', 0, false, 999999, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'userId', 0, true, length, include);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'userId', length, include, 999999, true);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userIdLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'userId',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userName', value: ''),
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterFilterCondition>
  userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userName', value: ''),
      );
    });
  }
}

extension PasskeyEntityQueryObject
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QFilterCondition> {}

extension PasskeyEntityQueryLinks
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QFilterCondition> {}

extension PasskeyEntityQuerySortBy
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QSortBy> {
  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByAlgorithm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'algorithm', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByAlgorithmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'algorithm', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByRpId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpId', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByRpIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpId', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByRpName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpName', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByRpNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpName', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortBySignCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signCount', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortBySignCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signCount', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByUserDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDisplayName', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByUserDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDisplayName', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension PasskeyEntityQuerySortThenBy
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QSortThenBy> {
  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByAlgorithm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'algorithm', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByAlgorithmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'algorithm', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByRpId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpId', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByRpIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpId', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByRpName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpName', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByRpNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpName', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenBySignCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signCount', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenBySignCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signCount', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByUserDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDisplayName', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByUserDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userDisplayName', Sort.desc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy> thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QAfterSortBy>
  thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension PasskeyEntityQueryWhereDistinct
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> {
  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByAlgorithm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'algorithm');
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct>
  distinctByCredentialId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'credentialId');
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct>
  distinctByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedBool');
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct>
  distinctByFilesystemPathString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'filesystemPathString',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedBool');
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByRpId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByRpName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctBySignCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signCount');
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct>
  distinctByUserDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'userDisplayName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<PasskeyEntity, PasskeyEntity, QDistinct> distinctByUserName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension PasskeyEntityQueryProperty
    on QueryBuilder<PasskeyEntity, PasskeyEntity, QQueryProperty> {
  QueryBuilder<PasskeyEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PasskeyEntity, int, QQueryOperations> algorithmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'algorithm');
    });
  }

  QueryBuilder<PasskeyEntity, List<int>, QQueryOperations>
  credentialIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'credentialId');
    });
  }

  QueryBuilder<PasskeyEntity, bool, QQueryOperations> encryptedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedBool');
    });
  }

  QueryBuilder<PasskeyEntity, String, QQueryOperations>
  filesystemPathStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filesystemPathString');
    });
  }

  QueryBuilder<PasskeyEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PasskeyEntity, bool, QQueryOperations> pinnedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedBool');
    });
  }

  QueryBuilder<PasskeyEntity, String, QQueryOperations> rpIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpId');
    });
  }

  QueryBuilder<PasskeyEntity, String, QQueryOperations> rpNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpName');
    });
  }

  QueryBuilder<PasskeyEntity, int, QQueryOperations> signCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signCount');
    });
  }

  QueryBuilder<PasskeyEntity, String, QQueryOperations>
  userDisplayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userDisplayName');
    });
  }

  QueryBuilder<PasskeyEntity, List<int>, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<PasskeyEntity, String, QQueryOperations> userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}
