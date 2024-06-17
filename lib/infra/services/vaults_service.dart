import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultsService {
  final VaultsRepository _vaultsRepository = globalLocator<VaultsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<int> getLastIndex() async {
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

  Future<VaultModel> getById(String uuid) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(uuid);
    return globalLocator<VaultModelFactory>().createFromEntity(vaultEntity);
  }

  Future<List<VaultModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false}) async {
    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAll();

    vaultEntityList = vaultEntityList.where((VaultEntity vaultEntity) {
      return vaultEntity.filesystemPath.isSubPathOf(parentFilesystemPath, singleLevelBool: firstLevelBool);
    }).toList();

    List<VaultModel> vaultModelList = <VaultModel>[];
    for (VaultEntity vaultEntity in vaultEntityList) {
      vaultModelList.add(await globalLocator<VaultModelFactory>().createFromEntity(vaultEntity));
    }

    return vaultModelList..sort((VaultModel a, VaultModel b) => a.compareTo(b));
  }

  Future<void> save(VaultModel vaultModel) async {
    await _vaultsRepository.save(VaultEntity.fromVaultModel(vaultModel));
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<VaultModel> vaultModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    vaultModelList.sort((VaultModel a, VaultModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (VaultModel vaultModel in vaultModelList) {
      await _secretsService.delete(vaultModel.filesystemPath);
      await _vaultsRepository.deleteById(vaultModel.uuid);
    }
  }

  Future<void> deleteById(String uuid) async {
    VaultModel vaultModel = await getById(uuid);
    await _secretsService.delete(vaultModel.filesystemPath);
    await _vaultsRepository.deleteById(uuid);
  }
}
