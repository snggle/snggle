import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

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
  // @formatter:on

  late String testSessionUUID;
  late VaultRecoverPageCubit actualVaultRecoverPageCubit;

  setUpAll(() {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    SecretsService actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    VaultsService actualVaultsService = VaultsService(vaultsRepository: VaultsRepository());

    actualVaultRecoverPageCubit = VaultRecoverPageCubit(
      vaultModelFactory: VaultModelFactory(vaultsService: actualVaultsService),
      vaultsService: actualVaultsService,
      secretsService: actualSecretsService,
    );
  });

  group('Tests of VaultRecoverPageCubit process', () {
    group('Tests of VaultRecoverPageCubit initialization', () {
      test('Should [return VaultRecoverPageState] with empty values as initial state', () {
        // Assert
        VaultRecoverPageState expectedVaultRecoverPageState = const VaultRecoverPageState();

        expect(actualVaultRecoverPageCubit.state, expectedVaultRecoverPageState);
      });
    });

    group('Tests of VaultRecoverPageCubit.init() method', () {
      test('Should [return VaultRecoverPageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultRecoverPageCubit.init(12);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.lastVaultIndex, 2);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 12);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 12);
      });

      test('Should [return VaultRecoverPageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultRecoverPageCubit.init(24);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.lastVaultIndex, 2);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 24);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 24);
      });
    });

    group('Tests of TextEditingControllers listener (form validation)', () {
      test('Should [return VaultRecoverPageState] with [mnemonicFilledBool == FALSE] if [some fields EMPTY]', () {
        // Arrange
        List<String> actualMnemonic = List<String>.generate(16, (int index) => 'abort');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 16; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        // Assert
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
      });

      test('Should [return VaultRecoverPageState] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == FALSE] if [fields FILLED] but [mnemonic INVALID]',
          () {
        // Arrange
        List<String> actualMnemonic = List<String>.generate(24, (int index) => 'assist');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 24; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        // Assert
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, true);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
      });

      test('Should [return VaultRecoverPageState] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == TRUE] if [fields FILLED] and [mnemonic VALID]', () {
        // Arrange
        // @formatter:off
        List<String> actualMnemonic = <String>[
          'require', 'point', 'property', 'company', 'tongue', 'busy', 'bench', 'burden', 'caution', 'gadget', 'knee', 'glance', 'thought', 'bulk', 'assist', 'month', 'cereal', 'report', 'quarter', 'tool', 'section', 'often', 'require', 'shield',
        ];
        // @formatter:on

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 24; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        // Assert

        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, true);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, true);
      });
    });

    group('Tests of VaultRecoverPageCubit.saveMnemonic() method', () {
      test('Should [return VaultRecoverPageState] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == FALSE] if [fields FILLED] but [mnemonic INVALID]',
          () async {
        // Arrange
        List<String> actualMnemonic = List<String>.generate(24, (int index) => 'assist');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 24; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        await actualVaultRecoverPageCubit.saveMnemonic();

        // Assert
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
      });

      test('Should [return VaultRecoverPageState.loading] and save vault in database', () async {
        // Arrange
        List<String> actualMnemonic = <String>[
          'require',
          'point',
          'property',
          'company',
          'tongue',
          'busy',
          'bench',
          'burden',
          'caution',
          'gadget',
          'knee',
          'glance',
          'thought',
          'bulk',
          'assist',
          'month',
          'cereal',
          'report',
          'quarter',
          'tool',
          'section',
          'often',
          'require',
          'shield',
        ];
        actualVaultRecoverPageCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 24; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        await actualVaultRecoverPageCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure =
            TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID)['secrets'] as Map<String, dynamic>;

        String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);
        String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(
          appPasswordModel: actualAppPasswordModel,
          encryptedData: actualEncryptedVaultsKeyValue!,
        );
        Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

        // Assert
        VaultRecoverPageState expectedVaultRecoverPageState = const VaultRecoverPageState.loading();

        expect(actualVaultRecoverPageCubit.state, expectedVaultRecoverPageState);

        // Since vault UUID generation is random, predicting it's value is not possible.
        // For that reason we check if vaults count increased by 1 in database
        expect(actualSecretsFilesystemStructure.length, 3);
        expect(actualVaultsMap.length, 3);
      });
    });
  });
}
