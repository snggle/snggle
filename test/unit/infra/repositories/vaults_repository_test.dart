import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO masterKeyVO = const MasterKeyVO(
      encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  group('Tests of VaultsRepository.getAll()', () {
    test('Should [return List of VaultEntity] if ["vaults" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      List<VaultEntity> actualVaultEntityList = await actualVaultsRepository.getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[
        const VaultEntity(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', name: 'Test Vault 1', pinnedBool: true),
        const VaultEntity(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'Test Vault 2', pinnedBool: false),
      ];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });

    test('Should [return EMPTY list] if ["vaults" key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      List<VaultEntity> actualVaultEntityList = await actualVaultsRepository.getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });

    test('Should [return EMPTY list] if ["vaults" key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      List<VaultEntity> actualVaultEntityList = await actualVaultsRepository.getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[];

      expect(actualVaultEntityList, expectedVaultEntityList);
    });
  });

  group('Tests of VaultsRepository.getById()', () {
    test('Should [return VaultEntity] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      VaultEntity actualVaultEntity = await actualVaultsRepository.getById('92b43ace-5439-4269-8e27-e999907f4379');

      // Assert
      VaultEntity expectedVaultEntity = const VaultEntity(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', name: 'Test Vault 1', pinnedBool: true);

      expect(actualVaultEntity, expectedVaultEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Assert
      expect(
        () => actualVaultsRepository.getById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsRepository.save()', () {
    test('Should [UPDATE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      VaultEntity actualUpdatedVaultEntity = const VaultEntity(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'Updated name', pinnedBool: false);

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'pinned': true,
          'name': 'Test Vault 1',
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'pinned': false,
          'name': 'Test Vault 2',
        },
      };

      TestUtils.printInfo('Should [return Map of vaults] as ["vaults" key EXISTS] in database');
      expect(actualVaultsMap, expectedVaultsMap);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.save(actualUpdatedVaultEntity);
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'pinned': true,
          'name': 'Test Vault 1',
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'pinned': false,
          'name': 'Updated name',
        },
      };

      TestUtils.printInfo('Should [return Map of vaults] with updated vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      VaultEntity actualNewVaultEntity = const VaultEntity(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'New Vault', pinnedBool: true);

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{};

      TestUtils.printInfo('Should [return EMPTY map] as ["vault" key value is EMPTY]');
      expect(actualVaultsMap, expectedVaultsMap);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.save(actualNewVaultEntity);
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 1,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'pinned': true,
          'name': 'New Vault',
        }
      };

      TestUtils.printInfo('Should [return Map of vaults] with new vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if ["vaults" key NOT EXISTS] in database', () async {
      // Arrange
      VaultEntity actualNewVaultEntity = const VaultEntity(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'New Vault', pinnedBool: false);

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualEncryptedVaultKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as ["vault" key NOT EXISTS] in database');
      expect(actualEncryptedVaultKeyValue, null);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.save(actualNewVaultEntity);
      actualEncryptedVaultKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 1,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'pinned': false,
          'name': 'New Vault',
        }
      };

      TestUtils.printInfo('Should [return Map of vaults] with new vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });
  });

  group('Tests of VaultsRepository.deleteById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedVaultsKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'pinned': true,
          'name': 'Test Vault 1',
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'pinned': false,
          'name': 'Test Vault 2',
        },
      };

      TestUtils.printInfo('Should [return Map of vaults] as ["vault" key EXISTS] in database');
      expect(actualVaultsMap, expectedVaultsMap);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.deleteById('92b43ace-5439-4269-8e27-e999907f4379');
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = masterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'pinned': false,
          'name': 'Test Vault 2',
        },
      };

      TestUtils.printInfo('Should [return Map of vaults] without removed vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Assert
      expect(
        () => actualVaultsRepository.deleteById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}
