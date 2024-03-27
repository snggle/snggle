import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallet_groups_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultsService {
  final VaultsRepository _vaultsRepository;
  final SecretsService _secretsService;
  final WalletGroupsService _walletGroupsService;

  VaultsService({
    VaultsRepository? vaultsRepository,
    WalletGroupsService? walletGroupsService,
    SecretsService? secretsService,
  })  : _vaultsRepository = vaultsRepository ?? globalLocator<VaultsRepository>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _walletGroupsService = walletGroupsService ?? globalLocator<WalletGroupsService>();

  Future<int> getLastVaultIndex() async {
    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAll();
    if (vaultEntityList.isEmpty) {
      return -1;
    }
    List<int> vaultEntityIndexList = vaultEntityList.map((VaultEntity vaultEntity) => vaultEntity.index).toList();
    int currentMaxIndex = vaultEntityIndexList.reduce((int currentMaxIndex, int currentIndex) {
      return currentMaxIndex > currentIndex ? currentMaxIndex : currentIndex;
    });
    return currentMaxIndex;
  }

  Future<List<VaultModel>> getVaultList() async {
    VaultModelFactory vaultModelFactory = globalLocator<VaultModelFactory>();

    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAll();
    List<VaultModel> vaultModelList = vaultEntityList.map(vaultModelFactory.createFromEntity).toList();
    return vaultModelList;
  }

  Future<VaultModel> getVaultModel(String uuid) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(uuid);
    VaultModelFactory vaultModelFactory = globalLocator<VaultModelFactory>();
    return vaultModelFactory.createFromEntity(vaultEntity);
  }

  Future<void> saveVault(VaultModel vaultModel) async {
    await _vaultsRepository.save(VaultEntity.fromVaultModel(vaultModel));
  }

  Future<void> deleteVaultById(String uuid, {bool recursiveBool = false}) async {
    if (recursiveBool) {
      List<WalletGroupModel> walletGroupModelList = await _walletGroupsService.getWalletGroups(uuid, strictBool: true);
      for (WalletGroupModel walletGroupModel in walletGroupModelList) {
        await _walletGroupsService.deleteGroupByPath(walletGroupModel.containerPathModel.fullPath, recursiveBool: true);
      }
    }

    VaultModel vaultModel = await getVaultModel(uuid);
    await _secretsService.deleteSecrets(vaultModel.containerPathModel);
    await _vaultsRepository.deleteById(uuid);
  }
}
