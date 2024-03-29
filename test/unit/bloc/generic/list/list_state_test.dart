import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';

void main() {
  List<TestListItem> actualTestListItems = <TestListItem>[
    TestListItem(encryptedBool: true, pinnedBool: false),
    TestListItem(encryptedBool: false, pinnedBool: false),
    TestListItem(encryptedBool: false, pinnedBool: true),
  ];

  group('Tests of ListState.isSelectionEnabled getter', () {
    test('Should [return TRUE] if [SelectionModel EXISTS]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(
        loadingBool: false,
        allItems: actualTestListItems,
        selectionModel: SelectionModel<TestListItem>(selectedItems: <TestListItem>[], allItemsCount: 3),
      );

      // Assert
      expect(actualListState.isSelectionEnabled, true);
    });

    test('Should [return FALSE] if [SelectionModel NOT EXISTS]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(loadingBool: false, allItems: actualTestListItems);

      // Assert
      expect(actualListState.isSelectionEnabled, false);
    });
  });

  group('Tests of ListState.isScrollDisabled getter', () {
    test('Should [return TRUE] if [loadingBool == TRUE]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(
        loadingBool: true,
        allItems: actualTestListItems,
      );

      // Assert
      expect(actualListState.isScrollDisabled, true);
    });

    test('Should [return TRUE] if [loadingBool == FALSE] and [items EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = const ListState<TestListItem>(loadingBool: false, allItems: <TestListItem>[]);

      // Assert
      expect(actualListState.isScrollDisabled, true);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [items NOT EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(loadingBool: false, allItems: actualTestListItems);

      // Assert
      expect(actualListState.isScrollDisabled, false);
    });
  });

  group('Tests of ListState.isEmpty getter', () {
    test('Should [return TRUE] if [loadingBool == FALSE] and [items EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = const ListState<TestListItem>(loadingBool: false, allItems: <TestListItem>[]);

      // Assert
      expect(actualListState.isEmpty, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE] and [items EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = const ListState<TestListItem>(loadingBool: true, allItems: <TestListItem>[]);

      // Assert
      expect(actualListState.isEmpty, false);
    });

    test('Should [return FALSE] if [loadingBool == FALSE] and [items NOT EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(loadingBool: false, allItems: actualTestListItems);

      // Assert
      expect(actualListState.isScrollDisabled, false);
    });
  });

  group('Tests of ListState.selectedItems getter', () {
    test('Should [return selected items] if [SelectionModel EXISTS] and [selected items NOT EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(
        loadingBool: false,
        allItems: actualTestListItems,
        selectionModel: SelectionModel<TestListItem>(selectedItems: actualTestListItems, allItemsCount: 3),
      );

      // Act
      List<TestListItem> actualSelectedItems = actualListState.selectedItems;

      // Assert
      List<TestListItem> expectedSelectedItems = <TestListItem>[
        TestListItem(encryptedBool: true, pinnedBool: false),
        TestListItem(encryptedBool: false, pinnedBool: false),
        TestListItem(encryptedBool: false, pinnedBool: true),
      ];

      expect(actualSelectedItems, expectedSelectedItems);
    });

    test('Should [return EMPTY list] if [SelectionModel EXISTS] but [selected items EMPTY]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(
        loadingBool: false,
        allItems: actualTestListItems,
        selectionModel: SelectionModel<TestListItem>(selectedItems: <TestListItem>[], allItemsCount: 3),
      );

      // Act
      List<TestListItem> actualSelectedItems = actualListState.selectedItems;

      // Assert
      List<TestListItem> expectedSelectedItems = <TestListItem>[];

      expect(actualSelectedItems, expectedSelectedItems);
    });

    test('Should [return EMPTY list] if [SelectionModel NOT EXISTS]', () {
      // Arrange
      ListState<TestListItem> actualListState = ListState<TestListItem>(loadingBool: false, allItems: actualTestListItems);

      // Act
      List<TestListItem> actualSelectedItems = actualListState.selectedItems;

      // Assert
      List<TestListItem> expectedSelectedItems = <TestListItem>[];

      expect(actualSelectedItems, expectedSelectedItems);
    });
  });
}

class TestListItem extends AListItemModel {
  TestListItem({
    required super.encryptedBool,
    required super.pinnedBool,
  });

  @override
  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool}) {
    return TestListItem(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
    );
  }
}
