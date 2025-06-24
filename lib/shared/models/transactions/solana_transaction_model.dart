import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class SolanaTransactionModel extends ATransactionModel {
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
  });

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
      signDate: transactionEntity.signDate != null ? DateTime.parse(transactionEntity.signDate!) : null,
      signature: transactionEntity.signature,
    );
  }

  factory SolanaTransactionModel.fromCborSolSignRequest(int walletId, CborSolSignRequest cborSolSignRequest) {
    SignDataType signDataType = SignDataType.typedTransaction;
    //SolanaTransaction solanaTransaction = SolanaTransaction.fromSerializedData(cborSolSignRequest.signData);
    SolanaMessage message = SolanaMessage.fromBytes(cborSolSignRequest.signData);
    SolanaTransaction solanaTransaction = SolanaTransaction.fromSerializedData(cborSolSignRequest.signData);
    DecodedInstruction? decoded;
    print('--- Solana Message ---');
    print('Recent Blockhash: ${Base58Codec.encode(message.recentBlockhash)}');

    for (int i = 0; i < message.accountKeys.length; i++) {
      print('Account $i: ${Base58Codec.encode(message.accountKeys[i])}');
    }

    for (int i = 0; i < message.instructions.length; i++) {
      SolanaInstruction instruction = message.instructions[i];
      print('--- Instruction #$i ---');

      int programIdIndex = instruction.programIdIndex;
      String programId = Base58Codec.encode(message.accountKeys[programIdIndex]);
      print('Program ID Index: $programIdIndex => $programId');
      print('Account Indices: ${instruction.accountIndices}');
      print('Raw Data: ${instruction.data}');

      decoded = instruction.decode(message.accountKeys);

      print('Decoded Instruction:');
      print('  Type: ${decoded.type}');
      print('  Program ID: ${decoded.programId}');
      if (decoded.error != null) {
        print('  Error: ${decoded.error}');
        continue;
      }

      if (decoded.type == 'SPL-Token-Transfer') {
        print('SPL Token Transfer');
        print('  From: ${decoded.from}');
        print('  To:   ${decoded.to}');
        print('  Authority: ${decoded.authority}');
        print('  Amount: ${decoded.amount}');
      } else if (decoded.type == 'SOL-Transfer') {
        print('Native SOL Transfer');
        print('  From: ${decoded.from}');
        print('  To:   ${decoded.to}');
        print('  Amount (Lamports): ${decoded.amountLamports}');
      } else {
        print('Unknown instruction type.');
      }
    }

    return SolanaTransactionModel(
      id: Isar.autoIncrement,
      walletId: walletId,
      creationDate: DateTime.now(),
      signDataType: signDataType,
      amount: decoded?.amount.toString(),
      message: message.toString(),
      contractAddress: decoded?.mint,
      senderAddress: decoded?.from,
      recipientAddress: decoded?.to,
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
    String? signature,
    DateTime? signDate,
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
      signature: signature ?? this.signature,
      signDate: signDate ?? this.signDate,
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
  ];
}