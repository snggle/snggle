import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class SolanaTransactionModel extends ATransactionModel {
  final SolanaInstructionType? instructionType;
  final String? signer;

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
    super.signature,
    super.signDate,
    this.signer,
    this.instructionType,
  });

  @override
  factory SolanaTransactionModel.fromEntity(TransactionEntity transactionEntity) {
    return SolanaTransactionModel(
      id: transactionEntity.id,
      walletId: transactionEntity.walletId,
      creationDate: DateTime.parse(transactionEntity.creationDate),
      signDataType: transactionEntity.signDataType,
      amount: transactionEntity.amount,
      message: transactionEntity.message,
      contractAddress: transactionEntity.contractAddress,
      senderAddress: transactionEntity.senderAddress,
      recipientAddress: transactionEntity.recipientAddress,
      signer: transactionEntity.signer,
      signDate: transactionEntity.signDate != null ? DateTime.parse(transactionEntity.signDate!) : null,
      signature: transactionEntity.signature,
    );
  }

  factory SolanaTransactionModel.fromCborSolSignRequest(int walletId, CborSolSignRequest cborSolSignRequest) {
    ASolanaMessage message = ASolanaMessage.fromSerializedData(cborSolSignRequest.signData);
    SolanaInstructionDecoded? solanaInstructionDecoded = _findRelevantInstruction(message);

    return SolanaTransactionModel(
      id: Isar.autoIncrement,
      walletId: walletId,
      creationDate: DateTime.now(),
      signDataType: SignDataType.solanaMessage,
      amount: solanaInstructionDecoded?.amount?.toString(),
      message: message.toString(),
      contractAddress: solanaInstructionDecoded?.mint,
      senderAddress: solanaInstructionDecoded?.from,
      recipientAddress: solanaInstructionDecoded?.to,
      signer: solanaInstructionDecoded?.signer,
      instructionType: solanaInstructionDecoded?.type,
    );
  }

  @override
  SolanaTransactionModel copyWith({
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
    String? signer,
    String? signature,
    DateTime? signDate,
    SolanaInstructionType? instructionType,
  }) {
    return SolanaTransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      creationDate: creationDate ?? this.creationDate,
      signDataType: signDataType ?? this.signDataType,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      contractAddress: contractAddress ?? this.contractAddress,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      signer: signer ?? this.signer,
      signature: signature ?? this.signature,
      signDate: signDate ?? this.signDate,
      instructionType: instructionType ?? this.instructionType,
    );
  }

  @override
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      walletId: walletId,
      creationDate: creationDate.toUtc().toIso8601String(),
      signDataType: signDataType,
      amount: amount,
      message: message,
      contractAddress: contractAddress,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signature: signature,
      signDate: signDate?.toUtc().toIso8601String(),
    );
  }

  @override
  SolanaTransactionModel addSignature(String signature) {
    return copyWith(signDate: DateTime.now(), signature: signature);
  }

  static SolanaInstructionDecoded? _findRelevantInstruction(ASolanaMessage message) {
    for (int i = message.instructions.length - 1; i >= 0; i--) {
      SolanaInstructionDecoded decoded = message.instructions[i].decode(message.accountKeys);

      if (decoded.type == SolanaInstructionType.solTransfer || decoded.type == SolanaInstructionType.tokenTransfer) {
        return decoded;
      }
    }
    return null;
  }

  @override
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

  String? get displayedSender {
    if (instructionType == SolanaInstructionType.solTransfer) {
      return senderAddress;
    }
    else if (instructionType == SolanaInstructionType.tokenTransfer) {
      return signer;
    }
    return null;
  }

  String? get displayedRecipient {
    if (instructionType == SolanaInstructionType.solTransfer) {
      return recipientAddress;
    }
      return null;
  }

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
        signer,
        signature,
        signDate,
        instructionType,
      ];
}
