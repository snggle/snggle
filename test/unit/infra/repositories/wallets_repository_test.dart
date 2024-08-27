import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of WalletsRepository.getLastIndex()', () {
    test('Should [return last wallet index] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<WalletsRepository>().getLastIndex(FilesystemPath.fromString('vault1/network1'));

      // Assert
      int expectedLastIndex = 4;

      expect(actualLastIndex, expectedLastIndex);
    });

    test('Should [return NULL] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<WalletsRepository>().getLastIndex(FilesystemPath.fromString('vault1/network1'));

      // Assert
      expect(actualLastIndex, null);
    });
  });

  group('Tests of WalletsRepository.getAllDerivationPaths()', () {
    test('Should [return List of all derivation paths] if [database NOT EMPTY] and [FilesystemPath EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<String> actualDerivationPaths = await globalLocator<WalletsRepository>().getAllDerivationPaths(const FilesystemPath.empty());

      // Assert
      List<String> expectedDerivationPaths = <String>[
        "m/44'/60'/0'/0/0",
        "m/44'/60'/0'/0/1",
        "m/44'/60'/0'/0/2",
        "m/44'/60'/0'/0/3",
        "m/44'/60'/0'/0/4",
      ];

      expect(actualDerivationPaths, expectedDerivationPaths);
    });

    test('Should [return List of derivation paths] if [database NOT EMPTY] and [FilesystemPath NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<String> actualDerivationPaths = await globalLocator<WalletsRepository>().getAllDerivationPaths(FilesystemPath.fromString('vault1/network1/group3/'));

      // Assert
      List<String> expectedDerivationPaths = <String>[
        "m/44'/60'/0'/0/3",
        "m/44'/60'/0'/0/4",
      ];

      expect(actualDerivationPaths, expectedDerivationPaths);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<String> actualDerivationPaths = await globalLocator<WalletsRepository>().getAllDerivationPaths(const FilesystemPath.empty());

      // Assert
      List<String> expectedDerivationPaths = <String>[];

      expect(actualDerivationPaths, expectedDerivationPaths);
    });
  });

  group('Tests of WalletsRepository.getAll()', () {
    test('Should [return List of WalletEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAll();

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });
  });

  group('Tests of WalletsRepository.getAllByParentPath()', () {
    test('Should [return List of WalletEntity] if [wallets with specified path NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAllByParentPath(
        FilesystemPath.fromString('vault1/network1/group3'),
      );

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });

    test('Should [return EMPTY list] if [wallets with specified path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<WalletEntity> actualWalletEntityList = await globalLocator<WalletsRepository>().getAllByParentPath(FilesystemPath.fromString('vault1/network1'));

      // Assert
      List<WalletEntity> expectedWalletEntityList = <WalletEntity>[];

      expect(actualWalletEntityList, expectedWalletEntityList);
    });
  });

  group('Tests of WalletsRepository.getById()', () {
    test('Should [return WalletEntity] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      WalletEntity actualWalletEntity = await globalLocator<WalletsRepository>().getById(1);

      // Assert
      WalletEntity expectedWalletEntity = const WalletEntity(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPathString: 'vault1/network1/wallet1',
        name: 'WALLET 0',
      );

      expect(actualWalletEntity, expectedWalletEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<WalletsRepository>().getById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletsRepository.save()', () {
    test('Should [UPDATE wallet] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      WalletEntity actualUpdatedWalletEntity = const WalletEntity(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        index: 0,
        address: '0x0000000000000000000000000000000000000000',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPathString: 'vault1/network1/wallet1',
        name: 'UPDATED WALLET 0',
      );

      // Act
      await globalLocator<WalletsRepository>().save(actualUpdatedWalletEntity);

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

      WalletEntity actualNewWalletEntity = const WalletEntity(
        id: 999999,
        encryptedBool: true,
        pinnedBool: true,
        index: 999999,
        address: '0x0000000000000000000000000000000000000000',
        derivationPath: "m/44'/60'/0'/0/0",
        filesystemPathString: 'vault1/network1/wallet999999',
        name: 'NEW WALLET 0',
      );

      // Act
      await globalLocator<WalletsRepository>().save(actualNewWalletEntity);

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

  group('Tests of WalletsRepository.saveAll()', () {
    test('Should [UPDATE wallets] if [wallets EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<WalletEntity> actualWalletsToUpdate = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'UPDATED WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: true, pinnedBool: true, index: 1, address: '0x1111111111111111111111111111111111111111', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'UPDATED WALLET 1'),
        // @formatter:on
      ];

      // Act
      await globalLocator<WalletsRepository>().saveAll(actualWalletsToUpdate);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet1', name: 'UPDATED WALLET 0'),
        const WalletEntity(id: 2, encryptedBool: true, pinnedBool: true, index: 1, address: '0x1111111111111111111111111111111111111111', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'UPDATED WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });

    test('Should [SAVE wallets] if [wallets NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<WalletEntity> actualWalletsToSave = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 999998, encryptedBool: true, pinnedBool: true, index: 999998, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet999998', name: 'NEW WALLET 0'),
        const WalletEntity(id: 999999, encryptedBool: true, pinnedBool: true, index: 999999, address: '0x1111111111111111111111111111111111111111', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet999999', name: 'NEW WALLET 1'),
        // @formatter:on
      ];

      // Act
      await globalLocator<WalletsRepository>().saveAll(actualWalletsToSave);

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
        const WalletEntity(id: 999998, encryptedBool: true, pinnedBool: true, index: 999998, address: '0x0000000000000000000000000000000000000000', derivationPath: "m/44'/60'/0'/0/0", filesystemPathString: 'vault1/network1/wallet999998', name: 'NEW WALLET 0'),
        const WalletEntity(id: 999999, encryptedBool: true, pinnedBool: true, index: 999999, address: '0x1111111111111111111111111111111111111111', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet999999', name: 'NEW WALLET 1'),
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });
  });

  group('Tests of WalletsRepository.deleteById()', () {
    test('Should [REMOVE wallet] if [wallet EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<WalletsRepository>().deleteById(1);

      List<WalletEntity> actualWalletsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.wallets.where().findAll();
      });

      // Assert
      List<WalletEntity> expectedWalletsDatabaseValue = <WalletEntity>[
        // @formatter:off
        const WalletEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPathString: 'vault1/network1/wallet2', name: 'WALLET 1'),
        const WalletEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPathString: 'vault1/network1/wallet3', name: 'WALLET 2'),
        const WalletEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPathString: 'vault1/network1/group3/wallet4', name: 'WALLET 3'),
        const WalletEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPathString: 'vault1/network1/group3/wallet5', name: 'WALLET 4')
        // @formatter:on
      ];

      expect(actualWalletsDatabaseValue, expectedWalletsDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [wallet NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<WalletsRepository>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(testDatabase.close);
}