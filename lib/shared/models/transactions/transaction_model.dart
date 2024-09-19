import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class TransactionModel extends Equatable {
  final int id;
  final int walletId;
  final DateTime creationDate;
  final SignDataType signDataType;
  final String? amount;
  final String? fee;
  final String? functionData;
  final String? message;
  final String? contractAddress;
  final String? senderAddress;
  final String? recipientAddress;
  final String? signature;
  final DateTime? signDate;

  const TransactionModel({
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
    this.signDate,
    this.signature,
  });

  factory TransactionModel.fromEntity(TransactionEntity transactionEntity) {
    return TransactionModel(
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

  factory TransactionModel.fromCborEthSignRequest(int walletId, CborEthSignRequest cborEthSignRequest) {
    SignDataType signDataType = cborEthSignRequest.dataType == CborEthSignDataType.rawBytes ? SignDataType.rawBytes : SignDataType.typedTransaction;
    AEthereumTransaction? ethereumTransaction = AEthereumTransaction.fromSerializedData(signDataType, cborEthSignRequest.signData);

    return TransactionModel(
      id: Isar.autoIncrement,
      walletId: walletId,
      creationDate: DateTime.now(),
      signDataType: signDataType,
      amount: ethereumTransaction.getAmount(TokenDenominationType.network)?.toString(),
      fee: ethereumTransaction.getFee(TokenDenominationType.network)?.toString(),
      functionData: ethereumTransaction.abiFunction?.hex,
      message: ethereumTransaction.message,
      contractAddress: ethereumTransaction.contractAddress,
      senderAddress: cborEthSignRequest.address,
      recipientAddress: ethereumTransaction.recipientAddress,
    );
  }

  TransactionModel copyWith({
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
    return TransactionModel(
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

  TransactionEntity toEntity() {
    return TransactionEntity(
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

  TransactionModel addSignature(String signature) {
    return copyWith(signDate: DateTime.now(), signature: signature);
  }

  String get title {
    if (recipientAddress != null) {
      return StringUtils.getShortHex(recipientAddress!, 4);
    } else if (message != null) {
      return message!;
    } else if (contractAddress != null) {
      return StringUtils.getShortHex(contractAddress!, 4);
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
