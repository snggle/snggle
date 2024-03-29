import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';

class SelectionModel<T extends AListItemModel> with EquatableMixin {
  final int allItemsCount;
  final List<T> selectedItems;

  SelectionModel({
    required this.allItemsCount,
    required this.selectedItems,
  });

  SelectionModel.empty({required this.allItemsCount}) : selectedItems = <T>[];

  bool get areAllItemsSelected => selectedItems.length == allItemsCount;

  bool get canPinAll {
    bool allPinnedBool = selectedItems.every((T item) => item.pinnedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedItems.every((T item) => item.pinnedBool == false);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedItems.any((T item) => item.encryptedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedItems];
}
