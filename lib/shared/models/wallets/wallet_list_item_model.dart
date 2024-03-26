import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListItemModel extends AListItem {
  late WalletModel walletModel;

  WalletListItemModel({
    required super.encryptedBool,
    required this.walletModel,
  }) : super(pinnedBool: walletModel.pinnedBool);

  @override
  void setPinned({required bool pinnedBool}) {
    super.setPinned(pinnedBool: pinnedBool);
    walletModel = walletModel.copyWith(pinnedBool: pinnedBool);
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
