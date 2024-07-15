import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.vaults;

  // @formatter:off
  Map<String, String> filledVaultsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.vaults.name:'HrSAuzL39JquAN92Hq+TidSF6T4RaXf5TX8++/LNiUp6AjprjtjphbmRZkJ8XV0Gtu3ToaG7W9NIUuwAadgcJuk/1mjJM1Fi2kHI4czI7Ljg9wAARGIUpnSb5CZniFRymA9JujPoea8SkaVhSM9YL/xUa8K7lanwRn21IiOMQJ++ljk+LfbMRi0ebEPMTGnayCj2hDrOKcSYAehHrZ6ECYFDSUthhDrUZEmxbUqNVBHUJiJqW/etEgZYckKRfQxzFB2qhriBRutYhAWK4HGTBAIPjcZT7ydWAOp5v5MkbHkCE+ic9KdJk1aOoj+5BBLuEkXF2ao1zHqwBXq3jb/pgu2ZI0DyhNPY4lCQw7dnFT6ZflP3FNitnbGzWAu8FlP0Pll6gcuxRiV8H/R4QDdMOCxZZfWuIMJmLZbYGq2TClC/duRR/3oa7tPLHNYRN6tDszJfzQC/pldijozd8pW5NBElodHGjPFdLSgM+iG/lChwqMQ74iGxHOr9zLHCF6ldB4wXIUMdDGVOx255A1YtzI9uqilGshjhYPL6OXhkEspKuTqBZuABoEWQA2MCOmWO7jQdgTOB0xa6B438w95XaTpb1mH09rrjjYEspk18jLH0GsYabWrW/2kWh2xnwVHGtW9uMpkDPqFAYMpbVWliQhTbexUrOBwjV6GWFCCJ3eDRdkNH97FGoEmxOYTVYTVJEWQeBDNZUBLCyvN0IBpiLKFtDAc8grgLjtLpZZt0Jv090Aoh/VCrrhTHuN5oSNQtEUUULha/ZoDF7bqtFCF6boANi6hjAmjKaGz3pN/jKKCkDdoar9T1SU6yFFUS9YUIWHbhesOXrILEiPcpyHmg4t31wpaOZtnR3Tc7dkHIyr3iID//7i/DVPxws0wMV+nEsi48LL/SbkUJwXEK/dM2BIVDK1Y=',
    SecureStorageKey.wallets.name: 'rGYdF3j8KhnKg/BL+8ss82On/2WHDui2Vsof+R4246/wLjWhb6rHWPh2r/ddeyYzFgYfXDsV3ewAkXJ0vyoXf4UvAg1rUixEyAWhY8dfLJl2KT2EagbxBb8TyaDV9JDMnyi+TwvFuKN76eP9ZXG7tTiIYa9p+n3kmM0XfSQzTQk5qinlSReoEn19aaa4c57KTgSSmZmR8sDJpbt59a9Rhq9y7CDfhbQuR8Xu1ma1b4Wd6gfnx7XYYepGCWHYi3ZQadI5p7QuIv/52S/fRsvQ6vM2564u5dnxyHXwxHncmJqQgl4z9XKwkmwo1rO5mmrYQ62VDpRhxiCsViYpOqsLRwmgwhf3dcclm1IG2rGsn9t5sxrSFJZLdCJTJlYviQEbod/8cI974znkvwayScDlJNJ9Ku6pzbMnharaoOQB8pm2O8om79gBUu3ZiA09H1jIvxX2bPj4q3MnB+OnAhmY/Hk6T4u3bR0dk9PBRQ1uM5VbY4eobNvfo3fSBdjhx6h9jPosJyNJQOFBhFLbvKwcoeaPeMCclWLX6Zd5PlxeP143i/hvBYvAzzSQKoKEHjczcSylV2o5QFGFMFzV+dUT9vXk2Z+98htYJuwecUPPqih7Fx9OU4Qn8WN2bRwjdXNDwaebD081Esk9LKnIQy8W0TeXAP7rs4326xWc2tZCg0O2dSi1K7lv2erb32ZNbT5Ys173TqHOryKxvE8OsP/NtpwWkqRbb5H6SEVtbERnK6D1ljx0CDEsNgFMzLezp6o2NtVzhETTWRxYJMksD9iHCNp4MZ9Mocrn7iipX+vMGUsdCdUpdljTeYfBPsklaxnQ+v9J6tgI+aOfdAhTYA1yfgxK8Sxxmp3NLyjGdG6RIHmOjrqFeAjLN+haZF7C501KTETmYSynfYGJjOLgF1zy1/TR+kg9y8Lly76WL2xWx7RFvBopfPeaaeSTym1xwxumKdmfIbms/AxaPGz7NmYbGMk8w2Y=',
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    SecureStorageKey.vaults.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  setUp(() {
    testDatabase = TestDatabase(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of initial database state', () {
    test('Should [return Map of vaults] as ["vaults" key value EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'pinned': true,
          'encrypted': true,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'filesystem_path': '92b43ace-5439-4269-8e27-e999907f4379',
          'name': 'Test Vault 1'
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'pinned': true,
          'encrypted': true,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'filesystem_path': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'name': 'Test Vault 2'
        },
        '438791a4-b537-4589-af4f-f56b6449a0bb': <String, dynamic>{
          'index': 3,
          'pinned': true,
          'encrypted': true,
          'uuid': '438791a4-b537-4589-af4f-f56b6449a0bb',
          'filesystem_path': 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb',
          'name': 'Test Vault 3'
        }
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [return EMPTY map] as ["vaults" key value is EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyVaultsDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{};

      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsRepository.getAll()', () {
    test('Should [return List of VaultEntity] if ["vaults" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[
        VaultEntity(
          pinnedBool: true,
          encryptedBool: true,
          index: 1,
          uuid: '92b43ace-5439-4269-8e27-e999907f4379',
          name: 'Test Vault 1',
          filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
        ),
        VaultEntity(
          pinnedBool: true,
          encryptedBool: true,
          index: 2,
          uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          name: 'Test Vault 2',
          filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
        ),
        VaultEntity(
          pinnedBool: true,
          encryptedBool: true,
          index: 3,
          uuid: '438791a4-b537-4589-af4f-f56b6449a0bb',
          name: 'Test Vault 3',
          filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb'),
        ),
      ];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });

    test('Should [return EMPTY list] if ["vaults" key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyVaultsDatabase);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });

    test('Should [return EMPTY list] if ["vaults" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      // Act
      List<VaultEntity> actualVaultEntityList = await globalLocator<VaultsRepository>().getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });
  });

  group('Tests of VaultsRepository.getById()', () {
    test('Should [return VaultEntity] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      // Act
      VaultEntity actualVaultEntity = await globalLocator<VaultsRepository>().getById('92b43ace-5439-4269-8e27-e999907f4379');

      // Assert
      VaultEntity expectedVaultEntity = VaultEntity(
        pinnedBool: true,
        encryptedBool: true,
        index: 1,
        uuid: '92b43ace-5439-4269-8e27-e999907f4379',
        name: 'Test Vault 1',
        filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
      );

      expect(actualVaultEntity, expectedVaultEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      // Assert
      expect(
        () => globalLocator<VaultsRepository>().getById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsRepository.save()', () {
    test('Should [UPDATE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      VaultEntity actualUpdatedVaultEntity = VaultEntity(
        pinnedBool: true,
        encryptedBool: false,
        index: 2,
        uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        name: 'Updated name',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
      );

      // Act
      await globalLocator<VaultsRepository>().save(actualUpdatedVaultEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'pinned': true,
          'encrypted': true,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'filesystem_path': '92b43ace-5439-4269-8e27-e999907f4379',
          'name': 'Test Vault 1'
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'pinned': true,
          'encrypted': false,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'filesystem_path': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'name': 'Updated name'
        },
        '438791a4-b537-4589-af4f-f56b6449a0bb': <String, dynamic>{
          'index': 3,
          'pinned': true,
          'encrypted': true,
          'uuid': '438791a4-b537-4589-af4f-f56b6449a0bb',
          'filesystem_path': 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb',
          'name': 'Test Vault 3'
        }
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyVaultsDatabase);

      VaultEntity actualNewVaultEntity = VaultEntity(
        encryptedBool: true,
        pinnedBool: false,
        index: 1,
        uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        name: 'NEW VAULT',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
      );

      // Act
      await globalLocator<VaultsRepository>().save(actualNewVaultEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 1,
          'pinned': false,
          'encrypted': true,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'filesystem_path': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'name': 'NEW VAULT'
        }
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if ["vaults" key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      VaultEntity actualNewVaultEntity = VaultEntity(
        pinnedBool: true,
        encryptedBool: false,
        index: 1,
        uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        name: 'NEW VAULT',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
      );

      // Act
      await globalLocator<VaultsRepository>().save(actualNewVaultEntity);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 1,
          'pinned': true,
          'encrypted': false,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'filesystem_path': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'name': 'NEW VAULT'
        }
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsRepository.deleteById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledVaultsDatabase);

      // Act
      await globalLocator<VaultsRepository>().deleteById('92b43ace-5439-4269-8e27-e999907f4379');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'pinned': true,
          'encrypted': true,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'filesystem_path': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'name': 'Test Vault 2'
        },
        '438791a4-b537-4589-af4f-f56b6449a0bb': <String, dynamic>{
          'index': 3,
          'pinned': true,
          'encrypted': true,
          'uuid': '438791a4-b537-4589-af4f-f56b6449a0bb',
          'filesystem_path': 'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb',
          'name': 'Test Vault 3'
        }
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyVaultsDatabase);

      // Assert
      expect(
        () => globalLocator<VaultsRepository>().deleteById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}
