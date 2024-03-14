import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';

class VaultListPageState extends Equatable {
  final bool loadingBool;
  final VaultSelectionModel? vaultSelectionModel;
  final String? searchPattern;
  late final List<VaultListItemModel> allVaults;

  VaultListPageState({
    required this.loadingBool,
    this.vaultSelectionModel,
    this.searchPattern,
    List<VaultListItemModel>? allVaults,
  }) {
    this.allVaults = <VaultListItemModel>[
      ...?allVaults?.where((VaultListItemModel e) => e.vaultModel.pinnedBool == true),
      ...?allVaults?.where((VaultListItemModel e) => e.vaultModel.pinnedBool == false),
    ];
  }

  VaultListPageState copyWith({
    bool? loadingBool,
    String? searchPattern,
    List<VaultListItemModel>? allVaults,
    VaultSelectionModel? vaultSelectionModel,
  }) {
    return VaultListPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      searchPattern: searchPattern ?? this.searchPattern,
      allVaults: allVaults ?? this.allVaults,
      vaultSelectionModel: vaultSelectionModel ?? this.vaultSelectionModel,
    );
  }

  bool get isSelectingEnabled {
    return vaultSelectionModel != null;
  }

  List<VaultListItemModel> get selectedVaults {
    return vaultSelectionModel?.selectedVaults ?? <VaultListItemModel>[];
  }

  List<VaultListItemModel> get visibleVaults {
    return allVaults.where((VaultListItemModel e) => e.name.toLowerCase().contains(searchPattern?.toLowerCase() ?? '')).toList();
  }

  @override
  List<Object?> get props => <Object?>[allVaults, visibleVaults, vaultSelectionModel, loadingBool];
}
