import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';

class VaultSelectionModel extends SelectionModel<VaultListItemModel> {
  VaultSelectionModel(super.selectedItems);

  factory VaultSelectionModel.fromSelectionModel(SelectionModel<VaultListItemModel> selectionModel) {
    return VaultSelectionModel(selectionModel.selectedItems);
  }

  bool get canPinAll {
    bool allPinnedBool = selectedItems.every((VaultListItemModel element) => element.pinnedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedItems.every((VaultListItemModel element) => element.pinnedBool == false);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedItems.any((VaultListItemModel element) => element.encryptedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedItems];
}
