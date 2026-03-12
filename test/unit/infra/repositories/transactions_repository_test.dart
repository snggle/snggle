import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/transactions_repository.dart';
import 'package:snggle/shared/models/password_model.dart';

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

  group('Tests of TransactionsRepository.getByWallet()', () {
    test('Should [return list of EthereumTransactionEntity] if [wallet EXISTS] in database', () async {
      // Act
      List<ATransactionEntity> actualTransactions = await globalLocator<TransactionsRepository>().getByWallet(1);

      // Assert
      List<EthereumTransactionEntity> expectedTransactions = <EthereumTransactionEntity>[
        // @formatter:off
        const EthereumTransactionEntity(id: 1, walletId: 1, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.0001360611596022 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        const EthereumTransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        const EthereumTransactionEntity(id: 3, walletId: 1, creationDate: '2024-08-02T08:49:48.001235Z', signDate: '2024-08-02T08:49:49.236407Z', signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        const EthereumTransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01')
        // @formatter:on
      ];

      expect(actualTransactions, expectedTransactions);
    });

    test('Should [return list of SolanaTransactionEntity] if [wallet EXISTS] in database', () async {
      // Act
      List<ATransactionEntity> actualTransactions = await globalLocator<TransactionsRepository>().getByWallet(2);

      // Assert
      List<SolanaTransactionEntity> expectedTransactions = <SolanaTransactionEntity>[
        // @formatter:off
        const SolanaTransactionEntity(id: 1, walletId: 2, creationDate: '2025-09-09T08:53:19.566569Z', signDate: '2025-09-09T09:15:36.512800Z', signDataType: SignDataType.typedTransaction, amount: '1 SOL', message: null, contractAddress: null, senderAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', recipientAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z', signature: '0x62f39fd988858b02dbbd2668480e6a8ae9968211254294d526bb55e671f275e1d7856e54d7cba4a6d2dfb8d1f33f767c8723dfa808b3ba45b92d85a5a4559c0b', signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', transactionData: '0x010002041d03d401085ece51cf8df279aca8ed6d2d4a948417b90d4d1540545e141858f4519808055de375e1951892abb0b8341f73632ff23f9668773a30f4ca34cd7b5c00000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a400000003aacc177d1e979ccaa6af5ec31bd72f2521ba73bc95c6cb19d139782dcb24ee00303000903002d31010000000003000502ef010000020200010c0200000000ca9a3b00000000'),
        const SolanaTransactionEntity(id: 2, walletId: 2, creationDate: '2025-08-24T18:04:33.916920Z', signDate: '2025-08-24T18:04:36.767125Z', signDataType: SignDataType.rawBytes, amount: null, message: 'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l\nIssued At: 2025-08-24T18:04:20.382Z', contractAddress: null, senderAddress: null, recipientAddress: null, signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', signature: '0x3997909afb8abb9c5ead3e28d22c0cd9c435ecb012dae4fdb7449724178dd3172cb11bba680bebf29f6665d3188ce889ad36af264dab1081af49d704b2c9d70c'),
        // @formatter:on
      ];

      expect(actualTransactions, expectedTransactions);
    });

    test('Should [return EMPTY list of ATransactionEntity] if [wallet NOT EXISTS] in database', () async {
      // Act
      List<ATransactionEntity> actualTransactions = await globalLocator<TransactionsRepository>().getByWallet(99999);

      // Assert
      List<ATransactionEntity> expectedTransactions = <ATransactionEntity>[];

      expect(actualTransactions, expectedTransactions);
    });
  });

  group('Tests of TransactionsRepository.save()', () {
    test('Should [UPDATE EthereumTransactionEntity] if [EthereumTransactionEntity EXISTS] in database', () async {
      // Arrange
      EthereumTransactionEntity actualUpdatedTransactionEntity = const EthereumTransactionEntity(
        id: 1,
        walletId: 1,
        creationDate: '2024-08-02T08:49:32.089322Z',
        signDate: '2024-08-02T08:49:33.209288Z',
        signDataType: SignDataType.typedTransaction,
        amount: '99999 ETH',
        fee: '99999 ETH',
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        signature:
            '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      );

      // Act
      await globalLocator<TransactionsRepository>().save(actualUpdatedTransactionEntity);

      List<EthereumTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.ethereumTransactions.where().findAll();
      });

      // Assert
      List<EthereumTransactionEntity> expectedTransactionsDatabaseValue = <EthereumTransactionEntity>[
        // @formatter:off
        const EthereumTransactionEntity(id: 1, walletId: 1, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '99999 ETH', fee: '99999 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        const EthereumTransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        const EthereumTransactionEntity(id: 3, walletId: 1, creationDate: '2024-08-02T08:49:48.001235Z', signDate: '2024-08-02T08:49:49.236407Z', signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        const EthereumTransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01')
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });

    test('Should [UPDATE SolanaTransactionEntity] if [SolanaTransactionEntity EXISTS] in database', () async {
      // Arrange
      SolanaTransactionEntity actualUpdatedTransactionEntity = const SolanaTransactionEntity(
        id: 1,
        walletId: 2,
        creationDate: '2024-08-02T08:49:32.089322Z',
        signDate: '2024-08-02T08:49:33.209288Z',
        signDataType: SignDataType.typedTransaction,
        amount: '99999 SOL',
        senderAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z',
        recipientAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signature:
            '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      );

      // Act
      await globalLocator<TransactionsRepository>().save(actualUpdatedTransactionEntity);

      List<SolanaTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.solanaTransactions.where().findAll();
      });

      // Assert
      List<SolanaTransactionEntity> expectedTransactionsDatabaseValue = <SolanaTransactionEntity>[
        // @formatter:off
        const SolanaTransactionEntity(id: 1, walletId: 2, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '99999 SOL', senderAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z', signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', recipientAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        const SolanaTransactionEntity(id: 2, walletId: 2, creationDate: '2025-08-24T18:04:33.916920Z', signDate: '2025-08-24T18:04:36.767125Z', signDataType: SignDataType.rawBytes, amount: null, signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', message: 'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l\nIssued At: 2025-08-24T18:04:20.382Z', contractAddress: null, senderAddress: null, recipientAddress: null, signature: '0x3997909afb8abb9c5ead3e28d22c0cd9c435ecb012dae4fdb7449724178dd3172cb11bba680bebf29f6665d3188ce889ad36af264dab1081af49d704b2c9d70c'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });

    test('Should [SAVE EthereumTransactionEntity] if [EthereumTransactionEntity NOT EXIST] in database', () async {
      // Arrange
      EthereumTransactionEntity actualNewTransactionEntity = const EthereumTransactionEntity(
        id: 99999,
        walletId: 99999,
        creationDate: '2024-08-02T08:49:32.089322Z',
        signDate: '2024-08-02T08:49:33.209288Z',
        signDataType: SignDataType.typedTransaction,
        amount: '99999 ETH',
        fee: '99999 ETH',
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        signature:
            '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      );

      // Act
      await globalLocator<TransactionsRepository>().save(actualNewTransactionEntity);

      List<EthereumTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.ethereumTransactions.where().findAll();
      });

      // Assert
      List<EthereumTransactionEntity> expectedTransactionsDatabaseValue = <EthereumTransactionEntity>[
        // @formatter:off
          const EthereumTransactionEntity(id: 1, walletId: 1, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.0001360611596022 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
          const EthereumTransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
          const EthereumTransactionEntity(id: 3, walletId: 1, creationDate: '2024-08-02T08:49:48.001235Z', signDate: '2024-08-02T08:49:49.236407Z', signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
          const EthereumTransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01'),
          const EthereumTransactionEntity(id: 99999, walletId: 99999, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '99999 ETH', fee: '99999 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });

    test('Should [SAVE SolanaTransactionEntity] if [SolanaTransactionEntity NOT EXIST] in database', () async {
      // Arrange
      SolanaTransactionEntity actualNewTransactionEntity = const SolanaTransactionEntity(
        id: 99999,
        walletId: 99999,
        creationDate: '2024-08-02T08:49:32.089322Z',
        signDate: '2024-08-02T08:49:33.209288Z',
        signDataType: SignDataType.typedTransaction,
        amount: '99999 SOL',
        senderAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z',
        recipientAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signature:
            '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      );

      // Act
      await globalLocator<TransactionsRepository>().save(actualNewTransactionEntity);

      List<SolanaTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.solanaTransactions.where().findAll();
      });

      // Assert
      List<SolanaTransactionEntity> expectedTransactionsDatabaseValue = <SolanaTransactionEntity>[
        // @formatter:off
        const SolanaTransactionEntity(id: 1, walletId: 2, creationDate: '2025-09-09T08:53:19.566569Z', signDate: '2025-09-09T09:15:36.512800Z', signDataType: SignDataType.typedTransaction, amount: '1 SOL', message: null, contractAddress: null, senderAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', recipientAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z', signature: '0x62f39fd988858b02dbbd2668480e6a8ae9968211254294d526bb55e671f275e1d7856e54d7cba4a6d2dfb8d1f33f767c8723dfa808b3ba45b92d85a5a4559c0b', transactionData: '0x010002041d03d401085ece51cf8df279aca8ed6d2d4a948417b90d4d1540545e141858f4519808055de375e1951892abb0b8341f73632ff23f9668773a30f4ca34cd7b5c00000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a400000003aacc177d1e979ccaa6af5ec31bd72f2521ba73bc95c6cb19d139782dcb24ee00303000903002d31010000000003000502ef010000020200010c0200000000ca9a3b00000000'),
        const SolanaTransactionEntity(id: 2, walletId: 2, creationDate: '2025-08-24T18:04:33.916920Z', signDate: '2025-08-24T18:04:36.767125Z', signDataType: SignDataType.rawBytes, amount: null, signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', message: 'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l\nIssued At: 2025-08-24T18:04:20.382Z', contractAddress: null, senderAddress: null, recipientAddress: null, signature: '0x3997909afb8abb9c5ead3e28d22c0cd9c435ecb012dae4fdb7449724178dd3172cb11bba680bebf29f6665d3188ce889ad36af264dab1081af49d704b2c9d70c'),
        const SolanaTransactionEntity(id: 99999, walletId: 99999, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '99999 SOL', senderAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z', signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', recipientAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });
  });

  group('Tests of TransactionsRepository.deleteAll()', () {
    test('Should [REMOVE transactions] if [transactions EXIST] in database', () async {
      // Arrange
      List<EthereumTransactionEntity> actualTransactionsToDelete = <EthereumTransactionEntity>[
        // @formatter:off
        const EthereumTransactionEntity(id: 1, walletId: 1, creationDate: '2024-08-02T08:49:32.089322Z', signDate: '2024-08-02T08:49:33.209288Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.0001360611596022 ETH', functionData: null, message: null, contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101'),
        const EthereumTransactionEntity(id: 3, walletId: 1, creationDate: '2024-08-02T08:49:48.001235Z', signDate: '2024-08-02T08:49:49.236407Z', signDataType: SignDataType.rawBytes, amount: null, fee: null, functionData: null, message: 'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2', contractAddress: null, senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c'),
        // @formatter:on
      ];

      // Act
      await globalLocator<TransactionsRepository>().deleteAll(actualTransactionsToDelete);

      List<EthereumTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.ethereumTransactions.where().findAll();
      });

      // Assert
      List<EthereumTransactionEntity> expectedTransactionsDatabaseValue = <EthereumTransactionEntity>[
        // @formatter:off
        const EthereumTransactionEntity(id: 2, walletId: 1, creationDate: '2024-08-02T08:49:35.922761Z', signDate: '2024-08-02T08:49:36.621694Z', signDataType: SignDataType.typedTransaction, amount: '37510516893', fee: '0.00032559980259381 ETH', functionData: '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d', message: null, contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C', signature: '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901'),
        const EthereumTransactionEntity(id: 4, walletId: 1, creationDate: '2024-08-02T08:50:06.549602Z', signDate: '2024-08-02T08:50:07.539410Z', signDataType: SignDataType.typedTransaction, amount: '0.019321570386261305 ETH', fee: '0.001496331786753402 ETH', functionData: '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd', message: null, contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad', senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09', recipientAddress: null, signature: '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });

    test('Should [REMOVE transactions] if [transactions EXIST] in database', () async {
      // Arrange
      List<SolanaTransactionEntity> actualTransactionsToDelete = <SolanaTransactionEntity>[
        // @formatter:off
        const SolanaTransactionEntity(id: 1, walletId: 2, creationDate: '2025-09-09T08:53:19.566569Z', signDate: '2025-09-09T09:15:36.512800Z', signDataType: SignDataType.typedTransaction, amount: '1 SOL', message: null, contractAddress: null, senderAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', recipientAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z', signature: '0x62f39fd988858b02dbbd2668480e6a8ae9968211254294d526bb55e671f275e1d7856e54d7cba4a6d2dfb8d1f33f767c8723dfa808b3ba45b92d85a5a4559c0b', transactionData: '0x010002041d03d401085ece51cf8df279aca8ed6d2d4a948417b90d4d1540545e141858f4519808055de375e1951892abb0b8341f73632ff23f9668773a30f4ca34cd7b5c00000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a400000003aacc177d1e979ccaa6af5ec31bd72f2521ba73bc95c6cb19d139782dcb24ee00303000903002d31010000000003000502ef010000020200010c0200000000ca9a3b00000000'),
        // @formatter:on
      ];

      // Act
      await globalLocator<TransactionsRepository>().deleteAll(actualTransactionsToDelete);

      List<SolanaTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.solanaTransactions.where().findAll();
      });

      // Assert
      List<SolanaTransactionEntity> expectedTransactionsDatabaseValue = <SolanaTransactionEntity>[
        // @formatter:off
        const SolanaTransactionEntity(id: 2, walletId: 2, creationDate: '2025-08-24T18:04:33.916920Z', signDate: '2025-08-24T18:04:36.767125Z', signDataType: SignDataType.rawBytes, amount: null, signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19', message: 'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l\nIssued At: 2025-08-24T18:04:20.382Z', contractAddress: null, senderAddress: null, recipientAddress: null, signature: '0x3997909afb8abb9c5ead3e28d22c0cd9c435ecb012dae4fdb7449724178dd3172cb11bba680bebf29f6665d3188ce889ad36af264dab1081af49d704b2c9d70c'),
        // @formatter:on
      ];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });
  });

  group('Tests of TransactionsRepository.deleteByWallet()', () {
    test('Should [REMOVE transactions] if [wallet EXISTS] in database', () async {
      // Act
      await globalLocator<TransactionsRepository>().deleteByWallet(1);

      List<EthereumTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.ethereumTransactions.where().findAll();
      });

      // Assert
      List<EthereumTransactionEntity> expectedTransactionsDatabaseValue = <EthereumTransactionEntity>[];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });

    test('Should [REMOVE transactions] if [wallet EXISTS] in database', () async {
      // Act
      await globalLocator<TransactionsRepository>().deleteByWallet(2);

      List<SolanaTransactionEntity> actualTransactionsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.solanaTransactions.where().findAll();
      });

      // Assert
      List<SolanaTransactionEntity> expectedTransactionsDatabaseValue = <SolanaTransactionEntity>[];

      expect(actualTransactionsDatabaseValue, expectedTransactionsDatabaseValue);
    });
  });

  tearDown(testDatabase.close);
}
