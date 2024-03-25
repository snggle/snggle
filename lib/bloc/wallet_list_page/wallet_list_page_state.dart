import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_selection_model.dart';

class WalletListPageState extends Equatable {
  final bool loadingBool;
  final bool searchBoxVisibleBool;
  final String? searchPattern;
  final WalletSelectionModel? walletSelectionModel;
  late final List<WalletListItemModel> allWallets;

  WalletListPageState({
    required this.loadingBool,
    this.searchBoxVisibleBool = false,
    this.searchPattern,
    this.walletSelectionModel,
    List<WalletListItemModel>? allWallets,
  }) {
    List<WalletListItemModel> sortedWallets = List<WalletListItemModel>.from(allWallets ?? <WalletListItemModel>[])
      ..sort((WalletListItemModel a, WalletListItemModel b) => a.walletModel.index.compareTo(b.walletModel.index));

    List<WalletListItemModel> pinnedWallets = sortedWallets.where((WalletListItemModel e) => e.walletModel.pinnedBool == true).toList();
    List<WalletListItemModel> unpinnedWallets = sortedWallets.where((WalletListItemModel e) => e.walletModel.pinnedBool == false).toList();

    this.allWallets = <WalletListItemModel>[...pinnedWallets, ...unpinnedWallets];
  }

  WalletListPageState copyWith({
    bool? loadingBool,
    bool? searchBoxVisibleBool,
    String? searchPattern,
    WalletSelectionModel? walletSelectionModel,
    List<WalletListItemModel>? allWallets,
  }) {
    return WalletListPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      searchBoxVisibleBool: searchBoxVisibleBool ?? this.searchBoxVisibleBool,
      searchPattern: searchPattern ?? this.searchPattern,
      walletSelectionModel: walletSelectionModel ?? this.walletSelectionModel,
      allWallets: allWallets ?? this.allWallets,
    );
  }

  bool get isSelectingEnabled {
    return walletSelectionModel != null;
  }

  bool get isScrollDisabled {
    return loadingBool || hasEmptyVaults;
  }

  bool get hasEmptyVaults {
    return loadingBool == false && allWallets.isEmpty;
  }

  List<WalletListItemModel> get selectedWallets {
    return walletSelectionModel?.selectedWallets ?? <WalletListItemModel>[];
  }

  List<WalletListItemModel> get visibleWallets {
    return allWallets.where((WalletListItemModel e) => e.name.toLowerCase().contains(searchPattern?.toLowerCase() ?? '')).toList();
  }

  @override
  List<Object?> get props => <Object?>[loadingBool, searchBoxVisibleBool, searchPattern, walletSelectionModel, allWallets.hashCode];
}
