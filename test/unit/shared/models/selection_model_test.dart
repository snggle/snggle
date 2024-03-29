import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';

void main() {
  group('Tests of SelectionModel.areAllItemsSelected getter', () {
    test('Should [return TRUE] if [all items SELECTED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.areAllItemsSelected, true);
    });

    test('Should [return FALSE] if [some items UNSELECTED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.areAllItemsSelected, false);
    });

    test('Should [return FALSE] if [all items UNSELECTED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[],
      );

      // Assert
      expect(actualSelectionModel.areAllItemsSelected, false);
    });
  });

  group('Tests of SelectionModel.canPinAll getter', () {
    test('Should [return TRUE] if [all items UNPINNED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.canPinAll, true);
    });

    test('Should [return TRUE] if [at least one item UNPINNED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: true),
          TestListItem(encryptedBool: false, pinnedBool: true),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.canPinAll, true);
    });

    test('Should [return FALSE] if [all items PINNED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: true),
          TestListItem(encryptedBool: false, pinnedBool: true),
          TestListItem(encryptedBool: false, pinnedBool: true),
        ],
      );

      // Assert
      expect(actualSelectionModel.canPinAll, false);
    });

    test('Should [return FALSE] if [selection EMPTY]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[],
      );

      // Assert
      expect(actualSelectionModel.canPinAll, false);
    });
  });

  group('Tests of SelectionModel.canUnpinAll getter', () {
    test('Should [return TRUE] if [all items PINNED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: true),
          TestListItem(encryptedBool: false, pinnedBool: true),
          TestListItem(encryptedBool: false, pinnedBool: true),
        ],
      );

      // Assert
      expect(actualSelectionModel.canUnpinAll, true);
    });

    test('Should [return TRUE] if [at least one item PINNED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: true),
        ],
      );

      // Assert
      expect(actualSelectionModel.canUnpinAll, true);
    });

    test('Should [return FALSE] if [all items UNPINNED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.canUnpinAll, false);
    });

    test('Should [return FALSE] if [selection EMPTY]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[],
      );

      // Assert
      expect(actualSelectionModel.canUnpinAll, false);
    });
  });

  group('Tests of SelectionModel.canLockAll getter', () {
    test('Should [return TRUE] if [all items UNLOCKED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.canLockAll, true);
    });

    test('Should [return FALSE] if [at least one item LOCKED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: true, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.canLockAll, false);
    });

    test('Should [return FALSE] if [all items LOCKED]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: true, pinnedBool: false),
          TestListItem(encryptedBool: true, pinnedBool: false),
          TestListItem(encryptedBool: true, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSelectionModel.canLockAll, false);
    });

    test('Should [return FALSE] if [selection EMPTY]', () {
      // Arrange
      SelectionModel<TestListItem> actualSelectionModel = SelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[],
      );

      // Assert
      expect(actualSelectionModel.canLockAll, false);
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
