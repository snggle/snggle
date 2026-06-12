import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
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

    actualVaultCreatePageCubit = VaultCreatePageCubit(
      parentFilesystemPath: FilesystemPath.fromString('vaults'),
    );
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
        expect(actualVaultCreatePageCubit.state.mnemonicFormVisibleBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicModel, isNotNull);
        expect(actualVaultCreatePageCubit.state.mnemonicModel!.mnemonicList.length, 12);
      });

      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words15);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.mnemonicFormVisibleBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicModel, isNotNull);
        expect(actualVaultCreatePageCubit.state.mnemonicModel!.mnemonicList.length, 15);
      });

      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words18);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.mnemonicFormVisibleBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicModel, isNotNull);
        expect(actualVaultCreatePageCubit.state.mnemonicModel!.mnemonicList.length, 18);
      });

      test('Should [return VaultCreatePageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words21);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.mnemonicFormVisibleBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicModel, isNotNull);
        expect(actualVaultCreatePageCubit.state.mnemonicModel!.mnemonicList.length, 21);
      });

      test('Should [return VaultCreatePageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultCreatePageCubit.init(MnemonicSize.words24);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.mnemonicFormVisibleBool, true);
        expect(actualVaultCreatePageCubit.state.mnemonicModel, isNotNull);
        expect(actualVaultCreatePageCubit.state.mnemonicModel!.mnemonicList.length, 24);
      });

      test('Should [emit VaultCreatePageState] with [vaultNameEmptyBool == TRUE] if a vault name is EMPTY', () async {
        // Arrange
        await actualVaultCreatePageCubit.init(MnemonicSize.words24);

        // Act
        actualVaultCreatePageCubit.vaultNameTextEditingController.text = '';

        // Assert
        expect(
          actualVaultCreatePageCubit.state.nameEmptyBool,
          true,
        );
      });

      test('Should [emit VaultCreatePageState] with [vaultNameEmptyBool == FALSE] if a vault name is NOT EMPTY', () async {
        // Arrange
        await actualVaultCreatePageCubit.init(MnemonicSize.words24);

        // Act
        actualVaultCreatePageCubit.vaultNameTextEditingController.text = 'VAULT 99999';

        // Assert
        expect(
          actualVaultCreatePageCubit.state.nameEmptyBool,
          false,
        );
      });
    });

    group('Tests of VaultCreatePageCubit.saveMnemonic() method', () {
      test('Should [return VaultCreatePageState] with new vault in database', () async {
        // Arrange
        await actualVaultCreatePageCubit.init(MnemonicSize.words24);
        actualVaultCreatePageCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        await actualVaultCreatePageCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets/vaults');

        List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
          return isar.vaults.where().findAll();
        });

        // Assert
        expect(actualVaultCreatePageCubit.state.mnemonicFormVisibleBool, true);
        expect(actualVaultCreatePageCubit.state.repeatedVaultModel, null);
        expect(actualVaultCreatePageCubit.state.mnemonicModel, isNotNull);
        expect(actualVaultCreatePageCubit.state.mnemonicModel!.mnemonicList.length, 24);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue.length, 6);
      });
    });
  });

  tearDownAll(() async {
    await actualVaultCreatePageCubit.close();
    await testDatabase.close();
  });
}
