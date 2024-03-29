import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  List<TestListItem> actualTestListItems = <TestListItem>[
    TestListItem(encryptedBool: true, pinnedBool: false),
    TestListItem(encryptedBool: false, pinnedBool: false),
    TestListItem(encryptedBool: false, pinnedBool: true),
  ];

  group('Tests of ListState.isSelectionEnabled getter', () {
    test('Should [return TRUE] if [SelectionModel EXISTS]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
        selectionModel: SelectionModel(selectedItems: <TestListItem>[], allItemsCount: 3),
      );

      // Assert
      expect(actualListState.isSelectionEnabled, true);
    });

    test('Should [return FALSE] if [SelectionModel NOT EXISTS]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isSelectionEnabled, false);
    });
  });

  group('Tests of ListState.isScrollDisabled getter', () {
    test('Should [return TRUE] if [loadingBool == TRUE]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: true,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isScrollDisabled, true);
    });

    test('Should [return TRUE] if [loadingBool == FALSE] and [items EMPTY]', () {
      // Arrange
      ListState actualListState = const ListState(
        loadingBool: false,
        allItems: <TestListItem>[],
        filesystemPath: FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isScrollDisabled, true);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [items NOT EMPTY]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isScrollDisabled, false);
    });
  });

  group('Tests of ListState.isEmpty getter', () {
    test('Should [return TRUE] if [loadingBool == FALSE] and [items EMPTY]', () {
      // Arrange
      ListState actualListState = const ListState(
        loadingBool: false,
        allItems: <TestListItem>[],
        filesystemPath: FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isEmpty, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE] and [items EMPTY]', () {
      // Arrange
      ListState actualListState = const ListState(
        loadingBool: true,
        allItems: <TestListItem>[],
        filesystemPath: FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isEmpty, false);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [items NOT EMPTY]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
      );

      // Assert
      expect(actualListState.isScrollDisabled, false);
    });
  });

  group('Tests of ListState.selectedItems getter', () {
    test('Should [return selected items] if [SelectionModel EXISTS] and [selected items NOT EMPTY]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
        selectionModel: SelectionModel(selectedItems: actualTestListItems, allItemsCount: 3),
      );

      // Act
      List<AListItemModel> actualSelectedItems = actualListState.selectedItems;

      // Assert
      List<AListItemModel> expectedSelectedItems = <TestListItem>[
        TestListItem(encryptedBool: true, pinnedBool: false),
        TestListItem(encryptedBool: false, pinnedBool: false),
        TestListItem(encryptedBool: false, pinnedBool: true),
      ];

      expect(actualSelectedItems, expectedSelectedItems);
    });

    test('Should [return EMPTY list] if [SelectionModel EXISTS] but [selected items EMPTY]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
        selectionModel: SelectionModel(selectedItems: <TestListItem>[], allItemsCount: 3),
      );

      // Act
      List<AListItemModel> actualSelectedItems = actualListState.selectedItems;

      // Assert
      List<AListItemModel> expectedSelectedItems = <TestListItem>[];

      expect(actualSelectedItems, expectedSelectedItems);
    });

    test('Should [return EMPTY list] if [SelectionModel NOT EXISTS]', () {
      // Arrange
      ListState actualListState = ListState(
        loadingBool: false,
        allItems: actualTestListItems,
        filesystemPath: const FilesystemPath.empty(),
      );

      // Act
      List<AListItemModel> actualSelectedItems = actualListState.selectedItems;

      // Assert
      List<AListItemModel> expectedSelectedItems = <TestListItem>[];

      expect(actualSelectedItems, expectedSelectedItems);
    });
  });
}

class TestListItem extends AListItemModel {
  TestListItem({
    required super.encryptedBool,
    required super.pinnedBool,
  }) : super(uuid: '123', filesystemPath: const FilesystemPath.empty());

  @override
  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool}) {
    return TestListItem(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
    );
  }

  @override
  String get name => 'Test List Item';
}
