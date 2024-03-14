import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';

class VaultListPageState extends Equatable {
  final bool loadingBool;
  final bool searchBoxVisibleBool;
  final String? searchPattern;
  final VaultSelectionModel? vaultSelectionModel;
  late final List<VaultListItemModel> allVaults;

  VaultListPageState({
    required this.loadingBool,
    this.searchBoxVisibleBool = false,
    this.searchPattern,
    this.vaultSelectionModel,
    List<VaultListItemModel>? allVaults,
  }) {
    List<VaultListItemModel> sortedVaults = List<VaultListItemModel>.from(allVaults ?? <VaultListItemModel>[])
      ..sort((VaultListItemModel a, VaultListItemModel b) => a.vaultModel.index.compareTo(b.vaultModel.index));

    List<VaultListItemModel>? pinnedVaults = sortedVaults.where((VaultListItemModel e) => e.vaultModel.pinnedBool == true).toList();
    List<VaultListItemModel>? unpinnedVaults = sortedVaults.where((VaultListItemModel e) => e.vaultModel.pinnedBool == false).toList();

    this.allVaults = <VaultListItemModel>[...pinnedVaults, ...unpinnedVaults];
  }

  VaultListPageState copyWith({
    bool? loadingBool,
    bool? searchBoxVisibleBool,
    String? searchPattern,
    List<VaultListItemModel>? allVaults,
    VaultSelectionModel? vaultSelectionModel,
  }) {
    return VaultListPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      searchBoxVisibleBool: searchBoxVisibleBool ?? this.searchBoxVisibleBool,
      searchPattern: searchPattern ?? this.searchPattern,
      allVaults: allVaults ?? this.allVaults,
      vaultSelectionModel: vaultSelectionModel ?? this.vaultSelectionModel,
    );
  }

  bool get isSelectingEnabled {
    return vaultSelectionModel != null;
  }

  bool get isScrollDisabled {
    return loadingBool || hasEmptyVaults;
  }

  bool get hasEmptyVaults {
    return loadingBool == false && allVaults.isEmpty;
  }

  List<VaultListItemModel> get selectedVaults {
    return vaultSelectionModel?.selectedVaults ?? <VaultListItemModel>[];
  }

  List<VaultListItemModel> get visibleVaults {
    return allVaults.where((VaultListItemModel e) => e.name.toLowerCase().contains(searchPattern?.toLowerCase() ?? '')).toList();
  }

  @override
  List<Object?> get props => <Object?>[loadingBool, searchBoxVisibleBool, searchPattern, vaultSelectionModel, allVaults.hashCode];
}
