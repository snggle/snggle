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
        await actualVaultCreatePageCubit.init(12);

        // Assert
        // Since generated mnemonic phrase is random, predicting it's value is not possible.
        // For that reason values from [VaultCreatePageState] are checked one by one.
        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultCreatePageCubit.state.loadingBool, false);
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
        expect(actualVaultCreatePageCubit.state.mnemonicSize, 24);
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
        List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
          const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', fingerprint: '', name: 'VAULT 1'),
          const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', fingerprint: '', name: 'VAULT 2'),
          const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', fingerprint: '', name: 'VAULT 3'),
          const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', fingerprint: '', name: 'VAULT 4'),
          const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', fingerprint: '', name: 'VAULT 5'),
          const VaultEntity(id: 6, encryptedBool: false, pinnedBool: false, index: 5, filesystemPathString: 'vault6', fingerprint: '', name: 'Test vault')
        ];

        VaultCreatePageState expectedVaultCreatePageState = const VaultCreatePageState(
          confirmPageEnabledBool: true,
          loadingBool: false,
          mnemonicRepeatedBool: false,
          mnemonicSize: 24,
        // not included expected mnemonic because of random value
        );

        expect(actualVaultCreatePageCubit.state.confirmPageEnabledBool, expectedVaultCreatePageState.confirmPageEnabledBool);
        expect(actualVaultCreatePageCubit.state.loadingBool, expectedVaultCreatePageState.loadingBool);
        expect(actualVaultCreatePageCubit.state.mnemonicRepeatedBool, expectedVaultCreatePageState.mnemonicRepeatedBool);
        expect(actualVaultCreatePageCubit.state.mnemonicSize, expectedVaultCreatePageState.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
