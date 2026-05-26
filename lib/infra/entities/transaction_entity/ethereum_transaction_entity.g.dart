// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ethereum_transaction_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEthereumTransactionEntityCollection on Isar {
  IsarCollection<EthereumTransactionEntity> get ethereumTransactions =>
      this.collection();
}

const EthereumTransactionEntitySchema = CollectionSchema(
  name: r'EthereumTransactionEntity',
  id: -8577506285160129413,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.string),
    r'contractAddress': PropertySchema(
      id: 1,
      name: r'contractAddress',
      type: IsarType.string,
    ),
    r'creationDate': PropertySchema(
      id: 2,
      name: r'creationDate',
      type: IsarType.string,
    ),
    r'fee': PropertySchema(id: 3, name: r'fee', type: IsarType.string),
    r'functionData': PropertySchema(
      id: 4,
      name: r'functionData',
      type: IsarType.string,
    ),
    r'message': PropertySchema(id: 5, name: r'message', type: IsarType.string),
    r'recipientAddress': PropertySchema(
      id: 6,
      name: r'recipientAddress',
      type: IsarType.string,
    ),
    r'senderAddress': PropertySchema(
      id: 7,
      name: r'senderAddress',
      type: IsarType.string,
    ),
    r'signDataType': PropertySchema(
      id: 8,
      name: r'signDataType',
      type: IsarType.byte,
      enumMap: _EthereumTransactionEntitysignDataTypeEnumValueMap,
    ),
    r'signDate': PropertySchema(
      id: 9,
      name: r'signDate',
      type: IsarType.string,
    ),
    r'signature': PropertySchema(
      id: 10,
      name: r'signature',
      type: IsarType.string,
    ),
    r'walletId': PropertySchema(id: 11, name: r'walletId', type: IsarType.long),
  },

  estimateSize: _ethereumTransactionEntityEstimateSize,
  serialize: _ethereumTransactionEntitySerialize,
  deserialize: _ethereumTransactionEntityDeserialize,
  deserializeProp: _ethereumTransactionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _ethereumTransactionEntityGetId,
  getLinks: _ethereumTransactionEntityGetLinks,
  attach: _ethereumTransactionEntityAttach,
  version: '3.3.2',
);

int _ethereumTransactionEntityEstimateSize(
  EthereumTransactionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.amount;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contractAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.creationDate.length * 3;
  {
    final value = object.fee;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.functionData;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.message;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recipientAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.senderAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signature;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _ethereumTransactionEntitySerialize(
  EthereumTransactionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.amount);
  writer.writeString(offsets[1], object.contractAddress);
  writer.writeString(offsets[2], object.creationDate);
  writer.writeString(offsets[3], object.fee);
  writer.writeString(offsets[4], object.functionData);
  writer.writeString(offsets[5], object.message);
  writer.writeString(offsets[6], object.recipientAddress);
  writer.writeString(offsets[7], object.senderAddress);
  writer.writeByte(offsets[8], object.signDataType.index);
  writer.writeString(offsets[9], object.signDate);
  writer.writeString(offsets[10], object.signature);
  writer.writeLong(offsets[11], object.walletId);
}

EthereumTransactionEntity _ethereumTransactionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EthereumTransactionEntity(
    amount: reader.readStringOrNull(offsets[0]),
    contractAddress: reader.readStringOrNull(offsets[1]),
    creationDate: reader.readString(offsets[2]),
    fee: reader.readStringOrNull(offsets[3]),
    functionData: reader.readStringOrNull(offsets[4]),
    id: id,
    message: reader.readStringOrNull(offsets[5]),
    recipientAddress: reader.readStringOrNull(offsets[6]),
    senderAddress: reader.readStringOrNull(offsets[7]),
    signDataType:
        _EthereumTransactionEntitysignDataTypeValueEnumMap[reader
            .readByteOrNull(offsets[8])] ??
        SignDataType.rawBytes,
    signDate: reader.readStringOrNull(offsets[9]),
    signature: reader.readStringOrNull(offsets[10]),
    walletId: reader.readLong(offsets[11]),
  );
  return object;
}

P _ethereumTransactionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (_EthereumTransactionEntitysignDataTypeValueEnumMap[reader
                  .readByteOrNull(offset)] ??
              SignDataType.rawBytes)
          as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _EthereumTransactionEntitysignDataTypeEnumValueMap = {
  'rawBytes': 0,
  'typedTransaction': 1,
};
const _EthereumTransactionEntitysignDataTypeValueEnumMap = {
  0: SignDataType.rawBytes,
  1: SignDataType.typedTransaction,
};

