import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultListItemModel extends Equatable {
  final bool encryptedBool;
  final int totalWalletsCount;
  final VaultModel vaultModel;
  final List<WalletModel> vaultWalletsPreview;

  VaultListItemModel({
    required this.encryptedBool,
    required this.vaultModel,
    required List<WalletModel> vaultWallets,
  })  : totalWalletsCount = vaultWallets.length,
        vaultWalletsPreview = vaultWallets.sublist(0, min(9, vaultWallets.length));

  const VaultListItemModel._({
    required this.encryptedBool,
    required this.totalWalletsCount,
    required this.vaultModel,
    required this.vaultWalletsPreview,
  });

  VaultListItemModel copyWith({
    bool? encryptedBool,
    VaultModel? vaultModel,
    List<WalletModel>? vaultWallets,
  }) {
    return VaultListItemModel._(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      vaultModel: vaultModel ?? this.vaultModel,
      totalWalletsCount: vaultWallets != null ? vaultWallets.length : totalWalletsCount,
      vaultWalletsPreview: vaultWallets != null ? vaultWallets.sublist(0, min(9, vaultWallets.length)) : vaultWalletsPreview,
    );
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be replaced by user-provided name.
  String get name {
    return vaultModel.name ?? 'Vault ${vaultModel.index}'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, totalWalletsCount, vaultModel, vaultWalletsPreview];
}
