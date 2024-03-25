import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListItemModel extends Equatable {
  final bool encryptedBool;
  final WalletModel walletModel;

  const WalletListItemModel({
    required this.encryptedBool,
    required this.walletModel,
  });

  const WalletListItemModel._({
    required this.encryptedBool,
    required this.walletModel,
  });

  WalletListItemModel copyWith({
    bool? encryptedBool,
    WalletModel? walletModel,
  }) {
    return WalletListItemModel._(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      walletModel: walletModel ?? this.walletModel,
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
