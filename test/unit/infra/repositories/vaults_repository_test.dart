import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of VaultsRepository.getLastIndex()', () {
    test('Should [return last vault index] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<VaultsRepository>().getLastIndex();

      // Assert
      int expectedLastIndex = 4;

      expect(actualLastIndex, expectedLastIndex);
    });

    test('Should [return NULL] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<VaultsRepository>().getLastIndex();

      // Assert
      expect(actualLastIndex, null);
    });
  });

  group('Tests of VaultsRepository.getAll()', () {
    test('Should [return List of VaultEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });
  });

  group('Tests of VaultsRepository.getAllByParentPath()', () {
    test('Should [return List of VaultEntity] if [vaults with specified path NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAllByParentPath(FilesystemPath.fromString('group1'));

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });

    test('Should [return EMPTY list] if [vaults with specified path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAllByParentPath(FilesystemPath.fromString('group1'));

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });
  });

  group('Tests of VaultsRepository.getById()', () {
    test('Should [return VaultEntity] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      VaultEntity actualVaultEntity = await globalLocator<VaultsRepository>().getById(1);

      // Assert
      VaultEntity expectedVaultEntity = const VaultEntity(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPathString: 'vault1',
        name: 'VAULT 1',
      );

      expect(actualVaultEntity, expectedVaultEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<VaultsRepository>().getById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsRepository.save()', () {
    test('Should [UPDATE vault] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      VaultEntity actualUpdatedVaultEntity = const VaultEntity(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        index: 0,
        filesystemPathString: 'vault1',
        name: 'UPDATED VAULT 1',
      );

      // Act
      await globalLocator<VaultsRepository>().save(actualUpdatedVaultEntity);

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, filesystemPathString: 'vault1', name: 'UPDATED VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });

    test('Should [SAVE vault] if [vault NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      VaultEntity actualNewVaultEntity = const VaultEntity(
        id: 999999,
        encryptedBool: true,
        pinnedBool: true,
        index: 999999,
        filesystemPathString: 'vault999999',
        name: 'NEW VAULT 1',
      );

      // Act
      await globalLocator<VaultsRepository>().save(actualNewVaultEntity);

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5'),
        const VaultEntity(id: 999999, encryptedBool: true, pinnedBool: true, index: 999999, filesystemPathString: 'vault999999', name: 'NEW VAULT 1')
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });
  });

  group('Tests of VaultsRepository.saveAll()', () {
    test('Should [UPDATE vaults] if [vaults EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<VaultEntity> actualVaultsToUpdate = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, filesystemPathString: 'vault1', name: 'UPDATED VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: true, pinnedBool: true, index: 1, filesystemPathString: 'vault2', name: 'UPDATED VAULT 2'),
      ];

      // Act
      await globalLocator<VaultsRepository>().saveAll(actualVaultsToUpdate);

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: true, pinnedBool: true, index: 0, filesystemPathString: 'vault1', name: 'UPDATED VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: true, pinnedBool: true, index: 1, filesystemPathString: 'vault2', name: 'UPDATED VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });

    test('Should [SAVE vaults] if [vaults NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<VaultEntity> actualVaultsToUpdate = <VaultEntity>[
        const VaultEntity(id: 999998, encryptedBool: true, pinnedBool: true, index: 999998, filesystemPathString: 'vault999998', name: 'NEW VAULT 1'),
        const VaultEntity(id: 999999, encryptedBool: true, pinnedBool: true, index: 999999, filesystemPathString: 'vault999999', name: 'NEW VAULT 2'),
      ];

      // Act
      await globalLocator<VaultsRepository>().saveAll(actualVaultsToUpdate);

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5'),
        const VaultEntity(id: 999998, encryptedBool: true, pinnedBool: true, index: 999998, filesystemPathString: 'vault999998', name: 'NEW VAULT 1'),
        const VaultEntity(id: 999999, encryptedBool: true, pinnedBool: true, index: 999999, filesystemPathString: 'vault999999', name: 'NEW VAULT 2'),
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });
  });

  group('Tests of VaultsRepository.deleteById()', () {
    test('Should [REMOVE vault] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<VaultsRepository>().deleteById(1);

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<VaultsRepository>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
