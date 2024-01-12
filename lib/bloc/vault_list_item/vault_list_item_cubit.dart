import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/vault_list_item/vault_list_item_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
// After UI / list implementation responsibility of this cubit may be significantly rebuilt.
// For this reason, this cubit is not covered by tests, which should be added during UI implementation.
class VaultListItemCubit extends Cubit<VaultListItemState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();

  final VaultModel vaultModel;

  VaultListItemCubit({required this.vaultModel}) : super(const VaultListItemState.decrypted(vaultWalletsPreview: <WalletModel>[], totalWalletsCount: 0));

  // TODO(dominik): This operation is asynchronous and default state (encrypted=false, locked=false) is visible for a short time.
  // Implement LoadingState and handle it on the UI to avoid such situation (e.g. Use Shimmer effect)
  Future<void> init() async {
    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(vaultModel.containerPathModel, PasswordModel.defaultPassword());

    List<WalletModel> vaultWalletsAll = await _walletsService.getWalletList(vaultModel.uuid);
    List<WalletModel> vaultWalletsPreview = List<WalletModel>.from(vaultWalletsAll.sublist(0, min(9, vaultWalletsAll.length)));

    if (defaultPasswordBool == true) {
      emit(VaultListItemState.decrypted(vaultWalletsPreview: vaultWalletsPreview, totalWalletsCount: vaultWalletsAll.length));
    } else {
      emit(VaultListItemState.encrypted(vaultWalletsPreview: vaultWalletsPreview, totalWalletsCount: vaultWalletsAll.length, lockedBool: true));
    }
  }

  Future<void> reload() async {
    List<WalletModel> vaultWalletsAll = await _walletsService.getWalletList(vaultModel.uuid);
    List<WalletModel> vaultWalletsPreview = List<WalletModel>.from(vaultWalletsAll.sublist(0, min(9, vaultWalletsAll.length)));

    emit(VaultListItemState(
      encryptedBool: state.encryptedBool,
      lockedBool: state.lockedBool,
      totalWalletsCount: vaultWalletsAll.length,
      vaultWalletsPreview: vaultWalletsPreview,
    ));
  }

  Future<void> setPassword(PasswordModel passwordModel) async {
    VaultSecretsModel vaultSecretsModel = await _secretsService.getSecrets(vaultModel.containerPathModel, PasswordModel.defaultPassword());
    await _secretsService.saveSecrets(vaultSecretsModel, passwordModel);

    emit(state.copyEncrypted(lockedBool: false));
  }

  Future<void> removePassword(PasswordModel passwordModel) async {
    VaultSecretsModel vaultSecretsModel = await _secretsService.getSecrets(vaultModel.containerPathModel, passwordModel);
    await _secretsService.saveSecrets(vaultSecretsModel, PasswordModel.defaultPassword());

    emit(state.copyDecrypted());
  }

  Future<void> lock() async {
    emit(state.copyEncrypted(lockedBool: true));
  }

  Future<void> unlock(PasswordModel passwordModel) async {
    bool passwordValid = await _secretsService.isSecretsPasswordValid(vaultModel.containerPathModel, passwordModel);
    bool lockedBool = passwordValid == false;
    emit(state.copyEncrypted(lockedBool: lockedBool));
  }

  Future<VaultSecretsModel> getVaultSecrets(PasswordModel passwordModel) async {
    VaultSecretsModel vaultSecretsModel = await _secretsService.getSecrets(vaultModel.containerPathModel, passwordModel);
    return vaultSecretsModel;
  }
}
