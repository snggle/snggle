import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';

class SelectionModel<T extends AListItem> with EquatableMixin {
  final List<T> selectedItems;

  SelectionModel(this.selectedItems);

  SelectionModel.empty() : selectedItems = <T>[];

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
