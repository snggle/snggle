import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  String testSessionUUID = const Uuid().v4();

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');

  // @formatter:off
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'ZFiLtfcog0bpfT4AN9tg8jXR9PKtDvcUabkjiDXcoMX/vhusD8PMJ8ovCOhIpND9wWIRpoScteSHCy8IXCB0P7TBUY3QAZb4TYoyO7lUykbPJLUElerGZlrkMYSWECWMQplKYaZhvVbvWuJjHsCoN8hsmn0Gq9rLUfQqbGa2kXNt1LjNSPUtw2oip/aCnF6hKBRqS/pASONW23K114K7ZugSH0/59YlrN+I5bZ60V+kdoFoU',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'CpghTVIBHTk7+9SgXawmlE91VcpUvCr8/gVwXgME/EDaVM3liUlPyt+LWsye9jwxDFOAkxzuEZJ+FI5tk033Wxq/JuyijTR8Y+lNjU5qZymBSEIcU3FjdzCR9hoHNXJu/DkmFy9CEMBjdQD0YbYCK0lecDNLg9ti7c0NxMv80e8q4uCOJHs5wxvYm1ANct/SiwMf0MKeZCLw5NtO84d7JtnkYVoocCRjwk4KUNAlxJNqlcOF',
    },
  };

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'ZVuowQ2/PjumDFIYF6z8n4KMKAVtF80yeBUt+yqFaMIToIFD7OqTosYo9xlToLNm6M1UYqGKrDLwgAtTlo5VwItDPekz4fF/O3+qYhmSx8ddEMAUmx1WWGraEUq8490nYRGN9Gg+xlkmysVqZELSKKQEbLuqeTRxsqOVUi9qZ9d1Z12oQG+E44yXd9894gVnqX3Oa5AMOK59Rh2tbi9Cfb35bygm+8x07tod0WNbbJw114UVc+4zIMd8FJMdfi1NiEl/LeyKmy6r8gBYT3Dr4wbKRTp0PZzbMjChvwcaQLc+24Mi4IG/k3RfsqUIAq/BFqGcANtcwqZLJyWRQJMOFfaPIjkuQXkMyUZ0yRT96v1dqdAcj13G8lvuxEtDhr4i6B6xqQpgp5GB+F2CFrEEIN5sKRbs4Z72NW+a3Y515ozQ2Z25EoFNeobPYeFz2c+PsZd2EX2rVY6HZuPoo9yAEoiwGc4liEZdK7j0gA1LUUfwwPi4o56+pYlCfl9pTk4fz4Dk45Ojt4U57vX0bHNy8oXfdA9lF8Bf7XeRHqIq3U4/Wj+JWbyXUax65uFHqxgMwVFfU/GxQ+kWxmrECC4YASVV1QM5Ue+P0A10hrU48KPLO+mFilErKYWzB4WIqE2ow+/hgF+fsxY7oeFZURFNoOjFXtqEEdz7HnSVE/C817y6K3mMHytfWEcw31AEHEuWqXcsBdWJTvDbEJrTRwmuwRnnG8ZWmzlxHlNVAosaN4Sd9aGWvZbRdCHrn+Nx3bwNz/FWKDUfveUfM1SLqdE2NZtX1SBzzMcHr9O6L8sknFfrB15oTUYygawKKG1akhYhRE/+c+mKrlrIx6nFX9idw4PjSKs/5ojXs8nhU83Fw74EskHvc/gCNFdqOjTnLDunHrCHvdIZDFfnSyLRr/8U9oCq7Qg=',
    DatabaseParentKey.wallets.name: 'kCpm4AoYy7OgPiIdDgy81OIS48FfntjrPJAbh4HzCufZNmno/HPGMVDgV2VwwPx0dF08oVnQFa6yJxEO7xJdkrJUdN3MIzu1k2KHhb0i3V6N2YJvKBhVZkCbLqYIlgc9uKAanaS/mcwXoOrFnWzqLLwWD4eq4FQFvCJaW09RDfllBcDyDjejJZmZJUx0sUp2lh1G19dLYh5+RR6imea+jlj8DmG5EKlRpnKZbMMXBpJmOE2HLe3jvOVYL2BZjl2kPsvhtZnZ0ORjQ+fATCfsdvXh+Ux/nI+UakoBincFIiFD368gfu+JcKtBfwP4+K/9ONI9GybL1tu43qGcM5ZFnS75lg2W94sqsao/N2NgVBRO5SyT16N2s39jZcV1Abgqi1mTozfK3ueqYSOIgWU8Pxh8/QwPLY/yYwm96fXXLX65G2l1Fnq/O5gMaVK9agDARFNVvGwlJXxPsxu70/b2ql/jd4Ev0Y05zzYmN9Yh45jmi0L3QH1eUtInuzVMoaRz8sdF+Rip9ttsaHO1qBkKMP6SuAlacLH5IISoAQiC0ltyzpTemMpBbZG1gY98AUUpoWoxvDmzb2H/MUQ3JK6e2ksVrz1VilvGiYc+CPDaT+JPU6zpgk389H6ju1dOgbxJhLpIHk+guAPIWQjBabwhV1QEEzypOuUBtPvkxAQ7QfII78WKWr2+RdSUQ3FuEk2eVzmhLoBLyrSm8ItPxlb8TA67wLKecmI5cCMK2Q/AHAQ3koz9PQsphnY3y50T+s1VrLaQ1bnTUH7bt87vecYv9oR+f5UNGazUtSLDQKUhqG9v/jxx0ehHzptkqqbrh6oMydIpY6iUMYsYsZpZ5vxZyxxweluml0gB/hOEwebkKFYLRk3WdH2IZmv5p0g1se9poC4ssDPhcg3PqgCJstXCSUTpaEgly3DFi1+qDb4dvrg//C6d2BqkOaYuVGTx8uzYXI4rYF+y2wh6s1plsn/EBNRQZ1E=',
  };
  // @formatter:on

  VaultModel vaultModel1 = VaultModel(
    index: 1,
    pinnedBool: true,
    encryptedBool: true,
    uuid: '92b43ace-5439-4269-8e27-e999907f4379',
    filesystemPath: FilesystemPath.fromString('92b43ace-5439-4269-8e27-e999907f4379'),
    name: 'Test Vault 1',
    listItemsPreview: <AListItemModel>[],
  );

  VaultModel vaultModel2 = VaultModel(
    index: 2,
    pinnedBool: true,
    encryptedBool: true,
    uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
    filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
    name: 'Test Vault 2',
    listItemsPreview: <AListItemModel>[
      WalletModel(
        encryptedBool: false,
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        name: 'WALLET 0',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093/4e66ba36-966e-49ed-b639-191388ce38de'),
      ),
    ],
  );

  VaultModel updatedVaultModel2 = VaultModel(
    index: 2,
    pinnedBool: true,
    encryptedBool: true,
    uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093',
    filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
    name: 'UPDATED VAULT',
    listItemsPreview: <AListItemModel>[
      WalletModel(
        encryptedBool: false,
        pinnedBool: true,
        index: 0,
        address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
        derivationPath: "m/44'/118'/0'/0/0",
        network: 'ethereum',
        uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
        name: 'WALLET 0',
        filesystemPath: FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093/4e66ba36-966e-49ed-b639-191388ce38de'),
      ),
    ],
  );

  late VaultListPageCubit actualVaultListPageCubit;

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

    actualVaultListPageCubit = VaultListPageCubit(filesystemPath: const FilesystemPath.empty());
  });

  group('Tests of VaultListPageCubit process', () {
    group('Tests of VaultListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualVaultListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of VaultListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all vaults existing in database', () async {
        // Act
        await actualVaultListPageCubit.refreshAll();
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <VaultModel>[vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single vault', () async {
        // Arrange
        VaultModel actualVaultListItemModel = vaultModel2;

        // Update vault in database to check if it will be updated in the state
        await globalLocator<VaultsService>().save(updatedVaultModel2);

        // Act
        await actualVaultListPageCubit.refreshSingle(actualVaultListItemModel);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all vaults SELECTED]', () async {
        // Act
        actualVaultListPageCubit.toggleSelectAll();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          ),
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all vaults UNSELECTED] if all vaults were selected before', () async {
        // Act
        actualVaultListPageCubit.toggleSelectAll();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 2),
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified vault selected', () async {
        // Act
        actualVaultListPageCubit.selectSingle(vaultModel1);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[vaultModel1],
          ),
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified vault unselected', () async {
        // Act
        actualVaultListPageCubit.unselectSingle(vaultModel1);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 2),
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualVaultListPageCubit.disableSelection();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.updatePinnedVaults()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected vaults (pinnedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          pinnedBool: true,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected vaults (pinnedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[vaultModel1, updatedVaultModel2],
          pinnedBool: false,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel1.copyWith(pinnedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected vaults (encryptedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            vaultModel1.copyWith(pinnedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false),
          ],
          encryptedBool: false,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel1.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: false),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected vaults (encryptedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            vaultModel1.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: false),
          ],
          encryptedBool: true,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            vaultModel1.copyWith(pinnedBool: false, encryptedBool: true),
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted vault', () async {
        // Act
        await actualVaultListPageCubit.deleteItem(vaultModel1);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedVaultModel2.copyWith(pinnedBool: false, encryptedBool: true),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });
  });

  tearDownAll(() {
    TestUtils.clearCache(testSessionUUID);
  });
}