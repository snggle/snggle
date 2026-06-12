import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_list_page/entry_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late EntryListPageCubit actualEntryListPageCubit;

  // @formatter:off
  EntryModel entryModel1 = EntryModel(id: 1, encryptedBool: false, pinnedBool: false, index: 0, filesystemPath: FilesystemPath.fromString('entries/entry1'), name: 'ENTRY 0', website: 'https://snggle.com', emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, totpExistsBool: true);
  EntryModel entryModel2 = EntryModel(id: 2, encryptedBool: false, pinnedBool: false, index: 1, filesystemPath: FilesystemPath.fromString('entries/group1/entry2'), name: 'ENTRY 1', website: 'https://snggle.com', usernameExistsBool: true);
  EntryModel entryModel3 = EntryModel(id: 3, encryptedBool: false, pinnedBool: false, index: 2, filesystemPath: FilesystemPath.fromString('entries/group1/entry3'), name: 'ENTRY 2', website: 'https://snggle.com', emailExistsBool: true, passwordExistsBool: true);
  late GroupModel groupModel = GroupModel(id: 4, encryptedBool: false, pinnedBool: false, filesystemPath: FilesystemPath.fromString('entries/group1'), name: 'ENTRIES GROUP 1', listItemsPreview: <AListItemModel>[entryModel2, entryModel3]);
  late GroupModel updatedGroupModel = groupModel.copyWith(name: 'UPDATED ENTRIES GROUP 1');
  late EntryModel updatedEntryModel1 = entryModel1.copyWith(name: 'UPDATED ENTRY 0', website: 'https://updated-entry1.example');
  // @formatter:on

  group('Tests of EntryListPageCubit basic operations', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualEntryListPageCubit = EntryListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('entries'),
        onGroupNavigateBack: globalLocator<PasswordController>().removeByFilesystemPath,
      );
    });

    group('Tests of EntryListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualEntryListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of EntryListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all entries existing in database', () async {
        // Act
        await actualEntryListPageCubit.refreshAll();
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, entryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single ENTRY', () async {
        // Arrange
        await globalLocator<EntriesService>().save(updatedEntryModel1);

        // Act
        await actualEntryListPageCubit.refreshSingle(entryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualEntryListPageCubit.refreshSingle(groupModel);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.toggleSelectAll()', () {
      test('Should [emit ListState] with [all items SELECTED]', () async {
        // Act
        actualEntryListPageCubit.toggleSelectAll();
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with [all items UNSELECTED] if all items were selected before', () async {
        // Act
        actualEntryListPageCubit.toggleSelectAll();
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 2),
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified ENTRY selected', () async {
        // Act
        actualEntryListPageCubit.selectSingle(updatedEntryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[updatedEntryModel1],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP selected', () async {
        // Act
        actualEntryListPageCubit.selectSingle(updatedGroupModel);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[updatedEntryModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified ENTRY unselected', () async {
        // Act
        actualEntryListPageCubit.unselectSingle(updatedEntryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 2,
            selectedItems: <AListItemModel>[updatedGroupModel],
          ),
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with specified GROUP unselected', () async {
        // Act
        actualEntryListPageCubit.unselectSingle(updatedGroupModel);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 2),
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.disableSelection()', () {
      test('Should [emit ListState] without SelectionModel set', () async {
        // Act
        actualEntryListPageCubit.disableSelection();
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualEntryListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedGroupModel, updatedEntryModel1],
          pinnedBool: true,
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedEntryModel1.copyWith(pinnedBool: true),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == false)', () async {
        // Act
        await actualEntryListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            updatedEntryModel1.copyWith(pinnedBool: true),
          ],
          pinnedBool: false,
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            updatedEntryModel1.copyWith(pinnedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == true)', () async {
        // Act
        await actualEntryListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[updatedGroupModel.copyWith(pinnedBool: false)],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            updatedEntryModel1.copyWith(pinnedBool: false, encryptedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.unlockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected ENTRY (encryptedBool == false)', () async {
        // Act
        await actualEntryListPageCubit.unlockSelection(
          selectedItem: updatedEntryModel1.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            updatedEntryModel1.copyWith(pinnedBool: false, encryptedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated "encryptedBool" value for selected GROUP (encryptedBool == false)', () async {
        // Act
        await actualEntryListPageCubit.unlockSelection(
          selectedItem: updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            updatedEntryModel1.copyWith(pinnedBool: false, encryptedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.renameItem()', () {
      test('Should [emit ListState] with renamed GROUP', () async {
        // Arrange
        String actualNewGroupName = 'NEW GROUP NAME';

        // Act
        await actualEntryListPageCubit.renameItem(updatedGroupModel, actualNewGroupName);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(name: actualNewGroupName),
            updatedEntryModel1,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [throw UnsupportedError] because entries cannot be renamed from this cubit', () async {
        // Assert
        expect(
          () => actualEntryListPageCubit.renameItem(updatedEntryModel1, 'NEW ENTRY NAME'),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Tests of EntryListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted ENTRY', () async {
        // Act
        await actualEntryListPageCubit.deleteItem(updatedEntryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(name: 'NEW GROUP NAME', pinnedBool: false, encryptedBool: false),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualEntryListPageCubit.deleteItem(updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false));
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: const <AListItemModel>[],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of EntryListPageCubit moveItem()', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualEntryListPageCubit = EntryListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('entries'),
        onGroupNavigateBack: globalLocator<PasswordController>().removeByFilesystemPath,
      );
    });

    test('Should [emit ListState] with ENTRY moved into GROUP', () async {
      // Arrange
      await actualEntryListPageCubit.refreshAll();

      // Act
      await actualEntryListPageCubit.moveItem(entryModel1, groupModel.filesystemPath);
      ListState actualListState = actualEntryListPageCubit.state;

      // Assert
      ListState expectedListState = ListState(
        depth: 0,
        loadingBool: false,
        allItems: <AListItemModel>[
          groupModel.copyWith(
            listItemsPreview: <AListItemModel>[
              entryModel1.copyWith(filesystemPath: FilesystemPath.fromString('entries/group1/entry1')),
              entryModel2,
              entryModel3,
            ],
          ),
        ],
        filesystemPath: FilesystemPath.fromString('entries'),
      );

      expect(actualListState, expectedListState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of EntryListPageCubit groupItems()', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualEntryListPageCubit = EntryListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('entries'),
        onGroupNavigateBack: globalLocator<PasswordController>().removeByFilesystemPath,
      );
    });

    test('Should [emit ListState] with new group containing grouped items', () async {
      // Arrange
      await actualEntryListPageCubit.refreshAll();

      // Act
      await actualEntryListPageCubit.groupItems(groupModel, entryModel1, 'TEST GROUP');
      ListState actualListState = actualEntryListPageCubit.state;

      // Assert
      ListState expectedListState = ListState(
        depth: 0,
        loadingBool: false,
        allItems: <AListItemModel>[
          GroupModel(
            id: 5,
            pinnedBool: false,
            encryptedBool: false,
            filesystemPath: FilesystemPath.fromString('entries/group5'),
            listItemsPreview: <AListItemModel>[
              groupModel.copyWith(
                filesystemPath: FilesystemPath.fromString('entries/group5/group1'),
                listItemsPreview: <AListItemModel>[],
              ),
              entryModel1.copyWith(filesystemPath: FilesystemPath.fromString('entries/group5/entry1')),
            ],
            name: 'TEST GROUP',
          ),
        ],
        filesystemPath: FilesystemPath.fromString('entries'),
      );

      expect(actualListState, expectedListState);
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of EntryListPageCubit navigation process', () {
    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.fullDatabaseMock,
      );

      actualEntryListPageCubit = EntryListPageCubit(
        depth: 0,
        filesystemPath: FilesystemPath.fromString('entries'),
        onGroupNavigateBack: globalLocator<PasswordController>().removeByFilesystemPath,
      );
    });

    group('Tests of EntryListPageCubit initialization', () {
      test('Should [emit ListState] with [loadingBool == TRUE]', () {
        // Assert
        expect(actualEntryListPageCubit.state.loadingBool, true);
      });
    });

    group('Tests of EntryListPageCubit.refreshAll()', () {
      test('Should [emit ListState] with all entries existing in database', () async {
        // Act
        await actualEntryListPageCubit.refreshAll();
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, entryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualEntryListPageCubit.navigateNext(filesystemPath: groupModel.filesystemPath);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[entryModel2, entryModel3],
          filesystemPath: FilesystemPath.fromString('entries/group1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.navigateBack()', () {
      test('Should [emit ListState] representing list values from previous path', () async {
        // Act
        await actualEntryListPageCubit.navigateBack();
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[groupModel, entryModel1],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualEntryListPageCubit.navigateTo(filesystemPath: groupModel.filesystemPath, depth: 1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: groupModel,
          allItems: <AListItemModel>[entryModel2, entryModel3],
          filesystemPath: FilesystemPath.fromString('entries/group1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });
}
