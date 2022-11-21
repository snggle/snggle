import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dto/vaults/save_vault_request.dart';
import 'package:snuggle/infra/services/vaults_service.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snuggle/shared/models/vaults/vault_unsafe_secrets_model.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';
import 'package:uuid/uuid.dart';

class VaultListCubit extends Cubit<List<VaultListItemModel>> {
  final VaultsService _vaultsService = globalLocator<VaultsService>();

  VaultListCubit() : super(<VaultListItemModel>[]);

  // TODO(dominik): tmp method. Should be removed after implementing vault creation
  Future<void> generateNewVault() async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    SaveVaultRequest saveVaultRequest = SaveVaultRequest(
      uuid: const Uuid().v4(),
      name: 'Vault ${state.length}',
      vaultSecretsModel: VaultUnsafeSecretsModel(
        seed: seed,
      ),
    );

    await _vaultsService.saveVault(saveVaultRequest);
    await reload();
  }
  
  Future<void> encryptVault(VaultListItemModel vaultListItemModel, String password) async {
    await _vaultsService.encryptVault(vaultListItemModel.vaultModel, password);
    await reload();
  }

  Future<void> decryptVault(VaultListItemModel vaultListItemModel, String password) async {
    await _vaultsService.decryptVault(vaultListItemModel.vaultModel, password);
    await reload();
  }
  
  Future<void> deleteVault(VaultListItemModel vaultListItemModel) async {
    await _vaultsService.deleteVaultById(vaultListItemModel.vaultModel.uuid);
  }

  Future<void> reload() async {
    emit(await _vaultsService.getVaultListItems());
  }
}
