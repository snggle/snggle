import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';
import '../../../../../../utils/test_network_templates.dart';

void main() async {
  final TestDatabase testDatabase = TestDatabase();
  late NetworkListPageCubit actualNetworkListPageCubit;

  // @formatter:off
  GroupModel groupModel = GroupModel(
    id: 2,
    encryptedBool: false,
    pinnedBool: false,
    filesystemPath: FilesystemPath.fromString('vault1/group2'),
    name: 'NETWORKS GROUP 1',
    listItemsPreview: <AListItemModel>[
      NetworkGroupModel(id: 6, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2/network6'), networkTemplateModel: TestNetworkTemplates.ethereum, listItemsPreview: <AListItemModel>[], name: 'Ethereum6'),
      NetworkGroupModel(id: 8, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2/network8'), networkTemplateModel: TestNetworkTemplates.ethereum, listItemsPreview: <AListItemModel>[], name: 'Ethereum8'),
    ],
  );
  GroupModel updatedGroupModel = GroupModel(
    id: 2,
    encryptedBool: true,
    pinnedBool: true,
    filesystemPath: FilesystemPath.fromString('vault1/group2'),
    name: 'UPDATED NETWORKS GROUP 1',
    listItemsPreview: <AListItemModel>[
      NetworkGroupModel(id: 6, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2/network6'), networkTemplateModel: TestNetworkTemplates.ethereum, listItemsPreview: <AListItemModel>[], name: 'Ethereum6'),
      NetworkGroupModel(id: 8, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2/network8'), networkTemplateModel: TestNetworkTemplates.ethereum, listItemsPreview: <AListItemModel>[], name: 'Ethereum8'),
    ],
  );
  NetworkGroupModel networkGroupModel1 = NetworkGroupModel(
    pinnedBool: false,
    encryptedBool: false,
    id: 1,
    filesystemPath: FilesystemPath.fromString('vault1/network1'),
    networkTemplateModel: TestNetworkTemplates.ethereum,
    listItemsPreview: <AListItemModel>[
      GroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1/group3'), name: 'WALLETS GROUP 1', listItemsPreview: <AListItemModel>[]),
      WalletModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce', derivationPath: "m/44'/60'/0'/0/0", network: 'ethereum', name: 'WALLET 0', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet1')),
      WalletModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, address: '0xd5fb453b321901a1d74Ba3FE93929AED57CA8686', derivationPath: "m/44'/60'/0'/0/1", network: 'ethereum', name: 'WALLET 1', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet2')),
      WalletModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, address: '0x1C37924f1416fF39F74A7284429a18dbbbcc06CD', derivationPath: "m/44'/60'/0'/0/2", network: 'ethereum', name: 'WALLET 2', filesystemPath: FilesystemPath.fromString('vault1/network1/wallet3')),
    ],
    name: 'Ethereum1',
  );
  NetworkGroupModel networkGroupModel2 = NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[], name: 'Ethereum7');
  NetworkGroupModel networkGroupModel3 = NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], name: 'Ethereum9');
  NetworkGroupModel updatedNetworkGroupModel3 =  NetworkGroupModel(id: 9, encryptedBool: true, pinnedBool: true, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], name: 'Ethereum9-UPDATED');
  // @formatter:on

  group('Tests of NetworkListPageCubit process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualNetworkListPageCubit = NetworkListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
      );
    });

    group('Tests of NetworkListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualNetworkListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of NetworkListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all items existing in database', () async {
        // Act
        await actualNetworkListPageCubit.refreshAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel1, networkGroupModel2, networkGroupModel3],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single NETWORK GROUP', () async {
        // Arrange
        // Update network group in database to check if it will be updated in the state
        await globalLocator<NetworkGroupsService>().save(updatedNetworkGroupModel3);

        // Act
        await actualNetworkListPageCubit.refreshSingle(networkGroupModel3);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedNetworkGroupModel3, groupModel, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        // Update group in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualNetworkListPageCubit.refreshSingle(groupModel);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all items SELECTED]', () async {
        // Act
        actualNetworkListPageCubit.toggleSelectAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all items UNSELECTED] if all items were selected before', () async {
        // Act
        actualNetworkListPageCubit.toggleSelectAll();

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified NETWORK GROUP selected', () async {
        // Act
        actualNetworkListPageCubit.selectSingle(updatedNetworkGroupModel3);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedNetworkGroupModel3],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualNetworkListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedNetworkGroupModel3, updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified NETWORK GROUP unselected', () async {
        // Act
        actualNetworkListPageCubit.unselectSingle(updatedNetworkGroupModel3);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualNetworkListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualNetworkListPageCubit.disableSelection();

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3, networkGroupModel1, networkGroupModel2],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == false)', () async {
        // Act
        await actualNetworkListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedGroupModel, updatedNetworkGroupModel3],
          pinnedBool: false,
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            networkGroupModel1,
            networkGroupModel2,
            updatedNetworkGroupModel3.copyWith(pinnedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualNetworkListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedNetworkGroupModel3.copyWith(pinnedBool: false),
          ],
          pinnedBool: true,
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedNetworkGroupModel3.copyWith(pinnedBool: true),
            networkGroupModel1,
            networkGroupModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected ITEMS (encryptedBool == true)', () async {
        // Act
        await actualNetworkListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedNetworkGroupModel3.copyWith(pinnedBool: true),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
            updatedNetworkGroupModel3.copyWith(pinnedBool: true, encryptedBool: true),
            networkGroupModel1,
            networkGroupModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected NETWORK GROUP (encryptedBool == false)', () async {
        // Act
        await actualNetworkListPageCubit.unlockSelection(
          selectedItem: updatedNetworkGroupModel3.copyWith(pinnedBool: true, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
            updatedNetworkGroupModel3.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel1,
            networkGroupModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualNetworkListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false),
            updatedNetworkGroupModel3.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel1,
            networkGroupModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted NETWORK GROUP', () async {
        // Act
        await actualNetworkListPageCubit.deleteItem(updatedNetworkGroupModel3.copyWith(pinnedBool: true, encryptedBool: false));
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false),
            networkGroupModel1,
            networkGroupModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualNetworkListPageCubit.deleteItem(updatedGroupModel.copyWith(pinnedBool: true, encryptedBool: false));
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            networkGroupModel1,
            networkGroupModel2,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of NetworkListPageCubit groups process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualNetworkListPageCubit = NetworkListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
      );
    });

    group('Tests of NetworkListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualNetworkListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of NetworkListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all items existing in database', () async {
        // Act
        await actualNetworkListPageCubit.refreshAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel1, networkGroupModel2, networkGroupModel3],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.moveItem()', () {
      test('Should [emit ListState] with NETWORK GROUP moved into GROUP', () async {
        // Act
        await actualNetworkListPageCubit.moveItem(networkGroupModel1, groupModel.filesystemPath);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                networkGroupModel1.copyWith(filesystemPath: FilesystemPath.fromString('vault1/group2/network1'), listItemsPreview: <AListItemModel>[]),
                ...groupModel.listItemsPreview,
              ],
            ),
            networkGroupModel2,
            networkGroupModel3,
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualNetworkListPageCubit.groupItems(networkGroupModel2, networkGroupModel3, 'TEST GROUP');

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                networkGroupModel1.copyWith(filesystemPath: FilesystemPath.fromString('vault1/group2/network1'), listItemsPreview: <AListItemModel>[]),
                ...groupModel.listItemsPreview,
              ],
            ),
            GroupModel(
              id: 4,
              pinnedBool: false,
              encryptedBool: false,
              filesystemPath: FilesystemPath.fromString('vault1/group4'),
              listItemsPreview: <AListItemModel>[
                networkGroupModel2.copyWith(filesystemPath: FilesystemPath.fromString('vault1/group4/network7'), listItemsPreview: <AListItemModel>[]),
                networkGroupModel3.copyWith(filesystemPath: FilesystemPath.fromString('vault1/group4/network9'), listItemsPreview: <AListItemModel>[]),
              ],
              name: 'TEST GROUP',
            )
          ],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of NetworkListPageCubit navigation process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualNetworkListPageCubit = NetworkListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('vault1'),
      );
    });

    group('Tests of NetworkListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualNetworkListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of NetworkListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all items existing in database', () async {
        // Act
        await actualNetworkListPageCubit.refreshAll();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel1, networkGroupModel2, networkGroupModel3],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualNetworkListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 6, encryptedBool: false, pinnedBool: false, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/group2/network6'), listItemsPreview: <AListItemModel>[], name: 'Ethereum6'),
            NetworkGroupModel(id: 8, encryptedBool: false, pinnedBool: false, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/group2/network8'), listItemsPreview: <AListItemModel>[], name: 'Ethereum8'),
            // @formatter:off
          ],
          filesystemPath: FilesystemPath.fromString('vault1/group2'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualNetworkListPageCubit.navigateBack();
        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, networkGroupModel1, networkGroupModel2, networkGroupModel3],
          filesystemPath: FilesystemPath.fromString('vault1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of NetworkListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualNetworkListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);

        ListState actualListState = actualNetworkListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            // @formatter:off
            NetworkGroupModel(id: 6, encryptedBool: false, pinnedBool: false, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/group2/network6'), listItemsPreview: <AListItemModel>[], name: 'Ethereum6'),
            NetworkGroupModel(id: 8, encryptedBool: false, pinnedBool: false, networkTemplateModel: TestNetworkTemplates.ethereum, filesystemPath: FilesystemPath.fromString('vault1/group2/network8'), listItemsPreview: <AListItemModel>[], name: 'Ethereum8'),
            // @formatter:off
          ],
          filesystemPath: FilesystemPath.fromString('vault1/group2'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });
}