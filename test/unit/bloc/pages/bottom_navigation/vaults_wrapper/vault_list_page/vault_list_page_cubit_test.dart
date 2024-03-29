import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  initLocator();

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '92b43ace-5439-4269-8e27-e999907f4379.snggle': 'ZFiLtfcog0bpfT4AN9tg8jXR9PKtDvcUabkjiDXcoMX/vhusD8PMJ8ovCOhIpND9wWIRpoScteSHCy8IXCB0P7TBUY3QAZb4TYoyO7lUykbPJLUElerGZlrkMYSWECWMQplKYaZhvVbvWuJjHsCoN8hsmn0Gq9rLUfQqbGa2kXNt1LjNSPUtw2oip/aCnF6hKBRqS/pASONW23K114K7ZugSH0/59YlrN+I5bZ60V+kdoFoU',
      'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'CpghTVIBHTk7+9SgXawmlE91VcpUvCr8/gVwXgME/EDaVM3liUlPyt+LWsye9jwxDFOAkxzuEZJ+FI5tk033Wxq/JuyijTR8Y+lNjU5qZymBSEIcU3FjdzCR9hoHNXJu/DkmFy9CEMBjdQD0YbYCK0lecDNLg9ti7c0NxMv80e8q4uCOJHs5wxvYm1ANct/SiwMf0MKeZCLw5NtO84d7JtnkYVoocCRjwk4KUNAlxJNqlcOF',
    },
  };

  Map<String, String> filledVaultsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
    DatabaseParentKey.wallets.name:'WWn5m4f5r+veG0ZBsHTn+yfzYkexf1ClKj10Xjd1B6QJsgLpfRaltn33xLSCzRMJQze2ioV0BVhaHVafnDINIoi3jJIftfa1izjhxcVBDIrsAZsWCIzEXMIN2d2kq3FRH61PqlCTwRMcfYElXkZvxarH6SIypLNXsl/K25DMSma1zZgo+Pg5xgARaZV1PCE4XYlD2rkXRTFvvXABp5w+8VgHbd1G/opG3lwGKBETzsPOTUsnOrZ0PQg9mYSIt0WnVsewadKiMZY609Oh94l4txxNxG8cVA5G2jny9QqxDVflsIMx0m/XvjTmdSEBShz1ZLetgwSRPylFdfW+iBa4mTwro7joBJNI4xzXxslZkzNbwl9pPydxKBideN0JRI+RkE6znaug8j31wCkgp4knvCdGTB+Ycun6ZluqVwRYcVvKZhfv2Z7wWzPdTyVrZV6oC2i/O0IvYRFKWhO2DaTXWrWAqDxRKgt+S5dNzewERekZKqoL2t5SsReKRENy2PWNPfGMFRLAeD6HlGBRGimFjxUi43MLp+YXJluTSIqgOwrhNLbJ2sQT764nFVjB01s/w7PALek+X23Lb7zQ1+mOp6jjO+tU7nuziiUm+PCx5hKyzYDJIlWQOt5nWI/l6U4AxJ7K+ENOHyDYQY6JGasGXQxFc6EtqJW/3RJcZ18mxwwM3UEZrcw6tmyViBQCIAZeZmzOiqurpEMV93l51FVDSN3qYBW1LXel5dcFkd2i9QrPaqRjuKBLf8fLm0WWjT9QktoSSXonZzi0ItZaBpxUVMdv/2qiMG+3FbZtYXcnBnjOvdAZfzkiwTdYxmGerNZUUQsGPEVqMH7IIrt249v1rQaBl9KxYXYrW407iCDn4Fbth3MZjzancwFQjZPKtIFG08QKzT2Id48rBuLaXiDriznBbEq2Tw5cLxLWqsN2JYE0MeCOiwHMG3hmpCxWijtFrvK2WqtQIach1QUC6+n4MsgG3hEbsHMaKN9X1qJQE1gDcTNMsNzLlsCgXc5zJNjKETaVe42G+D1q4390KzTRfiHp43Rx7D9TtAXmzmjIYdUpxW5soMGrITziKumDYu1P/MiPI8lsK7IfVOj/dxcRC3Ni10NFFwlfJ6nHhiVyJiZ/4obwO8ZA/VJY5Uvh8iZU7Bqqo8i0+vTjpSJm9cp47bkGnKv0qzlIL9phx2e82OHK3gmt6XXHNayO7Gd95ipGn+15dpjGMTQEE9ZwOqPITddbDUmhfxU2lo2YotFX8R3PZL14IJsN+YCAhzrAJwMuEy20y0CiM54p7K9+hrxz/5mJd+VrJTLbWSFL1KgrnNPrJnSXlSeBC0AWr6Xj9Y+K+4FPtUs1rIKgkAHJhspxe4EilcCGBtwoyYdCr5ewUX1VnvFfRwF6frkPrXxQD3dkVD3Foge+P9OubTot5VKirMzgWDCNrxWn31sJW3E6DBvit5nSEz8pA7J5Kmk6/hzpppe6pNKo4cEbqdCxJoRw65Nk2FQ=',
  };
  // @formatter:on

  VaultModel vaultModel1 = VaultModel(index: 1, uuid: '92b43ace-5439-4269-8e27-e999907f4379', pinnedBool: true, name: 'Test Vault 1');
  VaultModel vaultModel2 = VaultModel(index: 2, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 2');
  VaultModel updatedVaultModel2 = VaultModel(index: 1, uuid: 'b1c2f688-85fc-43ba-9af1-52db40fa3093', pinnedBool: false, name: 'Test Vault 123');

  late String testSessionUUID;
  late SecretsService actualSecretsService;
  late VaultsService actualVaultsService;
  late WalletsService actualWalletsService;

  late VaultListPageCubit actualVaultListPageCubit;

  setUpAll(() {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledVaultsDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    WalletsRepository actualWalletsRepository = WalletsRepository();
    actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository, secretsService: actualSecretsService);

    VaultsRepository actualVaultsRepository = VaultsRepository();
    actualVaultsService = VaultsService(
      vaultsRepository: actualVaultsRepository,
      secretsService: actualSecretsService,
      walletsService: actualWalletsService,
    );

    actualVaultListPageCubit = VaultListPageCubit(
      secretsService: actualSecretsService,
      vaultsService: actualVaultsService,
      walletsService: actualWalletsService,
    );
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
        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single vault', () async {
        // Arrange
        VaultListItemModel actualVaultListItemModel = VaultListItemModel(encryptedBool: true, vaultModel: vaultModel2, vaultWallets: const <WalletModel>[]);

        // Update vault in database to check if it will be updated in the state
        await actualVaultsService.saveVault(updatedVaultModel2);

        // Act
        await actualVaultListPageCubit.refreshSingle(actualVaultListItemModel);

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.selectAll()', () {
      test('Should [emit ListState] with [all vaults SELECTED]', () async {
        // Act
        actualVaultListPageCubit.selectAll();

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<VaultListItemModel>(
            allItemsCount: 2,
            selectedItems: <VaultListItemModel>[
              VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
              VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
            ],
          ),
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all vaults UNSELECTED] if all vaults were selected before', () async {
        // Act
        actualVaultListPageCubit.selectAll();

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<VaultListItemModel>(selectedItems: <VaultListItemModel>[], allItemsCount: 2),
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified vault selected', () async {
        // Act
        actualVaultListPageCubit.selectSingle(VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]));
        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<VaultListItemModel>(
            allItemsCount: 2,
            selectedItems: <VaultListItemModel>[
              VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
            ],
          ),
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified vault unselected', () async {
        // Act
        actualVaultListPageCubit.unselectSingle(VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]));
        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<VaultListItemModel>(selectedItems: <VaultListItemModel>[], allItemsCount: 2),
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualVaultListPageCubit.disableSelection();

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.updatePinnedVaults()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected vaults (pinnedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1, vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2, vaultWallets: const <WalletModel>[]),
          ],
          pinnedBool: true,
        );

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1.copyWith(pinnedBool: true), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2.copyWith(pinnedBool: true), vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected vaults (pinnedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1.copyWith(pinnedBool: true), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2.copyWith(pinnedBool: true), vaultWallets: const <WalletModel>[]),
          ],
          pinnedBool: false,
        );

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.updateEncryptionStatus()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected vaults (encryptedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.updateEncryptionStatus(
          selectedItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
          ],
          encryptedBool: false,
        );

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: false, vaultModel: vaultModel1.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: false, vaultModel: updatedVaultModel2.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected vaults (encryptedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.updateEncryptionStatus(
          selectedItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: false, vaultModel: vaultModel1.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: false, vaultModel: updatedVaultModel2.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
          ],
          encryptedBool: true,
        );

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
            VaultListItemModel(encryptedBool: true, vaultModel: updatedVaultModel2.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.delete()', () {
      test('Should [emit ListState] without deleted vault', () async {
        // Act
        await actualVaultListPageCubit.delete(
          VaultListItemModel(encryptedBool: false, vaultModel: updatedVaultModel2.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
        );

        ListState<VaultListItemModel> actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState<VaultListItemModel> expectedListState = ListState<VaultListItemModel>(
          loadingBool: false,
          allItems: <VaultListItemModel>[
            VaultListItemModel(encryptedBool: true, vaultModel: vaultModel1.copyWith(pinnedBool: false), vaultWallets: const <WalletModel>[]),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}