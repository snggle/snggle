import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
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

  group('Tests of NetworkGroupsService.updateFilesystemPath()', () {
    test('Should [return updated NetworkGroupModel] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      NetworkGroupModel? actualNetworkGroupModel =
          await globalLocator<NetworkGroupsService>().updateFilesystemPath(1, FilesystemPath.fromString('new/network/path'));

      // Assert
      NetworkGroupModel expectedNetworkGroupModel = NetworkGroupModel(
          pinnedBool: false,
          encryptedBool: false,
          id: 1,
          filesystemPath: FilesystemPath.fromString('new/network/path/network1'),
          listItemsPreview: <AListItemModel>[],
          networkConfigModel: NetworkConfigModel.ethereum);

      expect(actualNetworkGroupModel, expectedNetworkGroupModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        globalLocator<NetworkGroupsService>().updateFilesystemPath(99999, FilesystemPath.fromString('new/network/path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of NetworkGroupsService.getById()', () {
    test('Should [return NetworkGroupModel] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      NetworkGroupModel? actualNetworkGroupModel = await globalLocator<NetworkGroupsService>().getById(1);

      // Assert
      NetworkGroupModel expectedNetworkGroupModel = NetworkGroupModel(
        pinnedBool: false,
        encryptedBool: false,
        id: 1,
        filesystemPath: FilesystemPath.fromString('vault1/network1'),
        networkConfigModel: NetworkConfigModel.ethereum,
        listItemsPreview: <AListItemModel>[
          // @formatter:off
          GroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1/group3'), name: 'WALLETS GROUP 1', listItemsPreview: <AListItemModel>[]),
          WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", network: 'ethereum', name: 'WALLET 0', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1')),
          WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", network: 'ethereum', name: 'WALLET 1', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2')),
          WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", network: 'ethereum', name: 'WALLET 2', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3')),
          // @formatter:on
        ],
      );

      expect(actualNetworkGroupModel, expectedNetworkGroupModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<NetworkGroupsService>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of NetworkGroupsService.getAllByParentPath()', () {
    test('Should [return List of NetworkGroupModel] if [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<NetworkGroupModel> actualNetworkGroupModelList = await globalLocator<NetworkGroupsService>().getAllByParentPath(
        FilesystemPath.fromString('vault1'),
        firstLevelBool: true,
      );

      // Assert
      List<NetworkGroupModel> expectedNetworkGroupModelList = <NetworkGroupModel>[
        NetworkGroupModel(
          pinnedBool: false,
          encryptedBool: false,
          id: 1,
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
          networkConfigModel: NetworkConfigModel.ethereum,
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            GroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1/group3'), name: 'WALLETS GROUP 1', listItemsPreview: <AListItemModel>[]),
            WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", network: 'ethereum', name: 'WALLET 0', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1')),
            WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", network: 'ethereum', name: 'WALLET 1', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2')),
            WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", network: 'ethereum', name: 'WALLET 2', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3')),
            // @formatter:on
          ],
        ),
        NetworkGroupModel(
            id: 7,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.cosmos,
            filesystemPath: FilesystemPath.fromString('vault1/network7'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 9,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.bitcoin,
            filesystemPath: FilesystemPath.fromString('vault1/network9'),
            listItemsPreview: <AListItemModel>[]),
      ];

      expect(actualNetworkGroupModelList, expectedNetworkGroupModelList);
    });

    test('Should [return List of NetworkGroupModel] if [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<NetworkGroupModel> actualNetworkGroupModelList = await globalLocator<NetworkGroupsService>().getAllByParentPath(
        const FilesystemPath.empty(),
        firstLevelBool: false,
      );

      // Assert
      List<NetworkGroupModel> expectedNetworkGroupModelList = <NetworkGroupModel>[
        NetworkGroupModel(
          pinnedBool: false,
          encryptedBool: false,
          id: 1,
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
          networkConfigModel: NetworkConfigModel.ethereum,
          listItemsPreview: <AListItemModel>[
            // @formatter:off
            GroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1/group3'), name: 'WALLETS GROUP 1', listItemsPreview: <AListItemModel>[]),
            WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", network: 'ethereum', name: 'WALLET 0', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1')),
            WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", network: 'ethereum', name: 'WALLET 1', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2')),
            WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", network: 'ethereum', name: 'WALLET 2', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3')),
            // @formatter:on
          ],
        ),
        NetworkGroupModel(
            id: 2,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.ethereum,
            filesystemPath: FilesystemPath.fromString('vault2/network2'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 3,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.ethereum,
            filesystemPath: FilesystemPath.fromString('vault3/network3'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 4,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.ethereum,
            filesystemPath: FilesystemPath.fromString('group1/vault4/network4'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 5,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.ethereum,
            filesystemPath: FilesystemPath.fromString('group1/vault5/network5'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 6,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.polkadot,
            filesystemPath: FilesystemPath.fromString('vault1/group2/network6'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 7,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.cosmos,
            filesystemPath: FilesystemPath.fromString('vault1/network7'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 8,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.kira,
            filesystemPath: FilesystemPath.fromString('vault1/group2/network8'),
            listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(
            id: 9,
            encryptedBool: false,
            pinnedBool: false,
            networkConfigModel: NetworkConfigModel.bitcoin,
            filesystemPath: FilesystemPath.fromString('vault1/network9'),
            listItemsPreview: <AListItemModel>[]),
      ];

      expect(actualNetworkGroupModelList, expectedNetworkGroupModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<NetworkGroupModel> actualNetworkGroupModelList = await globalLocator<NetworkGroupsService>().getAllByParentPath(
        actualFilesystemPath,
        firstLevelBool: true,
      );

      // Assert
      List<NetworkGroupModel> expectedNetworkGroupModelList = <NetworkGroupModel>[];

      expect(actualNetworkGroupModelList, expectedNetworkGroupModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<NetworkGroupModel> actualNetworkGroupModelList = await globalLocator<NetworkGroupsService>().getAllByParentPath(
        actualFilesystemPath,
        firstLevelBool: false,
      );

      // Assert
      List<NetworkGroupModel> expectedNetworkGroupModelList = <NetworkGroupModel>[];

      expect(actualNetworkGroupModelList, expectedNetworkGroupModelList);
    });
  });

  group('Tests of NetworkGroupsService.move()', () {
    test('Should [MOVE network] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<NetworkGroupsService>().move(
        NetworkGroupModel(
          pinnedBool: false,
          encryptedBool: false,
          id: 1,
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
          networkConfigModel: NetworkConfigModel.ethereum,
          listItemsPreview: <AListItemModel>[],
        ),
        FilesystemPath.fromString('new/network/path/network1'),
      );

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'new/network/path/network1'),
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsService.moveByParentPath()', () {
    test('Should [MOVE networks] with provided parent path', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<NetworkGroupsService>().moveByParentPath(
        FilesystemPath.fromString('vault1'),
        FilesystemPath.fromString('new/network/path/vault1'),
      );

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'new/network/path/vault1/network1'),
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'new/network/path/vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'new/network/path/vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'new/network/path/vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'new/network/path/vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsService.save()', () {
    test('Should [UPDATE NetworkGroupModel] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkGroupModel actualUpdatedNetworkGroupModel = NetworkGroupModel(
        id: 1,
        pinnedBool: true,
        encryptedBool: true,
        filesystemPath: FilesystemPath.fromString('vault1/network1'),
        networkConfigModel: NetworkConfigModel.ethereum,
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<NetworkGroupsService>().save(actualUpdatedNetworkGroupModel);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 1, encryptedBool: true, pinnedBool: true, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault1/network1'),
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [SAVE NetworkGroupModel] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkGroupModel actualUpdatedNetworkGroupModel = NetworkGroupModel(
        id: 99999,
        pinnedBool: true,
        encryptedBool: true,
        filesystemPath: FilesystemPath.fromString('vault1/network99999'),
        networkConfigModel: NetworkConfigModel.ethereum,
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<NetworkGroupsService>().save(actualUpdatedNetworkGroupModel);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault1/network1'),
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'vault1/network9'),
        const NetworkGroupEntity(id: 99999, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99999', name: 'Ethereum', networkId: 'ethereum'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsService.saveAll()', () {
    test('Should [UPDATE networks] if [networks EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<NetworkGroupModel> actualGroupsToUpdate = <NetworkGroupModel>[
        // @formatter:off
        NetworkGroupModel(id: 1, encryptedBool: true, pinnedBool: true, networkConfigModel: NetworkConfigModel.ethereum,  filesystemPath: FilesystemPath.fromString('vault1/network1'), listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(id: 7, encryptedBool: true, pinnedBool: true, networkConfigModel: NetworkConfigModel.cosmos, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkGroupsService>().saveAll(actualGroupsToUpdate);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 1, encryptedBool: true, pinnedBool: true, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault1/network1'),
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: true, pinnedBool: true, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [SAVE networks] if [networks NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<NetworkGroupModel> actualGroupsToUpdate = <NetworkGroupModel>[
        // @formatter:off
        NetworkGroupModel(id: 99998, encryptedBool: true, pinnedBool: true, networkConfigModel: NetworkConfigModel.ethereum,  filesystemPath: FilesystemPath.fromString('vault1/network99998'), listItemsPreview: <AListItemModel>[]),
        NetworkGroupModel(id: 99999, encryptedBool: true, pinnedBool: true, networkConfigModel: NetworkConfigModel.cosmos, filesystemPath: FilesystemPath.fromString('vault1/network99999'), listItemsPreview: <AListItemModel>[]),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkGroupsService>().saveAll(actualGroupsToUpdate);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault1/network1'),
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'vault1/network9'),
        const NetworkGroupEntity(id: 99998, encryptedBool: true, pinnedBool: true, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault1/network99998'),
        const NetworkGroupEntity(id: 99999, encryptedBool: true, pinnedBool: true, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network99999'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsService.deleteAllByParentPath()', () {
    test('Should [REMOVE networks] if [networks with path EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<NetworkGroupsService>().deleteAllByParentPath(FilesystemPath.fromString('vault1'));

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [REMOVE ALL networks] if [path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<NetworkGroupsService>().deleteAllByParentPath(const FilesystemPath.empty());

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsService.deleteById()', () {
    test('Should [REMOVE network] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<NetworkGroupsService>().deleteById(1);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        const NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault2/network2'),
        const NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'vault3/network3'),
        const NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault4/network4'),
        const NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum', networkId: 'ethereum', filesystemPathString: 'group1/vault5/network5'),
        const NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Polkadot', networkId: 'polkadot', filesystemPathString: 'vault1/group2/network6'),
        const NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Cosmos', networkId: 'cosmos', filesystemPathString: 'vault1/network7'),
        const NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Kira', networkId: 'kira', filesystemPathString: 'vault1/group2/network8'),
        const NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Bitcoin', networkId: 'bitcoin', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<NetworkGroupsService>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
