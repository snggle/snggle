import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/test_database.dart';

void main() {
  SecureStorageKey actualSecureStorageKey = SecureStorageKey.vaults;

  late TestDatabase testDatabase;
  late VaultRecoverPageCubit actualVaultRecoverPageCubit;

  setUpAll(() {
    // @formatter:off
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      secureStorageContent: <String, String>{
        SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
        SecureStorageKey.vaults.name:'s79EVY1UBK/W+AdjyvBuwCFBUQeNS9aXF9WH5uVxShl5UITBBtOCbG/D80f6Gohw9VhtPPeZQrP6d99zUSYZKF1/sv/eVxLBKIKcY333282bgauXJMjrTMjoSpPBTR4xSlc7hMCqXCViJlggvSjZ8H06DL/NCgljzKf+31mg4cIYUPM5nMw8b2CmLRGsTBYsBg9cgzwpcVU8tyPW11RaxD2Z5x5nvSDZRPfST8qnOlhaHazndVATf092PZ6xJXws9Vq6bYOtju6L//dJZH0bCYCGwgzdjUMNdA0TdTT39AMvJZ/q2VoMS40vEIQ3RALRJtFEUa3UAd0uVuofsMuu7pE77uOaYiC2y/O3SY5XUWRuWWDBdbC5qqruEg3KPNKMYGGO4/Unr1jkzWTI8X86UxPEHbGk7Ki+D7/F0ISpClTUMvvoiZBOWV+M3cK2tV60H4IxsrHcl25wbyNNN5H7ee5Mr+eDKcgoQlivq1+F1gsj7SRUmb26kKIi6/v5oSqjYaCBuq1Bjan+ZJpyWDD9ba5rzE9hqjTx/Jv83fIf7QEsZXtYynZj8VbetpCYR77iOyIAYpc1wP2FDH1DqXb62sDLPLY=',
      },
      filesystemStorageContent: <String, dynamic>{
        'secrets': <String, dynamic>{
          '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
          'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
        },
      },
    );
    // @formatter:on

    actualVaultRecoverPageCubit = VaultRecoverPageCubit(parentFilesystemPath: const FilesystemPath.empty());
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
        // @formatter:off
        List<String> actualMnemonic = <String>['require','point','property','company','tongue','busy','bench','burden','caution','gadget','knee','glance','thought','bulk','assist','month','cereal','report','quarter','tool','section','often','require','shield'];
        actualVaultRecoverPageCubit.vaultNameTextEditingController.text = 'Test vault';
        // @formatter:on

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 24; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        await actualVaultRecoverPageCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem()['secrets'] as Map<String, dynamic>;
        Map<String, dynamic> actualVaultsMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

        // Assert
        VaultRecoverPageState expectedVaultRecoverPageState = const VaultRecoverPageState.loading();

        expect(actualVaultRecoverPageCubit.state, expectedVaultRecoverPageState);

        // Since vault UUID generation is random, predicting it's value is not possible.
        // For that reason we check if vaults count increased by 1 in database
        expect(actualSecretsFilesystemStructure.length, 4);
        expect(actualVaultsMap.length, 3);
      });
    });
  });

  tearDownAll(() {
    testDatabase.close();
  });
}
