import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';
import '../../../utils/test_network_templates.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of VaultsService.getAllByParentPath()', () {
    test('Should [return List of VaultModel] if [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: true);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          index: 0,
          filesystemPath: FilesystemPath.fromString('vault1'),
          name: 'VAULT 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
            NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum1'),
            NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum7'),
            NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum9'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          index: 1,
          filesystemPath: FilesystemPath.fromString('vault2'),
          name: 'VAULT 2',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault2/network2'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum2'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          index: 2,
          filesystemPath: FilesystemPath.fromString('vault3'),
          name: 'VAULT 3',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault3/network3'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum3'),
            // @formatter:on
          ],
        ),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return List of VaultModel] if [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: false);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          index: 0,
          filesystemPath: FilesystemPath.fromString('vault1'),
          name: 'VAULT 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
            NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum1'),
            NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum7'),
            NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum9'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          index: 1,
          filesystemPath: FilesystemPath.fromString('vault2'),
          name: 'VAULT 2',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault2/network2'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum2'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          index: 2,
          filesystemPath: FilesystemPath.fromString('vault3'),
          name: 'VAULT 3',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault3/network3'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum3'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 4,
          encryptedBool: false,
          pinnedBool: false,
          index: 3,
          filesystemPath: FilesystemPath.fromString('group1/vault4'),
          name: 'VAULT 4',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 4, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1/vault4/network4'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum4'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 5,
          encryptedBool: false,
          pinnedBool: false,
          index: 4,
          filesystemPath: FilesystemPath.fromString('group1/vault5'),
          name: 'VAULT 5',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 5, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1/vault5/network5'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum5'),
            // @formatter:on
          ],
        ),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: true);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: false);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[];

      expect(actualVaultModelList, expectedVaultModelList);
    });
  });

  group('Tests of VaultsService.getById()', () {
    test('Should [return VaultModel] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultsService>().getById(1);

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[
          // @formatter:off
          GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
          NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum1'),
          NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum7'),
          NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum9'),
          // @formatter:on
        ],
      );

      expect(actualVaultModel, expectedVaultModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<VaultsService>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsService.move()', () {
    test('Should [MOVE vault] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<VaultsService>().move(
        VaultModel(
            id: 1,
            encryptedBool: false,
            pinnedBool: false,
            index: 0,
            filesystemPath: FilesystemPath.fromString('vault1'),
            name: 'VAULT 1',
            listItemsPreview: <AListItemModel>[]),
        FilesystemPath.fromString('new/path/vault1'),
      );

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'new/path/vault1', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });
  });

  group('Tests of VaultsService.moveAllByParentPath()', () {
    test('Should [MOVE vaults] starting with given path', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<VaultsService>().moveAllByParentPath(
        FilesystemPath.fromString('group1'),
        FilesystemPath.fromString('new/path/group1'),
      );

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'new/path/group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'new/path/group1/vault5', name: 'VAULT 5')
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });
  });

  group('Tests of VaultsService.save()', () {
    test('Should [UPDATE vault] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      VaultModel newVaultModel = VaultModel(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
        name: 'UPDATED VAULT 1',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<VaultsService>().save(newVaultModel);

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

      VaultModel actualNewVaultModel = VaultModel(
        id: 999999,
        encryptedBool: true,
        pinnedBool: true,
        index: 999999,
        filesystemPath: FilesystemPath.fromString('vault999999'),
        name: 'NEW VAULT 1',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<VaultsService>().save(actualNewVaultModel);

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

  group('Tests of VaultsService.saveAll()', () {
    test('Should [UPDATE vaults] if [vaults EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<VaultModel> actualVaultsToUpdate = <VaultModel>[
        // @formatter:off
        VaultModel(id: 1, encryptedBool: true, pinnedBool: true, index: 0, filesystemPath: FilesystemPath.fromString('vault1'), name: 'UPDATED VAULT 1', listItemsPreview: <AListItemModel>[]),
        VaultModel(id: 2, encryptedBool: true, pinnedBool: true, index: 1, filesystemPath: FilesystemPath.fromString('vault2'), name: 'UPDATED VAULT 2', listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      // Act
      await globalLocator<VaultsService>().saveAll(actualVaultsToUpdate);

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

    test('Should [SAVE vaults] if [vaults NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<VaultModel> actualVaultsToUpdate = <VaultModel>[
        // @formatter:off
        VaultModel(id: 99998, encryptedBool: true, pinnedBool: true, index: 99998, filesystemPath: FilesystemPath.fromString('vault99998'), name: 'NEW VAULT 1', listItemsPreview: <AListItemModel>[]),
        VaultModel(id: 99999, encryptedBool: true, pinnedBool: true, index: 99999, filesystemPath: FilesystemPath.fromString('vault99999'), name: 'NEW VAULT 2', listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      // Act
      await globalLocator<VaultsService>().saveAll(actualVaultsToUpdate);

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
        const VaultEntity(id: 99998, encryptedBool: true, pinnedBool: true, index: 99998, filesystemPathString: 'vault99998', name: 'NEW VAULT 1'),
        const VaultEntity(id: 99999, encryptedBool: true, pinnedBool: true, index: 99999, filesystemPathString: 'vault99999', name: 'NEW VAULT 2'),
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });
  });

  group('Tests of VaultsService.deleteAllByParentPath()', () {
    test('Should [REMOVE vaults] if [vaults with path EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<VaultsService>().deleteAllByParentPath(FilesystemPath.fromString('group1'));

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });

    test('Should [REMOVE ALL vaults] if [path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<VaultsService>().deleteAllByParentPath(const FilesystemPath.empty());

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });
  });

  group('Tests of VaultsService.deleteById()', () {
    test('Should [REMOVE vault] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<VaultsService>().deleteById(1);

      List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.vaults.where().findAll();
      });

      // Assert
      List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5'),
      ];

      expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<VaultsService>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsService.getLastIndex()', () {
    test('Should [return last vault index] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<VaultsService>().getLastIndex();

      // Assert
      int expectedLastIndex = 4;

      expect(actualLastIndex, expectedLastIndex);
    });

    test('Should [return -1] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<VaultsService>().getLastIndex();

      // Assert
      expect(actualLastIndex, -1);
    });
  });

  group('Tests of VaultsService.updateFilesystemPath()', () {
    test('Should [return updated VaultModel] if [vault EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      VaultModel? actualVaultModel = await globalLocator<VaultsService>().updateFilesystemPath(1, FilesystemPath.fromString('new/vault/path'));

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('new/vault/path/vault1'),
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualVaultModel, expectedVaultModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        globalLocator<VaultsService>().updateFilesystemPath(99999, FilesystemPath.fromString('new/vault/path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(testDatabase.close);
}