Id _ethereumTransactionEntityGetId(EthereumTransactionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ethereumTransactionEntityGetLinks(
  EthereumTransactionEntity object,
) {
  return [];
}

void _ethereumTransactionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  EthereumTransactionEntity object,
) {}

extension EthereumTransactionEntityQueryWhereSort
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QWhere
        > {
  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EthereumTransactionEntityQueryWhere
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QWhereClause
        > {
  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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

extension EthereumTransactionEntityQueryFilter
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QFilterCondition
        > {
  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'amount'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'amount'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'amount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'amount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'amount',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'amount',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'amount', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'amount', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'contractAddress'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'contractAddress'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'contractAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contractAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contractAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contractAddress',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'contractAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'contractAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'contractAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'contractAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contractAddress', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  contractAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'contractAddress', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'creationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'creationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'creationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'creationDate',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'creationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'creationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'creationDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'creationDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'creationDate', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  creationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'creationDate', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fee'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fee'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fee',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fee',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fee',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fee',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fee',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fee',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fee',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fee',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fee', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  feeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fee', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'functionData'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'functionData'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'functionData',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'functionData',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'functionData',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'functionData',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'functionData',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'functionData',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'functionData',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'functionData',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'functionData', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  functionDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'functionData', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'message'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'message'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'message',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'message',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'message',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'message',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'message',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'message',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'message',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'message',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'message', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'message', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'recipientAddress'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'recipientAddress'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recipientAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recipientAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recipientAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recipientAddress',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recipientAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recipientAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recipientAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recipientAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recipientAddress', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  recipientAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recipientAddress', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'senderAddress'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'senderAddress'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'senderAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'senderAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'senderAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'senderAddress',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'senderAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'senderAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'senderAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'senderAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'senderAddress', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  senderAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'senderAddress', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDataTypeEqualTo(SignDataType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signDataType', value: value),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDataTypeGreaterThan(SignDataType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signDataType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDataTypeLessThan(SignDataType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signDataType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDataTypeBetween(
    SignDataType lower,
    SignDataType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signDataType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'signDate'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'signDate'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'signDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signDate',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'signDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'signDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'signDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'signDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signDate', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'signDate', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'signature'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'signature'),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'signature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'signature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'signature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'signature',
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
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'signature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'signature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'signature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'signature',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'signature', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  signatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'signature', value: ''),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  walletIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'walletId', value: value),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  walletIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'walletId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  walletIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'walletId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterFilterCondition
  >
  walletIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'walletId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension EthereumTransactionEntityQueryObject
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QFilterCondition
        > {}

extension EthereumTransactionEntityQueryLinks
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QFilterCondition
        > {}

extension EthereumTransactionEntityQuerySortBy
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QSortBy
        > {
  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByContractAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByContractAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByFunctionData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByFunctionDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByRecipientAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByRecipientAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySenderAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySenderAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySignDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySignDataTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySignDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySignDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension EthereumTransactionEntityQuerySortThenBy
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QSortThenBy
        > {
  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByContractAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByContractAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByFunctionData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByFunctionDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByRecipientAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByRecipientAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySenderAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySenderAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySignDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySignDataTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySignDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySignDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<
    EthereumTransactionEntity,
    EthereumTransactionEntity,
    QAfterSortBy
  >
  thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension EthereumTransactionEntityQueryWhereDistinct
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QDistinct
        > {
  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByAmount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByContractAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'contractAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByCreationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByFee({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fee', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByFunctionData({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'functionData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'message', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByRecipientAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'recipientAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctBySenderAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'senderAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctBySignDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signDataType');
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctBySignDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctBySignature({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signature', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EthereumTransactionEntity, EthereumTransactionEntity, QDistinct>
  distinctByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId');
    });
  }
}

extension EthereumTransactionEntityQueryProperty
    on
        QueryBuilder<
          EthereumTransactionEntity,
          EthereumTransactionEntity,
          QQueryProperty
        > {
  QueryBuilder<EthereumTransactionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  contractAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractAddress');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String, QQueryOperations>
  creationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationDate');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fee');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  functionDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'functionData');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'message');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  recipientAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipientAddress');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  senderAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderAddress');
    });
  }

  QueryBuilder<EthereumTransactionEntity, SignDataType, QQueryOperations>
  signDataTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signDataType');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  signDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signDate');
    });
  }

  QueryBuilder<EthereumTransactionEntity, String?, QQueryOperations>
  signatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signature');
    });
  }

  QueryBuilder<EthereumTransactionEntity, int, QQueryOperations>
  walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
