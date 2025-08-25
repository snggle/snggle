import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';

part 'solana_transaction_entity.g.dart';

@Collection(
  accessor: 'solanaTransactions',
  ignore: <String>{'props', 'stringify', 'hashCode'},
)
class SolanaTransactionEntity extends ATransactionEntity {
  final String? signerAddress;

  const SolanaTransactionEntity({
    required super.id,
    required super.walletId,
    required super.creationDate,
    required super.signDataType,
    super.amount,
    super.message,
    super.contractAddress,
    super.senderAddress,
    super.recipientAddress,
    super.signDate,
    super.signature,
    this.signerAddress
  });

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
    signDate,
    signature,
    signerAddress,
  ];
}
