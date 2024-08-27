import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late WalletListPageCubit actualWalletListPageCubit;

  // @formatter:off
  GroupModel groupModel = GroupModel(
    id: 3,
    encryptedBool: false,
    pinnedBool: false,
    filesystemPath: FilesystemPath.fromString('vault1/network1/group3'),
    name: 'WALLETS GROUP 1',
    listItemsPreview: <AListItemModel>[
      WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
      WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
    ],
  );
  GroupModel updatedGroupModel = GroupModel(
    id: 3,
    encryptedBool: true,
    pinnedBool: true,
    filesystemPath: FilesystemPath.fromString('vault1/network1/group3'),
    name: 'UPDATED WALLETS GROUP 1',
    listItemsPreview: <AListItemModel>[
      WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
      WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
    ],
  );
  WalletModel walletModel1 = WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1'), name: 'WALLET 0');
  WalletModel walletModel2 = WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2'), name: 'WALLET 1');
  WalletModel walletModel3 = WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3'), name: 'WALLET 2');
  WalletModel updatedWalletModel3 = WalletModel(id: 3, encryptedBool: true, pinnedBool: true, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3'), name: 'UPDATED WALLET 2');
  // @formatter:on

  group('Tests of WalletListPageCubit process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualWalletListPageCubit = WalletListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('vault1/network1'),
      );
    });

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
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, walletModel1, walletModel2, walletModel3],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single WALLET', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await globalLocator<WalletsService>().save(updatedWalletModel3);

        // Act
        await actualWalletListPageCubit.refreshSingle(walletModel3);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedWalletModel3, groupModel, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualWalletListPageCubit.refreshSingle(groupModel);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all wallets SELECTED]', () async {
        // Act
        actualWalletListPageCubit.toggleSelectAll();
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all wallets UNSELECTED] if all items were selected before', () async {
        // Act
        actualWalletListPageCubit.toggleSelectAll();

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified WALLET selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[walletModel1],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualWalletListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[walletModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified WALLET unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualWalletListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualWalletListPageCubit.disableSelection();

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3, walletModel1, walletModel2],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedGroupModel, updatedWalletModel3],
          pinnedBool: true,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedWalletModel3.copyWith(pinnedBool: true),
            walletModel1,
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedWalletModel3.copyWith(pinnedBool: true),
          ],
          pinnedBool: false,
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedWalletModel3.copyWith(pinnedBool: false),
            walletModel1,
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected items (encryptedBool == true)', () async {
        // Act
        await actualWalletListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedWalletModel3.copyWith(pinnedBool: false),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            updatedWalletModel3.copyWith(pinnedBool: false, encryptedBool: true),
            walletModel1,
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected WALLET (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.unlockSelection(
          selectedItem: updatedWalletModel3.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            updatedWalletModel3.copyWith(pinnedBool: false, encryptedBool: false),
            walletModel1,
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualWalletListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            updatedWalletModel3.copyWith(pinnedBool: false, encryptedBool: false),
            walletModel1,
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted WALLET', () async {
        // Act
        await actualWalletListPageCubit.deleteItem(walletModel1);
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            updatedWalletModel3.copyWith(pinnedBool: false, encryptedBool: false),
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualWalletListPageCubit.deleteItem(
          updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
        );
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedWalletModel3.copyWith(pinnedBool: false, encryptedBool: false),
            walletModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of WalletListPageCubit groups process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualWalletListPageCubit = WalletListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('vault1/network1'),
      );
    });

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
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, walletModel1, walletModel2, walletModel3],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.moveItem()', () {
      test('Should [emit ListState] with WALLET moved into GROUP', () async {
        // Act
        await actualWalletListPageCubit.moveItem(walletModel1, groupModel.filesystemPath);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                walletModel1.copyWith(filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet1')),
                ...groupModel.listItemsPreview,
              ],
            ),
            walletModel2,
            walletModel3,
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualWalletListPageCubit.groupItems(walletModel2, walletModel3, 'TEST GROUP');

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            GroupModel(
              id: 4,
              pinnedBool: false,
              encryptedBool: false,
              filesystemPath: FilesystemPath.fromString('vault1/network1/group4'),
              listItemsPreview: <AListItemModel>[
                walletModel2.copyWith(filesystemPath: FilesystemPath.fromString('vault1/network1/group4/wallet2')),
                walletModel3.copyWith(filesystemPath: FilesystemPath.fromString('vault1/network1/group4/wallet3')),
              ],
              name: 'TEST GROUP',
            ),
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                walletModel1.copyWith(filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet1')),
                ...groupModel.listItemsPreview,
              ],
            ),
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of WalletListPageCubit navigation process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualWalletListPageCubit = WalletListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('vault1/network1'),
      );
    });

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
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, walletModel1, walletModel2, walletModel3],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualWalletListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            // @formatter:off
            WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
            WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
            // @formatter:on
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1/group3'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualWalletListPageCubit.navigateBack();
        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, walletModel1, walletModel2, walletModel3],
          filesystemPath: FilesystemPath.fromString('vault1/network1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of WalletListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualWalletListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);

        ListState actualListState = actualWalletListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            // @formatter:off
            WalletModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, address: '0x315C3d389598EAe9aA2bf5524556B9CFA857B97c', derivationPath: "m/44'/60'/0'/0/3", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet4'), name: 'WALLET 3'),
            WalletModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, address: '0x569f256904bBaA2d9Cb3AF3104fCE9f0fC43F639', derivationPath: "m/44'/60'/0'/0/4", filesystemPath: FilesystemPath.fromString('vault1/network1/group3/wallet5'), name: 'WALLET 4')
            // @formatter:on
          ],
          filesystemPath: FilesystemPath.fromString('vault1/network1/group3'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });
}