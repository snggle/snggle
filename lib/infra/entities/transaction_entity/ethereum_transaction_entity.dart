import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';

part 'ethereum_transaction_entity.g.dart';

@Collection(
  accessor: 'ethereumTransactions',
  ignore: <String>{'props', 'stringify', 'hashCode'},
)
class EthereumTransactionEntity extends ATransactionEntity {
  final String? fee;
  final String? functionData;

  const EthereumTransactionEntity({
    required super.id,
    required super.walletId,
    required super.creationDate,
    required super.signDataType,
    super.amount,
    super.message,
    super.contractAddress,
    super.senderAddress,
    super.recipientAddress,
    super.signature,
    super.signDate,
    this.fee,
    this.functionData,
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
    signature,
    signDate,
    fee,
    functionData,
  ];
}
