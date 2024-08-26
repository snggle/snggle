import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late VaultRecoverPageCubit actualVaultRecoverPageCubit;

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

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
        expect(actualVaultRecoverPageCubit.state.lastVaultIndex, 4);
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
        expect(actualVaultRecoverPageCubit.state.lastVaultIndex, 4);
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
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

        List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
          return isar.vaults.where().findAll();
        });

        // Assert
        List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
          const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', name: 'VAULT 1'),
          const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', name: 'VAULT 2'),
          const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', name: 'VAULT 3'),
          const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', name: 'VAULT 4'),
          const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', name: 'VAULT 5'),
          const VaultEntity(id: 6, encryptedBool: false, pinnedBool: false, index: 5, filesystemPathString: 'vault6', name: 'Test vault')
        ];

        // Assert
        VaultRecoverPageState expectedVaultRecoverPageState = const VaultRecoverPageState.loading();

        expect(actualVaultRecoverPageCubit.state, expectedVaultRecoverPageState);
        expect(actualSecretsFilesystemStructure.length, 9);
        expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
