import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_editable/mnemonic_form_editable_cubit.dart';
import 'package:snggle/bloc/widgets/mnemonic_form/mnemonic_form_editable/mnemonic_form_editable_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/predefined_network_templates.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
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

  group('Tests of MnemonicFormEditableCubit process', () {
    group('Tests of MnemonicFormEditableCubit initialization', () {
      test('Should [return MnemonicFormEditableCubit] with 12 empty TextEditingControllers', () {
        // Act
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, MnemonicSize.words12);
        expect(actualMnemonicFormEditableCubit.state.textControllers.length, 12);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
        expect(actualMnemonicFormEditableCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormEditableCubit.state.vaultNameExistsBool, false);
        expect(
            actualMnemonicFormEditableCubit.state.textControllers
                .every((TextEditingController textEditingController) => textEditingController.text.isEmpty),
            true);
      });

      test('Should [return MnemonicFormEditableCubit] with 15 empty TextEditingControllers', () {
        // Act
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words15);

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, MnemonicSize.words15);
        expect(actualMnemonicFormEditableCubit.state.textControllers.length, 15);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
        expect(actualMnemonicFormEditableCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormEditableCubit.state.vaultNameExistsBool, false);
        expect(
            actualMnemonicFormEditableCubit.state.textControllers
                .every((TextEditingController textEditingController) => textEditingController.text.isEmpty),
            true);
      });

      test('Should [return MnemonicFormEditableCubit] with 18 empty TextEditingControllers', () {
        // Act
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words18);

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, MnemonicSize.words18);
        expect(actualMnemonicFormEditableCubit.state.textControllers.length, 18);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
        expect(actualMnemonicFormEditableCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormEditableCubit.state.vaultNameExistsBool, false);
        expect(
            actualMnemonicFormEditableCubit.state.textControllers
                .every((TextEditingController textEditingController) => textEditingController.text.isEmpty),
            true);
      });

      test('Should [return MnemonicFormEditableCubit] with 21 empty TextEditingControllers', () {
        // Act
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words21);

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, MnemonicSize.words21);
        expect(actualMnemonicFormEditableCubit.state.textControllers.length, 21);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
        expect(actualMnemonicFormEditableCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormEditableCubit.state.vaultNameExistsBool, false);
        expect(
            actualMnemonicFormEditableCubit.state.textControllers
                .every((TextEditingController textEditingController) => textEditingController.text.isEmpty),
            true);
      });

      test('Should [return MnemonicFormEditableCubit] with 24 empty TextEditingControllers', () {
        // Act
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words24);

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, MnemonicSize.words24);
        expect(actualMnemonicFormEditableCubit.state.textControllers.length, 24);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
        expect(actualMnemonicFormEditableCubit.state.repeatedVaultModel, null);
        expect(actualMnemonicFormEditableCubit.state.vaultNameExistsBool, false);
        expect(
            actualMnemonicFormEditableCubit.state.textControllers
                .every((TextEditingController textEditingController) => textEditingController.text.isEmpty),
            true);
      });

      test('Should [emit MnemonicFormEditableState] with [vaultNameExistsBool == TRUE] if a vault name is TAKEN', () async {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Act
        actualMnemonicFormEditableCubit.vaultNameTextEditingController.text = 'VAULT 1';

        // Assert
        expect(
          actualMnemonicFormEditableCubit.state.vaultNameExistsBool,
          true,
        );
      });

      test('Should [emit MnemonicFormEditableState] with [vaultNameExistsBool == FALSE] if a vault name is NOT TAKEN', () async {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
            MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Act
        actualMnemonicFormEditableCubit.vaultNameTextEditingController.text = 'VAULT 99999';

        // Assert
        expect(
          actualMnemonicFormEditableCubit.state.vaultNameExistsBool,
          false,
        );
      });
    });

    group('Tests of TextEditingControllers listener (form validation)', () {
      test('Should [return MnemonicFormEditableCubit] with [mnemonicFilledBool == FALSE] if [some fields EMPTY]', () {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
          MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        List<String> actualMnemonic = List<String>.generate(8, (int index) => 'abort');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 8; i++) {
          actualMnemonicFormEditableCubit.state.textControllers[i].text = actualMnemonic[i];
          actualMnemonicFormEditableCubit.state.textControllers[i].notifyListeners();
        }

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
      });

      test('Should [return MnemonicFormEditableCubit] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == FALSE] if [fields FILLED] but [mnemonic INVALID]',
          () async {

        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
          MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        List<String> actualMnemonic = List<String>.generate(12, (int index) => 'assist');
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
          actualMnemonicFormEditableCubit.state.textControllers[i].text = actualMnemonic[i];
          actualMnemonicFormEditableCubit.state.textControllers[i].notifyListeners();
        }

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, true);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
      });

      test('Should [return MnemonicFormEditableCubit] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == TRUE] if [fields FILLED] and [mnemonic VALID]', () async {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
          MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        // @formatter:off
        List<String> actualMnemonic = <String>[
          'square', 'old', 'choose', 'soon', 'radar', 'used', 'index', 'wrong', 'cancel', 'frame', 'isolate', 'library'
        ];
        // @formatter:on

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
          actualMnemonicFormEditableCubit.state.textControllers[i].text = actualMnemonic[i];
          actualMnemonicFormEditableCubit.state.textControllers[i].notifyListeners();
        }

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, true);
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, true);
      });
    });

    group('Tests of MnemonicFormEditableCubit.saveMnemonic() method', () {
      test('Should [return MnemonicFormEditableCubit] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == FALSE] if [fields FILLED] but [mnemonic INVALID]',
          () async {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
          MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        List<String> actualMnemonic = List<String>.generate(12, (int index) => 'assist');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
          actualMnemonicFormEditableCubit.state.textControllers[i].text = actualMnemonic[i];
          actualMnemonicFormEditableCubit.state.textControllers[i].notifyListeners();
        }

        // Assert
        expect(
          () async => actualMnemonicFormEditableCubit.saveMnemonic(),
          throwsA(isA<Exception>()),
        );
      });

      test('Should [return MnemonicFormEditableCubit] with new vault in database', () async {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
          MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words24);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // @formatter:off
        List<String> actualMnemonic = <String>['require','point','property','company','tongue','busy','bench','burden','caution','gadget','knee','glance','thought','bulk','assist','month','cereal','report','quarter','tool','section','often','require','shield'];

        actualMnemonicFormEditableCubit.vaultNameTextEditingController.text = 'Test vault';

        // Assert
        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, false);
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, MnemonicSize.words24);
        expect(actualMnemonicFormEditableCubit.state.textControllers.length, 24);
        // @formatter:on

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 24; i++) {
          actualMnemonicFormEditableCubit.state.textControllers[i].text = actualMnemonic[i];
          actualMnemonicFormEditableCubit.state.textControllers[i].notifyListeners();
        }

        await actualMnemonicFormEditableCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

        List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
          return isar.vaults.where().findAll();
        });

        // Assert
        List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
          // @formatter:off
          const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', fingerprint: 'o50XEfBazUYWOzGIr0PxLaijSkSunwKbAMkAjtlcGng=', name: 'VAULT 1'),
          const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', fingerprint: '9cI8nWEzpJQZDx5dzfb6FyVvmaAUKC94Q1OQs9ai2eQ=', name: 'VAULT 2'),
          const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', fingerprint: 'Gow34W/o1hxCx0osLnstFO+ATc5vFkp21xXu4mKHC3s=', name: 'VAULT 3'),
          const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', fingerprint: 'VeIT3LQy3WdODsCjmwPgDoEsS7kwgsYDtz96awLpnPs=', name: 'VAULT 4'),
          const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', fingerprint: 'uQYyWS3a1fTFqqfJbHGB/f+c7qj+3wb8yDX1oup2CQk=', name: 'VAULT 5'),
          const VaultEntity(id: 6, encryptedBool: false, pinnedBool: false, index: 5, filesystemPathString: 'vault6', fingerprint: 'gYWsI/yzL250amkzRQFaRGuQT8iQuMNQZOAfZZXS/zk=', name: 'Test vault')
          // @formatter:on
        ];

        MnemonicFormEditableState expectedMnemonicFormEditableCubit = MnemonicFormEditableState(
          mnemonicValidBool: true,
          mnemonicFilledBool: false,
          mnemonicSize: MnemonicSize.words24,
          textControllers: const <TextEditingController>[],
          // not included expected mnemonic because of random value
        );

        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, expectedMnemonicFormEditableCubit.mnemonicValidBool);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, expectedMnemonicFormEditableCubit.mnemonicFilledBool);
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, expectedMnemonicFormEditableCubit.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
      });

      test('Should [return MnemonicFormEditableCubit.loading] and NOT save vault in database if it [already exists in database]', () async {
        // Arrange
        MnemonicFormEditableCubit actualMnemonicFormEditableCubit =
          MnemonicFormEditableCubit(parentFilesystemPath: const FilesystemPath.empty(), mnemonicSize: MnemonicSize.words12);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // @formatter:off
        List<String> actualMnemonic = <String>['square', 'old', 'choose', 'soon', 'radar', 'used', 'index', 'wrong', 'cancel', 'frame', 'isolate', 'library'];
        // @formatter:on

        actualMnemonicFormEditableCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
          actualMnemonicFormEditableCubit.state.textControllers[i].text = actualMnemonic[i];
          actualMnemonicFormEditableCubit.state.textControllers[i].notifyListeners();
        }

        await actualMnemonicFormEditableCubit.saveMnemonic();

        // Output is always a random string because AES changes the initialization vector with Random Secure
        // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
        Map<String, dynamic> actualSecretsFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

        List<VaultEntity> actualVaultsDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
          return isar.vaults.where().findAll();
        });

        // Assert
        List<VaultEntity> expectedVaultsDatabaseValue = <VaultEntity>[
          // @formatter:off
          const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', fingerprint: 'o50XEfBazUYWOzGIr0PxLaijSkSunwKbAMkAjtlcGng=', name: 'VAULT 1'),
          const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', fingerprint: '9cI8nWEzpJQZDx5dzfb6FyVvmaAUKC94Q1OQs9ai2eQ=', name: 'VAULT 2'),
          const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', fingerprint: 'Gow34W/o1hxCx0osLnstFO+ATc5vFkp21xXu4mKHC3s=', name: 'VAULT 3'),
          const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', fingerprint: 'VeIT3LQy3WdODsCjmwPgDoEsS7kwgsYDtz96awLpnPs=', name: 'VAULT 4'),
          const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', fingerprint: 'uQYyWS3a1fTFqqfJbHGB/f+c7qj+3wb8yDX1oup2CQk=', name: 'VAULT 5'),
          const VaultEntity(id: 6, encryptedBool: false, pinnedBool: false, index: 5, filesystemPathString: 'vault6', fingerprint: 'gYWsI/yzL250amkzRQFaRGuQT8iQuMNQZOAfZZXS/zk=', name: 'Test vault')
          // @formatter:on
        ];

        MnemonicFormEditableState expectedMnemonicFormEditableCubit = MnemonicFormEditableState(
          mnemonicValidBool: true,
          mnemonicFilledBool: true,
          mnemonicSize: MnemonicSize.words12,
          repeatedVaultModel: VaultModel(
            id: 1,
            encryptedBool: false,
            pinnedBool: false,
            index: 0,
            filesystemPath: FilesystemPath.fromString('vault1'),
            fingerprint: 'o50XEfBazUYWOzGIr0PxLaijSkSunwKbAMkAjtlcGng=',
            name: 'VAULT 1',
            listItemsPreview: <AListItemModel>[
              // @formatter:off
              GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
              NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum1'),
              NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum7'),
              NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: PredefinedNetworkTemplates.ethereum, name: 'Ethereum9'),
              // @formatter:on
            ],
          ),
          textControllers: const <TextEditingController>[],
          // not included expected mnemonic because of random value
        );

        expect(actualMnemonicFormEditableCubit.state.mnemonicValidBool, expectedMnemonicFormEditableCubit.mnemonicValidBool);
        expect(actualMnemonicFormEditableCubit.state.mnemonicFilledBool, expectedMnemonicFormEditableCubit.mnemonicFilledBool);
        expect(actualMnemonicFormEditableCubit.state.repeatedVaultModel, expectedMnemonicFormEditableCubit.repeatedVaultModel);
        expect(actualMnemonicFormEditableCubit.state.mnemonicSize, expectedMnemonicFormEditableCubit.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
