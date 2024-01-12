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

  // @formatter:off
  Map<String, String> filledChildKeysDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'pJ9oebXNvPd2LtRmPMKTQ7w1fswHP5E/6nTpAro4GpPwruAvkLy1mMTiEbiQ17Bw9tteULmYR3TidUOyimkFWmPD94O4gyhu4MEUP/wFajfsNY4AHjJ2bk7ZdZofZRqXXShkNSSDgQY2kKqlUndUx1XOd4+OcL1S6JuSSFoKm8LGUu5EDlvMRQbbUTkwFnW2kiXCbjBXVeDO4yaAKx6Shctr5ReU3bCT5K+9c2qjkBEb+Mj+qhtvxzaFJBvVZKqRjykBLYU9sSrrJnIzIIERjx+1s4WcIFuYQHvQzqCpPlCDi9ZA5xRm3QGw2tJQ4eRWWp2Tg2UE1PpJQcwR8O4+MZ6TDMg=',
  };

  Map<String, String> emptyChildKeysDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  group('Tests of VaultModelFactory.createNewVault()', () {
    test('Should [return VaultModel] with [randomly generated UUID] and [index EQUALS 0] if there are no vaults in the database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyChildKeysDatabase));
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
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
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
      VaultEntity actualVaultEntity = const VaultEntity(index: 10, uuid: '7d871464-f352-432d-ad70-b001b38a17c9', name: 'test');

      // Act
      VaultModel actualVaultModel = actualVaultModelFactory.createFromEntity(actualVaultEntity);

      // Assert
      VaultModel expectedVaultModel = VaultModel(index: 10, uuid: '7d871464-f352-432d-ad70-b001b38a17c9', name: 'test');
      expect(actualVaultModel, expectedVaultModel);
    });
  });
}
