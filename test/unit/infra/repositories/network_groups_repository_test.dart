import 'package:flutter_test/flutter_test.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/objectbox_database_manager.dart';
import 'package:snggle/infra/repositories/network_groups_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

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
        NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
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
        NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
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
        encryptedBool: false,
        pinnedBool: false,
        name: 'Ethereum1',
        filesystemPathString: 'vault1/network1',
        dbNetworkType: 'ethereum',
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
        encryptedBool: true,
        pinnedBool: true,
        name: 'UPDATED NETWORK GROUP 1',
        filesystemPathString: 'vault1/network1',
        dbNetworkType: 'ethereum',
      );

      // Act
      await globalLocator<NetworkGroupsRepository>().save(actualUpdatedNetworkGroupEntity);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<ObjectboxDatabaseManager>().perform((Store store) {
        return store.box<NetworkGroupEntity>().getAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [SAVE network] if [network NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      NetworkGroupEntity actualUpdatedNetworkGroupEntity = NetworkGroupEntity(
          id: 0,
          encryptedBool: true,
          pinnedBool: true,
          name: 'NEW NETWORK GROUP 1',
          filesystemPathString: 'vault1/network99999',
          dbNetworkType: 'ethereum');

      // Act
      await globalLocator<NetworkGroupsRepository>().save(actualUpdatedNetworkGroupEntity);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<ObjectboxDatabaseManager>().perform((Store store) {
        return store.box<NetworkGroupEntity>().getAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7,encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
        NetworkGroupEntity(id: 11, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99999', name: 'NEW NETWORK GROUP 1', dbNetworkType: 'ethereum'),
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
        NetworkGroupEntity(id: 1, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 2, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkGroupsRepository>().saveAll(actualNetworksToUpdate);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<ObjectboxDatabaseManager>().perform((Store store) {
        return store.box<NetworkGroupEntity>().getAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 2, encryptedBool: true, pinnedBool: true, name: 'UPDATED NETWORK GROUP 2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
        // @formatter:on
      ];

      expect(actualNetworksDatabaseValue, expectedNetworksDatabaseValue);
    });

    test('Should [SAVE networks] if [networks NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<NetworkGroupEntity> actualNetworksToUpdate = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 0, encryptedBool: true, pinnedBool: true, name: 'NEW NETWORK GROUP 1', filesystemPathString: 'vault1/network99998', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 0, encryptedBool: true, pinnedBool: true, name: 'NEW NETWORK GROUP 2', filesystemPathString: 'vault1/network99999', dbNetworkType: 'ethereum'),
        // @formatter:on
      ];

      // Act
      await globalLocator<NetworkGroupsRepository>().saveAll(actualNetworksToUpdate);

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<ObjectboxDatabaseManager>().perform((Store store) {
        return store.box<NetworkGroupEntity>().getAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 1, encryptedBool: false, pinnedBool: false, name: 'Ethereum1', filesystemPathString: 'vault1/network1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
        NetworkGroupEntity(id: 11, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99998', name: 'NEW NETWORK GROUP 1', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 12, encryptedBool: true, pinnedBool: true, filesystemPathString: 'vault1/network99999', name: 'NEW NETWORK GROUP 2', dbNetworkType: 'ethereum'),
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

      List<NetworkGroupEntity> actualNetworksDatabaseValue = await globalLocator<ObjectboxDatabaseManager>().perform((Store store) {
        return store.box<NetworkGroupEntity>().getAll();
      });

      // Assert
      List<NetworkGroupEntity> expectedNetworksDatabaseValue = <NetworkGroupEntity>[
        // @formatter:off
        NetworkGroupEntity(id: 2, encryptedBool: false, pinnedBool: false, name: 'Ethereum2', filesystemPathString: 'vault2/network2', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 3, encryptedBool: false, pinnedBool: false, name: 'Ethereum3', filesystemPathString: 'vault3/network3', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 4, encryptedBool: false, pinnedBool: false, name: 'Ethereum4', filesystemPathString: 'group1/vault4/network4', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 5, encryptedBool: false, pinnedBool: false, name: 'Ethereum5', filesystemPathString: 'group1/vault5/network5', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 6, encryptedBool: false, pinnedBool: false, name: 'Ethereum6', filesystemPathString: 'vault1/group2/network6', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 7, encryptedBool: false, pinnedBool: false, name: 'Ethereum7', filesystemPathString: 'vault1/network7', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 8, encryptedBool: false, pinnedBool: false, name: 'Ethereum8', filesystemPathString: 'vault1/group2/network8', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 9, encryptedBool: false, pinnedBool: false, name: 'Ethereum9', filesystemPathString: 'vault1/network9', dbNetworkType: 'ethereum'),
        NetworkGroupEntity(id: 10, encryptedBool: false, pinnedBool: false, name: 'Solana1', filesystemPathString: 'vault1/network10', dbNetworkType: 'solana'),
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
