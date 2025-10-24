import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class SolanaTransactionModel extends ATransactionModel {
  final String? instructionBytes;
  final String? signerAddress;
  final String? expectedAmountOut;
  final String? minimumAmountOut;
  final String? slippage;

  const SolanaTransactionModel({
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
    this.expectedAmountOut,
    this.minimumAmountOut,
    this.slippage,
    this.instructionBytes,
    this.signerAddress,
  });

  @override
  factory SolanaTransactionModel.fromEntity(SolanaTransactionEntity transactionEntity) {
    return SolanaTransactionModel(
      id: transactionEntity.id,
      walletId: transactionEntity.walletId,
      creationDate: DateTime.parse(transactionEntity.creationDate),
      signDataType: transactionEntity.signDataType,
      amount: transactionEntity.amount,
      expectedAmountOut: transactionEntity.expectedAmountOut,
      minimumAmountOut: transactionEntity.minimumAmountOut,
      slippage: transactionEntity.slippage,
      message: transactionEntity.message,
      contractAddress: transactionEntity.contractAddress,
      senderAddress: transactionEntity.senderAddress,
      recipientAddress: transactionEntity.recipientAddress,
      signDate: transactionEntity.signDate != null ? DateTime.parse(transactionEntity.signDate!) : null,
      signature: transactionEntity.signature,
      instructionBytes: transactionEntity.instructionBytes,
      signerAddress: transactionEntity.signerAddress,
    );
  }

  factory SolanaTransactionModel.fromCborSolSignRequest(int walletId, CborSolSignRequest cborSolSignRequest, ASolanaMessage solanaMessage) {
    SignDataType signDataType =
        cborSolSignRequest.dataType == CborSolSignDataType.transaction ? SignDataType.typedTransaction : SignDataType.rawBytes;

    if (solanaMessage is ASolanaTransactionMessage) {
      return _mapFromDecodedInstructions(
        walletId: walletId,
        message: solanaMessage,
        signData: cborSolSignRequest.signData,
        signDataType: signDataType,
      );
    } else {
      return SolanaTransactionModel(
        id: Isar.autoIncrement,
        walletId: walletId,
        creationDate: DateTime.now(),
        message: solanaMessage.message,
        signDataType: signDataType,
      );
    }
  }

  @override
  SolanaTransactionModel copyWith({
    int? id,
    int? walletId,
    DateTime? creationDate,
    SignDataType? signDataType,
    String? amount,
    String? expectedAmountOut,
    String? minimumAmountOut,
    String? slippage,
    String? message,
    String? contractAddress,
    String? senderAddress,
    String? recipientAddress,
    DateTime? signDate,
    String? signature,
    String? instructionBytes,
    String? signerAddress,
  }) {
    return SolanaTransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      creationDate: creationDate ?? this.creationDate,
      signDataType: signDataType ?? this.signDataType,
      amount: amount ?? this.amount,
      expectedAmountOut: expectedAmountOut ?? this.expectedAmountOut,
      minimumAmountOut: minimumAmountOut ?? this.minimumAmountOut,
      slippage: slippage ?? this.slippage,
      message: message ?? this.message,
      contractAddress: contractAddress ?? this.contractAddress,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      signDate: signDate ?? this.signDate,
      signature: signature ?? this.signature,
      instructionBytes: instructionBytes ?? this.instructionBytes,
      signerAddress: signerAddress ?? this.signerAddress,
    );
  }

  @override
  SolanaTransactionEntity toEntity() {
    return SolanaTransactionEntity(
      id: id,
      walletId: walletId,
      creationDate: creationDate.toUtc().toIso8601String(),
      signDataType: signDataType,
      amount: amount,
      expectedAmountOut: expectedAmountOut,
      minimumAmountOut: minimumAmountOut,
      slippage: slippage,
      message: message,
      contractAddress: contractAddress,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signDate: signDate?.toUtc().toIso8601String(),
      signature: signature,
      instructionBytes: instructionBytes,
      signerAddress: signerAddress,
    );
  }

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
  String get transactionLabel => switch (signDataType) {
        SignDataType.typedTransaction => 'TX',
        SignDataType.rawBytes => 'TEXT',
      };

  static SolanaTransactionModel _mapFromDecodedInstructions(
      {required int walletId, required Uint8List signData, required ASolanaTransactionMessage message, required SignDataType signDataType}) {
    String? amount;
    String? minimumAmountOut;
    String? expectedAmountOut;
    String? slippage;
    String? mintAddress;
    String? senderAddress;
    String? recipientAddress;
    String? signerAddress;

    for (ASolanaInstructionDecoded solanaInstructionDecoded in message.decodedInstructions) {
      amount = solanaInstructionDecoded.getAmount()?.toString() ?? amount;
      minimumAmountOut = solanaInstructionDecoded.getSwapMinimumAmountOut()?.toString() ?? minimumAmountOut;
      expectedAmountOut = solanaInstructionDecoded.getSwapExpectedAmountOut()?.toString() ?? expectedAmountOut;
      slippage = solanaInstructionDecoded.getSlippagePercentage()?.toString() ?? slippage;
      mintAddress = solanaInstructionDecoded.getMintAddress() ?? mintAddress;
      senderAddress = solanaInstructionDecoded.getSenderAddress() ?? senderAddress;
      recipientAddress = solanaInstructionDecoded.getRecipientAddress() ?? recipientAddress;
      signerAddress = solanaInstructionDecoded.getSignerAddress() ?? signerAddress;
    }

    return SolanaTransactionModel(
      id: Isar.autoIncrement,
      walletId: walletId,
      creationDate: DateTime.now(),
      signDataType: signDataType,
      amount: amount,
      expectedAmountOut: expectedAmountOut,
      minimumAmountOut: minimumAmountOut,
      slippage: slippage,
      instructionBytes: HexCodec.encode(signData, includePrefixBool: true),
      contractAddress: mintAddress,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signerAddress: signerAddress,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        walletId,
        creationDate,
        signDataType,
        amount,
        expectedAmountOut,
        minimumAmountOut,
        slippage,
        message,
        contractAddress,
        senderAddress,
        recipientAddress,
        signDate,
        signature,
        instructionBytes,
        signerAddress,
      ];
}
