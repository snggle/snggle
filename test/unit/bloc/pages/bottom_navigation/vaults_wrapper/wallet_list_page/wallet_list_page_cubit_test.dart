import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
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
      '04b5440e-e398-4520-9f9b-f0eea2d816e6.snggle': 'BrQcp0cakbIn31EdbLCnfzdlUQfwXPj/w7uVoHB6hxkP/SA6Q2vhXQuBJ+TLASlz6FFHTW4OQCqvjQ19RkO+l8F5LSPkQLQcOyOPAaouuUQ8CrbomTzlRr/qz0AoEZB8AyiXvLOghxJoRPPJ6xwux7cTmgSWOKtOPh9sqzJA0dyWVhstI+nfMNnVlXOCgqEMPpwp61xSQ/CvRrFYqht44zJPfWkvBVPd5NBeGd2TtNFBFs9J',
      '04b5440e-e398-4520-9f9b-f0eea2d816e6': <String, dynamic>{
        '4e66ba36-966e-49ed-b639-191388ce38de.snggle': 'AXRN5EO2mnHdhasGFuMNn+TkfJsytY+wNMCWsejh2Xy4gPwKBdDH/h7+OmMuK05GsLR9jO8dXGt4FpfpAX1okYMsgJW2HiONc27mokH3xFo2yAN8LP/z0fyLwV65ST/3NpENZ/1P+yVuVhBCy//91ZMzR1rjtZRvMROvml1WophQ4eCvKrfB/XIZJ4HK97wsUgc+dNppy1tW7r7PY/zIb8EuLqhfIgdXosbENVmOAWgylQdN',
        '3e7f3547-d78f-4dda-a916-3e9eabd4bfee.snggle': 'UAT9B0YwJ1bjxMeO1mXBB8P8qak1a4oxsiXpu2M773eZkqTcHMMl+O7kE2Icshxleb5NW0g0YX/w1fcxbNuoPevOOdhsUZcCemLqZn31P/ElcwxBiS0Cz0Cg9YdG9Tk/PUlC7Lu5rtaYvvtlJ8YAC3Csn5jvJD11+NNe/iSiRkCJBa6xjCbWl1MITQpCPstBzHC38qotIQGHdUN4zXZ8YdDMH9nlZreX2/0Q71KKV4T3A0pr',
      },
      '5f5332fb-37c1-4352-9153-d43692615f0f.snggle': '6TNCjwOyJDwsxtO9Ni3LPeVISyNd8NUElmdu/s7jmACJ4xtcsRdqNEtoHj7lpj5aaBa89EQbraXo83uhm4w0YDalnxtyCCPhXSZPJWQdEXD1Ov/uEDR6BAEV4wifjCR+dP3YH7F5eM3GCCGmgtj84lqHnYCQQXSrk7hv6UWR3sL8bmGGgx5HZtg0WJJcFMt1kfuHRaYScO4eOp08hJr8BMuNVPYQ4spkl0bWmdLPDHItqmfe',
      '5f5332fb-37c1-4352-9153-d43692615f0f': <String, dynamic>{
        '4d02947e-c838-4a77-bef3-0ffbdb1c7525.snggle': 'R27kuBRqPzz8H+Wv4mMrJIms+O4BP75Q3bW5tDBJ8xcyOH4Wg+yu5sou+g6Zr61qRhBndPFsOj/JRKtxgs6lDT7mdsrlNdjN8MxFoUaGWUzII5tsmBZ7jeGxsUb9xxn+WSukrg3o2gEkJ2lm1e0O86qrHslTAO7Q8iMPrzlHanxoJxu8Y6uMsfGLlo2F9L3NzjyQHBjLurC0uracTsAFikkjCiCDb7GdHHlnQ9oDPUt01Mgr',
        'ef63ccfc-c3da-4212-9dc1-693a9e75e90b.snggle': '1qWOLzU0uvfdx+gpsQJZ+GyFc0q3azKRNT32FLoDxZO2DVsJBdIW9VbAHYAsvsVDK395KN8gFriYgA6XFeXIEzJLNEMqZnYkns2FRL1ZIcvEXQE4+rsJFUyX+f4k7aN3wiGq7Hnh7fYIg5eecgGUWYBFgEGFWMfBpevmqtjXQg8E2HDhlI7Euf/WInZ90pshKUIqYAApKkOuuf5FouEJFZP73D7ZprkE28MPlRKsiK06sSZo'
      },
    },
  };

  Map<String, String> filledWalletsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    DatabaseParentKey.vaults.name:'L27Zi2cdyeFRM8YkfmUrOjQfp4VXBZ0hQyY+UolOfqxRKgAoEMLa739ozOibvsFVo8gfOhraL3bv4Qcv9ZWnmONA2myFVvkKsTwG7pkacbcN3epQ9lgQgrbsXmqKx4PI+pWpK3pTdHWVLIJx+rQ68/0lxQ5jGbLe2OcM7CUYxkTjmmb2/JTwzVLV49AlY+fb0o/+X5VVtUdMdsH/+6IxOwwsKuiqQHNdlTZGnVKPyca4UF7dWDP2kLbaVBdAC1basI3v/wDJZlr2TDunPHZNTeUhvNtLIKKT0UGpmqG6wzmswKSnIoLVrg9RKOuy02bkFFQNaBDF5ei4GCqD8aprgjqYKvmNf+xzwtYju0dTvi+NKu1OjCbG8c1xc/YTAQwfQsaXEg==',
    DatabaseParentKey.wallets.name:'WWn5m4f5r+veG0ZBsHTn+yfzYkexf1ClKj10Xjd1B6QJsgLpfRaltn33xLSCzRMJQze2ioV0BVhaHVafnDINIoi3jJIftfa1izjhxcVBDIrsAZsWCIzEXMIN2d2kq3FRH61PqlCTwRMcfYElXkZvxarH6SIypLNXsl/K25DMSma1zZgo+Pg5xgARaZV1PCE4XYlD2rkXRTFvvXABp5w+8VgHbd1G/opG3lwGKBETzsPOTUsnOrZ0PQg9mYSIt0WnVsewadKiMZY609Oh94l4txxNxG8cVA5G2jny9QqxDVflsIMx0m/XvjTmdSEBShz1ZLetgwSRPylFdfW+iBa4mTwro7joBJNI4xzXxslZkzNbwl9pPydxKBideN0JRI+RkE6znaug8j31wCkgp4knvCdGTB+Ycun6ZluqVwRYcVvKZhfv2Z7wWzPdTyVrZV6oC2i/O0IvYRFKWhO2DaTXWrWAqDxRKgt+S5dNzewERekZKqoL2t5SsReKRENy2PWNPfGMFRLAeD6HlGBRGimFjxUi43MLp+YXJluTSIqgOwrhNLbJ2sQT764nFVjB01s/w7PALek+X23Lb7zQ1+mOp6jjO+tU7nuziiUm+PCx5hKyzYDJIlWQOt5nWI/l6U4AxJ7K+ENOHyDYQY6JGasGXQxFc6EtqJW/3RJcZ18mxwwM3UEZrcw6tmyViBQCIAZeZmzOiqurpEMV93l51FVDSN3qYBW1LXel5dcFkd2i9QrPaqRjuKBLf8fLm0WWjT9QktoSSXonZzi0ItZaBpxUVMdv/2qiMG+3FbZtYXcnBnjOvdAZfzkiwTdYxmGerNZUUQsGPEVqMH7IIrt249v1rQaBl9KxYXYrW407iCDn4Fbth3MZjzancwFQjZPKtIFG08QKzT2Id48rBuLaXiDriznBbEq2Tw5cLxLWqsN2JYE0MeCOiwHMG3hmpCxWijtFrvK2WqtQIach1QUC6+n4MsgG3hEbsHMaKN9X1qJQE1gDcTNMsNzLlsCgXc5zJNjKETaVe42G+D1q4390KzTRfiHp43Rx7D9TtAXmzmjIYdUpxW5soMGrITziKumDYu1P/MiPI8lsK7IfVOj/dxcRC3Ni10NFFwlfJ6nHhiVyJiZ/4obwO8ZA/VJY5Uvh8iZU7Bqqo8i0+vTjpSJm9cp47bkGnKv0qzlIL9phx2e82OHK3gmt6XXHNayO7Gd95ipGn+15dpjGMTQEE9ZwOqPITddbDUmhfxU2lo2YotFX8R3PZL14IJsN+YCAhzrAJwMuEy20y0CiM54p7K9+hrxz/5mJd+VrJTLbWSFL1KgrnNPrJnSXlSeBC0AWr6Xj9Y+K+4FPtUs1rIKgkAHJhspxe4EilcCGBtwoyYdCr5ewUX1VnvFfRwF6frkPrXxQD3dkVD3Foge+P9OubTot5VKirMzgWDCNrxWn31sJW3E6DBvit5nSEz8pA7J5Kmk6/hzpppe6pNKo4cEbqdCxJoRw65Nk2FQ=',
  };
  // @formatter:on

  WalletModel walletModel1 = WalletModel(
    pinnedBool: true,
    index: 0,
    address: 'kira1q4ypasn8pak72h0dsppywd33n5rt66krgdt3np',
    derivationPath: "m/44'/118'/0'/0/0",
    network: 'kira',
    uuid: '4e66ba36-966e-49ed-b639-191388ce38de',
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  WalletModel walletModel2 = WalletModel(
    pinnedBool: true,
    index: 1,
    address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
  );

  WalletModel updatedWalletModel2 = WalletModel(
    pinnedBool: true,
    index: 1,
    address: 'kira1skj2f63ztaxk2q43pm2tg7t09r0whf5cadszdn',
    derivationPath: "m/44'/118'/0'/0/1",
    network: 'kira',
    uuid: '3e7f3547-d78f-4dda-a916-3e9eabd4bfee',
    parentPath: '04b5440e-e398-4520-9f9b-f0eea2d816e6',
    name: 'Updated Wallet 123',
  );

  late String testSessionUUID;
  late SecretsService actualSecretsService;
  late WalletsService actualWalletsService;

  late WalletListPageCubit actualWalletListPageCubit;

  setUpAll(() {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledWalletsDatabase));

    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.secrets,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);

    WalletsRepository actualWalletsRepository = WalletsRepository();
    actualWalletsService = WalletsService(walletsRepository: actualWalletsRepository, secretsService: actualSecretsService);

    actualWalletListPageCubit = WalletListPageCubit(
      vaultModel: VaultModel(index: 1, uuid: '04b5440e-e398-4520-9f9b-f0eea2d816e6', pinnedBool: true, name: 'Test Vault 1'),
      containerPathModel: ContainerPathModel.fromString('04b5440e-e398-4520-9f9b-f0eea2d816e6'),
      vaultPasswordModel: PasswordModel.defaultPassword(),
      secretsService: actualSecretsService,
      walletsService: actualWalletsService,
    );
  });

  group('Tests of WalletListPageCubit process', () {
    group('Tests of WalletListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualWalletListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of WalletListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all wallets existing in database', () async {
        // Act
        await actualWalletListPageCubit.refreshAll();
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: walletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single vault', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await actualWalletsService.saveWallet(updatedWalletModel2);

        // Act
        await actualWalletListPageCubit.refreshSingle(WalletListItemModel(encryptedBool: true, walletModel: walletModel2));

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectAll()', () {
      test('Should [emit ListState] with [all wallets SELECTED]', () async {
        // Act
        actualWalletListPageCubit.selectAll();
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[
              WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
              WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
            ],
          ),
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all wallets UNSELECTED] if all wallets were selected before', () async {
        // Act
        actualWalletListPageCubit.selectAll();

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified vault selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(WalletListItemModel(encryptedBool: true, walletModel: walletModel1));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[
              WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            ],
          ),
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified vault unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(WalletListItemModel(encryptedBool: true, walletModel: walletModel1));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          selectionModel: SelectionModel<AListItemModel>(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualWalletListPageCubit.disableSelection();

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected wallets (pinnedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
          pinnedBool: false,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1.copyWith(pinnedBool: false)),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2.copyWith(pinnedBool: false)),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected wallets (pinnedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1.copyWith(pinnedBool: false)),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2.copyWith(pinnedBool: false)),
          ],
          pinnedBool: true,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.updateEncryptionStatus()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected wallets (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.updateEncryptionStatus(
          selectedItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
          encryptedBool: false,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: false, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: false, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected wallets (encryptedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.updateEncryptionStatus(
          selectedItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: false, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: false, walletModel: updatedWalletModel2),
          ],
          encryptedBool: true,
        );

        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: walletModel1),
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
          ],
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.delete()', () {
      test('Should [emit ListState] without deleted wallet', () async {
        // Act
        await actualWalletListPageCubit.delete(WalletListItemModel(encryptedBool: true, walletModel: walletModel1));
        ListState<AListItemModel> actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState<AListItemModel> expectedListState = ListState<AListItemModel>(
          loadingBool: false,
          allItems: <WalletListItemModel>[
            WalletListItemModel(encryptedBool: true, walletModel: updatedWalletModel2),
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