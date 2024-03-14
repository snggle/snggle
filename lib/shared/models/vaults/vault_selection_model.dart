import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';

class VaultSelectionModel with EquatableMixin {
  final List<VaultListItemModel> selectedVaults;

  VaultSelectionModel(this.selectedVaults);

  VaultSelectionModel.empty() : selectedVaults = <VaultListItemModel>[];

  bool get canPin {
    bool allPinnedBool = selectedVaults.every((VaultListItemModel element) => element.isPinned);
    bool emptySelectionBool = selectedVaults.isEmpty;

    return emptySelectionBool == false && allPinnedBool == false;
  }

  bool get canUnpin {
    bool allUnpinnedBool = selectedVaults.every((VaultListItemModel element) => element.isPinned == false);
    bool emptySelectionBool = selectedVaults.isEmpty;

    return emptySelectionBool == false && allUnpinnedBool == false;
  }

  bool get canLock {
    bool anyLockedBool = selectedVaults.any((VaultListItemModel element) => element.isEncrypted);
    bool emptySelectionBool = selectedVaults.isEmpty;

    return emptySelectionBool == false && anyLockedBool == false;
  }

  @override
  List<Object?> get props => <Object?>[selectedVaults];
}
