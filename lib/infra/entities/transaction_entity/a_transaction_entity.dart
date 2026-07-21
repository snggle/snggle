import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

// ignore_for_file: must_be_immutable
/*
All fields of a class which extends Equatable should be immutable, but ObjectBox
requires the `id` field to be mutable because its value is set after an instance of
the class has been created.  Because of this, we ignore the linter rule
"must_be_immutable" on all ObjectBox entities.
*/
abstract class ATransactionEntity extends Equatable {
  @Id()
  int id;
  final int walletId;
  final String creationDate;
  final SignDataType signDataType;
  final String? amount;
  final String? message;
  final String? contractAddress;
  final String? senderAddress;
  final String? recipientAddress;
  final String? signature;
  final String? signDate;

  ATransactionEntity({
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
