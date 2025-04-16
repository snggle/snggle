import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

abstract class ATransactionEntity extends Equatable {
  final Id id;
  final int walletId;
  final String creationDate;

  final String? amount;
  final String? fee;
  final String? senderAddress;
  final String? message;
  final String? recipientAddress;
  final String? signer;
  final String? signature;
  final String? signDate;

  const ATransactionEntity({
    required this.id,
    required this.walletId,
    required this.creationDate,
    this.amount,
    this.fee,
    this.message,
    this.senderAddress,
    this.recipientAddress,
    this.signer,
    this.signature,
    this.signDate,
  });

  @override
  List<Object?> get props => <Object?>[
    id,
    walletId,
    creationDate,
    amount,
    fee,
    senderAddress,
    recipientAddress,
    signer,
    signature,
    signDate,
  ];
}
