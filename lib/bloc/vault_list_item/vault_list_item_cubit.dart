import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/vault_list_item/vault_list_item_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/vault_secrets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
// After UI / list implementation responsibility of this cubit may be significantly rebuilt.
// For this reason, this cubit is not covered by tests, which should be added during UI implementation.
class VaultListItemCubit extends Cubit<VaultListItemState> {
  final VaultSecretsService _vaultSecretsService = globalLocator<VaultSecretsService>();

  final VaultModel vaultModel;

  VaultListItemCubit({required this.vaultModel}) : super(const VaultListItemState.decrypted());

  // TODO(dominik): This operation is asynchronous and default state (encrypted=false, locked=false) is visible for a short time.
  // Implement LoadingState and handle it on the UI to avoid such situation (e.g. Use Shimmer effect)
  Future<void> init() async {
    bool defaultPasswordBool = await _vaultSecretsService.isSecretsPasswordValid(vaultModel.uuid, PasswordModel.defaultPassword());

    if (defaultPasswordBool == true) {
      emit(const VaultListItemState.decrypted());
    } else {
      emit(const VaultListItemState.encrypted(lockedBool: true));
    }
  }

  Future<void> setPassword(PasswordModel passwordModel) async {
    VaultSecretsModel vaultSecretsModel = await _vaultSecretsService.getSecrets(vaultModel.uuid, PasswordModel.defaultPassword());
    await _vaultSecretsService.saveSecrets(vaultSecretsModel, passwordModel);

    emit(const VaultListItemState.encrypted(lockedBool: false));
  }

  Future<void> removePassword(PasswordModel passwordModel) async {
    VaultSecretsModel vaultSecretsModel = await _vaultSecretsService.getSecrets(vaultModel.uuid, passwordModel);
    await _vaultSecretsService.saveSecrets(vaultSecretsModel, PasswordModel.defaultPassword());

    emit(const VaultListItemState.decrypted());
  }

  Future<void> lock() async {
    emit(const VaultListItemState.encrypted(lockedBool: true));
  }

  Future<void> unlock(PasswordModel passwordModel) async {
    bool passwordValid = await _vaultSecretsService.isSecretsPasswordValid(vaultModel.uuid, passwordModel);
    bool lockedBool = passwordValid == false;
    emit(VaultListItemState.encrypted(lockedBool: lockedBool));
  }

  Future<VaultSecretsModel> getVaultSecrets(PasswordModel passwordModel) async {
    VaultSecretsModel vaultSecretsModel = await _vaultSecretsService.getSecrets(vaultModel.uuid, passwordModel);
    return vaultSecretsModel;
  }
}
