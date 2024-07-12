import 'dart:typed_data';

import 'package:blockchain_utils/hex/hex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() async {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of WalletModelFactory.createNewWallet()', () {
    test('Should [return WalletModel] with initial values (database EMPTY)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.masterKeyOnlyDatabaseMock);

      // Act
      WalletModel actualWalletModel = await globalLocator<WalletModelFactory>().createNewWallet(WalletCreationRequestModel(
        index: 0,
        parentFilesystemPath: FilesystemPath.fromString('vault1/network1'),
        network: 'ethereum',
        derivationPath: "m/44'/118'/0'/0/0",
        publicKey: Uint8List.fromList(hex.decode('0252dab3c089ea59b9c9927c87453942ef67cd5be0bec9201ee5113c1de3bd4c7c')),
        privateKey: Uint8List.fromList(hex.decode('c7c4db3ed1c3115ee1029ceb0eb5dc76fe24935478c7299c9b95ae980c3bad2520')),
        name: 'NEW WALLET',
      ));

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'NEW WALLET',
        index: 0,
        address: '0x8556Df7F640632E6f255C439D07663Fc4EB39df1',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
      );

      expect(actualWalletModel, expectedWalletModel);
    });

    test('Should [return WalletModel] with initial values (database NOT EMPTY)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      WalletModel actualWalletModel = await globalLocator<WalletModelFactory>().createNewWallet(WalletCreationRequestModel(
        index: 5,
        parentFilesystemPath: FilesystemPath.fromString('vault1/network1'),
        network: 'ethereum',
        derivationPath: "m/44'/118'/0'/0/0",
        publicKey: Uint8List.fromList(hex.decode('0252dab3c089ea59b9c9927c87453942ef67cd5be0bec9201ee5113c1de3bd4c7c')),
        privateKey: Uint8List.fromList(hex.decode('c7c4db3ed1c3115ee1029ceb0eb5dc76fe24935478c7299c9b95ae980c3bad2520')),
        name: 'NEW WALLET',
      ));

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        id: 6,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet6'),
        name: 'NEW WALLET',
        index: 5,
        address: '0x8556Df7F640632E6f255C439D07663Fc4EB39df1',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
      );

      expect(actualWalletModel, expectedWalletModel);
    });
  });

  group('Tests of WalletModelFactory.createFromEntities()', () {
    test('Should [return List of WalletModel] from given List of WalletEntity', () async {
      // Arrange
      List<WalletEntity> actualWalletEntityList = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", network: 'ethereum', filesystemPathString: 'vault1/network1/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", network: 'ethereum', filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", network: 'ethereum', filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", network: 'ethereum', filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", network: 'ethereum', filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4'),
        // @formatter:on
      ];

      // Act
      List<WalletModel> actualWalletModelList = globalLocator<WalletModelFactory>().createFromEntities(actualWalletEntityList);

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        // @formatter:off
        WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'), name: 'WALLET 0'),
        WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2'), name: 'WALLET 1'),
        WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3'), name: 'WALLET 2'),
        WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
        WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });
  });

  group('Tests of WalletModelFactory.createFromEntity()', () {
    test('Should [return WalletModel] from given WalletEntity', () async {
      // Arrange
      WalletEntity actualWalletEntity = const WalletEntity(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        network: 'ethereum',
        filesystemPathString: 'vault1/network1/wallet1',
        name: 'WALLET 0',
      );

      // Act
      WalletModel actualWalletModel = globalLocator<WalletModelFactory>().createFromEntity(actualWalletEntity);

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        network: 'ethereum',
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      expect(actualWalletModel, expectedWalletModel);
    });
  });
}
