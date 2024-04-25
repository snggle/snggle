import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'pJ9oebXNvPd2LtRmPMKTQ7w1fswHP5E/6nTpAro4GpPwruAvkLy1mMTiEbiQ17Bw9tteULmYR3TidUOyimkFWmPD94O4gyhu4MEUP/wFajfsNY4AHjJ2bk7ZdZofZRqXXShkNSSDgQY2kKqlUndUx1XOd4+OcL1S6JuSSFoKm8LGUu5EDlvMRQbbUTkwFnW2kiXCbjBXVeDO4yaAKx6Shctr5ReU3bCT5K+9c2qjkBEb+Mj+qhtvxzaFJBvVZKqRjykBLYU9sSrrJnIzIIERjx+1s4WcIFuYQHvQzqCpPlCDi9ZA5xRm3QGw2tJQ4eRWWp2Tg2UE1PpJQcwR8O4+MZ6TDMg=',
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  group('Tests of VaultsService.getLastVaultIndex()', () {
    test('Should [return 2] if the largest vault index is equal 2', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      int actualLastVaultIndex = await actualVaultsService.getLastVaultIndex();

      // Assert
      expect(actualLastVaultIndex, 2);
    });

    test('Should [return -1] as a default value (empty collection)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      int actualLastVaultIndex = await actualVaultsService.getLastVaultIndex();

      // Assert
      expect(actualLastVaultIndex, -1);
    });
  });

  group('Tests of VaultsService.getVaultList()', () {
    test('Should [return List of VaultModel] if ["vaults" key HAS VALUES] ', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      List<VaultModel> actualVaultModelList = await actualVaultsService.getVaultList();

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', name: 'Test Vault 1'),
        VaultModel(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'Test Vault 2'),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return EMPTY list] if ["vaults" key is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      List<VaultModel> actualVaultModelList = await actualVaultsService.getVaultList();

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[];

      expect(actualVaultModelList, expectedVaultModelList);
    });
  });

  group('Tests of VaultsService.saveVault()', () {
    test('Should [UPDATE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      VaultModel newVaultModel = VaultModel(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'Updated Vault');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Test Vault 2'},
      };

      TestUtils.printInfo('Should [return Map of vaults] as ["vaults" key EXISTS] in database');
      expect(actualVaultsMap, expectedVaultsMap);

      // ************************************************************************************************

      // Act
      await actualVaultsService.saveVault(newVaultModel);
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Updated Vault'},
      };

      TestUtils.printInfo('Should [return Map of vaults] with updated vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      VaultModel newVaultModel = VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'New Vault');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{};

      TestUtils.printInfo('Should [return EMPTY map] as ["vaults" key value is EMPTY]');
      expect(actualVaultsMap, expectedVaultsMap);

      // ************************************************************************************************

      // Act
      await actualVaultsService.saveVault(newVaultModel);
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 1, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'New Vault'}
      };

      TestUtils.printInfo('Should [return Map of vaults] with new vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsService.deleteVaultById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Test Vault 2'},
      };

      TestUtils.printInfo('Should [return Map of vaults] as ["vaults" key EXISTS] in database');
      expect(actualVaultsMap, expectedVaultsMap);

      // ************************************************************************************************

      // Act
      await actualVaultsService.deleteVaultById('b1c2f688-85fc-43ba-9af1-52db40fa3093');
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
      };

      TestUtils.printInfo('Should [return Map of vaults] without removed vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Assert
      expect(
        () => actualVaultsService.deleteVaultById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}