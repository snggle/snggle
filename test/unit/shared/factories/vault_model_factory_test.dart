import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/repositories/wallet_groups_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallet_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
    },
  };

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
    WalletsService actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository, secretsService: actualSecretsService);

    WalletGroupsRepository actualWalletGroupsRepository = WalletGroupsRepository();
    WalletGroupsService actualWalletGroupsService = WalletGroupsService(
      walletGroupsRepository: actualWalletGroupsRepository,
      walletsService: actualWalletsService,
      secretsService: actualSecretsService,
    );

    actualVaultsService = VaultsService(
      vaultsRepository: VaultsRepository(),
      secretsService: actualSecretsService,
      walletGroupsService: actualWalletGroupsService,
    );
  });

  Map<String, String> filledChildKeysDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
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
      VaultModelFactory actualVaultModelFactory = VaultModelFactory(vaultsService: actualVaultsService);
      VaultEntity actualVaultEntity = const VaultEntity(index: 10, uuid: '7d871464-f352-432d-ad70-b001b38a17c9', pinnedBool: true, name: 'test');

      // Act
      VaultModel actualVaultModel = actualVaultModelFactory.createFromEntity(actualVaultEntity);

      // Assert
      VaultModel expectedVaultModel = VaultModel(index: 10, uuid: '7d871464-f352-432d-ad70-b001b38a17c9', pinnedBool: true, name: 'test');
      expect(actualVaultModel, expectedVaultModel);
    });
  });
}
