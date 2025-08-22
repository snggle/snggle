import 'package:equatable/equatable.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

abstract class ATransactionModel extends Equatable {
  final int id;
  final int walletId;
  final String? contractAddress;
  final DateTime creationDate;
  final String? amount;
  final String? message;
  final String? senderAddress;
  final String? recipientAddress;
  final String? signature;
  final DateTime? signDate;

  const ATransactionModel({
    required this.id,
    required this.walletId,
    required this.creationDate,
    this.amount,
    this.contractAddress,
    this.message,
    this.senderAddress,
    this.recipientAddress,
    this.signature,
    this.signDate,
  });

  ATransactionModel copyWith({
    int? id,
    int? walletId,
    DateTime? creationDate,
    String? amount,
    String? message,
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

  String? get transactionLabel => null;

  String get title {
    if (recipientAddress != null) {
      return StringUtils.getShortHex(recipientAddress!, 4);
    } else if (message != null) {
      return message!;
    } else {
      return '---';
    }
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        walletId,
        creationDate,
        amount,
        message,
        senderAddress,
        recipientAddress,
        signature,
        signDate,
      ];
}
