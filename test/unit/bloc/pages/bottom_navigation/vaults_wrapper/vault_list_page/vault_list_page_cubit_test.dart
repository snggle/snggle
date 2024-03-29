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
    DatabaseParentKey.wallets.name:'4k3KlhGTSoUehHhVcVFqBmtM4XUB4vJf8jpo2q7eP3Ij+CdOsprU3p9mzIO0S0/eT4dg1SHcJp4QprR+Do8Ez3QYkJCx1n0kztUIPt8ix3OGiIaBZcr8wtUkl0x7jHhUmN8el+o8uqPkNsBnkH3qXkyDmJyKbCmqpKTrETPzdYQeHfn5g3QU2eSVxPAwNHGyg+IKjB/9kve2FN9grGMB1/K0RyTswq5CiQtrlaD+AO07nekZu3vLWgaGn3c8WB/5CajAO5SgIBc+6LscWNeF8yuGDPr1qsoSI//nikln9RvSD9w+A979IYYpveme2kTrfBOPksWdzb05KUEUq3aKNkCyGAt9zN7s4XbqpP/BPd146Njypv+ujoD1wjqiVA9IFnMpYjV4HsWX5XzteyWqOatt22yheeX7ez8rw5fC58L1unhQuvPWp8f42zpRJhUbPPhoULVenqYrnZSRXlq+hYl0GpIiqSTIXNiGNQwOxbdeJBYWTABz7NnLyS1j757YIXjMN4c39MWz/764WkmPATziljPcBFMfOyVlaxhdVLLK8yzfNpURU7SYYMT+sVKHo/asMRE42nqbww42bOfe044BFzFw9moiBc+PSnfkIqkXdNgQCSnYhEgkhi/ZzzjHX7g02ab8rJcGvmoytmjoCkl5N5/Wb80HepIrgMalpLpU2nRHaBDoJ7dqoht5wjmHA1dWO916bV4AMqgVKu2JGQbqt+/dMVUryBI7cgWNQr56xYahrGtXXOxQYpIhTTpnT7PDX0gkc3OyKE2MeXC1MiOt1Qoe7y3WVVd35vSmhX+QGKNC3k2xt0BV/btFLrh549386X5Nol/85zjJPi+TlcXVrhG6J04lEj+JdES3pZ24hT88p4L45mbLf8emBF2baMFrdw/CHij/P/A9oK2bkkZ9sD7yJ+qu9423EyLpy9urWl8wNBbUB27ZTYPCZTWnzxvXBYUus+1GkHZ0W+bD36CYBZ/oqtm3n34L32HYactO/c2oDfTlbo+dTqBMFAWxmYa9ONv99EdrJGXbBv8lg1J44nPaQ76obblwObELtqqQMyOZckur1z5Q6MKXSaCGa6IFlXTqxl5lSVgHawQ2iGkaV68iYhK5WlOsASP3O30vZ5HhcxUhQRzCybY5iQDbOdBqABA1RMr26WAKfhKFabuHh37ItdcwIO6BFolsnnPtBFSGxsEr7i+K/kCdng9ubHwhHtC7M8goluNzLP3R+prLZx3H0K4zfD1mTbW3Ngr8rCmRmOULuSv/xysw4ejsWrpPXjNlJa7RSx71T/CWw9FPSpsZ4XiJnouFxxrll9+sVu+W',
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
    actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository);

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