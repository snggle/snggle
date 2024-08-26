import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
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
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of GroupModelFactory.createNewGroup()', () {
    test('Should [return GroupModel] with initial values', () async {
      // Act
      GroupModel actualGroupModel = await globalLocator<GroupModelFactory>().createNewGroup(
        parentFilesystemPath: FilesystemPath.fromString('test/path'),
        name: 'NEW GROUP',
      );

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        id: 4,
        pinnedBool: false,
        encryptedBool: false,
        filesystemPath: FilesystemPath.fromString('test/path/group4'),
        listItemsPreview: <AListItemModel>[],
        name: 'NEW GROUP',
      );

      expect(actualGroupModel, expectedGroupModel);
    });
  });

  group('Tests of GroupModelFactory.createFromEntities()', () {
    test('Should [return GroupModel] with values from given GroupEntity when [previewEmptyBool == false]', () async {
      // Arrange
      List<GroupEntity> actualGroupEntityList = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupModelFactory>().createFromEntities(actualGroupEntityList, previewEmptyBool: false);

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
            WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
            WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", network: 'ethereum', filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
            // @formatter:on
          ],
        ),
      ];

      expect(actualGroupModelList, expectedGroupModelList);
    });

    test('Should [return GroupModel] with values from given GroupEntity when [previewEmptyBool == true]', () async {
      // Arrange
      List<GroupEntity> actualGroupEntityList = <GroupEntity>[
        const GroupEntity(id: 1, encryptedBool: false, pinnedBool: false, filesystemPathString: 'group1', name: 'VAULTS GROUP 1'),
        const GroupEntity(id: 2, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/group2', name: 'NETWORKS GROUP 1'),
        const GroupEntity(id: 3, encryptedBool: false, pinnedBool: false, filesystemPathString: 'vault1/network1/group3', name: 'WALLETS GROUP 1')
      ];

      // Act
      List<GroupModel> actualGroupModelList = await globalLocator<GroupModelFactory>().createFromEntities(actualGroupEntityList, previewEmptyBool: true);

      // Assert
      List<GroupModel> expectedGroupModelList = <GroupModel>[
        // @formatter:off
        GroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1'), name: 'VAULTS GROUP 1', listItemsPreview: <AListItemModel>[]),
        GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
        GroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1/group3'), name: 'WALLETS GROUP 1', listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      expect(actualGroupModelList, expectedGroupModelList);
    });
  });

  group('Tests of GroupModelFactory.createFromEntity()', () {
    test('Should [return GroupModel] with values from given GroupEntity when [previewEmptyBool == false]', () async {
      // Arrange
      GroupEntity actualGroupEntity = const GroupEntity(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        name: 'ETHEREUM BASED',
        filesystemPathString: 'group1',
      );

      // Act
      GroupModel actualGroupModel = await globalLocator<GroupModelFactory>().createFromEntity(actualGroupEntity, previewEmptyBool: false);

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        filesystemPath: FilesystemPath.fromString('group1'),
        name: 'ETHEREUM BASED',
        listItemsPreview: <AListItemModel>[
          // @formatter:off
          VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, name: 'VAULT 4', filesystemPath: FilesystemPath.fromString('group1/vault4'), listItemsPreview: <AListItemModel>[]),
          VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, name: 'VAULT 5', filesystemPath: FilesystemPath.fromString('group1/vault5'), listItemsPreview: <AListItemModel>[]),
          // @formatter:on
        ],
      );

      expect(actualGroupModel, expectedGroupModel);
    });

    test('Should [return GroupModel] with values from given GroupEntity when [previewEmptyBool == true]', () async {
      // Arrange
      GroupEntity actualGroupEntity = const GroupEntity(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        name: 'ETHEREUM BASED',
        filesystemPathString: 'group1',
      );

      // Act
      GroupModel actualGroupModel = await globalLocator<GroupModelFactory>().createFromEntity(actualGroupEntity, previewEmptyBool: true);

      // Assert
      GroupModel expectedGroupModel = GroupModel(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        filesystemPath: FilesystemPath.fromString('group1'),
        name: 'ETHEREUM BASED',
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualGroupModel, expectedGroupModel);
    });
  });

  tearDownAll(testDatabase.close);
}