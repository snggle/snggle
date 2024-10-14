// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionEntityCollection on Isar {
  IsarCollection<TransactionEntity> get transactions => this.collection();
}

const TransactionEntitySchema = CollectionSchema(
  name: r'TransactionEntity',
  id: 7517214299117749517,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.string,
    ),
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
    r'fee': PropertySchema(
      id: 3,
      name: r'fee',
      type: IsarType.string,
    ),
    r'functionData': PropertySchema(
      id: 4,
      name: r'functionData',
      type: IsarType.string,
    ),
    r'message': PropertySchema(
      id: 5,
      name: r'message',
      type: IsarType.string,
    ),
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
      enumMap: _TransactionEntitysignDataTypeEnumValueMap,
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
    r'walletId': PropertySchema(
      id: 11,
      name: r'walletId',
      type: IsarType.long,
    )
  },
  estimateSize: _transactionEntityEstimateSize,
  serialize: _transactionEntitySerialize,
  deserialize: _transactionEntityDeserialize,
  deserializeProp: _transactionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _transactionEntityGetId,
  getLinks: _transactionEntityGetLinks,
  attach: _transactionEntityAttach,
  version: '3.1.0+1',
);

int _transactionEntityEstimateSize(
  TransactionEntity object,
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

void _transactionEntitySerialize(
  TransactionEntity object,
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

TransactionEntity _transactionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionEntity(
    amount: reader.readStringOrNull(offsets[0]),
    contractAddress: reader.readStringOrNull(offsets[1]),
    creationDate: reader.readString(offsets[2]),
    fee: reader.readStringOrNull(offsets[3]),
    functionData: reader.readStringOrNull(offsets[4]),
    id: id,
    message: reader.readStringOrNull(offsets[5]),
    recipientAddress: reader.readStringOrNull(offsets[6]),
    senderAddress: reader.readStringOrNull(offsets[7]),
    signDataType: _TransactionEntitysignDataTypeValueEnumMap[
            reader.readByteOrNull(offsets[8])] ??
        SignDataType.rawBytes,
    signDate: reader.readStringOrNull(offsets[9]),
    signature: reader.readStringOrNull(offsets[10]),
    walletId: reader.readLong(offsets[11]),
  );
  return object;
}

P _transactionEntityDeserializeProp<P>(
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
      return (_TransactionEntitysignDataTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SignDataType.rawBytes) as P;
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

const _TransactionEntitysignDataTypeEnumValueMap = {
  'rawBytes': 0,
  'typedTransaction': 1,
};
const _TransactionEntitysignDataTypeValueEnumMap = {
  0: SignDataType.rawBytes,
  1: SignDataType.typedTransaction,
};

Id _transactionEntityGetId(TransactionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionEntityGetLinks(
    TransactionEntity object) {
  return [];
}

void _transactionEntityAttach(
    IsarCollection<dynamic> col, Id id, TransactionEntity object) {}

extension TransactionEntityQueryWhereSort
    on QueryBuilder<TransactionEntity, TransactionEntity, QWhere> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransactionEntityQueryWhere
    on QueryBuilder<TransactionEntity, TransactionEntity, QWhereClause> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterWhereClause>
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
}

extension TransactionEntityQueryFilter
    on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contractAddress',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contractAddress',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contractAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contractAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contractAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contractAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contractAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contractAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contractAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contractAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contractAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      contractAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contractAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creationDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      creationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fee',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fee',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fee',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fee',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      feeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fee',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'functionData',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'functionData',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'functionData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'functionData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'functionData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'functionData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'functionData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'functionData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'functionData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'functionData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'functionData',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      functionDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'functionData',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
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

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'message',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recipientAddress',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recipientAddress',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipientAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipientAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipientAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      recipientAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipientAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'senderAddress',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'senderAddress',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      senderAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDataTypeEqualTo(SignDataType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signDataType',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDataTypeGreaterThan(
    SignDataType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signDataType',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDataTypeLessThan(
    SignDataType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signDataType',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDataTypeBetween(
    SignDataType lower,
    SignDataType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signDataType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signDate',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signDate',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signature',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signature',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      signatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      walletIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      walletIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      walletIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterFilterCondition>
      walletIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'walletId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransactionEntityQueryObject
    on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {}

extension TransactionEntityQueryLinks
    on QueryBuilder<TransactionEntity, TransactionEntity, QFilterCondition> {}

extension TransactionEntityQuerySortBy
    on QueryBuilder<TransactionEntity, TransactionEntity, QSortBy> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByContractAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByContractAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByFunctionData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByFunctionDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByRecipientAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByRecipientAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySenderAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySenderAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySignDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySignDataTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySignDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySignDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension TransactionEntityQuerySortThenBy
    on QueryBuilder<TransactionEntity, TransactionEntity, QSortThenBy> {
  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByContractAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByContractAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractAddress', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByFunctionData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByFunctionDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'functionData', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByRecipientAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByRecipientAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySenderAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySenderAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySignDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySignDataTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDataType', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySignDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySignDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QAfterSortBy>
      thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension TransactionEntityQueryWhereDistinct
    on QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> {
  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByAmount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByContractAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contractAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByCreationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct> distinctByFee(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fee', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByFunctionData({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'functionData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'message', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByRecipientAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipientAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctBySenderAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctBySignDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signDataType');
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctBySignDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctBySignature({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signature', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionEntity, TransactionEntity, QDistinct>
      distinctByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId');
    });
  }
}

extension TransactionEntityQueryProperty
    on QueryBuilder<TransactionEntity, TransactionEntity, QQueryProperty> {
  QueryBuilder<TransactionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
      contractAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractAddress');
    });
  }

  QueryBuilder<TransactionEntity, String, QQueryOperations>
      creationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationDate');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fee');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
      functionDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'functionData');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations> messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'message');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
      recipientAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipientAddress');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
      senderAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderAddress');
    });
  }

  QueryBuilder<TransactionEntity, SignDataType, QQueryOperations>
      signDataTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signDataType');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
      signDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signDate');
    });
  }

  QueryBuilder<TransactionEntity, String?, QQueryOperations>
      signatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signature');
    });
  }

  QueryBuilder<TransactionEntity, int, QQueryOperations> walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
