import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';

part 'ethereum_transaction_entity.g.dart';

@Collection(
  accessor: 'ethereumTransactions',
  ignore: <String>{'props', 'stringify', 'hashCode'},
)
class EthereumTransactionEntity extends ATransactionEntity {
  @enumerated
  final SignDataType signDataType;
  final String? functionData;
  final String? contractAddress;

  const EthereumTransactionEntity({
    required super.id,
    required super.walletId,
    required super.creationDate,
    required this.signDataType,
    super.amount,
    super.fee,
    super.senderAddress,
    super.recipientAddress,
    super.signer,
    super.signature,
    super.signDate,
    this.functionData,
    super.message,
    this.contractAddress,
  });

  @override
  List<Object?> get props => super.props..addAll(<Object?>[
    signDataType,
    functionData,
    message,
    contractAddress,
  ]);
}
