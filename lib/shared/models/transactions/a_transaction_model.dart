import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';

abstract class ATransactionModel extends Equatable {
  final int id;
  final int walletId;
  final DateTime creationDate;
  final SignDataType signDataType;
  final String? amount;
  final String? message;
  final String? contractAddress;
  final String? senderAddress;
  final String? recipientAddress;
  final String? signature;
  final DateTime? signDate;

  const ATransactionModel({
    required this.id,
    required this.walletId,
    required this.creationDate,
    required this.signDataType,
    this.amount,
    this.message,
    this.contractAddress,
    this.senderAddress,
    this.recipientAddress,
    this.signature,
    this.signDate,
  });

  ATransactionModel copyWith({
    int? id,
    int? walletId,
    DateTime? creationDate,
    SignDataType? signDataType,
    String? amount,
    String? message,
    String? contractAddress,
    String? senderAddress,
    String? recipientAddress,
    String? signature,
    DateTime? signDate,
  });

  static ATransactionModel fromEntity(ATransactionEntity entity) {
    if (entity is SolanaTransactionEntity) {
      return SolanaTransactionModel.fromEntity(entity);
    } else if (entity is EthereumTransactionEntity) {
      return EthereumTransactionModel.fromEntity(entity);
    } else {
      throw Exception('Unknown transaction entity: $entity');
    }
  }

  ATransactionEntity toEntity();

  ATransactionModel addSignature(String signature) {
    return copyWith(signDate: DateTime.now(), signature: signature);
  }

  String get transactionLabel;

  String get title;

  @override
  List<Object?> get props => <Object?>[
        id,
        walletId,
        creationDate,
        signDataType,
        amount,
        message,
        contractAddress,
        senderAddress,
        recipientAddress,
        signature,
        signDate,
      ];
}
