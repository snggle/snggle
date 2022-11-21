import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dto/vaults/save_vault_request.dart';
import 'package:snuggle/infra/entity/vaults/vault_entity.dart';
import 'package:snuggle/infra/repositories/vaults_repository.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snuggle/shared/models/vaults/vault_model.dart';
import 'package:snuggle/shared/models/vaults/vault_safe_secrets_model.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

class VaultsService {
  final VaultsRepository _vaultsRepository;

  VaultsService({
    VaultsRepository? vaultsRepository,
  }) : _vaultsRepository = vaultsRepository ?? globalLocator<VaultsRepository>();

  Future<void> deleteVaultById(String uuid) {
    return _vaultsRepository.deleteById(uuid);
  }

  Future<void> decryptVault(VaultModel vaultModel, String password) async {
    if (vaultModel.encrypted == false) {
      AppLogger().log(message: 'Unexpected behavior: Trying to decrypt an already decrypted vault', logLevel: LogLevel.error);
      return;
    }
    VaultModel decryptedVaultModel = vaultModel.copyWith(
      vaultSecretsModel: (vaultModel.vaultSecretsModel as VaultSafeSecretsModel).decrypt(password),
    );
    SaveVaultRequest saveVaultRequest = SaveVaultRequest.fromVaultModel(decryptedVaultModel);
    await saveVault(saveVaultRequest);
  }

  Future<void> encryptVault(VaultModel vaultModel, String password) async {
    VaultModel encryptedVaultModel = vaultModel.copyWith(
      vaultSecretsModel: vaultModel.vaultSecretsModel.encrypt(password),
    );
    SaveVaultRequest saveVaultRequest = SaveVaultRequest.fromVaultModel(encryptedVaultModel);
    await saveVault(saveVaultRequest);
  }

  Future<List<VaultListItemModel>> getVaultListItems() async {
    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAll();
    List<VaultListItemModel> vaultListItemModelList = vaultEntityList.map((VaultEntity vaultEntity) {
      return VaultListItemModel(vaultModel: vaultEntity.mapToModel());
    }).toList();
    return vaultListItemModelList;
  }

  Future<void> saveVault(SaveVaultRequest saveVaultRequest) async {
    await _vaultsRepository.save(saveVaultRequest.mapToEntity());
  }
}
