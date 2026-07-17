import 'dart:io';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/objectbox.g.dart';

void main() {
  test('generates TransactionsDatabaseMock ObjectBox fixture', () async {
    final Directory outputDirectory = Directory(p.join('test', 'mocks', 'transactionsDatabaseMock', 'objectbox_mock'));
    final File outputDatabaseFile = File(p.join('test', 'mocks', 'transactionsDatabaseMock', 'objectbox_mock.mdb'));

    if (outputDirectory.existsSync()) {
      outputDirectory.deleteSync(recursive: true);
    }

    if (outputDatabaseFile.existsSync()) {
      outputDatabaseFile.deleteSync();
    }

    outputDirectory.createSync(recursive: true);

    final Store store = Store(
      getObjectBoxModel(),
      directory: outputDirectory.path,
    );

    try {
      seedTransactionsDatabaseMock(store);

      expect(store.box<VaultEntity>().count(), 1);
      expect(store.box<WalletEntity>().count(), 2);
      expect(store.box<NetworkGroupEntity>().count(), 2);
      expect(store.box<EthereumTransactionEntity>().count(), 4);
      expect(store.box<SolanaTransactionEntity>().count(), 2);
    } finally {
      store.close();
    }

    final File generatedDatabaseFile = File(p.join(outputDirectory.path, 'data.mdb'));

    expect(generatedDatabaseFile.existsSync(), true);

    generatedDatabaseFile.copySync(outputDatabaseFile.path);
    outputDirectory.deleteSync(recursive: true);

    print('Generated ObjectBox database mock at: ${outputDatabaseFile.absolute.path}');
  });
}

