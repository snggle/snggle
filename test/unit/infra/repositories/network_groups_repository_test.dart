import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/network_groups_repository.dart';
import 'package:snggle/shared/models/networks/network_icon_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  EmbeddedNetworkTemplateEntity embeddedNetworkTemplateEntity = const EmbeddedNetworkTemplateEntity(
    addressEncoderType: 'ethereum(false)',
    curveType: CurveType.secp256k1,
    derivationPathName: null,
    derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    derivatorType: 'secp256k1',
    networkIconType: NetworkIconType.ethereum,
    name: 'Ethereum',
    predefinedNetworkTemplateId: 817800260,
    walletType: WalletType.legacy,
  );

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of NetworkGroupsRepository.getAll()', () {
    test('Should [return List of NetworkGroupEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<NetworkGroupEntity> actualNetworkGroupEntityList = await globalLocator<NetworkGroupsRepository>().getAll();

      // Assert
      List<NetworkGroupEntity> expectedNetworkGroupEntityList = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworkGroupEntityList, expectedNetworkGroupEntityList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<NetworkGroupEntity> actualNetworkGroupEntityList = await globalLocator<NetworkGroupsRepository>().getAll();

      // Assert
      List<NetworkGroupEntity> expectedNetworkGroupEntityList = <NetworkGroupEntity>[];

      expect(actualNetworkGroupEntityList, expectedNetworkGroupEntityList);
    });
  });

  group('Tests of NetworkGroupsRepository.getAllByParentPath()', () {
    test('Should [return List of NetworkGroupEntity] if [networks with specified path NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<NetworkGroupEntity> actualNetworkGroupEntityList = await globalLocator<NetworkGroupsRepository>().getAllByParentPath(
        FilesystemPath.fromString('vault1'),
      );

      // Assert
      List<NetworkGroupEntity> expectedNetworkGroupEntityList = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworkGroupEntityList, expectedNetworkGroupEntityList);
    });

    test('Should [return EMPTY list] if [network with specified path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<NetworkGroupEntity> actualNetworkGroupEntityList = await globalLocator<NetworkGroupsRepository>().getAllByParentPath(
        FilesystemPath.fromString('vault1'),
      );

      // Assert
      List<NetworkGroupEntity> expectedNetworkGroupEntityList = <NetworkGroupEntity>[];

      expect(actualNetworkGroupEntityList, expectedNetworkGroupEntityList);
    });
  });

  group('Tests of NetworkGroupsRepository.getById()', () {
    test('Should [return NetworkGroupEntity] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      NetworkGroupEntity actualNetworkGroupEntity = await globalLocator<NetworkGroupsRepository>().getById(1);

      // Assert
      NetworkGroupEntity expectedNetworkGroupEntity = NetworkGroupEntity(
        id: 1,
        embeddedNetworkTemplate: embeddedNetworkTemplateEntity,
        encryptedBool: false,
        pinnedBool: false,
        name: 'Ethereum1',
        filesystemPathString: 'vault1/network1',
      );

      expect(actualNetworkGroupEntity, expectedNetworkGroupEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Assert
      expect(
        () => globalLocator<NetworkGroupsRepository>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of NetworkGroupsRepository.save()', () {
    test('Should [UPDATE network] if [network EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkGroupEntity actualUpdatedNetworkGroupEntity = NetworkGroupEntity(
        id: 1,
        embeddedNetworkTemplate: embeddedNetworkTemplateEntity,
        encryptedBool: true,
        pinnedBool: true,
        name: 'UPDATED NETWORK GROUP 1',
        filesystemPathString: 'vault1/network1',
      );

      // Act
      await globalLocator<NetworkGroupsRepository>().save(actualUpdatedNetworkGroupEntity);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [SAVE network] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkGroupEntity actualUpdatedNetworkGroupEntity = NetworkGroupEntity(
        id: 99999,
        embeddedNetworkTemplate: embeddedNetworkTemplateEntity,
        encryptedBool: true,
        pinnedBool: true,
        name: 'NEW NETWORK GROUP 1',
        filesystemPathString: 'vault1/network99999',
      );

      // Act
      await globalLocator<NetworkGroupsRepository>().save(actualUpdatedNetworkGroupEntity);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        NetworkGroupEntity(id: 99999, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99999', name: 'NEW NETWORK GROUP 1'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsRepository.saveAll()', () {
    test('Should [UPDATE networks] if [networks EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<NetworkGroupEntity> actualNetworksToUpdate = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 2', filesystemPathString: 'vault2/network2'),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkGroupsRepository>().saveAll(actualNetworksToUpdate);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [SAVE networks] if [networks NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<NetworkGroupEntity> actualNetworksToUpdate = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 99998, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'NEW NETWORK GROUP 1', filesystemPathString: 'vault1/network99998'),
        NetworkGroupEntity(id: 99999, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, name: 'NEW NETWORK GROUP 2', filesystemPathString: 'vault1/network99999'),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkGroupsRepository>().saveAll(actualNetworksToUpdate);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1'),
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        NetworkGroupEntity(id: 99998, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99998', name: 'NEW NETWORK GROUP 1'),
        NetworkGroupEntity(id: 99999, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99999', name: 'NEW NETWORK GROUP 2'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });
  });

  group('Tests of NetworkGroupsRepository.deleteById()', () {
    test('Should [REMOVE network] if [network UUID EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<NetworkGroupsRepository>().deleteById(1);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.networkGroups.where().findAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 2, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2'),
        NetworkGroupEntity(id: 3, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3'),
        NetworkGroupEntity(id: 4, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4'),
        NetworkGroupEntity(id: 5, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5'),
        NetworkGroupEntity(id: 6, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6'),
        NetworkGroupEntity(id: 7, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7'),
        NetworkGroupEntity(id: 8, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8'),
        NetworkGroupEntity(id: 9, embeddedNetworkTemplate: embeddedNetworkTemplateEntity, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [network UUID NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<NetworkGroupsRepository>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
