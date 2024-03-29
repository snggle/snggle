import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';

class SelectionModel with EquatableMixin {
  final int allItemsCount;
  final List<AListItemModel> selectedItems;

  SelectionModel({
    required this.allItemsCount,
    required this.selectedItems,
  });

  SelectionModel.empty({required this.allItemsCount}) : selectedItems = <AListItemModel>[];

  bool get areAllItemsSelected => selectedItems.length == allItemsCount;

  bool get canPinAll {
    bool allPinnedBool = selectedItems.every((AListItemModel item) => item.pinnedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedItems.every((AListItemModel item) => item.pinnedBool == false);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedItems.any((AListItemModel item) => item.encryptedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[allItemsCount, selectedItems];
}
