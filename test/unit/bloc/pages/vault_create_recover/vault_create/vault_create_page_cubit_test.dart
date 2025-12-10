import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/vault_create_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late VaultCreatePageCubit actualVaultCreatePageCubit;

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

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
        await actualVaultCreatePageCubit.init(MnemonicSize.words12);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, MnemonicSize.words12);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 12);
      });

      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words15);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, MnemonicSize.words15);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 15);
      });

      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words18);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, MnemonicSize.words18);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 18);
      });

      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words21);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, MnemonicSize.words21);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 21);
      });

      test('Should [return VaultCreatePageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words24);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, MnemonicSize.words24);
        expect(actualVaultCreatePageCubit.state.mnemonic!.length, 24);
      });
    });

    group('Tests of VaultCreatePageCubit.saveMnemonic() method', () {
      test('Should [return VaultCreatePageState] with new vault in database', () async {
        // Arrange
        actualVaultCreatePageCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        await actualVaultCreatePageCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

        List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
          return isar.vaults.where().findAll();
        });

        // Assert
        VaultCreatePageState expectedVaultCreatePageState = VaultCreatePageState(
          confirmPageEnabledBool: true,
          repeatedVaultModel: null,
          mnemonicSize: MnemonicSize.words24,
          // not included expected mnemonic because of random value
        );

        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, expectedVaultCreatePageState.confirmPageEnabledBool);
        expect(actualVaultCreatePageCubit.state.repeatedVaultModel, expectedVaultCreatePageState.repeatedVaultModel);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, expectedVaultCreatePageState.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue.length, 6);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
