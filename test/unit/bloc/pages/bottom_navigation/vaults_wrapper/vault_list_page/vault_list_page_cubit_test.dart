import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';
import '../../../../../../utils/test_network_templates.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late VaultListPageCubit actualVaultListPageCubit;

  GroupModel groupModel = GroupModel(
    id: 1,
    encryptedBool: false,
    pinnedBool: false,
    filesystemPath: FilesystemPath.fromString('group1'),
    name: 'VAULTS GROUP 1',
    listItemsPreview: <AListItemModel>[
      // @formatter:off
      VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPath: FilesystemPath.fromString('group1/vault4'), name: 'VAULT 4', listItemsPreview: <AListItemModel>[]),
      VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPath: FilesystemPath.fromString('group1/vault5'), name: 'VAULT 5', listItemsPreview: <AListItemModel>[])
      // @formatter:on
    ],
  );
  GroupModel updatedGroupModel = GroupModel(
    id: 1,
    encryptedBool: true,
    pinnedBool: true,
    filesystemPath: FilesystemPath.fromString('group1'),
    name: 'UPDATED VAULTS GROUP 1',
    listItemsPreview: <AListItemModel>[
      // @formatter:off
      VaultModel(id: 4, encryptedBool: false, pinnedBool: false, index: 3, filesystemPath: FilesystemPath.fromString('group1/vault4'), name: 'VAULT 4', listItemsPreview: <AListItemModel>[]),
      VaultModel(id: 5, encryptedBool: false, pinnedBool: false, index: 4, filesystemPath: FilesystemPath.fromString('group1/vault5'), name: 'VAULT 5', listItemsPreview: <AListItemModel>[])
      // @formatter:on
    ],
  );
  VaultModel vaultModel1 = VaultModel(
    id: 1,
    encryptedBool: false,
    pinnedBool: false,
    index: 0,
    filesystemPath: FilesystemPath.fromString('vault1'),
    name: 'VAULT 1',
    listItemsPreview: <AListItemModel>[
      // @formatter:off
      GroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/group2'), name: 'NETWORKS GROUP 1', listItemsPreview: <AListItemModel>[]),
      NetworkGroupModel(id: 1, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network1'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum1'),
      NetworkGroupModel(id: 7, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network7'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum7'),
      NetworkGroupModel(id: 9, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault1/network9'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum9'),
      // @formatter:on
    ],
  );
  VaultModel vaultModel2 = VaultModel(
    id: 2,
    encryptedBool: false,
    pinnedBool: false,
    index: 1,
    filesystemPath: FilesystemPath.fromString('vault2'),
    name: 'VAULT 2',
    listItemsPreview: <AListItemModel>[
      // @formatter:off
      NetworkGroupModel(id: 2, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault2/network2'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum2'),
      // @formatter:on
    ],
  );
  VaultModel vaultModel3 = VaultModel(
    id: 3,
    encryptedBool: false,
    pinnedBool: false,
    index: 2,
    filesystemPath: FilesystemPath.fromString('vault3'),
    name: 'VAULT 3',
    listItemsPreview: <AListItemModel>[
      // @formatter:off
      NetworkGroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault3/network3'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum3'),
      // @formatter:on
    ],
  );
  VaultModel updatedVaultModel3 = VaultModel(
    id: 3,
    encryptedBool: true,
    pinnedBool: true,
    index: 2,
    filesystemPath: FilesystemPath.fromString('vault3'),
    name: 'UPDATED VAULT 3',
    listItemsPreview: <AListItemModel>[
      // @formatter:off
      NetworkGroupModel(id: 3, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('vault3/network3'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum3'),
      // @formatter:on
    ],
  );

  group('Tests of VaultListPageCubit basic operations', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualVaultListPageCubit = VaultListPageCubit(
        depth: 0,
        filesystemPath: const FilesystemPath.empty(),
      );
    });

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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, vaultModel1, vaultModel2, vaultModel3],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single VAULT', () async {
        // Arrange
        // Update vault in database to check if it will be updated in the state
        await globalLocator<VaultsService>().save(updatedVaultModel3);

        // Act
        await actualVaultListPageCubit.refreshSingle(vaultModel3);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedVaultModel3, groupModel, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        // Update group in database to check if it will be updated in the state
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualVaultListPageCubit.refreshSingle(groupModel);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all items SELECTED]', () async {
        // Act
        actualVaultListPageCubit.toggleSelectAll();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all items UNSELECTED] if all items were selected before', () async {
        // Act
        actualVaultListPageCubit.toggleSelectAll();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 4),
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified VAULT selected', () async {
        // Act
        actualVaultListPageCubit.selectSingle(vaultModel1);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[vaultModel1],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualVaultListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[vaultModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified VAULT unselected', () async {
        // Act
        actualVaultListPageCubit.unselectSingle(vaultModel1);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[updatedGroupModel], allItemsCount: 4),
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualVaultListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 4),
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3, vaultModel1, vaultModel2],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedGroupModel, updatedVaultModel3],
          pinnedBool: true,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedVaultModel3.copyWith(pinnedBool: true),
            vaultModel1,
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected vaults (pinnedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedVaultModel3.copyWith(pinnedBool: true),
          ],
          pinnedBool: false,
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedVaultModel3.copyWith(pinnedBool: false),
            vaultModel1,
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected items (encryptedBool == true)', () async {
        // Act
        await actualVaultListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedVaultModel3.copyWith(pinnedBool: false),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            updatedVaultModel3.copyWith(pinnedBool: false, encryptedBool: true),
            vaultModel1,
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected VAULT (encryptedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.unlockSelection(
          selectedItem: updatedVaultModel3.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            updatedVaultModel3.copyWith(pinnedBool: false, encryptedBool: false),
            vaultModel1,
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualVaultListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel3.copyWith(pinnedBool: false, encryptedBool: false),
            vaultModel1,
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted VAULT', () async {
        // Act
        await actualVaultListPageCubit.deleteItem(vaultModel1);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            updatedVaultModel3.copyWith(pinnedBool: false, encryptedBool: false),
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualVaultListPageCubit.deleteItem(updatedGroupModel);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedVaultModel3.copyWith(pinnedBool: false, encryptedBool: false),
            vaultModel2,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of VaultListPage groups process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualVaultListPageCubit = VaultListPageCubit(
        depth: 0,
        filesystemPath: const FilesystemPath.empty(),
      );
    });

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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, vaultModel1, vaultModel2, vaultModel3],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.moveItem()', () {
      test('Should [emit ListState] with VAULT moved into GROUP', () async {
        // Act
        await actualVaultListPageCubit.moveItem(vaultModel1, groupModel.filesystemPath);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                vaultModel1.copyWith(filesystemPath: FilesystemPath.fromString('group1/vault1'), listItemsPreview: <AListItemModel>[]),
                ...groupModel.listItemsPreview,
              ],
            ),
            vaultModel2,
            vaultModel3,
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualVaultListPageCubit.groupItems(vaultModel2, vaultModel3, 'TEST GROUP');

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            GroupModel(
              id: 4,
              pinnedBool: false,
              encryptedBool: false,
              filesystemPath: FilesystemPath.fromString('group4'),
              listItemsPreview: <AListItemModel>[
                vaultModel2.copyWith(filesystemPath: FilesystemPath.fromString('group4/vault2'), listItemsPreview: <AListItemModel>[]),
                vaultModel3.copyWith(filesystemPath: FilesystemPath.fromString('group4/vault3'), listItemsPreview: <AListItemModel>[]),
              ],
              name: 'TEST GROUP',
            ),
            groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                vaultModel1.copyWith(filesystemPath: FilesystemPath.fromString('group1/vault1'), listItemsPreview: <AListItemModel>[]),
                ...groupModel.listItemsPreview,
              ],
            ),
          ],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of VaultListPage navigation process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualVaultListPageCubit = VaultListPageCubit(
        depth: 0,
        filesystemPath: const FilesystemPath.empty(),
      );
    });

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
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, vaultModel1, vaultModel2, vaultModel3],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualVaultListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            VaultModel(
              id: 4,
              encryptedBool: false,
              pinnedBool: false,
              index: 3,
              filesystemPath: FilesystemPath.fromString('group1/vault4'),
              name: 'VAULT 4',
              listItemsPreview: <AListItemModel>[
                // @formatter:off
                  NetworkGroupModel(id: 4, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1/vault4/network4'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum4'),
                // @formatter:on
              ],
            ),
            VaultModel(
              id: 5,
              encryptedBool: false,
              pinnedBool: false,
              index: 4,
              filesystemPath: FilesystemPath.fromString('group1/vault5'),
              name: 'VAULT 5',
              listItemsPreview: <AListItemModel>[
                // @formatter:off
                  NetworkGroupModel(id: 5, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1/vault5/network5'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum5'),
                // @formatter:on
              ],
            ),
          ],
          filesystemPath: FilesystemPath.fromString('group1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualVaultListPageCubit.navigateBack();

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, vaultModel1, vaultModel2, vaultModel3],
          filesystemPath: const FilesystemPath.empty(),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of VaultListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualVaultListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);

        ListState actualListState = actualVaultListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[
            VaultModel(
              id: 4,
              encryptedBool: false,
              pinnedBool: false,
              index: 3,
              filesystemPath: FilesystemPath.fromString('group1/vault4'),
              name: 'VAULT 4',
              listItemsPreview: <AListItemModel>[
                // @formatter:off
                  NetworkGroupModel(id: 4, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1/vault4/network4'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum4'),
                // @formatter:on
              ],
            ),
            VaultModel(
              id: 5,
              encryptedBool: false,
              pinnedBool: false,
              index: 4,
              filesystemPath: FilesystemPath.fromString('group1/vault5'),
              name: 'VAULT 5',
              listItemsPreview: <AListItemModel>[
                // @formatter:off
                  NetworkGroupModel(id: 5, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('group1/vault5/network5'), listItemsPreview: <AListItemModel>[], networkTemplateModel: TestNetworkTemplates.ethereum, name: 'Ethereum5'),
                // @formatter:on
              ],
            ),
          ],
          filesystemPath: FilesystemPath.fromString('group1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });
}