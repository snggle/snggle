import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';

part 'solana_transaction_entity.g.dart';

@Collection(
  accessor: 'solanaTransactions',
  ignore: <String>{'props', 'stringify', 'hashCode'},
)
class SolanaTransactionEntity extends ATransactionEntity {

  const SolanaTransactionEntity({
    required super.id,
    required super.walletId,
    required super.creationDate,
    required super.message,
    super.amount,
    super.fee,
    super.senderAddress,
    super.recipientAddress,
    super.signer,
    super.signature,
    super.signDate,
  });

  @override
  List<Object?> get props => super.props..addAll(<Object?>[message]);
}
