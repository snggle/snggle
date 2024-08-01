import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of GroupsRepository.getAll()', () {
    test('Should [return List of GroupEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAll();

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAll();

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });
  });

  group('Tests of GroupsRepository.getAllByParentPath()', () {
    test('Should [return List of GroupEntity] if [groups with specified path NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAllByParentPath(FilesystemPath.fromString('vault1/network1/'));

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });

    test('Should [return EMPTY list] if [group with specified path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAllByParentPath(FilesystemPath.fromString('vault1/network1/'));

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });
  });

  group('Tests of GroupsRepository.getById()', () {
    test('Should [return GroupEntity] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      GroupEntity actualGroupEntity = await globalLocator<GroupsRepository>().getById(1);

      // Assert
      GroupEntity expectedGroupEntity = const GroupEntity(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPathString: 'group1',
        name: 'VAULTS GROUP 1',
      );

      expect(actualGroupEntity, expectedGroupEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<GroupsRepository>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of GroupsRepository.getByPath()', () {
    test('Should [return GroupEntity] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      GroupEntity actualGroupEntity = await globalLocator<GroupsRepository>().getByPath(FilesystemPath.fromString('vault1/network1/group3'));

      // Assert
      GroupEntity expectedGroupEntity = const GroupEntity(
        id: 3,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPathString: 'vault1/network1/group3',
        name: 'WALLETS GROUP 1',
      );

      expect(actualGroupEntity, expectedGroupEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<GroupsRepository>().getByPath(FilesystemPath.fromString('not_existing_path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of GroupsRepository.save()', () {
    test('Should [UPDATE group] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      GroupEntity actualUpdatedGroupEntity = const GroupEntity(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        filesystemPathString: 'group1',
        name: 'UPDATED VAULTS GROUP 1',
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualUpdatedGroupEntity);

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: true, pinnedBool: true, filesystemPathString: 'group1', name: 'UPDATED VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });

    test('Should [SAVE group] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      GroupEntity actualUpdatedGroupEntity = const GroupEntity(
        id: 99999,
        encryptedBool: true,
        pinnedBool: true,
        filesystemPathString: 'group1',
        name: 'NEW VAULTS GROUP 1',
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualUpdatedGroupEntity);

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1'),
        const GroupEntity(id: 99999, encryptedBool: true, pinnedBool: true, filesystemPathString: 'group1', name: 'NEW VAULTS GROUP 1'),
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });
  });

  group('Tests of GroupsRepository.saveAll()', () {
    test('Should [UPDATE groups] if [groups EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<GroupEntity> actualGroupsToUpdate = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: true, pinnedBool: true, filesystemPathString: 'group1', name: 'UPDATED VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/group2', name: 'UPDATED NETWORKS GROUP 1'),
      ];

      // Act
      await globalLocator<GroupsRepository>().saveAll(actualGroupsToUpdate);

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: true, pinnedBool: true, filesystemPathString: 'group1', name: 'UPDATED VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/group2', name: 'UPDATED NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });

    test('Should [SAVE groups] if [groups NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<GroupEntity> actualGroupsToUpdate = <GroupEntity>[
        const GroupEntity(id: 99998, encryptedBool: true, pinnedBool: true, filesystemPathString: 'group1', name: 'NEW VAULTS GROUP 1'),
        const GroupEntity(id: 99999, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/group2', name: 'NEW NETWORKS GROUP 1'),
      ];

      // Act
      await globalLocator<GroupsRepository>().saveAll(actualGroupsToUpdate);

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1'),
        const GroupEntity(id: 99998, encryptedBool: true, pinnedBool: true, filesystemPathString: 'group1', name: 'NEW VAULTS GROUP 1'),
        const GroupEntity(id: 99999, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/group2', name: 'NEW NETWORKS GROUP 1'),
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });
  });

  group('Tests of GroupsRepository.deleteById()', () {
    test('Should [REMOVE group] if [group UUID EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<GroupsRepository>().deleteById(1);

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [group UUID NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<GroupsRepository>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
