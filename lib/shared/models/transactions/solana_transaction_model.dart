import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class SolanaTransactionModel extends ATransactionModel {
  final String signerAddress;
  final String? transactionData;

  const SolanaTransactionModel({
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
  factory SolanaTransactionModel.fromEntity(SolanaTransactionEntity transactionEntity) {
    return SolanaTransactionModel(
      id: transactionEntity.id,
      walletId: transactionEntity.walletId,
      creationDate: DateTime.parse(transactionEntity.creationDate),
      signDataType: transactionEntity.signDataType,
      signerAddress: transactionEntity.signerAddress,
      amount: transactionEntity.amount,
      message: transactionEntity.message,
      contractAddress: transactionEntity.contractAddress,
      senderAddress: transactionEntity.senderAddress,
      recipientAddress: transactionEntity.recipientAddress,
      signDate: transactionEntity.signDate != null ? DateTime.parse(transactionEntity.signDate!) : null,
      signature: transactionEntity.signature,
      transactionData: transactionEntity.transactionData,
    );
  }

  factory SolanaTransactionModel.fromCborSolSignRequest(
      int senderWalletId, String senderWalletAddress, CborSolSignRequest cborSolSignRequest, ASolanaMessage solanaMessage) {
    SignDataType signDataType =
        cborSolSignRequest.dataType == CborSolSignDataType.transaction ? SignDataType.typedTransaction : SignDataType.rawBytes;

    if (solanaMessage is ASolanaTransactionMessage) {
      return _mapFromDecodedInstructions(
        senderWalletId: senderWalletId,
        senderWalletAddress: senderWalletAddress,
        message: solanaMessage,
        signData: cborSolSignRequest.signData,
        signDataType: signDataType,
      );
    } else {
      return SolanaTransactionModel(
        id: 0,
        walletId: senderWalletId,
        creationDate: DateTime.now(),
        message: solanaMessage.message,
        signDataType: signDataType,
        signerAddress: senderWalletAddress,
      );
    }
  }

  @override
  SolanaTransactionModel copyWith({
    int? id,
    int? walletId,
    DateTime? creationDate,
    SignDataType? signDataType,
    String? signerAddress,
    String? amount,
    String? message,
    String? contractAddress,
    String? senderAddress,
    String? recipientAddress,
    DateTime? signDate,
    String? signature,
    String? transactionData,
  }) {
    return SolanaTransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      creationDate: creationDate ?? this.creationDate,
      signDataType: signDataType ?? this.signDataType,
      signerAddress: signerAddress ?? this.signerAddress,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      contractAddress: contractAddress ?? this.contractAddress,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      signDate: signDate ?? this.signDate,
      signature: signature ?? this.signature,
      transactionData: transactionData ?? this.transactionData,
    );
  }

  @override
  SolanaTransactionEntity toEntity() {
    return SolanaTransactionEntity(
      id: id,
      walletId: walletId,
      creationDate: creationDate.toUtc().toIso8601String(),
      signDataType: signDataType,
      signerAddress: signerAddress,
      amount: amount,
      message: message,
      contractAddress: contractAddress,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signDate: signDate?.toUtc().toIso8601String(),
      signature: signature,
      transactionData: transactionData,
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
    } else if (transactionData != null) {
      return transactionData!;
    } else {
      return '---';
    }
  }

  @override
  String get transactionLabel => transactionData != null ? 'TX' : 'TEXT';

  static SolanaTransactionModel _mapFromDecodedInstructions(
      {required int senderWalletId,
      required String senderWalletAddress,
      required Uint8List signData,
      required ASolanaTransactionMessage message,
      required SignDataType signDataType}) {
    String? amount;
    String? mintAddress;
    String? senderAddress;
    String? recipientAddress;
    String? signerAddress;

    for (ASolanaInstructionDecoded solanaInstructionDecoded in message.decodedInstructions) {
      amount = solanaInstructionDecoded.getAmount()?.toString() ?? amount;
      mintAddress = solanaInstructionDecoded.getMintAddress() ?? mintAddress;
      senderAddress = solanaInstructionDecoded.getSenderAddress() ?? senderAddress;
      recipientAddress = solanaInstructionDecoded.getRecipientAddress() ?? recipientAddress;
      signerAddress = solanaInstructionDecoded.getSignerAddress() ?? signerAddress;
    }

    return SolanaTransactionModel(
      id: 0,
      walletId: senderWalletId,
      creationDate: DateTime.now(),
      signDataType: signDataType,
      amount: amount,
      contractAddress: mintAddress,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signerAddress: senderWalletAddress,
      transactionData: HexCodec.encode(signData, includePrefixBool: true),
    );
  }

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
