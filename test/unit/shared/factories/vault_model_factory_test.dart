import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

void main() {
  initLocator();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  Map<String, String> filledVaultsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379': <String, dynamic>{
        'index': 1,
        'uuid': '92b43ace-5439-4269-8e27-e999907f4379',
        'name': 'Test Vault 1',
        'password_protected': false,
      },
      'b1c2f688-85fc-43ba-9af1-52db40fa3093': <String, dynamic>{
        'index': 2,
        'uuid': 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
        'name': 'Test Vault 2',
        'password_protected': true,
      },
    }),
  };

  Map<String, String> emptyVaultsDatabase = <String, String>{
    actualDatabaseParentKey.name: jsonEncode(<String, dynamic>{}),
  };

  group('Tests of VaultModelFactory.createNewVault()', () {
    test('Should [return VaultModel] with [randomly generated UUID] and [index EQUALS 0] if there are no vaults in the database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());
      VaultModelFactory actualVaultModelFactory = VaultModelFactory(vaultsService: actualVaultsService);

      // Act
      VaultModel actualVaultModel = await actualVaultModelFactory.createNewVault();

      // Assert
      expect(actualVaultModel.index, 0);
      expect(actualVaultModel.uuid, isNotNull);
    });

    test('Should [return VaultModel] with [randomly generated UUID] and [index EQUALS 3] if the previous largest vault index is equal 2', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));
      VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());
      VaultModelFactory actualVaultModelFactory = VaultModelFactory(vaultsService: actualVaultsService);

      // Act
      VaultModel actualVaultModel = await actualVaultModelFactory.createNewVault();

      // Assert
      expect(actualVaultModel.index, 3);
      expect(actualVaultModel.uuid, isNotNull);
    });
  });

  group('Tests of VaultModelFactory.createFromEntity()', () {
    test('Should [return VaultModel] with values from given VaultEntity', () {
      // Arrange
      VaultModelFactory actualVaultModelFactory = VaultModelFactory();
      VaultEntity actualVaultEntity = const VaultEntity(
        index: 10,
        uuid: '7d871464-f352-432d-ad70-b001b38a17c9',
        name: 'test',
        passwordProtectedBool: false,
      );

      // Act
      VaultModel actualVaultModel = actualVaultModelFactory.createFromEntity(actualVaultEntity);

      // Assert
      VaultModel expectedVaultModel = VaultModel(
        index: 10,
        uuid: '7d871464-f352-432d-ad70-b001b38a17c9',
        name: 'test',
        passwordProtectedBool: false,
      );
      expect(actualVaultModel, expectedVaultModel);
    });
  });
}
