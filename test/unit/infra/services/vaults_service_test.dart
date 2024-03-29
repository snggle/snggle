import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
    },
  };

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  late VaultsService actualVaultsService;

  setUp(() {
    String testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    SecretsService actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    WalletsRepository actualWalletsRepository = WalletsRepository();
    WalletsService actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository);

    actualVaultsService = VaultsService(
      vaultsRepository: VaultsRepository(),
      secretsService: actualSecretsService,
      walletsService: actualWalletsService,
    );
  });

  group('Tests of VaultsService.getLastVaultIndex()', () {
    test('Should [return 2] if the largest vault index is equal 2', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      int actualLastVaultIndex = await actualVaultsService.getLastVaultIndex();

      // Assert
      expect(actualLastVaultIndex, 2);
    });

    test('Should [return -1] as a default value (empty collection)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

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

      // Act
      List<VaultModel> actualVaultModelList = await actualVaultsService.getVaultList();

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[
        VaultModel(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: true, name: 'Test Vault 1'),
        VaultModel(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2'),
      ];

      expect(actualVaultModelList, expectedVaultModelList);
    });

    test('Should [return EMPTY list] if ["vaults" key is EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      // Act
      List<VaultModel> actualVaultModelList = await actualVaultsService.getVaultList();

      // Assert
      List<VaultModel> expectedVaultModelList = <VaultModel>[];

      expect(actualVaultModelList, expectedVaultModelList);
    });
  });

  group('Tests of VaultsService.getVaultById()', () {
    test('Should [return VaultModel] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

      // Act
      VaultModel actualVaultModel = await actualVaultsService.getVaultById('92b43ace-5439-4269-8e27-e999907f4379');

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        index: 1,
        uuid: '92b43ace-5439-4269-8e27-e999907f4379',
        pinnedBool: true,
        name: 'Test Vault 1',
      );

      expect(actualVaultModel, expectedVaultModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      // Act;
      expect(
        () => actualVaultsService.getVaultById('not-existing-uuid'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of VaultsService.saveVault()', () {
    test('Should [UPDATE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      VaultModel newVaultModel = VaultModel(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: true, name: 'Updated Vault');

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
      await actualVaultsService.saveVault(newVaultModel);
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
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
          'pinned': true,
          'name': 'Updated Vault',
        },
      };

      TestUtils.printInfo('Should [return Map of vaults] with updated vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      VaultModel newVaultModel = VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: true, name: 'New Vault');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

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
  });

  group('Tests of VaultsService.deleteVaultById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
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
      await actualVaultsService.deleteVaultById('b1c2f688-85fc-43ba-9af1-52db40fa3093');
      actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedVaultsKeyValue!);
      actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedVaultsMap = <String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'pinned': true,
          'name': 'Test Vault 1',
        },
      };

      TestUtils.printInfo('Should [return Map of vaults] without removed vault');
      expect(actualVaultsMap, expectedVaultsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));

      // Assert
      expect(
        () => actualVaultsService.deleteVaultById('06fd9092-96d6-4c34-bc6d-8fb3d2f05415'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}