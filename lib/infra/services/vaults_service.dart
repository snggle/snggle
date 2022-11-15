import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/dao/vault/request/save_vault_request.dart';
import 'package:snuggle/infra/dao/vault/vault_dao.dart';
import 'package:snuggle/infra/mappers/vault_secrets_mapper.dart';
import 'package:snuggle/infra/repository/vaults_repository.dart';
import 'package:snuggle/infra/services/wallets_service.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';
import 'package:snuggle/shared/models/vaults/vault_list_item_model.dart';

class VaultsService {
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final VaultsRepository _vaultsRepository = globalLocator<VaultsRepository>();

  Future<void> saveVault(VaultInfoModel vaultInfoModel) async {
    SaveVaultRequest saveVaultsRequest = SaveVaultRequest(
      id: vaultInfoModel.id,
      name: vaultInfoModel.name,
      vaultSecretsDao: VaultSecretsMapper.mapVaultSecretsModelToDao(vaultInfoModel.vaultsSecretsModel),
    );
    await _vaultsRepository.saveVault(saveVaultsRequest);
  }

  Future<List<VaultListItemModel>> getAll() async {
    List<VaultListItemModel> vaultListItemModelList = <VaultListItemModel>[];
    List<VaultDao> vaultDaoList = await _vaultsRepository.getAll();
    for (VaultDao vaultDao in vaultDaoList) {
      vaultListItemModelList.add(
        VaultListItemModel(
          vaultInfoModel: VaultInfoModel(
            id: vaultDao.id,
            name: vaultDao.name,
            vaultsSecretsModel: VaultSecretsMapper.mapVaultSecretsDaoToModel(vaultDao.vaultSecretsDao),
          ),
          addressModelList: await _walletsService.getAllWalletAddresses(vaultDao.id),
        ),
      );
    }
    return vaultListItemModelList;
  }
}
