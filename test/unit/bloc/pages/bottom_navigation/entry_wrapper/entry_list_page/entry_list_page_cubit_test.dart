import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_list_page/entry_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../../../utils/database_mock.dart';
import '../../../../../../utils/test_database.dart';

class EntryListTestData {
  final GroupModel groupModel;
  final EntryModel entryModel1;
  final EntryModel entryModel2;
  final EntryModel entryModel3;
  final EntryModel entryModel4;

  const EntryListTestData({
    required this.groupModel,
    required this.entryModel1,
    required this.entryModel2,
    required this.entryModel3,
    required this.entryModel4,
  });
}

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late EntryListPageCubit actualEntryListPageCubit;

  Future<EntryListTestData> seedEntries() async {
    GroupModel seededGroup = await globalLocator<GroupModelFactory>().createNewGroup(
      parentFilesystemPath: FilesystemPath.fromString('entries'),
      name: 'GROUP 1',
    );

    EntryModel entryModel1 = await globalLocator<EntryModelFactory>().createNewEntry(
      FilesystemPath.fromString('entries'),
      'ENTRY 0',
      'https://snggle.com',
      'entry1@example.com',
      'entry_user_1',
      'entry_password_1',
    );
    EntryModel entryModel2 = await globalLocator<EntryModelFactory>().createNewEntry(
      FilesystemPath.fromString('entries'),
      'ENTRY 1',
      'https://snggle.com',
      null,
      'entry_user_2',
      null,
    );
    EntryModel entryModel3 = await globalLocator<EntryModelFactory>().createNewEntry(
      seededGroup.filesystemPath,
      'ENTRY 2',
      'https://snggle.com',
      'entry3@example.com',
      null,
      'entry_password_3',
    );
    EntryModel entryModel4 = await globalLocator<EntryModelFactory>().createNewEntry(
      FilesystemPath.fromString('entries'),
      'ENTRY 3',
      'https://snggle.com',
      null,
      null,
      null,
    );

    GroupModel groupModel = await globalLocator<GroupsService>().getById(seededGroup.id);

    return EntryListTestData(
      groupModel: groupModel,
      entryModel1: entryModel1,
      entryModel2: entryModel2,
      entryModel3: entryModel3,
      entryModel4: entryModel4,
    );
  }

  group('Tests of EntryListPageCubit basic operations', () {
    late EntryListTestData testData;
    late GroupModel updatedGroupModel;
    late EntryModel updatedEntryModel4;

    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      );

      testData = await seedEntries();
      updatedGroupModel = testData.groupModel.copyWith(name: 'UPDATED GROUP 1');
      updatedEntryModel4 = testData.entryModel4.copyWith(
        name: 'UPDATED ENTRY 3',
        website: 'https://updated-entry3.example',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
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
          allItems: <AListItemModel>[
            testData.groupModel,
            testData.entryModel1,
            testData.entryModel2,
            testData.entryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.refreshSingle()', () {
      test('Should [emit ListState] with updated values for single ENTRY', () async {
        // Arrange
        await globalLocator<EntriesService>().save(updatedEntryModel4);

        // Act
        await actualEntryListPageCubit.refreshSingle(testData.entryModel4);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            testData.groupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] with updated values for single GROUP', () async {
        // Arrange
        await globalLocator<GroupsService>().save(updatedGroupModel);

        // Act
        await actualEntryListPageCubit.refreshSingle(testData.groupModel);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
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
            allItemsCount: 4,
            selectedItems: <AListItemModel>[
              updatedGroupModel,
              testData.entryModel1,
              testData.entryModel2,
              updatedEntryModel4,
            ],
          ),
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
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
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 4),
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.selectSingle()', () {
      test('Should [emit ListState] with specified ENTRY selected', () async {
        // Act
        actualEntryListPageCubit.selectSingle(testData.entryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[testData.entryModel1],
          ),
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
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
            allItemsCount: 4,
            selectedItems: <AListItemModel>[testData.entryModel1, updatedGroupModel],
          ),
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.unselectSingle()', () {
      test('Should [emit ListState] with specified ENTRY unselected', () async {
        // Act
        actualEntryListPageCubit.unselectSingle(testData.entryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          selectionModel: SelectionModel(
            allItemsCount: 4,
            selectedItems: <AListItemModel>[updatedGroupModel],
          ),
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
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
          selectionModel: SelectionModel(selectedItems: <AListItemModel>[], allItemsCount: 4),
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
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
          allItems: <AListItemModel>[
            updatedGroupModel,
            testData.entryModel1,
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.pinSelection()', () {
      test('Should [emit ListState] with updated "pinnedBool" value for selected items (pinnedBool == true)', () async {
        // Act
        await actualEntryListPageCubit.pinSelection(
          selectedItems: <AListItemModel>[updatedGroupModel, testData.entryModel1],
          pinnedBool: true,
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: true),
            testData.entryModel1.copyWith(pinnedBool: true),
            testData.entryModel2,
            updatedEntryModel4,
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
            testData.entryModel1.copyWith(pinnedBool: true),
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
            testData.entryModel1.copyWith(pinnedBool: false),
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.lockSelection()', () {
      test('Should [emit ListState] with updated "encryptedBool" value for selected items (encryptedBool == true)', () async {
        // Act
        await actualEntryListPageCubit.lockSelection(
          selectedItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false),
            testData.entryModel1.copyWith(pinnedBool: false),
          ],
          newPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            testData.entryModel1.copyWith(pinnedBool: false, encryptedBool: true),
            testData.entryModel2,
            updatedEntryModel4,
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
          selectedItem: testData.entryModel1.copyWith(pinnedBool: false, encryptedBool: true),
          oldPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: true),
            testData.entryModel1.copyWith(pinnedBool: false, encryptedBool: false),
            testData.entryModel2,
            updatedEntryModel4,
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
            testData.entryModel1.copyWith(pinnedBool: false, encryptedBool: false),
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.rename()', () {
      test('Should [throw UnsupportedError] because entries cannot be renamed from this cubit', () async {
        // Assert
        expect(
          () => actualEntryListPageCubit.renameItem(testData.entryModel1, 'NEW ENTRY NAME'),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Tests of EntryListPageCubit.deleteItem()', () {
      test('Should [emit ListState] without deleted ENTRY', () async {
        // Act
        await actualEntryListPageCubit.deleteItem(testData.entryModel1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            updatedGroupModel.copyWith(pinnedBool: false, encryptedBool: false),
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });

      test('Should [emit ListState] without deleted GROUP', () async {
        // Act
        await actualEntryListPageCubit.deleteItem(updatedGroupModel);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            testData.entryModel2,
            updatedEntryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of EntryListPageCubit groups process', () {
    late EntryListTestData testData;

    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      );

      testData = await seedEntries();

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
          allItems: <AListItemModel>[
            testData.groupModel,
            testData.entryModel1,
            testData.entryModel2,
            testData.entryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.moveItem()', () {
      test('Should [emit ListState] with ENTRY moved into GROUP', () async {
        // Act
        await actualEntryListPageCubit.moveItem(testData.entryModel1, testData.groupModel.filesystemPath);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            testData.groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                testData.entryModel1.copyWith(filesystemPath: FilesystemPath.fromString('entries/group1/entry1')),
                testData.entryModel3,
              ],
            ),
            testData.entryModel2,
            testData.entryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.groupItems()', () {
      test('Should [emit ListState] with new group containing selected items', () async {
        // Act
        await actualEntryListPageCubit.groupItems(testData.entryModel2, testData.entryModel4, 'TEST GROUP');
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 0,
          loadingBool: false,
          allItems: <AListItemModel>[
            testData.groupModel.copyWith(
              listItemsPreview: <AListItemModel>[
                testData.entryModel1.copyWith(filesystemPath: FilesystemPath.fromString('entries/group1/entry1')),
                testData.entryModel3,
              ],
            ),
            GroupModel(
              id: 2,
              pinnedBool: false,
              encryptedBool: false,
              filesystemPath: FilesystemPath.fromString('entries/group2'),
              listItemsPreview: <AListItemModel>[
                testData.entryModel2.copyWith(filesystemPath: FilesystemPath.fromString('entries/group2/entry2')),
                testData.entryModel4.copyWith(filesystemPath: FilesystemPath.fromString('entries/group2/entry4')),
              ],
              name: 'TEST GROUP',
            ),
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });

  group('Tests of EntryListPageCubit navigation process', () {
    late EntryListTestData testData;

    setUpAll(() async {
      await testDatabase.init(
        appPasswordModel: PasswordModel.fromPlaintext('1111'),
        databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      );

      testData = await seedEntries();

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
          allItems: <AListItemModel>[
            testData.groupModel,
            testData.entryModel1,
            testData.entryModel2,
            testData.entryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.navigateNext()', () {
      test('Should [emit ListState] representing list values from next path', () async {
        // Act
        await actualEntryListPageCubit.navigateNext(filesystemPath: testData.groupModel.filesystemPath);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: testData.groupModel,
          allItems: <AListItemModel>[
            testData.entryModel3,
          ],
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
          allItems: <AListItemModel>[
            testData.groupModel,
            testData.entryModel1,
            testData.entryModel2,
            testData.entryModel4,
          ],
          filesystemPath: FilesystemPath.fromString('entries'),
        );

        expect(actualListState, expectedListState);
      });
    });

    group('Tests of EntryListPageCubit.navigateTo()', () {
      test('Should [emit ListState] representing list values from selected path', () async {
        // Act
        await actualEntryListPageCubit.navigateTo(filesystemPath: testData.groupModel.filesystemPath, depth: 1);
        ListState actualListState = actualEntryListPageCubit.state;

        // Assert
        ListState expectedListState = ListState(
          depth: 1,
          loadingBool: false,
          groupModel: testData.groupModel,
          allItems: <AListItemModel>[
            testData.entryModel3,
          ],
          filesystemPath: FilesystemPath.fromString('entries/group1'),
        );

        expect(actualListState, expectedListState);
      });
    });

    tearDownAll(testDatabase.close);
  });
}
