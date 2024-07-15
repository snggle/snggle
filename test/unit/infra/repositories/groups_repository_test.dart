import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.groups;

  // @formatter:off
  Map<String, String> filledGroupsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.groups.name:'Dahf6fZt86Rk1JWB2bHFI1Gm6VwouPQQJZaYS7d3TOWODACEm/LB++EKMKT+Uu/5gMwBYtnbod9MH6dSbfwWNgkPjESjKcm0VPRVg4U0UgVAXQt0/ctApDgqsQ1uXU6sRUnGF7dW6ylAgIfTVFYoODmfoTEHQZnhvsatsgqVcskeACgpd08pfjbjbEsj+F0iAkhM8xV97kYKOtvATkYsy9zWz5mCML79F0fle6A7106h7KIEOxvXQ2bgxoMk6UmkLYkclHHd2n07FC2GkTBOUNXkUI89Nfx2I4sQBmd9OnoDqaghr8k/SHvg7shj6aLWu+JzHa/zxc/c3LmkiGGYJmeQA6c8lMjTv8Oouqv7GGZqjynZCwuu10rF8NhdJBXX5FmUK1TOgbD40vQB68Yt3eszx2/JUw59vUCCm6rFKRlC1EfxUkboOdNE3/FJVz6jf94N+C2bZRKDC9LBZL0tZWq+IjbxyhOeEHg3bQX3dkkjrOOUNCLAx7js+xgC5k+tgVc0XDiqFqa90Rj4fh41LZkxyRpL+jxsh5nRVXH5L1gTuP+0G7VFxW4k+u4yUEg8IygXy5JFPQuJx5zn7zi9FrCo2STMy13IofXdeCyXa1/EgNtg2fcndbaXIfzBIzrXax6Tz9hGzasb090DmKMMiKTuXZHafgzMT+KqsfL01BP3UDD3sqygC5OiymdrSaH/ItIcVrGt2H/LS4EnAYWEuu/WyPtJPxb9paxfMhVKj4Pk0Lh13XtT+pXDvD+IdQrAbCk7rMNHo1ofwtOXInpbmiTZY5/M99a3+XvKafI9eAdtWH8xPHRayQCbiI4hDo3jkl6TOzddRr4PKvPlOqIPiHkRR8JwSFjiHs8pGtmUKH41cS69bOF4mmi07kzQLbEKJkWZid2dGUhOqbc6z1/wRtD3S6ACVp29tHalOaIyh/T6C37RWGYZbCon5ORKCZFjjNqIzPlTQE+8UM91bsZ22w8YjfgHFPhmd9MgT4e8P0sHrsh2jHVId/nIU9z7VW8PrbXGPJHfVnIV5ZduGL921tT6WzAWUS55Jt/f9ZXqv2IPDm+gWCaOv2vN9kprgkdoC0i5VeocSN+bVb9zumAp/ERF9JJVcVe3BdEQxuLUqE0EmEa/7lO71DU26XmXL6M0CxjPodLOK7gfX6RAFequTJWlm20+6+Al8lwm5V6GyBeuHQ4P93Tztwk0WYfDFXXAbGpkYN5pmhDsyeb3L6AUjff7wIWWW63K7XSZUaYdcYCbPhp0thWYFzBg//ZfCGgCQr435/XetHaDxBPav4qiV+NHZ7QfgxEay4Io1OQY/xXdHG4fYw5KEMRbcgrubPK6RXP2q2yLIAcpvfst89xGPLUq8smo3z+IjNexx3eCRlxT2ZFIJPoT+1InrG2zV++IykWl9c8GB3FXQtcUFDbmEoS6n7w=',
    SecureStorageKey.vaults.name:'BhInXa4ps9i/JlaiVgSrVsGp1mXDoUoQyLA0e/5iMetwNZ5WRnQlv8nrNjjkthbKGo9915CdHAsGQxYFs4bGLEjBja3rWVO1hWPUo/pnGevlfbeCgN5Y4NEQG6bz8RHHjaNLIeel/xj5unpaFt/eFg71fSsdUMrdlxd9vYPDTV2KPuDCrzq6PBikZQxwQ+RfXVhXtVRtmlza5KolYaaI2nBJpheKb6hm6P6XA9mTKLIB7i391bLDAZIndBkPpzvuC8HDXVPyAGi7ublguoPMG7qBLTNmt6Q83BMNAEDke/tgo5FTHUG5+HZ8ZqOphR0REd+xTis/gzxncdDheMkGFq/TAi0o+uM/N8s5E0alrjLa+1Mf',
    SecureStorageKey.wallets.name: 'DtTL1lkRsCtec5BZoOn7CeRi5rF9WfTAUpno8tEfDxZEi7cDKoxBxwJalUv0nfClezacdypqvxSetuMI8V0jZO+u07w83K/x54mtuM+X8qUqzdqha8fIqdcZYV66iQUFmy0KH5seF7383bHuoEr1AFAMyLrWje+Em2LfBKKDtAXyJQFy1PlZ5tkodiMAQlfUqXS9KPXfmae6hSKQIebl2NPXdZWVYAQzxPivkaWh3w6lKeHoG0DRlwAHLD0O9AopRgOQ5hliPqSoWlelhFBWlGrMNh/hwMA27UErKawMswIYDMu9FvjqVMiAIXI7BUWqbf72SYBktXlkPY6WS7OE7Z4ezR9a6H1AwoK9L38SDrmwQ3MNiQU45PhstPbq1CpxTDP0AnY2pyNy/0vBgmJ5txFAVcI5hU+YjQsD3q51CNe4uO1kIvWlIFCFDmVhh8PqV+sSNswVUcL1KpKaEPVO1E4draDJalOFk9zV0X2KU1QUJ1NIjdvXTaNgwaY+bTRWgPDu5cHcPxSHHXX/7Tlr3tz+2m+ElqST1++fRQZD4YolLfyVHBIM9PqEYNDkzDpvZb6X1cXSJ8UZBnwSnet+Kd+zyH+uMhb5+zBPIFsbNvFoZGjD',
  };

  Map<String, String> emptyGroupsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.groups.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  setUp(() {
    // @formatter:off
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      secureStorageContent: <String, String>{
        SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      },
    );
    // @formatter:on
  });

  group('Tests of initial database state', () {
    test('Should [return Map of groups] as ["groups" key value EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [return EMPTY map] as ["groups" key value is EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyGroupsDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{};

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsRepository.getAll()', () {
    test('Should [return List of GroupEntity] if ["groups" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAll();

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[
        GroupEntity(
          pinnedBool: false,
          encryptedBool: false,
          uuid: '0a73e366-264a-462f-b86c-40865933a8cd',
          name: 'AIRDROPS',
          filesystemPath: FilesystemPath.fromString('0a73e366-264a-462f-b86c-40865933a8cd'),
        ),
        GroupEntity(
          pinnedBool: false,
          encryptedBool: false,
          uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          name: 'WORK',
          filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
        ),
        NetworkGroupEntity(
          pinnedBool: false,
          encryptedBool: false,
          uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
          name: 'Ethereum',
          filesystemPath: FilesystemPath.fromString(
            'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          ),
          networkId: 'ethereum',
        ),
        GroupEntity(
          pinnedBool: false,
          encryptedBool: false,
          uuid: '1480a241-8561-4b93-96f8-6256234cec26',
          name: 'ETHEREUM BASED',
          filesystemPath:
              FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'),
        ),
      ];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });

    test('Should [return EMPTY list] if ["groups" key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyGroupsDatabase);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAll();

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });

    test('Should [return EMPTY list] if ["groups" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      // Act
      List<GroupEntity> actualGroupEntityList = await globalLocator<GroupsRepository>().getAll();

      // Assert
      List<GroupEntity> expectedGroupEntityList = <GroupEntity>[];

      expect(actualGroupEntityList, expectedGroupEntityList);
    });
  });

  group('Tests of GroupsRepository.getById()', () {
    test('Should [return GroupEntity] if [group UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      // Act
      GroupEntity actualGroupEntity = await globalLocator<GroupsRepository>().getById('c01a1d77-8952-43b5-99fb-fb3b7c680db2');

      // Assert
      GroupEntity expectedGroupEntity = GroupEntity(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        name: 'WORK',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
      );

      expect(actualGroupEntity, expectedGroupEntity);
    });

    test('Should [return NetworkGroupEntity] if [group UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      // Act
      GroupEntity actualGroupEntity = await globalLocator<GroupsRepository>().getById('b944d651-5162-479b-a927-8fcd4f47e074');

      // Assert
      NetworkGroupEntity expectedNetworkGroupEntity = NetworkGroupEntity(
        pinnedBool: false,
        encryptedBool: false,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        name: 'Ethereum',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkId: 'ethereum',
      );

      expect(actualGroupEntity, expectedNetworkGroupEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [group UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      // Assert
      expect(
        () => globalLocator<GroupsRepository>().getById('not-existing-uuid'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of GroupsRepository.save()', () {
    test('Should [UPDATE GroupEntity] if [group UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      GroupEntity actualUpdatedGroupEntity = GroupEntity(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        name: 'UPDATED GROUP',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualUpdatedGroupEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': true,
          'encrypted': true,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'UPDATED GROUP',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [UPDATE NetworkGroupEntity] if [group UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      NetworkGroupEntity actualUpdatedGroupEntity = NetworkGroupEntity(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        name: 'UPDATED GROUP',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkId: 'ethereum',
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualUpdatedGroupEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'WORK',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': true,
          'encrypted': true,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'UPDATED GROUP',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [SAVE GroupEntity] if [group UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyGroupsDatabase);

      GroupEntity actualNewGroupEntity = GroupEntity(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        name: 'NEW GROUP',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualNewGroupEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': true,
          'encrypted': true,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'NEW GROUP',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [SAVE NetworkGroupEntity] if [group UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyGroupsDatabase);

      NetworkGroupEntity actualNewGroupEntity = NetworkGroupEntity(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        name: 'NEW GROUP',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkId: 'ethereum',
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualNewGroupEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': true,
          'encrypted': true,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'NEW GROUP',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [SAVE GroupEntity] if ["group" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      GroupEntity actualNewGroupEntity = GroupEntity(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
        name: 'NEW GROUP',
        filesystemPath: FilesystemPath.fromString('c01a1d77-8952-43b5-99fb-fb3b7c680db2'),
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualNewGroupEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'c01a1d77-8952-43b5-99fb-fb3b7c680db2': <String, dynamic>{
          'type': 'group',
          'pinned': true,
          'encrypted': true,
          'uuid': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2',
          'name': 'NEW GROUP',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [SAVE NetworkGroupEntity] if ["group" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      NetworkGroupEntity actualNewGroupEntity = NetworkGroupEntity(
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'b944d651-5162-479b-a927-8fcd4f47e074',
        name: 'NEW GROUP',
        filesystemPath: FilesystemPath.fromString(
          'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
        ),
        networkId: 'ethereum',
      );

      // Act
      await globalLocator<GroupsRepository>().save(actualNewGroupEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': true,
          'encrypted': true,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'NEW GROUP',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of GroupsRepository.deleteById()', () {
    test('Should [REMOVE group] if [group UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledGroupsDatabase);

      // Act
      await globalLocator<GroupsRepository>().deleteById('c01a1d77-8952-43b5-99fb-fb3b7c680db2');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        '0a73e366-264a-462f-b86c-40865933a8cd': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '0a73e366-264a-462f-b86c-40865933a8cd',
          'name': 'AIRDROPS',
          'filesystem_path': '0a73e366-264a-462f-b86c-40865933a8cd'
        },
        'b944d651-5162-479b-a927-8fcd4f47e074': <String, dynamic>{
          'pinned': false,
          'encrypted': false,
          'uuid': 'b944d651-5162-479b-a927-8fcd4f47e074',
          'name': 'Ethereum',
          'filesystem_path':
              'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26/b944d651-5162-479b-a927-8fcd4f47e074',
          'type': 'network',
          'network_id': 'ethereum'
        },
        '1480a241-8561-4b93-96f8-6256234cec26': <String, dynamic>{
          'type': 'group',
          'pinned': false,
          'encrypted': false,
          'uuid': '1480a241-8561-4b93-96f8-6256234cec26',
          'name': 'ETHEREUM BASED',
          'filesystem_path': 'c01a1d77-8952-43b5-99fb-fb3b7c680db2/92b43ace-5439-4269-8e27-e999907f4379/1480a241-8561-4b93-96f8-6256234cec26'
        },
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [group UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyGroupsDatabase);

      // Assert
      expect(
        () => globalLocator<GroupsRepository>().deleteById('not-existing-uuid'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}