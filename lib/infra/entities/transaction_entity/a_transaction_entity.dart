import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

abstract class ATransactionEntity extends Equatable {
  final Id id;
  final int walletId;
  final String creationDate;
  @enumerated
  final SignDataType signDataType;
  final String? amount;
  final String? message;
  final String? contractAddress;
  final String? senderAddress;
  final String? recipientAddress;
  final String? signature;
  final String? signDate;

  const ATransactionEntity({
    required this.id,
    required this.walletId,
    required this.creationDate,
    required this.signDataType,
    this.amount,
    this.contractAddress,
    this.message,
    this.senderAddress,
    this.recipientAddress,
    this.signature,
    this.signDate,
  });

  @override
  List<Object?> get props => <Object?>[
    id,
    walletId,
    creationDate,
    signDataType,
    amount,
    contractAddress,
    message,
    senderAddress,
    recipientAddress,
    signature,
    signDate,
  ];
}
