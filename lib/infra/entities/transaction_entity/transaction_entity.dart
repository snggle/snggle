import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'transaction_entity.g.dart';

@Collection(accessor: 'transactions', ignore: <String>{'props', 'stringify', 'hashCode'})
class TransactionEntity extends Equatable {
  final Id id;
  final int walletId;
  final String creationDate;
  @enumerated
  final SignDataType signDataType;
  final String? amount;
  final String? fee;
  final String? functionData;
  final String? message;
  final String? contractAddress;
  final String? senderAddress;
  final String? recipientAddress;
  final String? signature;
  final String? signDate;

  const TransactionEntity({
    required this.id,
    required this.walletId,
    required this.creationDate,
    required this.signDataType,
    this.amount,
    this.fee,
    this.functionData,
    this.message,
    this.contractAddress,
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
        fee,
        functionData,
        message,
        contractAddress,
        senderAddress,
        recipientAddress,
        signature,
        signDate,
      ];
}
