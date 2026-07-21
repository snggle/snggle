import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/shared/utils/enum_storage_codec.dart';

@Entity()
// ignore_for_file: must_be_immutable
/*
All fields of a class which extends Equatable should be immutable, but ObjectBox
requires the `id` field to be mutable because its value is set after an instance of
the class has been created.  Because of this, we ignore the linter rule
"must_be_immutable" on all ObjectBox entities.
*/
class EthereumTransactionEntity extends Equatable implements ATransactionEntity {
  // ObjectBox persists `signDataType` via the `dbSignDataType` string column,
  // so this codec maps stable storage IDs to `SignDataType` enum values.
  static final EnumStorageCodec<SignDataType> _signDataTypeCodec = EnumStorageCodec<SignDataType>(<SignDataType, String>{
    SignDataType.rawBytes: 'rawBytes',
    SignDataType.typedTransaction: 'typedTransaction',
  });

  @override
  @Id()
  int id;
  @override
  @Index()
  final int walletId;
  @override
  final String creationDate;
  String? dbSignDataType;
  @override
  final String? amount;
  @override
  final String? message;
  @override
  final String? contractAddress;
  @override
  final String? senderAddress;
  @override
  final String? recipientAddress;
  @override
  final String? signature;
  @override
  final String? signDate;
  final String? fee;
  final String? functionData;

  EthereumTransactionEntity({
    required this.id,
    required this.walletId,
    required this.creationDate,
    SignDataType? signDataType,
    this.dbSignDataType,
    this.amount,
    this.message,
    this.contractAddress,
    this.senderAddress,
    this.recipientAddress,
    this.signature,
    this.signDate,
    this.fee,
    this.functionData,
  }) {
    if (signDataType != null) {
      this.signDataType = signDataType;
    }
  }

  @Transient()
  @override
  SignDataType get signDataType => _signDataTypeCodec.fromStorageValue(dbSignDataType)!;

  set signDataType(SignDataType? signDataType) {
    dbSignDataType = _signDataTypeCodec.toStorageValue(signDataType);
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    walletId,
    creationDate,
    dbSignDataType,
    amount,
    message,
    contractAddress,
    senderAddress,
    recipientAddress,
    signature,
    signDate,
    signDataType,
    fee,
    functionData,
  ];
}
