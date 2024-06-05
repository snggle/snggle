import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../../../utils/test_utils.dart';

// ignore_for_file: invalid_assignment
void main() {
  String testSessionUUID = const Uuid().v4();

  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.vaults;
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');

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
    DatabaseParentKey.vaults.name:'s79EVY1UBK/W+AdjyvBuwCFBUQeNS9aXF9WH5uVxShl5UITBBtOCbG/D80f6Gohw9VhtPPeZQrP6d99zUSYZKF1/sv/eVxLBKIKcY333282bgauXJMjrTMjoSpPBTR4xSlc7hMCqXCViJlggvSjZ8H06DL/NCgljzKf+31mg4cIYUPM5nMw8b2CmLRGsTBYsBg9cgzwpcVU8tyPW11RaxD2Z5x5nvSDZRPfST8qnOlhaHazndVATf092PZ6xJXws9Vq6bYOtju6L//dJZH0bCYCGwgzdjUMNdA0TdTT39AMvJZ/q2VoMS40vEIQ3RALRJtFEUa3UAd0uVuofsMuu7pE77uOaYiC2y/O3SY5XUWRuWWDBdbC5qqruEg3KPNKMYGGO4/Unr1jkzWTI8X86UxPEHbGk7Ki+D7/F0ISpClTUMvvoiZBOWV+M3cK2tV60H4IxsrHcl25wbyNNN5H7ee5Mr+eDKcgoQlivq1+F1gsj7SRUmb26kKIi6/v5oSqjYaCBuq1Bjan+ZJpyWDD9ba5rzE9hqjTx/Jv83fIf7QEsZXtYynZj8VbetpCYR77iOyIAYpc1wP2FDH1DqXb62sDLPLY=',
  };
  // @formatter:on

  late VaultCreatePageCubit actualVaultCreatePageCubit;

  setUpAll(() {
    globalLocator.allowReassignment = true;
    initLocator();

    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);
    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectoryBuilder: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);

    globalLocator.registerLazySingleton(() => actualSecretsRepository);
    globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

    actualVaultCreatePageCubit = VaultCreatePageCubit(parentFilesystemPath: const FilesystemPath.empty());
  });

  group('Tests of VaultCreatePageCubit process', () {
    group('Tests of VaultCreatePageCubit initialization', () {
      test('Should [return VaultCreatePageState] with empty values as initial state', () {
        // Assert
        VaultCreatePageState expectedVaultCreatePageState = const VaultCreatePageState();

        expect(actualVaultCreatePageCubit.state, expectedVaultCreatePageState);
      });
    });

    group('Tests of VaultCreatePageCubit.init() method', () {
      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(12);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.loadingBool, false);
        expect(actualVaultCreatePageCubit.state.lastVaultIndex, 2);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, 12);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 12);
      });

      test('Should [return VaultCreatePageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultCreatePageCubit.init(24);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.loadingBool, false);
        expect(actualVaultCreatePageCubit.state.lastVaultIndex, 2);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, 24);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 24);
      });
    });

    group('Tests of VaultCreatePageCubit.saveMnemonic() method', () {
      test('Should [return VaultCreatePageState.loading] and save vault in database', () async {
        // Arrange
        actualVaultCreatePageCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        await actualVaultCreatePageCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID)['secrets'];

        // Assert
        String? actualEncryptedVaultsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);
        String actualDecryptedVaultsKeyValue = actualMasterKeyVO.decrypt(
          appPasswordModel: actualAppPasswordModel,
          encryptedData: actualEncryptedVaultsKeyValue!,
        );
        Map<String, dynamic> actualVaultsMap = jsonDecode(actualDecryptedVaultsKeyValue) as Map<String, dynamic>;

        // Assert
        VaultCreatePageState expectedVaultCreatePageState = const VaultCreatePageState.loading();

        expect(actualVaultCreatePageCubit.state, expectedVaultCreatePageState);

        // Since vault UUID generation is random, predicting it's value is not possible.
        // For that reason we check if vaults count increased by 1 in database
        expect(actualSecretsFilesystemStructure.length, 4);
        expect(actualVaultsMap.length, 3);
      });
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}
