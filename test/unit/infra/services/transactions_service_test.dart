import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.transactionsDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of TransactionsService.getByWallet()', () {
    test('Should [return list of TransactionModel] if [wallet EXISTS] in database', () async {
      // Act
      List<TransactionModel> actualTransactions = await globalLocator<TransactionsService>().getByWallet(1);

      // Assert
      List<TransactionModel> expectedTransactions = <TransactionModel>[
        // @formatter:off
        TransactionModel(id: 1, walletId: 1, creationDate: DateTime.parse('2024-08-02T08:49:32.089322Z'), signDate: DateTime.parse('2024-08-02T08:49:33.209288Z'), signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.0001360611596022 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        TransactionModel(id: 2, walletId: 1, creationDate: DateTime.parse('2024-08-02T08:49:35.922761Z'), signDate: DateTime.parse('2024-08-02T08:49:36.621694Z'), signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        TransactionModel(id: 3, walletId: 1, creationDate: DateTime.parse('2024-08-02T08:49:48.001235Z'), signDate: DateTime.parse('2024-08-02T08:49:49.236407Z'), signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        TransactionModel(id: 4, walletId: 1, creationDate: DateTime.parse('2024-08-02T08:50:06.549602Z'), signDate: DateTime.parse('2024-08-02T08:50:07.539410Z'), signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01')
        // @formatter:on
      ];

      expect(actualTransactions, expectedTransactions);
    });

    test('Should [return EMPTY list of TransactionModel] if [wallet NOT EXISTS] in database', () async {
      // Act
      List<TransactionModel> actualTransactions = await globalLocator<TransactionsService>().getByWallet(99999);

      // Assert
      List<TransactionModel> expectedTransactions = <TransactionModel>[];

      expect(actualTransactions, expectedTransactions);
    });
  });

  group('Tests of TransactionsService.save()', () {
    test('Should [UPDATE transaction] if [transaction EXISTS] in database', () async {
      // Arrange
      TransactionModel actualUpdatedTransactionModel = TransactionModel(
        id: 1,
        walletId: 1,
        creationDate: DateTime.parse('2024-08-02T08:49:32.089322Z'),
        signDate: DateTime.parse('2024-08-02T08:49:33.209288Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '99999 ETH',
        fee: '99999 ETH',
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      );

      // Act
      await globalLocator<TransactionsService>().save(actualUpdatedTransactionModel);

      List<TransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.transactions.where().findAll();
      });

      // Assert
      List<TransactionEntity> expectedTransactionsDatabaseValue = <TransactionEntity>[
        // @formatter:off
        const TransactionEntity(id: 1, walletId: 1, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '99999 ETH', fee: '99999 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        const TransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        const TransactionEntity(id: 3, walletId: 1, creationDate: '2024-08-02T08:49:48.001235Z', signDate: '2024-08-02T08:49:49.236407Z', signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        const TransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01')
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });

    test('Should [SAVE transaction] if [transaction NOT EXIST] in database', () async {
      // Arrange
      TransactionModel actualNewTransactionModel = TransactionModel(
        id: 99999,
        walletId: 99999,
        creationDate: DateTime.parse('2024-08-02T08:49:32.089322Z'),
        signDate: DateTime.parse('2024-08-02T08:49:33.209288Z'),
        signDataType: SignDataType.typedTransaction,
        amount: '99999 ETH',
        fee: '99999 ETH',
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      );

      // Act
      await globalLocator<TransactionsService>().save(actualNewTransactionModel);

      List<TransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.transactions.where().findAll();
      });

      // Assert
      List<TransactionEntity> expectedTransactionsDatabaseValue = <TransactionEntity>[
        // @formatter:off
        const TransactionEntity(id: 1, walletId: 1, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.0001360611596022 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        const TransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        const TransactionEntity(id: 3, walletId: 1, creationDate: '2024-08-02T08:49:48.001235Z', signDate: '2024-08-02T08:49:49.236407Z', signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        const TransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01'),
        const TransactionEntity(id: 99999, walletId: 99999, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '99999 ETH', fee: '99999 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });
  });

  group('Tests of TransactionsService.deleteAll()', () {
    test('Should [REMOVE transactions] if [transactions EXIST] in database', () async {
      // Arrange
      List<TransactionModel> actualTransactionsToDelete = <TransactionModel>[
        // @formatter:off
        TransactionModel(id: 1, walletId: 1, creationDate: DateTime.parse('2024-08-02T08:49:32.089322Z'), signDate: DateTime.parse('2024-08-02T08:49:33.209288Z'), signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.0001360611596022 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        TransactionModel(id: 3, walletId: 1, creationDate: DateTime.parse('2024-08-02T08:49:48.001235Z'), signDate: DateTime.parse('2024-08-02T08:49:49.236407Z'), signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        // @formatter:on
      ];

      // Act
      await globalLocator<TransactionsService>().deleteAll(actualTransactionsToDelete);

      List<TransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.transactions.where().findAll();
      });

      // Assert
      List<TransactionEntity> expectedTransactionsDatabaseValue = <TransactionEntity>[
        // @formatter:off
        const TransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        const TransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });
  });

  group('Tests of TransactionsService.deleteByWallet()', () {
    test('Should [REMOVE transactions] if [wallet EXISTS] in database', () async {
      // Act
      await globalLocator<TransactionsService>().deleteByWallet(1);

      List<TransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.transactions.where().findAll();
      });

      // Assert
      List<TransactionEntity> expectedTransactionsDatabaseValue = <TransactionEntity>[];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });
  });

  tearDown(testDatabase.close);
}
