import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/predefined_network_templates.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_subdirectory_type.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of VaultModelFactory.createNewVault()', () {
    test('Should [return VaultModel] with initial values (database EMPTY)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.masterKeyOnlyDatabaseMock);
      Mnemonic actualMnemonic = Mnemonic.fromMnemonicPhrase('practice bundle birth birth invite route loop spy weapon suffer truck bounce');

      // Act
      VaultModel actualVaultModel =
      await globalLocator<VaultModelFactory>().createNewVault(
          FilesystemPath.fromString(FilesystemStorageSubdirectoryType.vaults.name), actualMnemonic, 'NEW VAULT');

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPath: FilesystemPath.fromString('vaults/vault1'),
        fingerprint: '381505146',
        name: 'NEW VAULT',
        index: 0,
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualVaultModel, expectedVaultModel);
    });

    test('Should [return VaultModel] with initial values (database NOT EMPTY)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);
      Mnemonic actualMnemonic = Mnemonic.fromMnemonicPhrase('practice bundle birth birth invite route loop spy weapon suffer truck bounce');

      // Act
      VaultModel actualVaultModel =
      await globalLocator<VaultModelFactory>().createNewVault(
          FilesystemPath.fromString(FilesystemStorageSubdirectoryType.vaults.name), actualMnemonic, 'NEW VAULT');

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        id: 6,
        encryptedBool: false,
        pinnedBool: false,
        filesystemPath: FilesystemPath.fromString('vaults/vault6'),
        fingerprint: '381505146',
        name: 'NEW VAULT',
        index: 5,
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualVaultModel, expectedVaultModel);
    });
  });

  group('Tests of VaultModelFactory.createFromEntities()', () {
    test('Should [return List of VaultModel] from given List of VaultEntity when [previewEmptyBool == false]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<VaultEntity> actualVaultEntityList = <VaultEntity>[
        // @formatter:off
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vaults/vault1', fingerprint: '2429747484', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vaults/vault2', fingerprint: '2619341544', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vaults/vault3', fingerprint: '405998762', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'vaults/group1/vault4', fingerprint: '1024969286=', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'vaults/group1/vault5', fingerprint: '1980042394', name: 'VAULT 5')
        // @formatter:on
      ];

      // Act
      List<VaultModel> actualVaultModelList =
      await globalLocator<VaultModelFactory>().createFromEntities(actualVaultEntityList, previewEmptyBool: false);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          index: 0,
          filesystemPath: FilesystemPath.fromString('vaults/vault1'),
          fingerprint: '2429747484',
          name: 'VAULT 1',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
            NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum1'),
            NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum7'),
            NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum9'),
            NetworkGroupModel(id: 10, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network10'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.solana, name: 'Solana1'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          index: 1,
          filesystemPath: FilesystemPath.fromString('vaults/vault2'),
          fingerprint: '2619341544',
          name: 'VAULT 2',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault2/network2'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum2'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          index: 2,
          filesystemPath: FilesystemPath.fromString('vaults/vault3'),
          fingerprint: '405998762',
          name: 'VAULT 3',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault3/network3'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum3'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 4,
          encryptedBool: false,
          pinnedBool: false,
          index: 3,
          filesystemPath: FilesystemPath.fromString('vaults/group1/vault4'),
          fingerprint: '1024969286=',
          name: 'VAULT 4',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 4, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/group1/vault4/network4'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum4'),
            // @formatter:on
          ],
        ),
        VaultModel(
          id: 5,
          encryptedBool: false,
          pinnedBool: false,
          index: 4,
          filesystemPath: FilesystemPath.fromString('vaults/group1/vault5'),
          fingerprint: '1980042394',
          name: 'VAULT 5',
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 5, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/group1/vault5/network5'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum5'),
            // @formatter:on
          ],
        ),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return List of VaultModel] from given List of VaultEntity when [previewEmptyBool == true]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<VaultEntity> actualVaultEntityList = <VaultEntity>[
        // @formatter:off
        const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vaults/vault1', fingerprint: '2429747484', name: 'VAULT 1'),
        const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vaults/vault2', fingerprint: '2619341544', name: 'VAULT 2'),
        const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vaults/vault3', fingerprint: '405998762', name: 'VAULT 3'),
        const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'vaults/group1/vault4', fingerprint: '1024969286=', name: 'VAULT 4'),
        const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'vaults/group1/vault5', fingerprint: '1980042394', name: 'VAULT 5')
        // @formatter:on
      ];

      // Act
      List<VaultModel> actualVaultModelList =
      await globalLocator<VaultModelFactory>().createFromEntities(actualVaultEntityList, previewEmptyBool: true);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        // @formatter:off
        VaultModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPath: FilesystemPath.fromString('vaults/vault1'), fingerprint: '2429747484', name: 'VAULT 1', listItemsPreview: <AListItemModel>[]),
        VaultModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPath: FilesystemPath.fromString('vaults/vault2'), fingerprint: '2619341544', name: 'VAULT 2', listItemsPreview: <AListItemModel>[]),
        VaultModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPath: FilesystemPath.fromString('vaults/vault3'), fingerprint: '405998762', name: 'VAULT 3', listItemsPreview: <AListItemModel>[]),
        VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPath: FilesystemPath.fromString('vaults/group1/vault4'), fingerprint: '1024969286=', name: 'VAULT 4', listItemsPreview: <AListItemModel>[]),
        VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPath: FilesystemPath.fromString('vaults/group1/vault5'), fingerprint: '1980042394', name: 'VAULT 5', listItemsPreview: <AListItemModel>[])
        // @formatter:on
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });
  });

  group('Tests of VaultModelFactory.createFromEntity()', () {
    test('Should [return VaultModel] from given VaultEntity when [previewEmptyBool == false]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      VaultEntity actualVaultEntity = const VaultEntity(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        fingerprint: '2429747484',
        name: 'VAULT 1',
        filesystemPathString: 'vaults/vault1',
      );

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultModelFactory>().createFromEntity(actualVaultEntity, previewEmptyBool: false);

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vaults/vault1'),
        fingerprint: '2429747484',
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[
          // @formatter:off
          GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
          NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum1'),
          NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum7'),
          NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum9'),
          NetworkGroupModel(id: 10, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vaults/vault1/network10'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.solana, name: 'Solana1'),
          // @formatter:on
        ],
      );

      expect(actualVaultModel, expectedVaultModel);
    });

    test('Should [return VaultModel] from given VaultEntity when [previewEmptyBool == true]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      VaultEntity actualVaultEntity = const VaultEntity(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        fingerprint: '2429747484',
        name: 'VAULT 1',
        filesystemPathString: 'vaults/vault1',
      );

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultModelFactory>().createFromEntity(actualVaultEntity, previewEmptyBool: true);

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('vaults/vault1'),
        fingerprint: '2429747484',
        name: 'VAULT 1',
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualVaultModel, expectedVaultModel);
    });
  });

  tearDownAll(testDatabase.close);
}
