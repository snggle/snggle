// ignore_for_file: must_be_immutable

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';

@Entity()
class SolanaTransactionEntity extends Equatable implements ATransactionEntity {
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
  final String signerAddress;
  final String? transactionData;

  @Transient()
  @override
  SignDataType get signDataType => enumByNameOrNull<SignDataType>(SignDataType.values, dbSignDataType)!;

  set signDataType(SignDataType value) {
    dbSignDataType = value.name;
  }

  SolanaTransactionEntity({
    required this.id,
    required this.walletId,
    required this.creationDate,
    required this.signerAddress,
    SignDataType? signDataType,
    this.dbSignDataType,
    this.amount,
    this.message,
    this.contractAddress,
    this.senderAddress,
    this.recipientAddress,
    this.signDate,
    this.signature,
    this.transactionData,
  }) {
    if (signDataType != null) {
      this.signDataType = signDataType;
    }
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        walletId,
        creationDate,
        dbSignDataType,
        signerAddress,
        amount,
        message,
        contractAddress,
        senderAddress,
        recipientAddress,
        signDate,
        signature,
        signDataType,
        transactionData,
      ];
}
