// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_template_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNetworkTemplateEntityCollection on Isar {
  IsarCollection<NetworkTemplateEntity> get networkTemplates =>
      this.collection();
}

const NetworkTemplateEntitySchema = CollectionSchema(
  name: r'NetworkTemplateEntity',
  id: 9041530423138201,
  properties: {
    r'addressEncoderType': PropertySchema(
      id: 0,
      name: r'addressEncoderType',
      type: IsarType.string,
    ),
    r'curveType': PropertySchema(
      id: 1,
      name: r'curveType',
      type: IsarType.string,
      enumMap: _NetworkTemplateEntitycurveTypeEnumValueMap,
    ),
    r'derivationPathName': PropertySchema(
      id: 2,
      name: r'derivationPathName',
      type: IsarType.string,
    ),
    r'derivationPathTemplate': PropertySchema(
      id: 3,
      name: r'derivationPathTemplate',
      type: IsarType.string,
    ),
    r'derivatorType': PropertySchema(
      id: 4,
      name: r'derivatorType',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'networkIconType': PropertySchema(
      id: 6,
      name: r'networkIconType',
      type: IsarType.string,
      enumMap: _NetworkTemplateEntitynetworkIconTypeEnumValueMap,
    ),
    r'predefinedNetworkTemplateId': PropertySchema(
      id: 7,
      name: r'predefinedNetworkTemplateId',
      type: IsarType.long,
    ),
    r'walletType': PropertySchema(
      id: 8,
      name: r'walletType',
      type: IsarType.string,
      enumMap: _NetworkTemplateEntitywalletTypeEnumValueMap,
    )
  },
  estimateSize: _networkTemplateEntityEstimateSize,
  serialize: _networkTemplateEntitySerialize,
  deserialize: _networkTemplateEntityDeserialize,
  deserializeProp: _networkTemplateEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _networkTemplateEntityGetId,
  getLinks: _networkTemplateEntityGetLinks,
  attach: _networkTemplateEntityAttach,
  version: '3.1.0+1',
);

int _networkTemplateEntityEstimateSize(
  NetworkTemplateEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.addressEncoderType.length * 3;
  bytesCount += 3 + object.curveType.name.length * 3;
  {
    final value = object.derivationPathName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.derivationPathTemplate.length * 3;
  bytesCount += 3 + object.derivatorType.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.networkIconType.name.length * 3;
  bytesCount += 3 + object.walletType.name.length * 3;
  return bytesCount;
}

void _networkTemplateEntitySerialize(
  NetworkTemplateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.addressEncoderType);
  writer.writeString(offsets[1], object.curveType.name);
  writer.writeString(offsets[2], object.derivationPathName);
  writer.writeString(offsets[3], object.derivationPathTemplate);
  writer.writeString(offsets[4], object.derivatorType);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.networkIconType.name);
  writer.writeLong(offsets[7], object.predefinedNetworkTemplateId);
  writer.writeString(offsets[8], object.walletType.name);
}

NetworkTemplateEntity _networkTemplateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NetworkTemplateEntity(
    addressEncoderType: reader.readString(offsets[0]),
    curveType: _NetworkTemplateEntitycurveTypeValueEnumMap[
            reader.readStringOrNull(offsets[1])] ??
        CurveType.secp256k1,
    derivationPathName: reader.readStringOrNull(offsets[2]),
    derivationPathTemplate: reader.readString(offsets[3]),
    derivatorType: reader.readString(offsets[4]),
    name: reader.readString(offsets[5]),
    networkIconType: _NetworkTemplateEntitynetworkIconTypeValueEnumMap[
            reader.readStringOrNull(offsets[6])] ??
        NetworkIconType.bitcoin,
    predefinedNetworkTemplateId: reader.readLongOrNull(offsets[7]),
    walletType: _NetworkTemplateEntitywalletTypeValueEnumMap[
            reader.readStringOrNull(offsets[8])] ??
        WalletType.legacy,
  );
  return object;
}

