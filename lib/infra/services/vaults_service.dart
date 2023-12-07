import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultsService {
  final VaultsRepository _vaultsRepository;

  VaultsService({
    VaultsRepository? vaultsRepository,
  }) : _vaultsRepository = vaultsRepository ?? globalLocator<VaultsRepository>();

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

  Future<void> saveVault(VaultModel vaultModel) async {
    await _vaultsRepository.save(VaultEntity.fromVaultModel(vaultModel));
  }

  Future<void> deleteVaultById(String uuid) {
    return _vaultsRepository.deleteById(uuid);
  }
}
