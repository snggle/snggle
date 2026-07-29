import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/shared/objectbox/objectbox.g.dart';

void main() {
  test('generates TransactionsDatabaseMock ObjectBox fixture', () async {
    final Directory outputDirectory = Directory(p.join('test', 'mocks', 'fullDatabaseMock', 'objectbox_mock'));
    final File outputDatabaseFile = File(p.join('test', 'mocks', 'fullDatabaseMock', 'objectbox_mock.mdb'));

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

      expect(store.box<VaultEntity>().count(), 5);
      expect(store.box<WalletEntity>().count(), 6);
      expect(store.box<NetworkGroupEntity>().count(), 10);
      expect(store.box<EthereumTransactionEntity>().count(), 0);
      expect(store.box<SolanaTransactionEntity>().count(), 0);
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
    final Box<GroupEntity> groupBox = store.box<GroupEntity>();
    //final Box<EmbeddedNetworkTemplateEntity> embeddedNetworkTemplateBox = store.box<EmbeddedNetworkTemplateEntity>();
    final Box<EthereumTransactionEntity> ethereumTransactionBox = store.box<EthereumTransactionEntity>();
    final Box<SolanaTransactionEntity> solanaTransactionBox = store.box<SolanaTransactionEntity>();

    ethereumTransactionBox.removeAll();
    solanaTransactionBox.removeAll();
    walletBox.removeAll();
    networkGroupBox.removeAll();
    //embeddedNetworkTemplateBox.removeAll();
    vaultBox
      ..removeAll()
      ..putMany(
        <VaultEntity>[
          VaultEntity(
            id: 0,
            encryptedBool: false,
            filesystemPathString: 'vault1',
            fingerprint: '2429747484',
            index: 0,
            name: 'VAULT 1',
            pinnedBool: false,
          ),
          VaultEntity(
            id: 0,
            encryptedBool: false,
            filesystemPathString: 'vault2',
            fingerprint: '2619341544',
            index: 1,
            name: 'VAULT 2',
            pinnedBool: false,
          ),
          VaultEntity(
            id: 0,
            encryptedBool: false,
            filesystemPathString: 'vault3',
            fingerprint: '405998762',
            index: 2,
            name: 'VAULT 3',
            pinnedBool: false,
          ),
          VaultEntity(
            id: 0,
            encryptedBool: false,
            filesystemPathString: 'group1/vault4',
            fingerprint: '1024969286',
            index: 3,
            name: 'VAULT 4',
            pinnedBool: false,
          ),
          VaultEntity(
            id: 0,
            encryptedBool: false,
            filesystemPathString: 'group1/vault5',
            fingerprint: '1980042394',
            index: 4,
            name: 'VAULT 5',
            pinnedBool: false,
          ),
        ],
      );

    networkGroupBox.putMany(<NetworkGroupEntity>[
      NetworkGroupEntity(
          id: 0, encryptedBool: false, filesystemPathString: 'vault1/network1', name: 'Ethereum1', pinnedBool: false, dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0, encryptedBool: false, filesystemPathString: 'vault2/network2', name: 'Ethereum2', pinnedBool: false, dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0, encryptedBool: false, filesystemPathString: 'vault3/network3', name: 'Ethereum3', pinnedBool: false, dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'group1/vault4/network4',
          name: 'Ethereum4',
          pinnedBool: false,
          dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'group1/vault5/network5',
          name: 'Ethereum5',
          pinnedBool: false,
          dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'vault1/group2/network6',
          name: 'Ethereum6',
          pinnedBool: false,
          dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0, encryptedBool: false, filesystemPathString: 'vault1/network7', name: 'Ethereum7', pinnedBool: false, dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'vault1/group2/network8',
          name: 'Ethereum8',
          pinnedBool: false,
          dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0, encryptedBool: false, filesystemPathString: 'vault1/network9', name: 'Ethereum9', pinnedBool: false, dbNetworkType: 'ethereum'),
      NetworkGroupEntity(
          id: 0, encryptedBool: false, filesystemPathString: 'vault1/network10', name: 'Solana1', pinnedBool: false, dbNetworkType: 'solana'),
    ]);

    groupBox.putMany(
      <GroupEntity>[
        GroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'group1',
          name: 'VAULTS GROUP 1',
          pinnedBool: false,
        ),
        GroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'vault1/group2',
          name: 'NETWORKS GROUP 1',
          pinnedBool: false,
        ),
        GroupEntity(
          id: 0,
          encryptedBool: false,
          filesystemPathString: 'vault1/network1/group3',
          name: 'WALLETS GROUP 1',
          pinnedBool: false,
        )
      ],
    );

    walletBox.putMany(<WalletEntity>[
      WalletEntity(
        id: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        encryptedBool: false,
        filesystemPathString: 'vault1/network1/wallet1',
        name: 'WALLET 0',
        pinnedBool: false,
      ),
      WalletEntity(
        id: 0,
        address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686',
        derivationPath: "m/44'/60'/0'/0/1",
        encryptedBool: false,
        filesystemPathString: 'vault1/network1/wallet2',
        name: 'WALLET 1',
        pinnedBool: false,
      ),
      WalletEntity(
        id: 0,
        address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD',
        derivationPath: "m/44'/60'/0'/0/2",
        encryptedBool: false,
        filesystemPathString: 'vault1/network1/wallet3',
        name: 'WALLET 2',
        pinnedBool: false,
      ),
      WalletEntity(
        id: 0,
        address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c',
        derivationPath: "m/44'/60'/0'/0/3",
        encryptedBool: false,
        filesystemPathString: 'vault1/network1/group3/wallet4',
        name: 'WALLET 3',
        pinnedBool: false,
      ),
      WalletEntity(
        id: 0,
        address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639',
        derivationPath: "m/44'/60'/0'/0/4",
        encryptedBool: false,
        filesystemPathString: 'vault1/network1/group3/wallet5',
        name: 'WALLET 4',
        pinnedBool: false,
      ),
      WalletEntity(
        id: 0,
        address: '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19',
        derivationPath: "m/44'/501'/0'/0'",
        encryptedBool: false,
        filesystemPathString: 'vault1/network10/wallet6',
        name: 'WALLET 5',
        pinnedBool: false,
      ),
    ]);
  });
}
