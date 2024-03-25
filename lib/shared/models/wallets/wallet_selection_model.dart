import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';

class WalletSelectionModel with EquatableMixin {
  final List<WalletListItemModel> selectedWallets;

  WalletSelectionModel(this.selectedWallets);

  WalletSelectionModel.empty() : selectedWallets = <WalletListItemModel>[];

  bool get canPinAll {
    bool allPinnedBool = selectedWallets.every((WalletListItemModel element) => element.walletModel.pinnedBool);
    bool emptySelectionBool = selectedWallets.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedWallets.every((WalletListItemModel element) => element.walletModel.pinnedBool == false);
    bool emptySelectionBool = selectedWallets.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedWallets.any((WalletListItemModel element) => element.encryptedBool);
    bool emptySelectionBool = selectedWallets.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedWallets];
}
