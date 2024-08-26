// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedded_network_template_entity.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EmbeddedNetworkTemplateEntitySchema = Schema(
  name: r'EmbeddedNetworkTemplateEntity',
  id: 1003810363897541755,
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
      enumMap: _EmbeddedNetworkTemplateEntitycurveTypeEnumValueMap,
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
      enumMap: _EmbeddedNetworkTemplateEntitynetworkIconTypeEnumValueMap,
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
      enumMap: _EmbeddedNetworkTemplateEntitywalletTypeEnumValueMap,
    )
  },
  estimateSize: _embeddedNetworkTemplateEntityEstimateSize,
  serialize: _embeddedNetworkTemplateEntitySerialize,
  deserialize: _embeddedNetworkTemplateEntityDeserialize,
  deserializeProp: _embeddedNetworkTemplateEntityDeserializeProp,
);

int _embeddedNetworkTemplateEntityEstimateSize(
  EmbeddedNetworkTemplateEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.addressEncoderType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.curveType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.derivationPathName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.derivationPathTemplate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.derivatorType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.networkIconType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.walletType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _embeddedNetworkTemplateEntitySerialize(
  EmbeddedNetworkTemplateEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.addressEncoderType);
  writer.writeString(offsets[1], object.curveType?.name);
  writer.writeString(offsets[2], object.derivationPathName);
  writer.writeString(offsets[3], object.derivationPathTemplate);
  writer.writeString(offsets[4], object.derivatorType);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.networkIconType?.name);
  writer.writeLong(offsets[7], object.predefinedNetworkTemplateId);
  writer.writeString(offsets[8], object.walletType?.name);
}

EmbeddedNetworkTemplateEntity _embeddedNetworkTemplateEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmbeddedNetworkTemplateEntity(
    addressEncoderType: reader.readStringOrNull(offsets[0]),
    curveType: _EmbeddedNetworkTemplateEntitycurveTypeValueEnumMap[
        reader.readStringOrNull(offsets[1])],
    derivationPathName: reader.readStringOrNull(offsets[2]),
    derivationPathTemplate: reader.readStringOrNull(offsets[3]),
    derivatorType: reader.readStringOrNull(offsets[4]),
    name: reader.readStringOrNull(offsets[5]),
    networkIconType: _EmbeddedNetworkTemplateEntitynetworkIconTypeValueEnumMap[
        reader.readStringOrNull(offsets[6])],
    predefinedNetworkTemplateId: reader.readLongOrNull(offsets[7]),
    walletType: _EmbeddedNetworkTemplateEntitywalletTypeValueEnumMap[
        reader.readStringOrNull(offsets[8])],
  );
  return object;
}

P _embeddedNetworkTemplateEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (_EmbeddedNetworkTemplateEntitycurveTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_EmbeddedNetworkTemplateEntitynetworkIconTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (_EmbeddedNetworkTemplateEntitywalletTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _EmbeddedNetworkTemplateEntitycurveTypeEnumValueMap = {
  r'secp256k1': r'secp256k1',
};
const _EmbeddedNetworkTemplateEntitycurveTypeValueEnumMap = {
  r'secp256k1': CurveType.secp256k1,
};
const _EmbeddedNetworkTemplateEntitynetworkIconTypeEnumValueMap = {
  r'bitcoin': r'bitcoin',
  r'cosmos': r'cosmos',
  r'ethereum': r'ethereum',
  r'unknown': r'unknown',
};
const _EmbeddedNetworkTemplateEntitynetworkIconTypeValueEnumMap = {
  r'bitcoin': NetworkIconType.bitcoin,
  r'cosmos': NetworkIconType.cosmos,
  r'ethereum': NetworkIconType.ethereum,
  r'unknown': NetworkIconType.unknown,
};
const _EmbeddedNetworkTemplateEntitywalletTypeEnumValueMap = {
  r'legacy': r'legacy',
};
const _EmbeddedNetworkTemplateEntitywalletTypeValueEnumMap = {
  r'legacy': WalletType.legacy,
};

extension EmbeddedNetworkTemplateEntityQueryFilter on QueryBuilder<
    EmbeddedNetworkTemplateEntity,
    EmbeddedNetworkTemplateEntity,
    QFilterCondition> {
  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'addressEncoderType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'addressEncoderType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeEqualTo(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeGreaterThan(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeLessThan(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addressEncoderType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> addressEncoderTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'addressEncoderType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'curveType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'curveType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeEqualTo(
    CurveType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeGreaterThan(
    CurveType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeLessThan(
    CurveType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeBetween(
    CurveType? lower,
    CurveType? upper, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'curveType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> curveTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'curveType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'derivationPathName',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'derivationPathName',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPathName',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivationPathName',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'derivationPathTemplate',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'derivationPathTemplate',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateEqualTo(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateGreaterThan(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateLessThan(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivationPathTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivationPathTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivationPathTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'derivatorType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'derivatorType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeEqualTo(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeGreaterThan(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeLessThan(
    String? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'derivatorType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> derivatorTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'derivatorType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameBetween(
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'networkIconType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'networkIconType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeEqualTo(
    NetworkIconType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeGreaterThan(
    NetworkIconType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeLessThan(
    NetworkIconType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeBetween(
    NetworkIconType? lower,
    NetworkIconType? upper, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'networkIconType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> networkIconTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'networkIconType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predefinedNetworkTemplateId',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predefinedNetworkTemplateId',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> predefinedNetworkTemplateIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predefinedNetworkTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'walletType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'walletType',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeEqualTo(
    WalletType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeGreaterThan(
    WalletType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeLessThan(
    WalletType? value, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeBetween(
    WalletType? lower,
    WalletType? upper, {
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
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

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddedNetworkTemplateEntity, EmbeddedNetworkTemplateEntity,
      QAfterFilterCondition> walletTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'walletType',
        value: '',
      ));
    });
  }
}

extension EmbeddedNetworkTemplateEntityQueryObject on QueryBuilder<
    EmbeddedNetworkTemplateEntity,
    EmbeddedNetworkTemplateEntity,
    QFilterCondition> {}
