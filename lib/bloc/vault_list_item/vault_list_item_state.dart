import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultListItemState extends Equatable {
  final bool encryptedBool;
  final bool lockedBool;
  final int totalWalletsCount;
  final List<WalletModel> vaultWalletsPreview;

  const VaultListItemState({
    required this.encryptedBool,
    required this.lockedBool,
    required this.totalWalletsCount,
    required this.vaultWalletsPreview,
  });

  const VaultListItemState.decrypted({required this.vaultWalletsPreview, required this.totalWalletsCount})
      : encryptedBool = false,
        lockedBool = false;

  const VaultListItemState.encrypted({
    required this.vaultWalletsPreview,
    required this.totalWalletsCount,
    this.lockedBool = true,
  }) : encryptedBool = true;

  VaultListItemState copyDecrypted() {
    return VaultListItemState.decrypted(vaultWalletsPreview: vaultWalletsPreview, totalWalletsCount: totalWalletsCount);
  }

  VaultListItemState copyEncrypted({required bool lockedBool}) {
    return VaultListItemState.encrypted(vaultWalletsPreview: vaultWalletsPreview, totalWalletsCount: totalWalletsCount, lockedBool: lockedBool);
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, lockedBool, totalWalletsCount, vaultWalletsPreview];
}
