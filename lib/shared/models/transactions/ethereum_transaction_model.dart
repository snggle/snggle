import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class EthereumTransactionModel extends ATransactionModel {
  final String? fee;
  final String? functionData;
  final SignDataType signDataType;

  const EthereumTransactionModel({
    required super.id,
    required super.walletId,
    required super.creationDate,
    required this.signDataType,
    super.amount,
    this.fee,
    this.functionData,
    super.message,
    super.contractAddress,
    super.senderAddress,
    super.recipientAddress,
    super.signDate,
    super.signature,
  });

  @override
  factory EthereumTransactionModel.fromEntity(EthereumTransactionEntity transactionEntity) {
    return EthereumTransactionModel(
      id: transactionEntity.id,
      walletId: transactionEntity.walletId,
      creationDate: DateTime.parse(transactionEntity.creationDate),
      signDataType: transactionEntity.signDataType,
      amount: transactionEntity.amount,
      fee: transactionEntity.fee,
      functionData: transactionEntity.functionData,
      message: transactionEntity.message,
      contractAddress: transactionEntity.contractAddress,
      senderAddress: transactionEntity.senderAddress,
      recipientAddress: transactionEntity.recipientAddress,
      signDate: transactionEntity.signDate != null ? DateTime.parse(transactionEntity.signDate!) : null,
      signature: transactionEntity.signature,
    );
  }

  factory EthereumTransactionModel.fromCborEthSignRequest(int walletId, CborEthSignRequest cborEthSignRequest) {
    SignDataType signDataType = cborEthSignRequest.dataType == CborEthSignDataType.rawBytes ? SignDataType.rawBytes : SignDataType.typedTransaction;
    AEthereumTransaction? ethereumTransaction = AEthereumTransaction.fromSerializedData(signDataType, cborEthSignRequest.signData);

    return EthereumTransactionModel(
      id: Isar.autoIncrement,
      walletId: walletId,
      creationDate: DateTime.now(),
      signDataType: signDataType,
      amount: ethereumTransaction.getAmount(TokenDenominationType.network)?.toString(),
      fee: ethereumTransaction.getFee(TokenDenominationType.network)?.toString(),
      functionData: ethereumTransaction.abiFunction?.hex,
      message: ethereumTransaction.message,
      contractAddress: ethereumTransaction.contractAddress,
      senderAddress: cborEthSignRequest.address.toString(),
      recipientAddress: ethereumTransaction.recipientAddress,
    );
  }

  @override
  EthereumTransactionModel copyWith({
    int? id,
    int? walletId,
    DateTime? creationDate,
    SignDataType? signDataType,
    String? amount,
    String? fee,
    String? functionData,
    String? message,
    String? contractAddress,
    String? senderAddress,
    String? recipientAddress,
    String? signature,
    DateTime? signDate,
  }) {
    return EthereumTransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      creationDate: creationDate ?? this.creationDate,
      signDataType: signDataType ?? this.signDataType,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      functionData: functionData ?? this.functionData,
      message: message ?? this.message,
      contractAddress: contractAddress ?? this.contractAddress,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      signature: signature ?? this.signature,
      signDate: signDate ?? this.signDate,
    );
  }

  @override
  EthereumTransactionEntity toEntity() {
    return EthereumTransactionEntity(
      id: id,
      walletId: walletId,
      creationDate: creationDate.toUtc().toIso8601String(),
      signDataType: signDataType,
      fee: fee,
      amount: amount,
      functionData: functionData,
      message: message,
      contractAddress: contractAddress,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signature: signature,
      signDate: signDate?.toUtc().toIso8601String(),
    );
  }

  @override
  EthereumTransactionModel addSignature(String signature) {
    return copyWith(signDate: DateTime.now(), signature: signature);
  }

  @override
  String? get transactionLabel => switch (signDataType) {
    SignDataType.typedTransaction => 'TX',
    SignDataType.rawBytes => 'TEXT',
  };

  @override
  String get title {
    if (recipientAddress != null) {
      return StringUtils.getShortPublicAddress(recipientAddress!, 4);
    } else if (message != null) {
      return message!;
    } else if (contractAddress != null) {
      return StringUtils.getShortPublicAddress(contractAddress!, 4);
    } else {
      return '---';
    }
  }

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
