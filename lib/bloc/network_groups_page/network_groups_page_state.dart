import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_selection_model.dart';

class NetworkGroupsPageState extends Equatable {
  final bool loadingBool;
  final bool searchBoxVisibleBool;
  final String? searchPattern;
  // final WalletSelectionModel? walletSelectionModel;
  late final List<NetworkGroupListItemModel> allNetworks;

  NetworkGroupsPageState({
    required this.loadingBool,
    this.searchBoxVisibleBool = false,
    this.searchPattern,
    // this.walletSelectionModel,
    List<NetworkGroupListItemModel>? allNetworks,
  }) {
    this.allNetworks = allNetworks ?? <NetworkGroupListItemModel>[];
  }

  NetworkGroupsPageState copyWith({
    bool? loadingBool,
    bool? searchBoxVisibleBool,
    String? searchPattern,
    WalletSelectionModel? walletSelectionModel,
    List<NetworkGroupListItemModel>? allNetworks,
  }) {
    return NetworkGroupsPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      searchBoxVisibleBool: searchBoxVisibleBool ?? this.searchBoxVisibleBool,
      searchPattern: searchPattern ?? this.searchPattern,
      // walletSelectionModel: walletSelectionModel ?? this.walletSelectionModel,
      allNetworks: allNetworks ?? this.allNetworks,
    );
  }

  // bool get isSelectingEnabled {
  //   return walletSelectionModel != null;
  // }

  bool get isScrollDisabled {
    return loadingBool || hasEmptyVaults;
  }

  bool get hasEmptyVaults {
    return loadingBool == false && allNetworks.isEmpty;
  }

  // List<WalletListItemModel> get selectedWallets {
  //   return walletSelectionModel?.selectedWallets ?? <WalletListItemModel>[];
  // }

  // List<WalletListItemModel> get visibleWallets {
  //   return allNetworks.where((WalletListItemModel e) => e.name.toLowerCase().contains(searchPattern?.toLowerCase() ?? '')).toList();
  // }

  @override
  List<Object?> get props => <Object?>[loadingBool, searchBoxVisibleBool, searchPattern, allNetworks.hashCode];
}
