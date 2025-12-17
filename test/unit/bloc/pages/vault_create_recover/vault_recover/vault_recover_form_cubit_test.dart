import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_recover/vault_recover_page_state.dart';
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
      test('Should [return VaultRecoverPageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultRecoverPageCubit.init(15);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 15);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 15);
      });

      test('Should [return VaultRecoverPageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultRecoverPageCubit.init(18);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 18);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 18);
      });

      test('Should [return VaultRecoverPageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultRecoverPageCubit.init(21);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 21);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 21);
      });

      test('Should [return VaultRecoverPageState] containing info about current vault index and generated mnemonic phrase', () async {
        // Act
        await actualVaultRecoverPageCubit.init(24);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 24);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 24);
      });

      test('Should [return VaultRecoverPageState] with new values after calling method again (mnemonic size changed)', () async {
        // Act
        await actualVaultRecoverPageCubit.init(12);

        // Assert
        // Since generated TextEditingControllers have different hashCodes we are not able to compare them directly.
        // For that reason values from [VaultRecoverPageState] are checked one by one.
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 12);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 12);
      });



      test('Should [emit VaultCreatePageState] with [vaultNameExistsBool == TRUE] if a vault name is TAKEN', () async {
        // Arrange
        await actualVaultRecoverPageCubit.init(12);

        // Act
        actualVaultRecoverPageCubit.vaultNameTextEditingController.text = 'VAULT 1';

        // Assert
        expect(
          actualVaultRecoverPageCubit.state.vaultNameExistsBool,
          true,
        );
      });

      test('Should [emit VaultCreatePageState] with [vaultNameExistsBool == FALSE] if a vault name is TAKEN', () async {
        // Arrange
        await actualVaultRecoverPageCubit.init(12);

        // Act
        actualVaultRecoverPageCubit.vaultNameTextEditingController.text = 'VAULT 99999';

        // Assert
        expect(
          actualVaultRecoverPageCubit.state.vaultNameExistsBool,
          false,
        );
      });
    });

    group('Tests of TextEditingControllers listener (form validation)', () {
      test('Should [return VaultRecoverPageState] with [mnemonicFilledBool == FALSE] if [some fields EMPTY]', () {
        // Arrange
        List<String> actualMnemonic = List<String>.generate(8, (int index) => 'abort');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 8; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        // Assert
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
      });

      test('Should [return VaultRecoverPageState] with [mnemonicFilledBool == TRUE], [mnemonicValidBool == FALSE] if [fields FILLED] but [mnemonic INVALID]',
          () {
        // Arrange
        List<String> actualMnemonic = List<String>.generate(12, (int index) => 'assist');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
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
          'square', 'old', 'choose', 'soon', 'radar', 'used', 'index', 'wrong', 'cancel', 'frame', 'isolate', 'library'
        ];
        // @formatter:on

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
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
        List<String> actualMnemonic = List<String>.generate(12, (int index) => 'assist');

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
          actualVaultRecoverPageCubit.state.textControllers![i].text = actualMnemonic[i];
          actualVaultRecoverPageCubit.state.textControllers![i].notifyListeners();
        }

        // Assert
        expect(
          () async => actualVaultRecoverPageCubit.saveMnemonic(),
          throwsA(isA<Exception>()),
        );
      });

      test('Should [return VaultRecoverPageState] with new vault in database', () async {
        // Arrange
        // @formatter:off
        List<String> actualMnemonic = <String>['require','point','property','company','tongue','busy','bench','burden','caution','gadget','knee','glance','thought','bulk','assist','month','cereal','report','quarter','tool','section','often','require','shield'];

        await actualVaultRecoverPageCubit.init(24);

        actualVaultRecoverPageCubit.vaultNameTextEditingController.text = 'Test vault';

        // Assert
        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, true);
        expect(actualVaultRecoverPageCubit.state.loadingBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, false);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, 24);
        expect(actualVaultRecoverPageCubit.state.textControllers?.length, 24);
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
          // @formatter:off
          const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', fingerprint: '2429747484', name: 'VAULT 1'),
          const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', fingerprint: '2619341544', name: 'VAULT 2'),
          const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', fingerprint: '405998762', name: 'VAULT 3'),
          const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', fingerprint: '1024969286', name: 'VAULT 4'),
          const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', fingerprint: '1980042394', name: 'VAULT 5'),
          const VaultEntity(id: 6, encryptedBool: false, pinnedBool: false, index: 5, filesystemPathString: 'vault6', fingerprint: '2583323534', name: 'Test vault')
          // @formatter:on
        ];

        VaultRecoverPageState expectedVaultRecoverPageState = const VaultRecoverPageState(
          confirmPageEnabledBool: true,
          mnemonicValidBool: true,
          mnemonicFilledBool: false,
          mnemonicSize: 24,
          // not included expected mnemonic because of random value
        );

        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, expectedVaultRecoverPageState.confirmPageEnabledBool);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, expectedVaultRecoverPageState.mnemonicValidBool);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, expectedVaultRecoverPageState.mnemonicFilledBool);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, expectedVaultRecoverPageState.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
      });

      test('Should [return VaultRecoverPageState.loading] and NOT save vault in database if it [already exists in database]', () async {
        // Arrange
        // @formatter:off
        List<String> actualMnemonic = <String>['square', 'old', 'choose', 'soon', 'radar', 'used', 'index', 'wrong', 'cancel', 'frame', 'isolate', 'library'];
        // @formatter:on

        await actualVaultRecoverPageCubit.init(12);

        actualVaultRecoverPageCubit.vaultNameTextEditingController.text = 'Test vault';

        // Act
        // Imitate entering mnemonic words
        for (int i = 0; i < 12; i++) {
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
          // @formatter:off
          const VaultEntity(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPathString: 'vault1', fingerprint: '2429747484', name: 'VAULT 1'),
          const VaultEntity(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPathString: 'vault2', fingerprint: '2619341544', name: 'VAULT 2'),
          const VaultEntity(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPathString: 'vault3', fingerprint: '405998762', name: 'VAULT 3'),
          const VaultEntity(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPathString: 'group1/vault4', fingerprint: '1024969286', name: 'VAULT 4'),
          const VaultEntity(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPathString: 'group1/vault5', fingerprint: '1980042394', name: 'VAULT 5'),
          const VaultEntity(id: 6, encryptedBool: false, pinnedBool: false, index: 5, filesystemPathString: 'vault6', fingerprint: '2583323534', name: 'Test vault')
          // @formatter:on
        ];

        VaultRecoverPageState expectedVaultRecoverPageState = VaultRecoverPageState(
          confirmPageEnabledBool: true,
          mnemonicValidBool: true,
          mnemonicFilledBool: true,
          mnemonicSize: 12,
          repeatedVaultModel: VaultModel(
            id: 1,
            encryptedBool: false,
            pinnedBool: false,
            index: 0,
            filesystemPath: FilesystemPath.fromString('vault1'),
            fingerprint: '2429747484',
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
          // not included expected mnemonic because of random value
        );

        expect(actualVaultRecoverPageCubit.state.confirmPageEnabledBool, expectedVaultRecoverPageState.confirmPageEnabledBool);
        expect(actualVaultRecoverPageCubit.state.mnemonicValidBool, expectedVaultRecoverPageState.mnemonicValidBool);
        expect(actualVaultRecoverPageCubit.state.mnemonicFilledBool, expectedVaultRecoverPageState.mnemonicFilledBool);
        expect(actualVaultRecoverPageCubit.state.repeatedVaultModel, expectedVaultRecoverPageState.repeatedVaultModel);
        expect(actualVaultRecoverPageCubit.state.mnemonicSize, expectedVaultRecoverPageState.mnemonicSize);
        expect(actualSecretsFilesystemStructure.length, 10);
        expect(actualVaultsDatabaseValue, expectedVaultsDatabaseValue);
      });
    });
  });

  tearDownAll(testDatabase.close);
}
