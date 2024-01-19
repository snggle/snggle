import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  Map<String, String> filledVaultsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
        'index': 1,
        'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
        'password_protected': true,
        'name': 'Test Vault 1',
      },
      'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
        'index': 2,
        'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        'password_protected': false,
        'name': 'Test Vault 2',
      },
    }),
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{}),
  };

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
        VaultModel(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', passwordProtectedBool: true, name: 'Test Vault 1'),
        VaultModel(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', passwordProtectedBool: false, name: 'Test Vault 2'),
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
      VaultModel newVaultModel = VaultModel(
        index: 2,
        uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        passwordProtectedBool: true,
        name: 'Updated name',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'password_protected': true,
          'name': 'Test Vault 1',
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'password_protected': false,
          'name': 'Test Vault 2',
        },
      });

      TestUtils.printInfo('Should [return Map of vaults] as ["vaults" key EXISTS] in database');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);

      // ************************************************************************************************

      // Act
      await actualVaultsService.saveVault(newVaultModel);
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'password_protected': true,
          'name': 'Test Vault 1',
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'password_protected': true,
          'name': 'Updated name',
        },
      });

      TestUtils.printInfo('Should [return Map of vaults] with updated vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      VaultModel newVaultModel = VaultModel(
        index: 1,
        uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        passwordProtectedBool: false,
        name: 'New Vault',
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{});

      TestUtils.printInfo('Should [return EMPTY map] as ["vault" key value is EMPTY]');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);

      // ************************************************************************************************

      // Act
      await actualVaultsService.saveVault(newVaultModel);
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 1,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'password_protected': false,
          'name': 'New Vault',
        }
      });

      TestUtils.printInfo('Should [return Map of vaults] with new vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
    });
  });

  group('Tests of VaultsService.deleteVaultById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'password_protected': true,
          'name': 'Test Vault 1',
        },
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
          'index': 2,
          'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
          'password_protected': false,
          'name': 'Test Vault 2',
        },
      });

      TestUtils.printInfo('Should [return Map of vaults] as ["vault" key EXISTS] in database');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);

      // ************************************************************************************************

      // Act
      await actualVaultsService.deleteVaultById('b1c2f688-85fc-43ba-9af1-52db40fa3093');
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
          'index': 1,
          'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
          'password_protected': true,
          'name': 'Test Vault 1',
        },
      });

      TestUtils.printInfo('Should [return Map of vaults] without removed vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
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
