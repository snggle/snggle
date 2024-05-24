import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  String testSessionUUID = const Uuid().v4();

  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
      'e527efe1-a05b-49f5-bfe9-d3532f5c9db9': <String, dynamic>{
        '438791a4-b537-4589-af4f-f56b6449a0bb.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      },
    },
  };

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'HrSAuzL39JquAN92Hq+TidSF6T4RaXf5TX8++/LNiUp6AjprjtjphbmRZkJ8XV0Gtu3ToaG7W9NIUuwAadgcJuk/1mjJM1Fi2kHI4czI7Ljg9wAARGIUpnSb5CZniFRymA9JujPoea8SkaVhSM9YL/xUa8K7lanwRn21IiOMQJ++ljk+LfbMRi0ebEPMTGnayCj2hDrOKcSYAehHrZ6ECYFDSUthhDrUZEmxbUqNVBHUJiJqW/etEgZYckKRfQxzFB2qhriBRutYhAWK4HGTBAIPjcZT7ydWAOp5v5MkbHkCE+ic9KdJk1aOoj+5BBLuEkXF2ao1zHqwBXq3jb/pgu2ZI0DyhNPY4lCQw7dnFT6ZflP3FNitnbGzWAu8FlP0Pll6gcuxRiV8H/R4QDdMOCxZZfWuIMJmLZbYGq2TClC/duRR/3oa7tPLHNYRN6tDszJfzQC/pldijozd8pW5NBElodHGjPFdLSgM+iG/lChwqMQ74iGxHOr9zLHCF6ldB4wXIUMdDGVOx255A1YtzI9uqilGshjhYPL6OXhkEspKuTqBZuABoEWQA2MCOmWO7jQdgTOB0xa6B438w95XaTpb1mH09rrjjYEspk18jLH0GsYabWrW/2kWh2xnwVHGtW9uMpkDPqFAYMpbVWliQhTbexUrOBwjV6GWFCCJ3eDRdkNH97FGoEmxOYTVYTVJEWQeBDNZUBLCyvN0IBpiLKFtDAc8grgLjtLpZZt0Jv090Aoh/VCrrhTHuN5oSNQtEUUULha/ZoDF7bqtFCF6boANi6hjAmjKaGz3pN/jKKCkDdoar9T1SU6yFFUS9YUIWHbhesOXrILEiPcpyHmg4t31wpaOZtnR3Tc7dkHIyr3iID//7i/DVPxws0wMV+nEsi48LL/SbkUJwXEK/dM2BIVDK1Y=',
    DatabaseParentKey.wallets.name: 'rGYdF3j8KhnKg/BL+8ss82On/2WHDui2Vsof+R4246/wLjWhb6rHWPh2r/ddeyYzFgYfXDsV3ewAkXJ0vyoXf4UvAg1rUixEyAWhY8dfLJl2KT2EagbxBb8TyaDV9JDMnyi+TwvFuKN76eP9ZXG7tTiIYa9p+n3kmM0XfSQzTQk5qinlSReoEn19aaa4c57KTgSSmZmR8sDJpbt59a9Rhq9y7CDfhbQuR8Xu1ma1b4Wd6gfnx7XYYepGCWHYi3ZQadI5p7QuIv/52S/fRsvQ6vM2564u5dnxyHXwxHncmJqQgl4z9XKwkmwo1rO5mmrYQ62VDpRhxiCsViYpOqsLRwmgwhf3dcclm1IG2rGsn9t5sxrSFJZLdCJTJlYviQEbod/8cI974znkvwayScDlJNJ9Ku6pzbMnharaoOQB8pm2O8om79gBUu3ZiA09H1jIvxX2bPj4q3MnB+OnAhmY/Hk6T4u3bR0dk9PBRQ1uM5VbY4eobNvfo3fSBdjhx6h9jPosJyNJQOFBhFLbvKwcoeaPeMCclWLX6Zd5PlxeP143i/hvBYvAzzSQKoKEHjczcSylV2o5QFGFMFzV+dUT9vXk2Z+98htYJuwecUPPqih7Fx9OU4Qn8WN2bRwjdXNDwaebD081Esk9LKnIQy8W0TeXAP7rs4326xWc2tZCg0O2dSi1K7lv2erb32ZNbT5Ys173TqHOryKxvE8OsP/NtpwWkqRbb5H6SEVtbERnK6D1ljx0CDEsNgFMzLezp6o2NtVzhETTWRxYJMksD9iHCNp4MZ9Mocrn7iipX+vMGUsdCdUpdljTeYfBPsklaxnQ+v9J6tgI+aOfdAhTYA1yfgxK8Sxxmp3NLyjGdG6RIHmOjrqFeAjLN+haZF7C501KTETmYSynfYGJjOLgF1zy1/TR+kg9y8Lly76WL2xWx7RFvBopfPeaaeSTym1xwxumKdmfIbms/AxaPGz7NmYbGMk8w2Y=',
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  setUp(() {
    globalLocator.allowReassignment = true;
    initLocator();

    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

    globalLocator.registerLazySingleton(() => actualSecretsRepository);
    globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);
  });

  group('Tests of initial database state', () {
    test('Should [return Map of vaults] as ["vaults" key value EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

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
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{};

      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsService.getLastIndex()', () {
    test('Should [return 3] if the largest vault index is equal 3', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      int actualLastVaultIndex = await globalLocator<VaultsService>().getLastIndex();

      // Assert
      expect(actualLastVaultIndex, 3);
    });

    test('Should [return -1] as a default value (empty collection)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      // Act
      int actualLastVaultIndex = await globalLocator<VaultsService>().getLastIndex();

      // Assert
      expect(actualLastVaultIndex, -1);
    });
  });

  group('Tests of VaultsService.getById()', () {
    test('Should [return VaultModel] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      VaultModel actualVaultModel = await globalLocator<VaultsService>().getById('92b43ace-5439-4269-8e27-e999907f4379');

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        index: 1,
        pinnedBool: true,
        encryptedBool: true,
        uuid: '92b43ace-5439-4269-8e27-e999907f4379',
        filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
        name: 'Test Vault 1',
        listItemsPreview: <AListItemModel>[],
      );

      expect(actualVaultModel, expectedVaultModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Assert
      expect(
        () => globalLocator<VaultsService>().getById('non-existent-uuid'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsService.getAllByParentPath()', () {
    test('Should [return List of VaultModel] if [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: true);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(
          index: 1,
          pinnedBool: true,
          encryptedBool: true,
          uuid: '92b43ace-5439-4269-8e27-e999907f4379',
          filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
          name: 'Test Vault 1',
          listItemsPreview: <AListItemModel>[],
        ),
        VaultModel(
          index: 2,
          pinnedBool: true,
          encryptedBool: true,
          uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
          name: 'Test Vault 2',
          listItemsPreview: <AListItemModel>[
            WalletModel(
              encryptedBool: false,
              pinnedBool: true,
              index: 0,
              address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
              derivationPath: "m/44'/118'/0'/0/0",
              network: 'ethereum',
              uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
              name: 'WALLET 0',
              filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093/4e66ba36-966e-49ed-b639-191388ce38de'),
            ),
          ],
        ),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return List of VaultModel] if [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(const FilesystemPath.empty(), firstLevelBool: false);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(
          index: 1,
          pinnedBool: true,
          encryptedBool: true,
          uuid: '92b43ace-5439-4269-8e27-e999907f4379',
          filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
          name: 'Test Vault 1',
          listItemsPreview: <AListItemModel>[],
        ),
        VaultModel(
          index: 2,
          pinnedBool: true,
          encryptedBool: true,
          uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
          name: 'Test Vault 2',
          listItemsPreview: <AListItemModel>[
            WalletModel(
              encryptedBool: false,
              pinnedBool: true,
              index: 0,
              address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
              derivationPath: "m/44'/118'/0'/0/0",
              network: 'ethereum',
              uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
              name: 'WALLET 0',
              filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093/4e66ba36-966e-49ed-b639-191388ce38de'),
            ),
          ],
        ),
        VaultModel(
          index: 3,
          pinnedBool: true,
          encryptedBool: true,
          uuid: '438791a4-b537-4589-af4f-f56b6449a0bb',
          filesystemPath: FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb'),
          name: 'Test Vault 3',
          listItemsPreview: <AListItemModel>[
            WalletModel(
              encryptedBool: false,
              pinnedBool: true,
              index: 0,
              address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
              derivationPath: "m/44'/118'/0'/0/1",
              network: 'ethereum',
              uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
              name: 'WALLET 0',
              filesystemPath: FilesystemPath.fromString(
                'e527efe1-a05b-49f5-bfe9-d3532f5c9db9/438791a4-b537-4589-af4f-f56b6449a0bb/3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
              ),
            ),
          ],
        ),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == TRUE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: true);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY] (firstLevelBool == FALSE)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Act
      List<VaultModel> actualVaultModelList = await globalLocator<VaultsService>().getAllByParentPath(actualFilesystemPath, firstLevelBool: false);

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[];

      expect(actualVaultModelList, expectedVaultModelList);
    });
  });

  group('Tests of VaultsService.save()', () {
    test('Should [UPDATE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      VaultModel newVaultModel = VaultModel(
        index: 1,
        pinnedBool: true,
        encryptedBool: true,
        uuid: '92b43ace-5439-4269-8e27-e999907f4379',
        filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
        name: 'UPDATED VAULT',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<VaultsService>().save(newVaultModel);
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'pinned': true,
          'encrypted': true,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'filesystem_path': '92b43ace-5439-4269-8e27-e999907f4379',
          'name': 'UPDATED VAULT'
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
        },
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      VaultModel newVaultModel = VaultModel(
        index: 1,
        pinnedBool: true,
        encryptedBool: true,
        uuid: 'c364c002-2213-4e0b-9a91-600acedac274',
        filesystemPath: FilesystemPath.fromString('c364c002-2213-4e0b-9a91-600acedac274'),
        name: 'NEW VAULT',
        listItemsPreview: <AListItemModel>[],
      );

      // Act
      await globalLocator<VaultsService>().save(newVaultModel);
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        'c364c002-2213-4e0b-9a91-600acedac274': <String, dynamic>{
          'index': 1,
          'pinned': true,
          'encrypted': true,
          'uuid': 'c364c002-2213-4e0b-9a91-600acedac274',
          'filesystem_path': 'c364c002-2213-4e0b-9a91-600acedac274',
          'name': 'NEW VAULT'
        }
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsService.deleteAllByParentPath()', () {
    test('Should [REMOVE vaults] if [vaults with path EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      await globalLocator<VaultsService>().deleteAllByParentPath(FilesystemPath.fromString('e527efe1-a05b-49f5-bfe9-d3532f5c9db9'));
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

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
      };

      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [REMOVE ALL vaults] if [path EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      await globalLocator<VaultsService>().deleteAllByParentPath(const FilesystemPath.empty());
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{};

      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsService.deleteById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      await globalLocator<VaultsService>().deleteById('b1c2f688-85fc-43ba-9af1-52db40fa3093');
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

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
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      // Assert
      expect(
        () => globalLocator<VaultsService>().deleteById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}