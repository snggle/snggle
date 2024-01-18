import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  Map<String, String> filledVaultsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
      'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Test Vault 2'},
    }),
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{}),
  };

  Map<String, String> emptyDatabase = <String, String>{};

  group('Tests of VaultsRepository.getAll()', () {
    test('Should [return List of VaultEntity] if ["vaults" key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      List<VaultEntity> actualVaultEntityList = await actualVaultsRepository.getAll();

      // Assert
      List<VaultEntity> expectedVaultEntityList = <VaultEntity>[
        const VaultEntity(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', name: 'Test Vault 1'),
        const VaultEntity(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'Test Vault 2'),
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
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
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
      VaultEntity expectedVaultEntity = const VaultEntity(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', name: 'Test Vault 1');

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
      VaultEntity actualUpdatedVaultEntity = const VaultEntity(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'Updated name');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Test Vault 2'},
      });

      TestUtils.printInfo('Should [return Map of vaults] as ["vaults" key EXISTS] in database');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.save(actualUpdatedVaultEntity);
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Updated name'},
      });

      TestUtils.printInfo('Should [return Map of vaults] with updated vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
    });

    test('Should [SAVE vault] if [vault UUID NOT EXISTS] in collection', () async {
      // Arrange
      VaultEntity actualNewVaultEntity = const VaultEntity(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'New Vault');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{});

      TestUtils.printInfo('Should [return EMPTY map] as ["vault" key value is EMPTY]');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.save(actualNewVaultEntity);
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 1, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'New Vault'}
      });

      TestUtils.printInfo('Should [return Map of vaults] with new vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
    });

    test('Should [SAVE vault] if ["vaults" key NOT EXISTS] in database', () async {
      // Arrange
      VaultEntity actualNewVaultEntity = const VaultEntity(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', name: 'New Vault');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as ["vault" key NOT EXISTS] in database');
      expect(actualVaultsKeyValue, null);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.save(actualNewVaultEntity);
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 1, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'New Vault'}
      });

      TestUtils.printInfo('Should [return Map of vaults] with new vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
    });
  });

  group('Tests of VaultsRepository.deleteById()', () {
    test('Should [REMOVE vault] if [vault UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsRepository actualVaultsRepository = VaultsRepository();

      // Act
      String? actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{'index': 1, 'uuid': '92b43ace-5439-4269-8e27-e999907f4379', 'name': 'Test Vault 1'},
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Test Vault 2'},
      });

      TestUtils.printInfo('Should [return Map of vaults] as ["vault" key EXISTS] in database');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);

      // ************************************************************************************************

      // Act
      await actualVaultsRepository.deleteById('92b43ace-5439-4269-8e27-e999907f4379');
      actualVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedVaultsKeyValue = jsonEncode(<String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{'index': 2, 'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093', 'name': 'Test Vault 2'},
      });

      TestUtils.printInfo('Should [return Map of vaults] without removed vault');
      expect(actualVaultsKeyValue, expectedVaultsKeyValue);
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