void seedTransactionsDatabaseMock(Store store) {
  store.runInTransaction(TxMode.write, () {
    final Box<VaultEntity> vaultBox = store.box<VaultEntity>();
    final Box<WalletEntity> walletBox = store.box<WalletEntity>();
    final Box<NetworkGroupEntity> networkGroupBox = store.box<NetworkGroupEntity>();
    final Box<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateBox = store.box<EmbeddedNetworkTemplateEntity>();
    final Box<EthereumTransactionEntity> ethereumTransactionBox = store.box<EthereumTransactionEntity>();
    final Box<SolanaTransactionEntity> solanaTransactionBox = store.box<SolanaTransactionEntity>();

    ethereumTransactionBox.removeAll();
    solanaTransactionBox.removeAll();
    walletBox.removeAll();
    networkGroupBox.removeAll();
    embeddedNetworkTemplateBox.removeAll();
    vaultBox
      ..removeAll()
      ..put(
        VaultEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'vault1',
          fingerprint: '1024969286',
          index: 0,
          name: 'New_Vault_0',
          pinnedBool: false,
        ),
      );

    final EmbeddedNetworkTemplateEntity ethereumTemplate = EmbeddedNetworkTemplateEntity(
      id: 0,
      addressEncoderType: 'ethereum(false)',
      dbCurveType: 'secp256k1',
      derivationPathTemplate: "m/44'/60'/0'/0/{{i}}",
      derivatorType: 'secp256k1',
      name: 'Ethereum',
      dbNetworkIconType: 'ethereum',
      dbNetworkType: 'ethereum',
      dbWalletType: 'legacy',
    );

    final EmbeddedNetworkTemplateEntity solanaTemplate = EmbeddedNetworkTemplateEntity(
      id: 0,
      addressEncoderType: 'solana()',
      dbCurveType: 'ed25519',
      derivationPathTemplate: "m/44'/501'/{{i}}'/0'",
      derivatorType: 'ed25519',
      name: 'Solana',
      dbNetworkIconType: 'solana',
      dbNetworkType: 'solana',
      dbWalletType: 'legacy',
    );

    embeddedNetworkTemplateBox.putMany(<EmbeddedNetworkTemplateEntity>[
      ethereumTemplate,
      solanaTemplate,
    ]);

    networkGroupBox.putMany(<NetworkGroupEntity>[
      NetworkGroupEntity(
        id: 0,
        encryptedBool: false,
        filesystemPathString: 'vault1/network1',
        name: 'Ethereum',
        pinnedBool: false,
        embeddedNetworkTemplate: ethereumTemplate,
      ),
      NetworkGroupEntity(
        id: 0,
        encryptedBool: false,
        filesystemPathString: 'vault1/network2',
        name: 'Solana',
        pinnedBool: false,
        embeddedNetworkTemplate: solanaTemplate,
      ),
    ]);

    final List<int> walletIds = walletBox.putMany(<WalletEntity>[
      WalletEntity(
        id: 0,
        address: '0x03f04cb5D332ecCB602D8eFe463C921140CFcA09',
        derivationPath: "m/44'/60'/0'/0/0",
        encryptedBool: false,
        filesystemPathString: 'vault1/network1/wallet1',
        name: 'WALLET 0',
        pinnedBool: false,
      ),
      WalletEntity(
        id: 0,
        address: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        derivationPath: "m/44'/501'/0'/0'",
        encryptedBool: false,
        filesystemPathString: 'vault1/network2/wallet2',
        name: 'WALLET 1',
        pinnedBool: false,
      ),
    ]);

    final int ethereumWalletId = walletIds[0];
    final int solanaWalletId = walletIds[1];

    ethereumTransactionBox.putMany(<EthereumTransactionEntity>[
      EthereumTransactionEntity(
        id: 0,
        walletId: ethereumWalletId,
        creationDate: '2024-08-02T08:49:32.089322Z',
        signDataType: SignDataType.values[1],
        amount: '0.019321570386261305 ETH',
        fee: '0.0001360611596022 ETH',
        contractAddress: null,
        functionData: null,
        message: null,
        recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        signDate: '2024-08-02T08:49:33.209288Z',
        signature:
            '0x42eded7c70890e1a7ec6705745164875edeba29d985ebe9cf3cf8eae3b40b3455087553feeb1d5f9a8afd99411378ad2a833daeda9e7a628ac997ac629639ca101',
      ),
      EthereumTransactionEntity(
        id: 0,
        walletId: ethereumWalletId,
        creationDate: '2024-08-02T08:49:35.922761Z',
        signDataType: SignDataType.values[1],
        amount: '37510516893',
        fee: '0.00032559980259381 ETH',
        contractAddress: '0xa0b73e1ff0b80914ab6fe0444e65848c4c34450b',
        functionData:
            '0xa9059cbb00000000000000000000000053Bf0A18754873A8102625D8225AF6a15a43423C00000000000000000000000000000000000000000000000000000008bbcd109d',
        message: null,
        recipientAddress: '0x53Bf0A18754873A8102625D8225AF6a15a43423C',
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        signDate: '2024-08-02T08:49:36.621694Z',
        signature:
            '0x5aea02ee3a2b95fdbbdfbdc61c408a3cff8ea633a893639f2ee5c69adaba1600020b0d592fdcd43a9cafa53ec2c66f4d1189c83c7cab716d8ab7274da50dba1901',
      ),
      EthereumTransactionEntity(
        id: 0,
        walletId: ethereumWalletId,
        creationDate: '2024-08-02T08:49:48.001235Z',
        signDataType: SignDataType.values[0],
        amount: null,
        fee: null,
        contractAddress: null,
        functionData: null,
        message:
            'Welcome to OpenSea!\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:\n0x03f04cb5d332eccb602d8efe463c921140cfca09\n\nNonce:\n37b61cff-7238-457f-b9da-bdb78356f0b2',
        recipientAddress: null,
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        signDate: '2024-08-02T08:49:49.236407Z',
        signature:
            '0x78742b7c719af4244a4a43bd4499fd7be872b16a3dddd4dc75f5c70c89ba3d4879fc210bc79d2a8279567beeab1d3edcddea284219744788bba29eb38e3755f41c',
      ),
      EthereumTransactionEntity(
        id: 0,
        walletId: ethereumWalletId,
        creationDate: '2024-08-02T08:50:06.549602Z',
        signDataType: SignDataType.values[1],
        amount: '0.019321570386261305 ETH',
        fee: '0.001496331786753402 ETH',
        contractAddress: '0x3fc91a3afd70395cd496c647d5a6cc9d4b2b7fad',
        functionData:
            '0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000667aac7700000000000000000000000000000000000000000000000000000000000000040b080604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000280000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000044a4ddab603539000000000000000000000000000000000000000000000000000000004ceda9bf00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f8000000000000000000000000000000fee13a103a10d593b9ae06b3e05f2e7e1c0000000000000000000000000000000000000000000000000000000000000019000000000000000000000000000000000000000000000000000000000000006000000000000000000000000016980b3b4a3f9d89e33311b5aa8f80303e5ca4f80000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000004cbc6dcd',
        message: null,
        recipientAddress: null,
        senderAddress: '0x03f04cb5d332eccb602d8efe463c921140cfca09',
        signDate: '2024-08-02T08:50:07.539410Z',
        signature:
            '0xb1e99ac9e84fec90600c56f24a553b90d50ee7d6d4e934e174fe7a02187422a83ad818822da386a21f81a478b52a3fbcbad205b61863945ed54697f2beab278e01',
      ),
    ]);

    solanaTransactionBox.putMany(<SolanaTransactionEntity>[
      SolanaTransactionEntity(
        id: 0,
        walletId: solanaWalletId,
        creationDate: '2025-09-09T08:53:19.566569Z',
        signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signDataType: SignDataType.values[1],
        amount: '1 SOL',
        contractAddress: null,
        message: null,
        recipientAddress: '6VWUtQiEbSXy6viXkxs7xywevQJXruVD1NmhX4akdC1Z',
        senderAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signDate: '2025-09-09T09:15:36.512800Z',
        signature:
            '0x62f39fd988858b02dbbd2668480e6a8ae9968211254294d526bb55e671f275e1d7856e54d7cba4a6d2dfb8d1f33f767c8723dfa808b3ba45b92d85a5a4559c0b',
        transactionData:
            '0x010002041d03d401085ece51cf8df279aca8ed6d2d4a948417b90d4d1540545e141858f4519808055de375e1951892abb0b8341f73632ff23f9668773a30f4ca34cd7b5c00000000000000000000000000000000000000000000000000000000000000000306466fe5211732ffecadba72c39be7bc8ce5bbc5f7126b2c439b3a400000003aacc177d1e979ccaa6af5ec31bd72f2521ba73bc95c6cb19d139782dcb24ee00303000903002d31010000000003000502ef010000020200010c0200000000ca9a3b00000000',
      ),
      SolanaTransactionEntity(
        id: 0,
        walletId: solanaWalletId,
        creationDate: '2025-08-24T18:04:33.916920Z',
        signerAddress: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        signDataType: SignDataType.values[0],
        amount: null,
        contractAddress: null,
        message:
            'opensea.io wants you to sign in with your account:\n2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19\n\nClick to sign in and accept the OpenSea Terms of Service (https://opensea.io/tos) and Privacy Policy (https://opensea.io/privacy).\n\nURI: https://opensea.io/\nVersion: 1\nChain ID: 1\nNonce: rcil64cq0m5lrml5ogstsegg9l\nIssued At: 2025-08-24T18:04:20.382Z',
        recipientAddress: null,
        senderAddress: null,
        signDate: '2025-08-24T18:04:36.767125Z',
        signature:
            '0x3997909afb8abb9c5ead3e28d22c0cd9c435ecb012dae4fdb7449724178dd3172cb11bba680bebf29f6665d3188ce889ad36af264dab1081af49d704b2c9d70c',
        transactionData: null,
      ),
    ]);
  });
}