P _networkTemplateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_NetworkTemplateEntitycurveTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          CurveType.secp256k1) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_NetworkTemplateEntitynetworkIconTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NetworkIconType.bitcoin) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (_NetworkTemplateEntitywalletTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          WalletType.legacy) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _NetworkTemplateEntitycurveTypeEnumValueMap = {
  r'secp256k1': r'secp256k1',
};
const _NetworkTemplateEntitycurveTypeValueEnumMap = {
  r'secp256k1': CurveType.secp256k1,
};
const _NetworkTemplateEntitynetworkIconTypeEnumValueMap = {
  r'bitcoin': r'bitcoin',
  r'cosmos': r'cosmos',
  r'ethereum': r'ethereum',
  r'unknown': r'unknown',
};
const _NetworkTemplateEntitynetworkIconTypeValueEnumMap = {
  r'bitcoin': NetworkIconType.bitcoin,
  r'cosmos': NetworkIconType.cosmos,
  r'ethereum': NetworkIconType.ethereum,
  r'unknown': NetworkIconType.unknown,
};
const _NetworkTemplateEntitywalletTypeEnumValueMap = {
  r'legacy': r'legacy',
};
const _NetworkTemplateEntitywalletTypeValueEnumMap = {
  r'legacy': WalletType.legacy,
};

Id _networkTemplateEntityGetId(NetworkTemplateEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _networkTemplateEntityGetLinks(
    NetworkTemplateEntity object) {
  return [];
}

void _networkTemplateEntityAttach(
    IsarCollection<dynamic> col, Id id, NetworkTemplateEntity object) {}

extension NetworkTemplateEntityByIndex
    on IsarCollection<NetworkTemplateEntity> {
  Future<NetworkTemplateEntity?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  NetworkTemplateEntity? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<NetworkTemplateEntity?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<NetworkTemplateEntity?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(NetworkTemplateEntity object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(NetworkTemplateEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<NetworkTemplateEntity> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<NetworkTemplateEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension NetworkTemplateEntityQueryWhereSort
    on QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QWhere> {
  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NetworkTemplateEntityQueryWhere on QueryBuilder<NetworkTemplateEntity,
    NetworkTemplateEntity, QWhereClause> {
  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
      nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterWhereClause>
      nameNotEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NetworkTemplateEntityQueryFilter on QueryBuilder<
    NetworkTemplateEntity, NetworkTemplateEntity, QFilterCondition> {
  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addressEncoderType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addressEncoderType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addressEncoderType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addressEncoderType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'addressEncoderType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'addressEncoderType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      addressEncoderTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'addressEncoderType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      addressEncoderTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'addressEncoderType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addressEncoderType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'addressEncoderType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeEqualTo(
    CurveType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'curveType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeGreaterThan(
    CurveType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'curveType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeLessThan(
    CurveType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'curveType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeBetween(
    CurveType lower,
    CurveType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'curveType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'curveType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'curveType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      curveTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'curveType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      curveTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'curveType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'curveType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> curveTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'curveType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'derivationPathName',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'derivationPathName',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPathName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'derivationPathName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'derivationPathName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'derivationPathName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'derivationPathName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'derivationPathName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      derivationPathNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'derivationPathName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      derivationPathNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'derivationPathName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPathName',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivationPathName',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPathTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'derivationPathTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'derivationPathTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'derivationPathTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'derivationPathTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'derivationPathTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      derivationPathTemplateContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'derivationPathTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      derivationPathTemplateMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'derivationPathTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPathTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivationPathTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivatorType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'derivatorType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'derivatorType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'derivatorType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'derivatorType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'derivatorType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      derivatorTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'derivatorType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      derivatorTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'derivatorType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivatorType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivatorType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameBetween(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeEqualTo(
    NetworkIconType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'networkIconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeGreaterThan(
    NetworkIconType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'networkIconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeLessThan(
    NetworkIconType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'networkIconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeBetween(
    NetworkIconType lower,
    NetworkIconType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'networkIconType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'networkIconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'networkIconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      networkIconTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'networkIconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      networkIconTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'networkIconType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'networkIconType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'networkIconType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predefinedNetworkTemplateId',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predefinedNetworkTemplateId',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predefinedNetworkTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predefinedNetworkTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predefinedNetworkTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predefinedNetworkTemplateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeEqualTo(
    WalletType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeGreaterThan(
    WalletType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walletType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeLessThan(
    WalletType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walletType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeBetween(
    WalletType lower,
    WalletType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walletType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'walletType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'walletType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      walletTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'walletType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
          QAfterFilterCondition>
      walletTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'walletType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletType',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity,
      QAfterFilterCondition> walletTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'walletType',
        value: '',
      ));
    });
  }
}

extension NetworkTemplateEntityQueryObject on QueryBuilder<
    NetworkTemplateEntity, NetworkTemplateEntity, QFilterCondition> {}

extension NetworkTemplateEntityQueryLinks on QueryBuilder<NetworkTemplateEntity,
    NetworkTemplateEntity, QFilterCondition> {}

extension NetworkTemplateEntityQuerySortBy
    on QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QSortBy> {
  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByAddressEncoderType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressEncoderType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByAddressEncoderTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressEncoderType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByCurveType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curveType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByCurveTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curveType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByDerivationPathName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathName', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByDerivationPathNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathName', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByDerivationPathTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathTemplate', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByDerivationPathTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathTemplate', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByDerivatorType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivatorType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByDerivatorTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivatorType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByNetworkIconType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkIconType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByNetworkIconTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkIconType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByPredefinedNetworkTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predefinedNetworkTemplateId', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByPredefinedNetworkTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predefinedNetworkTemplateId', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByWalletType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      sortByWalletTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletType', Sort.desc);
    });
  }
}

extension NetworkTemplateEntityQuerySortThenBy
    on QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QSortThenBy> {
  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByAddressEncoderType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressEncoderType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByAddressEncoderTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addressEncoderType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByCurveType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curveType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByCurveTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curveType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByDerivationPathName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathName', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByDerivationPathNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathName', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByDerivationPathTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathTemplate', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByDerivationPathTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivationPathTemplate', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByDerivatorType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivatorType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByDerivatorTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'derivatorType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByNetworkIconType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkIconType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByNetworkIconTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkIconType', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByPredefinedNetworkTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predefinedNetworkTemplateId', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByPredefinedNetworkTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predefinedNetworkTemplateId', Sort.desc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByWalletType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletType', Sort.asc);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QAfterSortBy>
      thenByWalletTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletType', Sort.desc);
    });
  }
}

