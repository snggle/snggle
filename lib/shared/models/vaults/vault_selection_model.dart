import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';

class VaultSelectionModel with EquatableMixin {
  final List<VaultListItemModel> selectedVaults;

  VaultSelectionModel(this.selectedVaults);

  VaultSelectionModel.empty() : selectedVaults = <VaultListItemModel>[];

  bool get canPinAll {
    bool allPinnedBool = selectedVaults.every((VaultListItemModel element) => element.vaultModel.pinnedBool);
    bool emptySelectionBool = selectedVaults.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpinAll {
    bool allUnpinnedBool = selectedVaults.every((VaultListItemModel element) => element.vaultModel.pinnedBool == false);
    bool emptySelectionBool = selectedVaults.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLockAll {
    bool anyLockedBool = selectedVaults.any((VaultListItemModel element) => element.encryptedBool);
    bool emptySelectionBool = selectedVaults.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedVaults];
}
