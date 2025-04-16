// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solana_transaction_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSolanaTransactionEntityCollection on Isar {
  IsarCollection<SolanaTransactionEntity> get solanaTransactions =>
      this.collection();
}

const SolanaTransactionEntitySchema = CollectionSchema(
  name: r'SolanaTransactionEntity',
  id: 7768928013329643072,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.string,
    ),
    r'creationDate': PropertySchema(
      id: 1,
      name: r'creationDate',
      type: IsarType.string,
    ),
    r'fee': PropertySchema(
      id: 2,
      name: r'fee',
      type: IsarType.string,
    ),
    r'message': PropertySchema(
      id: 3,
      name: r'message',
      type: IsarType.string,
    ),
    r'recipientAddress': PropertySchema(
      id: 4,
      name: r'recipientAddress',
      type: IsarType.string,
    ),
    r'senderAddress': PropertySchema(
      id: 5,
      name: r'senderAddress',
      type: IsarType.string,
    ),
    r'signDate': PropertySchema(
      id: 6,
      name: r'signDate',
      type: IsarType.string,
    ),
    r'signature': PropertySchema(
      id: 7,
      name: r'signature',
      type: IsarType.string,
    ),
    r'signer': PropertySchema(
      id: 8,
      name: r'signer',
      type: IsarType.string,
    ),
    r'walletId': PropertySchema(
      id: 9,
      name: r'walletId',
      type: IsarType.long,
    )
  },
  estimateSize: _solanaTransactionEntityEstimateSize,
  serialize: _solanaTransactionEntitySerialize,
  deserialize: _solanaTransactionEntityDeserialize,
  deserializeProp: _solanaTransactionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _solanaTransactionEntityGetId,
  getLinks: _solanaTransactionEntityGetLinks,
  attach: _solanaTransactionEntityAttach,
  version: '3.1.0+1',
);

int _solanaTransactionEntityEstimateSize(
  SolanaTransactionEntity object,
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
  bytesCount += 3 + object.creationDate.length * 3;
  {
    final value = object.fee;
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
  {
    final value = object.signer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _solanaTransactionEntitySerialize(
  SolanaTransactionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.amount);
  writer.writeString(offsets[1], object.creationDate);
  writer.writeString(offsets[2], object.fee);
  writer.writeString(offsets[3], object.message);
  writer.writeString(offsets[4], object.recipientAddress);
  writer.writeString(offsets[5], object.senderAddress);
  writer.writeString(offsets[6], object.signDate);
  writer.writeString(offsets[7], object.signature);
  writer.writeString(offsets[8], object.signer);
  writer.writeLong(offsets[9], object.walletId);
}

SolanaTransactionEntity _solanaTransactionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SolanaTransactionEntity(
    amount: reader.readStringOrNull(offsets[0]),
    creationDate: reader.readString(offsets[1]),
    fee: reader.readStringOrNull(offsets[2]),
    id: id,
    message: reader.readStringOrNull(offsets[3]),
    recipientAddress: reader.readStringOrNull(offsets[4]),
    senderAddress: reader.readStringOrNull(offsets[5]),
    signDate: reader.readStringOrNull(offsets[6]),
    signature: reader.readStringOrNull(offsets[7]),
    signer: reader.readStringOrNull(offsets[8]),
    walletId: reader.readLong(offsets[9]),
  );
  return object;
}

P _solanaTransactionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
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
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _solanaTransactionEntityGetId(SolanaTransactionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _solanaTransactionEntityGetLinks(
    SolanaTransactionEntity object) {
  return [];
}

void _solanaTransactionEntityAttach(
    IsarCollection<dynamic> col, Id id, SolanaTransactionEntity object) {}

extension SolanaTransactionEntityQueryWhereSort
    on QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QWhere> {
  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SolanaTransactionEntityQueryWhere on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QWhereClause> {
  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterWhereClause> idBetween(
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

extension SolanaTransactionEntityQueryFilter on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QFilterCondition> {
  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      amountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      creationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      creationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creationDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> creationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fee',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fee',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      feeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fee',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      feeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fee',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fee',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> feeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fee',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recipientAddress',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recipientAddress',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      recipientAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipientAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      recipientAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipientAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipientAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> recipientAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipientAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'senderAddress',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'senderAddress',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      senderAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      senderAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> senderAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'senderAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signDate',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signDate',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      signDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      signDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signature',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signature',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureEqualTo(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureBetween(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureStartsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureEndsWith(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      signatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      signatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signer',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signer',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      signerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
          QAfterFilterCondition>
      signerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signer',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> signerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signer',
        value: '',
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> walletIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'walletId',
        value: value,
      ));
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> walletIdGreaterThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> walletIdLessThan(
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

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity,
      QAfterFilterCondition> walletIdBetween(
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

extension SolanaTransactionEntityQueryObject on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QFilterCondition> {}

extension SolanaTransactionEntityQueryLinks on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QFilterCondition> {}

extension SolanaTransactionEntityQuerySortBy
    on QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QSortBy> {
  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByRecipientAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByRecipientAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySenderAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySenderAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySignDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySignDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySigner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortBySignerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      sortByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension SolanaTransactionEntityQuerySortThenBy on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QSortThenBy> {
  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByRecipientAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByRecipientAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipientAddress', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySenderAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySenderAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderAddress', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySignDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySignDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signDate', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySigner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenBySignerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signer', Sort.desc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.asc);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QAfterSortBy>
      thenByWalletIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'walletId', Sort.desc);
    });
  }
}

extension SolanaTransactionEntityQueryWhereDistinct on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QDistinct> {
  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctByAmount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctByCreationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctByFee({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fee', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'message', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctByRecipientAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipientAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctBySenderAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctBySignDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctBySignature({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signature', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctBySigner({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SolanaTransactionEntity, SolanaTransactionEntity, QDistinct>
      distinctByWalletId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'walletId');
    });
  }
}

extension SolanaTransactionEntityQueryProperty on QueryBuilder<
    SolanaTransactionEntity, SolanaTransactionEntity, QQueryProperty> {
  QueryBuilder<SolanaTransactionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String, QQueryOperations>
      creationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationDate');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fee');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'message');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      recipientAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipientAddress');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      senderAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderAddress');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      signDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signDate');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      signatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signature');
    });
  }

  QueryBuilder<SolanaTransactionEntity, String?, QQueryOperations>
      signerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signer');
    });
  }

  QueryBuilder<SolanaTransactionEntity, int, QQueryOperations>
      walletIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'walletId');
    });
  }
}
