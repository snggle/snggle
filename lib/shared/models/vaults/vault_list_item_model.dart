import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultListItemModel extends AListItem {
  final int totalWalletsCount;
  final List<WalletModel> vaultWalletsPreview;
  late VaultModel vaultModel;

  VaultListItemModel({
    required super.encryptedBool,
    required this.vaultModel,
    required List<WalletModel> vaultWallets,
  })  : totalWalletsCount = vaultWallets.length,
        vaultWalletsPreview = vaultWallets.sublist(0, min(9, vaultWallets.length)),
        super(pinnedBool: vaultModel.pinnedBool);

  VaultListItemModel._({
    required super.encryptedBool,
    required this.totalWalletsCount,
    required this.vaultModel,
    required this.vaultWalletsPreview,
  }) : super(pinnedBool: vaultModel.pinnedBool);

  @override
  void setPinned({required bool pinnedBool}) {
    super.setPinned(pinnedBool: pinnedBool);
    vaultModel = vaultModel.copyWith(pinnedBool: pinnedBool);
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be replaced by user-provided name.
  String get name {
    return vaultModel.name ?? 'Vault ${vaultModel.index}'.toUpperCase();
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, totalWalletsCount, vaultModel, vaultWalletsPreview];
}
