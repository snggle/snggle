import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';

class WalletSelectionModel extends SelectionModel<WalletListItemModel> {
  WalletSelectionModel(super.selectedItems);

  factory WalletSelectionModel.fromSelectionModel(SelectionModel<WalletListItemModel> selectionModel) {
    return WalletSelectionModel(selectionModel.selectedItems);
  }

  bool get canPinAll {
    bool allPinnedBool = selectedItems.every((WalletListItemModel element) => element.pinnedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedItems.every((WalletListItemModel element) => element.pinnedBool == false);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedItems.any((WalletListItemModel element) => element.encryptedBool);
    bool emptySelectionBool = selectedItems.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedItems];
}
