import 'dart:math';

import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultListItemModel extends AListItemModel {
  final int totalWalletsCount;
  final List<String> walletAddressesPreview;
  late VaultModel vaultModel;

  VaultListItemModel({
    required super.encryptedBool,
    required this.vaultModel,
    required List<WalletModel> vaultWallets,
  })  : totalWalletsCount = vaultWallets.length,
        walletAddressesPreview = vaultWallets.sublist(0, min(9, vaultWallets.length)).map((WalletModel e) => e.address).toList(),
        super(pinnedBool: vaultModel.pinnedBool);

  VaultListItemModel._({
    required super.encryptedBool,
    required this.totalWalletsCount,
    required this.vaultModel,
    required this.walletAddressesPreview,
  }) : super(pinnedBool: vaultModel.pinnedBool);

  @override
  VaultListItemModel copyWith({
    bool? encryptedBool,
    bool? pinnedBool,
    int? totalWalletsCount,
    VaultModel? vaultModel,
    List<String>? walletAddressesPreview,
  }) {
    return VaultListItemModel._(
      encryptedBool: encryptedBool ?? this.encryptedBool,
      totalWalletsCount: totalWalletsCount ?? this.totalWalletsCount,
      vaultModel: (vaultModel ?? this.vaultModel).copyWith(pinnedBool: pinnedBool),
      walletAddressesPreview: walletAddressesPreview ?? this.walletAddressesPreview,
    );
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be replaced by user-provided name.
  String get name {
    return vaultModel.name ?? 'Vault ${vaultModel.index}'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, totalWalletsCount, vaultModel, walletAddressesPreview];
}
