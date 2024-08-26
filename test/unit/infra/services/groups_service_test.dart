import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';
import '../../../utils/test_network_templates.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of GroupsService.getAllByParentPath()', () {
    test('Should [return List of GroupModel] if [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: true);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[
        GroupModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('group1'),
          name: 'VAULTS GROUP 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPath: FilesystemPath.fromString('group1/vault4'), name: 'VAULT 4', listItemsPreview: <AListItemModel>[]),
            VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPath: FilesystemPath.fromString('group1/vault5'), name: 'VAULT 5', listItemsPreview: <AListItemModel>[])
            // @formatter:on
          ],
        ),
      ];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return List of GroupModel] if [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: false);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[
        GroupModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('group1'),
          name: 'VAULTS GROUP 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPath: FilesystemPath.fromString('group1/vault4'), name: 'VAULT 4', listItemsPreview: <AListItemModel>[]),
            VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPath: FilesystemPath.fromString('group1/vault5'), name: 'VAULT 5', listItemsPreview: <AListItemModel>[])
            // @formatter:on
          ],
        ),
        GroupModel(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('vault1/group2'),
          name: 'NETWORKS GROUP 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 6, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2/network6'), networkTemplateModel: TestNetworkTemplates.ethereum, listItemsPreview: <AListItemModel>[], name: 'Ethereum6'),
            NetworkGroupModel(id: 8, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2/network8'), networkTemplateModel: TestNetworkTemplates.ethereum, listItemsPreview: <AListItemModel>[], name: 'Ethereum8'),
            // @formatter:on
          ],
        ),
        GroupModel(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('vault1/network1/group3'),
          name: 'WALLETS GROUP 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
            WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
            // @formatter:on
          ],
        ),
      ];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: true);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: false);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[];

      expect(actualGroupModelList, expectedGroupModelList);
    });
  });

  group('Tests of GroupsService.getById()', () {
    test('Should [return GroupModel] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getById(1);

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        filesystemPath: FilesystemPath.fromString('group1'),
        name: 'VAULTS GROUP 1',
        listItemsPreview: <AListItemModel>[
          // @formatter:off
          VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPath: FilesystemPath.fromString('group1/vault4'), name: 'VAULT 4', listItemsPreview: <AListItemModel>[]),
          VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPath: FilesystemPath.fromString('group1/vault5'), name: 'VAULT 5', listItemsPreview: <AListItemModel>[])
          // @formatter:on
        ],
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<GroupsService>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of GroupsService.move()', () {
    test('Should [MOVE group] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<GroupsService>().move(
        GroupModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('group1'),
          name: 'VAULTS GROUP 1',
          listItemsPreview: <AListItemModel>[],
        ),
        FilesystemPath.fromString('new/path/group1'),
      );

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'new/path/group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });
  });

  group('Tests of GroupsService.moveAllByParentPath()', () {
    test('Should [MOVE groups] with provided parent path', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<GroupsService>().moveAllByParentPath(
        FilesystemPath.fromString('vault1'),
        FilesystemPath.fromString('new/path/vault1'),
      );

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'new/path/vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'new/path/vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });
  });

  group('Tests of GroupsService.save()', () {
    test('Should [UPDATE GroupModel] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      GroupModel actualUpdatedGroupModel = GroupModel(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        filesystemPath: FilesystemPath.fromString('group1'),
        name: 'UPDATED VAULTS GROUP 1',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<GroupsService>().save(actualUpdatedGroupModel);

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

    test('Should [SAVE GroupModel] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      GroupModel actualUpdatedGroupModel = GroupModel(
        id: 99999,
        encryptedBool: true,
        pinnedBool: true,
        filesystemPath: FilesystemPath.fromString('group1'),
        name: 'NEW VAULTS GROUP 1',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<GroupsService>().save(actualUpdatedGroupModel);

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

  group('Tests of GroupsService.saveAll()', () {
    test('Should [UPDATE groups] if [groups EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<GroupModel> actualGroupsToUpdate = <GroupModel>[
        // @formatter:off
        GroupModel(id: 1, encryptedBool: true, pinnedBool: true, filesystemPath: FilesystemPath.fromString('group1'), name: 'UPDATED VAULTS GROUP 1', listItemsPreview: <AListItemModel>[]),
        GroupModel(id: 2, encryptedBool: true, pinnedBool: true, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'UPDATED NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      // Act
      await globalLocator<GroupsService>().saveAll(actualGroupsToUpdate);

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

      List<GroupModel> actualGroupsToUpdate = <GroupModel>[
        // @formatter:off
        GroupModel(id: 99998, encryptedBool: true, pinnedBool: true, filesystemPath: FilesystemPath.fromString('group1'), name: 'NEW VAULTS GROUP 1', listItemsPreview: <AListItemModel>[]),
        GroupModel(id: 99999, encryptedBool: true, pinnedBool: true, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NEW NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      // Act
      await globalLocator<GroupsService>().saveAll(actualGroupsToUpdate);

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

  group('Tests of GroupsService.deleteAllByParentPath()', () {
    test('Should [REMOVE groups] if [groups with path EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<GroupsService>().deleteAllByParentPath(FilesystemPath.fromString('vault1'));

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
      ];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });

    test('Should [REMOVE ALL groups] if [path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<GroupsService>().deleteAllByParentPath(const FilesystemPath.empty());

      List<GroupEntity> actualGroupsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.groups.where().findAll();
      });

      // Assert
      List<GroupEntity> expectedGroupsDatabaseValue = <GroupEntity>[];

      expect(actualGroupsDatabaseValue, expectedGroupsDatabaseValue);
    });
  });

  group('Tests of GroupsService.deleteById()', () {
    test('Should [REMOVE group] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<GroupsService>().deleteById(1);

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

    test('Should [throw ChildKeyNotFoundException] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<GroupsService>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of GroupsService.getByPath()', () {
    test('Should [return GroupModel] if [group path EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('vault1/network1/group3');

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getByPath(actualFilesystemPath);

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        id: 3,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPath: FilesystemPath.fromString('vault1/network1/group3'),
        name: 'WALLETS GROUP 1',
        listItemsPreview: <AListItemModel>[
          // @formatter:off
          WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
          WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
          // @formatter:on
        ],
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [return NULL] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().getByPath(actualFilesystemPath);

      // Assert
      expect(actualGroupModel, null);
    });
  });

  group('Tests of GroupsService.updateFilesystemPath()', () {
    test('Should [return updated GroupModel] if [group EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      GroupModel? actualGroupModel = await globalLocator<GroupsService>().updateFilesystemPath(1, FilesystemPath.fromString('new/group/path'));

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        filesystemPath: FilesystemPath.fromString('new/group/path/group1'),
        name: 'VAULTS GROUP 1',
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [group NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        globalLocator<GroupsService>().updateFilesystemPath(99999, FilesystemPath.fromString('new/group/path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
