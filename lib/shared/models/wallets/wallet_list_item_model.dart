import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListItemModel extends AListItemModel {
  late WalletModel walletModel;

  WalletListItemModel({
    required super.encryptedBool,
    required this.walletModel,
  }) : super(pinnedBool: walletModel.pinnedBool);

  @override
  WalletListItemModel copyWith({
    bool? encryptedBool,
    bool? pinnedBool,
    WalletModel? walletModel,
  }) {
    return WalletListItemModel(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      walletModel: (walletModel ?? this.walletModel).copyWith(
        pinnedBool: pinnedBool ?? this.pinnedBool,
      ),
    );
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be replaced by user-provided name.
  String get name {
    return walletModel.name ?? 'Wallet ${walletModel.index}'.toUpperCase();
  }

  String get shortenedAddress {
    return '${walletModel.address.substring(0, 7)}...${walletModel.address.substring(walletModel.address.length - 4)}';
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, walletModel];
}
