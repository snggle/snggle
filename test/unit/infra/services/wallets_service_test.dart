import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of WalletsService.getAllByParentPath()', () {
    test('Should [return List of WalletModel] [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: false);

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        // @formatter:off
        WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'), name: 'WALLET 0'),
        WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2'), name: 'WALLET 1'),
        WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3'), name: 'WALLET 2'),
        WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
        WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return List of WalletModel] [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        FilesystemPath.fromString('vault1/network1'),
        firstLevelBool: true,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[
        // @formatter:off
        WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'), name: 'WALLET 0'),
        WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2'), name: 'WALLET 1'),
        WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3'), name: 'WALLET 2'),
        // @formatter:on
      ];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return EMPTY list] if [given path IS EMPTY] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        FilesystemPath.fromString('vault1/network1'),
        firstLevelBool: false,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[];

      expect(actualWalletModelList, expectedWalletModelList);
    });

    test('Should [return EMPTY list] if [given path IS EMPTY] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<WalletModel> actualWalletModelList = await globalLocator<WalletsService>().getAllByParentPath(
        FilesystemPath.fromString('vault1/network1'),
        firstLevelBool: true,
      );

      // Assert
      List<WalletModel> expectedWalletModelList = <WalletModel>[];

      expect(actualWalletModelList, expectedWalletModelList);
    });
  });

  group('Tests of WalletsService.getById()', () {
    test('Should [return WalletModel] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      WalletModel actualWalletModel = await globalLocator<WalletsService>().getById(1);

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      expect(actualWalletModel, expectedWalletModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<WalletsService>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsService.move()', () {
    test('Should [MOVE wallet] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<WalletsService>().move(
        WalletModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          index: 0,
          address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
          derivationPath: "m/44'/60'/0'/0/0",
          filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
          name: 'WALLET 0',
        ),
        FilesystemPath.fromString('new/wallet/path/wallet1'),
      );

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'new/wallet/path/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });
  });

  group('Tests of WalletsService.moveAllByParentPath()', () {
    test('Should [MOVE wallets] with provided parent path', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<WalletsService>().moveAllByParentPath(
        FilesystemPath.fromString('vault1/network1/group3'),
        FilesystemPath.fromString('new/wallet/path'),
      );

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'new/wallet/path/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'new/wallet/path/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });
  });

  group('Tests of WalletsService.save()', () {
    test('Should [UPDATE wallet] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      WalletModel actualUpdatedWalletModel = WalletModel(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        index: 0,
        address: '0x0000000000000000000000000000000000000000',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'UPDATED WALLET 0',
      );

      // Act
      await globalLocator<WalletsService>().save(actualUpdatedWalletModel);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'UPDATED WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });

    test('Should [SAVE wallet] if [wallet NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      WalletModel actualNewWalletModel = WalletModel(
        id: 999999,
        encryptedBool: true,
        pinnedBool: true,
        index: 999999,
        address: '0x0000000000000000000000000000000000000000',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet999999'),
        name: 'NEW WALLET 0',
      );

      // Act
      await globalLocator<WalletsService>().save(actualNewWalletModel);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4'),
        const WalletEntity(id: 999999, encryptedBool: true, pinnedBool: true, index: 999999, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet999999', name: 'NEW WALLET 0')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });
  });

  group('Tests of WalletsService.saveAll()', () {
    test('Should [UPDATE wallets] if [wallets EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<WalletModel> actualWalletsToUpdate = <WalletModel>[
        // @formatter:off
        WalletModel(id: 1, encryptedBool: true, pinnedBool: true, index: 0, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'), name: 'UPDATED WALLET 0'),
        WalletModel(id: 2, encryptedBool: true, pinnedBool: true, index: 1, address: '0x0000000000000000000000000000000000000001', derivationPath: "m/44'/60'/0'/0/1", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2'), name: 'UPDATED WALLET 1'),
        // @formatter:on
      ];

      // Act
      await globalLocator<WalletsService>().saveAll(actualWalletsToUpdate);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'UPDATED WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: true, pinnedBool: true, index: 1, address: '0x0000000000000000000000000000000000000001', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'UPDATED WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });

    test('Should [SAVE wallets] if [wallets NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<WalletModel> actualWalletsToUpdate = <WalletModel>[
        // @formatter:off
        WalletModel(id: 99998, encryptedBool: true, pinnedBool: true, index: 99998, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet99998'), name: 'NEW WALLET 0'),
        WalletModel(id: 99999, encryptedBool: true, pinnedBool: true, index: 99999, address: '0x0000000000000000000000000000000000000001', derivationPath: "m/44'/60'/0'/0/1", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet99999'), name: 'NEW WALLET 1'),
        // @formatter:on
      ];

      // Act
      await globalLocator<WalletsService>().saveAll(actualWalletsToUpdate);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4'),
        const WalletEntity(id: 99998, encryptedBool: true, pinnedBool: true, index: 99998, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet99998', name: 'NEW WALLET 0'),
        const WalletEntity(id: 99999, encryptedBool: true, pinnedBool: true, index: 99999, address: '0x0000000000000000000000000000000000000001', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet99999', name: 'NEW WALLET 1')
        // @formatter:on
      ];
      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });
  });

  group('Tests of WalletsService.deleteAllByParentPath()', () {
    test('Should [REMOVE wallets] if [wallets with path EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<WalletsService>().deleteAllByParentPath(FilesystemPath.fromString('vault1/network1/group3'));

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });

    test('Should [REMOVE ALL wallets] if [path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<WalletsService>().deleteAllByParentPath(const FilesystemPath.empty());

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });
  });

  group('Tests of WalletsService.deleteById()', () {
    test('Should [REMOVE wallet] if [wallet EXISTS] in collection', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<WalletsService>().deleteById(1);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4'),
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet UUID NOT EXISTS] in collection', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<WalletsService>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsService.getByAddress()', () {
    test('Should [return WalletModel] if [wallet address EXISTS] in collection', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      WalletModel? actualWalletModel = await globalLocator<WalletsService>().getByAddress('0x4BD51C77E08Ac696789464A079cEBeE203963Dce');

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'),
        name: 'WALLET 0',
      );

      expect(actualWalletModel, expectedWalletModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet address NOT EXISTS] in collection', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<WalletsService>().getByAddress('0x000000000000000000000000000000000000dEaD'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsService.getLastIndex()', () {
    test('Should [return last wallet index] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int actualLastIndex = await globalLocator<WalletsService>().getLastIndex(FilesystemPath.fromString('vault1/network1'));

      // Assert
      expect(actualLastIndex, 4);
    });

    test('Should [return -1] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      int actualLastIndex = await globalLocator<WalletsService>().getLastIndex(FilesystemPath.fromString('vault1/network1'));

      // Assert
      expect(actualLastIndex, -1);
    });
  });

  group('Tests of WalletsService.getLastDerivationIndex()', () {
    test('Should [return last derivation index] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int actualLastDerivationIndex = await globalLocator<WalletsService>().getLastDerivationIndex(FilesystemPath.fromString('vault1/network1'));

      // Assert
      expect(actualLastDerivationIndex, 4);
    });

    test('Should [return -1] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      int actualLastDerivationIndex = await globalLocator<WalletsService>().getLastDerivationIndex(FilesystemPath.fromString('vault1/network1'));

      // Assert
      expect(actualLastDerivationIndex, -1);
    });
  });

  group('Tests of WalletsService.isDerivationPathExists()', () {
    test('Should [return TRUE] if [derivation path EXISTS] for specified FilesystemPath', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool actualDerivationPathExistsBool = await globalLocator<WalletsService>().isDerivationPathExists(
        FilesystemPath.fromString('vault1/network1'),
        "m/44'/60'/0'/0/0",
      );

      // Assert
      expect(actualDerivationPathExistsBool, true);
    });

    test('Should [return FALSE] if [derivation path NOT EXISTS] for specified FilesystemPath', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      bool actualDerivationPathExistsBool = await globalLocator<WalletsService>().isDerivationPathExists(
        FilesystemPath.fromString('vault1/network1'),
        "m/99999'/99999/99999",
      );

      // Assert
      expect(actualDerivationPathExistsBool, false);
    });
  });

  group('Tests of WalletsService.updateFilesystemPath()', () {
    test('Should [return updated WalletModel] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      WalletModel? actualWalletModel = await globalLocator<WalletsService>().updateFilesystemPath(1, FilesystemPath.fromString('new/wallet/path'));

      // Assert
      WalletModel expectedWalletModel = WalletModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPath: FilesystemPath.fromString('new/wallet/path/wallet1'),
        name: 'WALLET 0',
      );

      expect(actualWalletModel, expectedWalletModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        globalLocator<WalletsService>().updateFilesystemPath(99999, FilesystemPath.fromString('new/wallet/path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(testDatabase.close);
}
