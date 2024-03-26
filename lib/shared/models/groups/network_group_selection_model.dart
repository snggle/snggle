import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';

class NetworkGroupSelectionModel extends SelectionModel<NetworkGroupListItemModel> {
  NetworkGroupSelectionModel(super.selectedItems);

  factory NetworkGroupSelectionModel.fromSelectionModel(SelectionModel<NetworkGroupListItemModel> selectionModel) {
    return NetworkGroupSelectionModel(selectionModel.selectedItems);
  }

  bool get canPinAll {
    bool allPinnedBool = selectedItems.every((NetworkGroupListItemModel element) => element.pinnedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedItems.every((NetworkGroupListItemModel element) => element.pinnedBool == false);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedItems.any((NetworkGroupListItemModel element) => element.encryptedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedItems];
}
