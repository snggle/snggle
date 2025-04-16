import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';

part 'solana_transaction_entity.g.dart';

@Collection(
  accessor: 'solanaTransactions',
  ignore: <String>{'props', 'stringify', 'hashCode'},
)
class SolanaTransactionEntity extends ATransactionEntity {
  final String signerAddress;
  final String? transactionData;

  const SolanaTransactionEntity({
    required super.id,
    required super.walletId,
    required super.creationDate,
    required super.signDataType,
    required this.signerAddress,
    super.amount,
    super.message,
    super.contractAddress,
    super.senderAddress,
    super.recipientAddress,
    super.signDate,
    super.signature,
    this.transactionData,
  });

  @override
  List<Object?> get props => <Object?>[
        id,
        walletId,
        creationDate,
        signDataType,
        signerAddress,
        amount,
        message,
        contractAddress,
        senderAddress,
        recipientAddress,
        signDate,
        signature,
        transactionData,
      ];
}
