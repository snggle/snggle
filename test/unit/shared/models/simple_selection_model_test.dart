import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

void main() {
  group('Tests of SimpleSelectionModel.areAllItemsSelected getter', () {
    test('Should [return TRUE] if [all items SELECTED]', () {
      // Arrange
      SimpleSelectionModel<TestListItem> actualSimpleSelectionModel = SimpleSelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSimpleSelectionModel.areAllItemsSelected, true);
    });

    test('Should [return FALSE] if [some items UNSELECTED]', () {
      // Arrange
      SimpleSelectionModel<TestListItem> actualSimpleSelectionModel = SimpleSelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[
          TestListItem(encryptedBool: false, pinnedBool: false),
          TestListItem(encryptedBool: false, pinnedBool: false),
        ],
      );

      // Assert
      expect(actualSimpleSelectionModel.areAllItemsSelected, false);
    });

    test('Should [return FALSE] if [all items UNSELECTED]', () {
      // Arrange
      SimpleSelectionModel<TestListItem> actualSimpleSelectionModel = const SimpleSelectionModel<TestListItem>(
        allItemsCount: 3,
        selectedItems: <TestListItem>[],
      );

      // Assert
      expect(actualSimpleSelectionModel.areAllItemsSelected, false);
    });
  });
}

class TestListItem extends AListItemModel {
  TestListItem({
    required super.encryptedBool,
    required super.pinnedBool,
  }) : super(id: 0, filesystemPath: const FilesystemPath.empty());

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
