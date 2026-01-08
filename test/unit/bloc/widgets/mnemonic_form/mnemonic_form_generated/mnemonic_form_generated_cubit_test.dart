import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_generated/mnemonic_form_generated_cubit.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_generated/mnemonic_form_generated_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of MnemonicFormGeneratedCubit process', () {
    group('Tests of MnemonicFormGeneratedCubit initialization', () {
      test('Should [return MnemonicFormGeneratedCubit] with 12 mnemonic words', () {
        // Act
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);

        // Assert
        expect(actualMnemonicFormGeneratedCubit.state.mnemonicSize, MnemonicSize.words12);
        expect(actualMnemonicFormGeneratedCubit.state.mnemonic.length, 12);
        expect(actualMnemonicFormGeneratedCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool, false);
      });

      test('Should [return MnemonicFormGeneratedCubit] with 15 mnemonic words', () {
        // Act
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words15);

        // Assert
        expect(actualMnemonicFormGeneratedCubit.state.mnemonicSize, MnemonicSize.words15);
        expect(actualMnemonicFormGeneratedCubit.state.mnemonic.length, 15);
        expect(actualMnemonicFormGeneratedCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool, false);
      });

      test('Should [return MnemonicFormGeneratedCubit] with 18 mnemonic words', () {
        // Act
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words18);

        // Assert
        expect(actualMnemonicFormGeneratedCubit.state.mnemonicSize, MnemonicSize.words18);
        expect(actualMnemonicFormGeneratedCubit.state.mnemonic.length, 18);
        expect(actualMnemonicFormGeneratedCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool, false);
      });

      test('Should [return MnemonicFormGeneratedCubit] with 21 mnemonic words', () {
        // Act
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words21);

        // Assert
        expect(actualMnemonicFormGeneratedCubit.state.mnemonicSize, MnemonicSize.words21);
        expect(actualMnemonicFormGeneratedCubit.state.mnemonic.length, 21);
        expect(actualMnemonicFormGeneratedCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool, false);
      });

      test('Should [return MnemonicFormGeneratedCubit] with 24 mnemonic words', () {
        // Act
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
        MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words24);

        // Assert
        expect(actualMnemonicFormGeneratedCubit.state.mnemonicSize, MnemonicSize.words24);
        expect(actualMnemonicFormGeneratedCubit.state.mnemonic.length, 24);
        expect(actualMnemonicFormGeneratedCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool, false);
      });

      test('Should [emit MnemonicFormEditableState] with [vaultNameExistsBool == TRUE] if a vault name is TAKEN', () async {
        // Arrange
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Act
        actualMnemonicFormGeneratedCubit.vaultNameTextEditingController.text = 'VAULT 1';

        // Assert
        expect(
          actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool,
          true,
        );
      });

      test('Should [emit MnemonicFormEditableState] with [vaultNameExistsBool == FALSE] if a vault name is NOT TAKEN', () async {
        // Arrange
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Act
        actualMnemonicFormGeneratedCubit.vaultNameTextEditingController.text = 'VAULT 99999';

        // Assert
        expect(
          actualMnemonicFormGeneratedCubit.state.vaultNameExistsBool,
          false,
        );
      });
    });

    group('Tests of MnemonicFormGeneratedCubit.saveMnemonic() method', () {
      test('Should [return MnemonicFormGeneratedState] with new vault in database', () async {
        // Arrange
        MnemonicFormGeneratedCubit actualMnemonicFormGeneratedCubit =
          MnemonicFormGeneratedCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        actualMnemonicFormGeneratedCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        await actualMnemonicFormGeneratedCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

        List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
          return isar.vaults.where().findAll();
        });

        // Assert
        List<String> actualPlaceholderMnemonic = List<String>.generate(12, (int index) => 'assist');

        MnemonicFormGeneratedState expectedMnemonicFormGeneratedState = MnemonicFormGeneratedState(
          repeatedVaultModel: null,
          mnemonicSize: MnemonicSize.words12,
          // we cannot include an actual expected mnemonic in the test because of the random value
          mnemonic: actualPlaceholderMnemonic,
        );

        expect(actualMnemonicFormGeneratedCubit.state.repeatedVaultModel, expectedMnemonicFormGeneratedState.repeatedVaultModel);
        expect(actualMnemonicFormGeneratedCubit.state.mnemonicSize, expectedMnemonicFormGeneratedState.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue.length, 6);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
