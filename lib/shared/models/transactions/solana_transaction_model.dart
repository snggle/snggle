import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:isar/isar.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class SolanaTransactionModel extends ATransactionModel {
  final String? signerAddress;

  const SolanaTransactionModel({
    required super.id,
    required super.walletId,
    required super.creationDate,
    super.amount,
    super.message,
    super.contractAddress,
    super.senderAddress,
    super.recipientAddress,
    super.signature,
    super.signDate,
    this.signerAddress,
  });

  @override
  factory SolanaTransactionModel.fromEntity(SolanaTransactionEntity transactionEntity) {
    return SolanaTransactionModel(
      id: transactionEntity.id,
      walletId: transactionEntity.walletId,
      creationDate: DateTime.parse(transactionEntity.creationDate),
      amount: transactionEntity.amount,
      message: transactionEntity.message,
      senderAddress: transactionEntity.senderAddress,
      recipientAddress: transactionEntity.recipientAddress,
      signerAddress: transactionEntity.signer,
      signDate: transactionEntity.signDate != null ? DateTime.parse(transactionEntity.signDate!) : null,
      signature: transactionEntity.signature,
    );
  }

  factory SolanaTransactionModel.fromCborSolSignRequest(int walletId, CborSolSignRequest cborSolSignRequest) {
    SolanaSignDataType solanaSignDataType = cborSolSignRequest.dataType == CborSolSignDataType.transaction ? SolanaSignDataType.transaction : SolanaSignDataType.message;
    ASolanaMessage solanaMessage = ASolanaMessage.fromSerializedData(solanaSignDataType, cborSolSignRequest.signData);

    if (solanaMessage is ASolanaTransactionMessage) {
      return _mapFromDecodedInstructions(
        walletId: walletId,
        signData: cborSolSignRequest.signData,
        message: solanaMessage,
      );
    } else {
      return SolanaTransactionModel(
        id: Isar.autoIncrement,
        walletId: walletId,
        creationDate: DateTime.now(),
        message: solanaMessage.message,
      );
    }
  }

  @override
  SolanaTransactionModel copyWith({
    int? id,
    int? walletId,
    DateTime? creationDate,
    String? amount,
    String? fee,
    String? functionData,
    String? contractAddress,
    String? message,
    String? mint,
    String? senderAddress,
    String? recipientAddress,
    String? signerAddress,
    String? signature,
    DateTime? signDate,
  }) {
    return SolanaTransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      creationDate: creationDate ?? this.creationDate,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      contractAddress: contractAddress ?? this.contractAddress,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      signerAddress: signerAddress ?? this.signerAddress,
      signature: signature ?? this.signature,
      signDate: signDate ?? this.signDate,
    );
  }

  @override
  SolanaTransactionEntity toEntity() {
    return SolanaTransactionEntity(
      id: id,
      walletId: walletId,
      creationDate: creationDate.toUtc().toIso8601String(),
      amount: amount,
      message: message,
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
  String? get transactionLabel => 'TX';

  static SolanaTransactionModel _mapFromDecodedInstructions({required int walletId, required Uint8List signData, required ASolanaTransactionMessage message}) {
    String? amount;
    String? mint;
    String? senderAddress;
    String? recipientAddress;
    String? signer;

    for (ASolanaInstructionDecoded solanaInstructionDecoded in message.decodedInstructions) {
      switch (solanaInstructionDecoded.runtimeType) {
        case SolanaSystemTransferInstruction:
          amount = solanaInstructionDecoded.getAmount().toString();
          senderAddress = solanaInstructionDecoded.source;
          recipientAddress = solanaInstructionDecoded.destination;
          break;

        case SolanaTokenTransferCheckedInstruction:
          amount = solanaInstructionDecoded.getAmount().toString();
          mint = solanaInstructionDecoded.mint;
          senderAddress = solanaInstructionDecoded.source;
          recipientAddress = solanaInstructionDecoded.destination;
          signer = solanaInstructionDecoded.authority;
          break;

        case SolanaStakeWithdrawInstruction:
          amount = solanaInstructionDecoded.getAmount().toString();
          recipientAddress = solanaInstructionDecoded.destination;
          signer = solanaInstructionDecoded.withdrawAuthority;
          senderAddress = solanaInstructionDecoded.stakeAccount;
          break;

        case SolanaStakeDelegateInstruction:
          recipientAddress = solanaInstructionDecoded.stakeAccount;
          signer = solanaInstructionDecoded.stakeAuthority;
          break;

        case SolanaStakeInitializeInstruction:
          senderAddress = solanaInstructionDecoded.staker;
          recipientAddress = solanaInstructionDecoded.stakeAccount;
          break;

        case SolanaStakeDeactivateInstruction:
          senderAddress = solanaInstructionDecoded.stakeAccount;
          recipientAddress = solanaInstructionDecoded.stakeAuthority;
          signer = solanaInstructionDecoded.stakeAuthority;
          break;

        default:
          break;
      }
    }

    return SolanaTransactionModel(
      id: Isar.autoIncrement,
      walletId: walletId,
      creationDate: DateTime.now(),
      amount: amount,
      message: HexCodec.encode(signData),
      contractAddress: mint,
      senderAddress: senderAddress,
      recipientAddress: recipientAddress,
      signerAddress: signer,
    );
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
        amount,
        message,
        contractAddress,
        senderAddress,
        recipientAddress,
        signerAddress,
        signature,
        signDate,
      ];
}
