import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  group('Tests of SolanaTransactionModel.fromEntity() constructor', () {
    test('Should [return SolanaTransactionModel] from given TransactionEntity', () {
      // Arrange
      SolanaTransactionEntity actualSolanaTransactionEntity = SolanaTransactionEntity(
        id: 1,
        walletId: 1,
        creationDate: '2024-07-01T13:45:41.420590Z',
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signature:
            '0x6f115b38753bddd14db7b9bb26b132be8f355abdde63dbcdf6fdbd94de774ce8058c544d50b5eed1936d57063cca5922eace9ffcb2b907c793a9c376d5bd6d6b00',
        signDate: '2024-07-01T13:45:42.999751Z',
      );

      // Act
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel.fromEntity(actualSolanaTransactionEntity);

      // Assert
      SolanaTransactionModel expectedSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signature:
            '0x6f115b38753bddd14db7b9bb26b132be8f355abdde63dbcdf6fdbd94de774ce8058c544d50b5eed1936d57063cca5922eace9ffcb2b907c793a9c376d5bd6d6b00',
        signDate: DateTime.parse('2024-07-01T13:45:42.999751Z'),
      );

      expect(actualSolanaTransactionModel, expectedSolanaTransactionModel);
    });
  });

  group('Tests of SolanaTransactionModel.fromCborSolSignRequest() constructor', () {
    test('Should [return SolanaTransactionModel] from given CborSolSignRequest', () {
      // Arrange
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
          'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
        ),
        dataType: CborSolSignDataType.transaction,
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true)
          ],
        ),
      );

      // @formatter:off
      WalletModel actualWalletModel = WalletModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network2/wallet1'), name: 'SOLANA WALLET', address: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y', derivationPath: "m/44'/501'/0'/0'");
      // @formatter:on

      SignDataType actualSignDataType =
          actualCborSolSignRequest.dataType == CborSolSignDataType.transaction ? SignDataType.typedTransaction : SignDataType.rawBytes;
      ASolanaMessage actualSolanaMessage = ASolanaMessage.fromSerializedData(actualSignDataType, actualCborSolSignRequest.signData);

      // Act
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel.fromCborSolSignRequest(
          actualWalletModel.id, actualWalletModel.address, actualCborSolSignRequest, actualSolanaMessage);

      // Assert
      SolanaTransactionModel expectedSolanaTransactionModel = SolanaTransactionModel(
        id: 0,
        walletId: 1,
        creationDate: actualSolanaTransactionModel.creationDate,
        signDataType: SignDataType.typedTransaction,
        amount: '0.1 SOL',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        recipientAddress: '23qJPvgvCBGJFhPmemqcksVCtrLDKyXJh5ZstjfCuu9q',
        transactionData: HexCodec.encode(
            base64Decode(
                'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA'),
            includePrefixBool: true),
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
      );

      expect(actualSolanaTransactionModel, expectedSolanaTransactionModel);
    });
  });

  group('Tests of SolanaTransactionModel.toEntity()', () {
    test('Should [return TransactionEntity] from given SolanaTransactionModel', () {
      // Arrange
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signature:
            '0x6f115b38753bddd14db7b9bb26b132be8f355abdde63dbcdf6fdbd94de774ce8058c544d50b5eed1936d57063cca5922eace9ffcb2b907c793a9c376d5bd6d6b00',
        signDate: DateTime.parse('2024-07-01T13:45:42.999751Z'),
      );

      // Act
      SolanaTransactionEntity actualSolanaTransactionEntity = actualSolanaTransactionModel.toEntity();

      // Assert
      SolanaTransactionEntity expectedSolanaTransactionEntity = SolanaTransactionEntity(
        id: 1,
        walletId: 1,
        creationDate: '2024-07-01T13:45:41.420590Z',
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signature:
            '0x6f115b38753bddd14db7b9bb26b132be8f355abdde63dbcdf6fdbd94de774ce8058c544d50b5eed1936d57063cca5922eace9ffcb2b907c793a9c376d5bd6d6b00',
        signDate: '2024-07-01T13:45:42.999751Z',
      );

      expect(actualSolanaTransactionEntity, expectedSolanaTransactionEntity);
    });
  });

  group('Tests of SolanaTransactionModel.addSignature()', () {
    test('Should [return SolanaTransactionModel] with new signature', () {
      // Arrange
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
      );

      // Act
      ATransactionModel actualNewTransactionModel = actualSolanaTransactionModel.addSignature('signature');

      // Assert
      SolanaTransactionModel expectedNewTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signature: 'signature',
        signDate: actualNewTransactionModel.signDate,
      );

      expect(actualNewTransactionModel, expectedNewTransactionModel);
    });
  });

  group('Tests of SolanaTransactionModel.title getter', () {
    test('Should [return shortened recipientAddress] by default', () {
      // Arrange
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        recipientAddress: '5RipPdH3QLE7cyKzf7HKDrUoBrPKNi8odK866vJZV3AP',
      );

      // Act
      String actualTransactionTitle = actualSolanaTransactionModel.title;

      // Assert
      String expectedTransactionTitle = '5Rip...V3AP';

      expect(actualTransactionTitle, expectedTransactionTitle);
    });

    test('Should [return shortened contractAddress] if recipientAddress is null', () {
      // Arrange
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        contractAddress: '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
      );

      // Act
      String actualTransactionTitle = actualSolanaTransactionModel.title;

      // Assert
      String expectedTransactionTitle = '4zMM...ncDU';

      expect(actualTransactionTitle, expectedTransactionTitle);
    });

    test('Should [return message] if recipientAddress and contractAddress are null', () {
      // Arrange
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        message:
            'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l/nIssued At: 2025-08-24T18:04:20.382Z by',
        amount: '0.019321570386261305 SOL',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
      );

      // Act
      String actualTransactionTitle = actualSolanaTransactionModel.title;

      // Assert
      String expectedTransactionTitle =
          'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l/nIssued At: 2025-08-24T18:04:20.382Z by';

      expect(actualTransactionTitle, expectedTransactionTitle);
    });

    test('Should [return (---)] if recipientAddress, contractAddress and message are null', () {
      // Arrange
      SolanaTransactionModel actualSolanaTransactionModel = SolanaTransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-07-01T13:45:41.420590Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '0.019321570386261305 SOL',
        senderAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
        signerAddress: 'EX1oURpiPWWYUjVSK9KQR2qyqTBaR1EGfRNxkTsNk57Y',
      );

      // Act
      String actualTransactionTitle = actualSolanaTransactionModel.title;

      // Assert
      String expectedTransactionTitle = '---';

      expect(actualTransactionTitle, expectedTransactionTitle);
    });
  });
}
