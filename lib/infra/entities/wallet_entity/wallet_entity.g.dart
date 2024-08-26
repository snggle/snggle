// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalletEntityCollection on Isar {
  IsarCollection<WalletEntity> get wallets => this.collection();
}

const WalletEntitySchema = CollectionSchema(
  name: r'WalletEntity',
  id: 495311719639707741,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'derivationPath': PropertySchema(
      id: 1,
      name: r'derivationPath',
      type: IsarType.string,
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
    r'index': PropertySchema(
      id: 4,
      name: r'index',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'pinnedBool': PropertySchema(
      id: 6,
      name: r'pinnedBool',
      type: IsarType.bool,
    )
  },
  estimateSize: _walletEntityEstimateSize,
  serialize: _walletEntitySerialize,
  deserialize: _walletEntityDeserialize,
  deserializeProp: _walletEntityDeserializeProp,
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
  embeddedSchemas: {},
  getId: _walletEntityGetId,
  getLinks: _walletEntityGetLinks,
  attach: _walletEntityAttach,
  version: '3.1.0+1',
);

int _walletEntityEstimateSize(
  WalletEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.derivationPath.length * 3;
  bytesCount += 3 + object.filesystemPathString.length * 3;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _walletEntitySerialize(
  WalletEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.derivationPath);
  writer.writeBool(offsets[2], object.encryptedBool);
  writer.writeString(offsets[3], object.filesystemPathString);
  writer.writeLong(offsets[4], object.index);
  writer.writeString(offsets[5], object.name);
  writer.writeBool(offsets[6], object.pinnedBool);
}

WalletEntity _walletEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalletEntity(
    address: reader.readString(offsets[0]),
    derivationPath: reader.readString(offsets[1]),
    encryptedBool: reader.readBool(offsets[2]),
    filesystemPathString: reader.readString(offsets[3]),
    id: id,
    index: reader.readLong(offsets[4]),
    name: reader.readStringOrNull(offsets[5]),
    pinnedBool: reader.readBool(offsets[6]),
  );
  return object;
}

P _walletEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walletEntityGetId(WalletEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _walletEntityGetLinks(WalletEntity object) {
  return [];
}

void _walletEntityAttach(
    IsarCollection<dynamic> col, Id id, WalletEntity object) {}

extension WalletEntityQueryWhereSort
    on QueryBuilder<WalletEntity, WalletEntity, QWhere> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WalletEntityQueryWhere
    on QueryBuilder<WalletEntity, WalletEntity, QWhereClause> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause>
      filesystemPathStringEqualTo(String filesystemPathString) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'filesystemPathString',
        value: [filesystemPathString],
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterWhereClause>
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

extension WalletEntityQueryFilter
    on QueryBuilder<WalletEntity, WalletEntity, QFilterCondition> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'derivationPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'derivationPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'derivationPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'derivationPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'derivationPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'derivationPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'derivationPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPath',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      derivationPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivationPath',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      encryptedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedBool',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      filesystemPathStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filesystemPathString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      filesystemPathStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filesystemPathString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      filesystemPathStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filesystemPathString',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      filesystemPathStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filesystemPathString',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> indexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      indexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> indexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> indexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameEqualTo(
    String? value, {
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameLessThan(
    String? value, {
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterFilterCondition>
      pinnedBoolEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinnedBool',
        value: value,
      ));
    });
  }
}

extension WalletEntityQueryObject
    on QueryBuilder<WalletEntity, WalletEntity, QFilterCondition> {}

extension WalletEntityQueryLinks
    on QueryBuilder<WalletEntity, WalletEntity, QFilterCondition> {}

extension WalletEntityQuerySortBy
    on QueryBuilder<WalletEntity, WalletEntity, QSortBy> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      sortByDerivationPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPath', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      sortByDerivationPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPath', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      sortByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      sortByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      sortByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> sortByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      sortByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }
}

extension WalletEntityQuerySortThenBy
    on QueryBuilder<WalletEntity, WalletEntity, QSortThenBy> {
  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      thenByDerivationPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPath', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      thenByDerivationPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPath', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      thenByEncryptedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedBool', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      thenByFilesystemPathString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      thenByFilesystemPathStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filesystemPathString', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'index', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy> thenByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.asc);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QAfterSortBy>
      thenByPinnedBoolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinnedBool', Sort.desc);
    });
  }
}

extension WalletEntityQueryWhereDistinct
    on QueryBuilder<WalletEntity, WalletEntity, QDistinct> {
  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByDerivationPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'derivationPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct>
      distinctByEncryptedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedBool');
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct>
      distinctByFilesystemPathString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filesystemPathString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'index');
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalletEntity, WalletEntity, QDistinct> distinctByPinnedBool() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinnedBool');
    });
  }
}

extension WalletEntityQueryProperty
    on QueryBuilder<WalletEntity, WalletEntity, QQueryProperty> {
  QueryBuilder<WalletEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalletEntity, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<WalletEntity, String, QQueryOperations>
      derivationPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'derivationPath');
    });
  }

  QueryBuilder<WalletEntity, bool, QQueryOperations> encryptedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedBool');
    });
  }

  QueryBuilder<WalletEntity, String, QQueryOperations>
      filesystemPathStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filesystemPathString');
    });
  }

  QueryBuilder<WalletEntity, int, QQueryOperations> indexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'index');
    });
  }

  QueryBuilder<WalletEntity, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<WalletEntity, bool, QQueryOperations> pinnedBoolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinnedBool');
    });
  }
}
