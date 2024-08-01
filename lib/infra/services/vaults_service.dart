import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultsService {
  final VaultsRepository _vaultsRepository = globalLocator<VaultsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<VaultModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(id);
    vaultEntity = vaultEntity.copyWith(filesystemPathString: parentFilesystemPath.add('vault$id').fullPath);
    await _vaultsRepository.save(vaultEntity);
    return globalLocator<VaultModelFactory>().createFromEntity(vaultEntity);
  }

  Future<int> getLastIndex() async {
    int? lastIndex = await _vaultsRepository.getLastIndex();
    return lastIndex ?? -1;
  }

  Future<VaultModel> getById(int id) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(id);
    return globalLocator<VaultModelFactory>().createFromEntity(vaultEntity);
  }

  Future<List<VaultModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    VaultModelFactory vaultModelFactory = globalLocator<VaultModelFactory>();

    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAllByParentPath(parentFilesystemPath);
    vaultEntityList = vaultEntityList.where((VaultEntity vaultEntity) {
      return vaultEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<VaultModel> vaultModelList = await vaultModelFactory.createFromEntities(vaultEntityList, previewEmptyBool: previewEmptyBool);
    return vaultModelList;
  }

  Future<void> move(VaultModel vaultModel, FilesystemPath newFilesystemPath) async {
    VaultModel movedVaultModel = vaultModel.copyWith(filesystemPath: newFilesystemPath);
    await save(movedVaultModel);
    await _secretsService.move(vaultModel.filesystemPath, movedVaultModel.filesystemPath);
  }

  Future<void> moveByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<VaultModel> vaultModelsToMove = await getAllByParentPath(previousFilesystemPath, firstLevelBool: false, previewEmptyBool: true);
    for (int i = 0; i < vaultModelsToMove.length; i++) {
      VaultModel vaultModel = vaultModelsToMove[i];
      VaultModel updatedVaultModel = vaultModel.copyWith(
        filesystemPath: vaultModel.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath),
      );

      vaultModelsToMove[i] = updatedVaultModel;
      await _secretsService.move(vaultModel.filesystemPath, updatedVaultModel.filesystemPath);
    }

    await saveAll(vaultModelsToMove);
  }

  Future<int> save(VaultModel vaultModel) async {
    return _vaultsRepository.save(VaultEntity.fromVaultModel(vaultModel));
  }

  Future<List<int>> saveAll(List<VaultModel> vaultModelList) async {
    return _vaultsRepository.saveAll(vaultModelList.map(VaultEntity.fromVaultModel).toList());
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<VaultModel> vaultModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    vaultModelList.sort((VaultModel a, VaultModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (VaultModel vaultModel in vaultModelList) {
      await _secretsService.delete(vaultModel.filesystemPath);
      await _vaultsRepository.deleteById(vaultModel.id);
    }
  }

  Future<void> deleteById(int id) async {
    VaultModel vaultModel = await getById(id);

    await _secretsService.delete(vaultModel.filesystemPath);
    await _vaultsRepository.deleteById(id);
  }
}