extension NetworkTemplateEntityQueryWhereDistinct
    on QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct> {
  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByAddressEncoderType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addressEncoderType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByCurveType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'curveType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByDerivationPathName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'derivationPathName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByDerivationPathTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'derivationPathTemplate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByDerivatorType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'derivatorType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByNetworkIconType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'networkIconType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByPredefinedNetworkTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predefinedNetworkTemplateId');
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkTemplateEntity, QDistinct>
      distinctByWalletType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletType', caseSensitive: caseSensitive);
    });
  }
}

extension NetworkTemplateEntityQueryProperty on QueryBuilder<
    NetworkTemplateEntity, NetworkTemplateEntity, QQueryProperty> {
  QueryBuilder<NetworkTemplateEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NetworkTemplateEntity, String, QQueryOperations>
      addressEncoderTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addressEncoderType');
    });
  }

  QueryBuilder<NetworkTemplateEntity, CurveType, QQueryOperations>
      curveTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'curveType');
    });
  }

  QueryBuilder<NetworkTemplateEntity, String?, QQueryOperations>
      derivationPathNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'derivationPathName');
    });
  }

  QueryBuilder<NetworkTemplateEntity, String, QQueryOperations>
      derivationPathTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'derivationPathTemplate');
    });
  }

  QueryBuilder<NetworkTemplateEntity, String, QQueryOperations>
      derivatorTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'derivatorType');
    });
  }

  QueryBuilder<NetworkTemplateEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<NetworkTemplateEntity, NetworkIconType, QQueryOperations>
      networkIconTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'networkIconType');
    });
  }

  QueryBuilder<NetworkTemplateEntity, int?, QQueryOperations>
      predefinedNetworkTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predefinedNetworkTemplateId');
    });
  }

  QueryBuilder<NetworkTemplateEntity, WalletType, QQueryOperations>
      walletTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletType');
    });
  }
}
