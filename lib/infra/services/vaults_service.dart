import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultsService implements IListItemsService<VaultModel> {
  final VaultsRepository _vaultsRepository = globalLocator<VaultsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  @override
  Future<List<VaultModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    VaultModelFactory vaultModelFactory = globalLocator<VaultModelFactory>();

    List<VaultEntity> vaultEntityList = await _vaultsRepository.getAllByParentPath(parentFilesystemPath);
    vaultEntityList = vaultEntityList.where((VaultEntity vaultEntity) {
      return vaultEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<VaultModel> vaultModelList = await vaultModelFactory.createFromEntities(vaultEntityList, previewEmptyBool: previewEmptyBool);
    return vaultModelList;
  }

  @override
  Future<VaultModel> getById(int id) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(id);
    return globalLocator<VaultModelFactory>().createFromEntity(vaultEntity);
  }

  @override
  Future<void> move(VaultModel listItem, FilesystemPath newFilesystemPath) async {
    VaultModel movedVaultModel = listItem.copyWith(filesystemPath: newFilesystemPath);
    await save(movedVaultModel);
    await _secretsService.move(listItem.filesystemPath, movedVaultModel.filesystemPath);
  }

  @override
  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
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

  @override
  Future<int> save(VaultModel listItem) async {
    return _vaultsRepository.save(VaultEntity.fromVaultModel(listItem));
  }

  @override
  Future<List<int>> saveAll(List<VaultModel> listItems) async {
    return _vaultsRepository.saveAll(listItems.map(VaultEntity.fromVaultModel).toList());
  }

  @override
  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<VaultModel> vaultModelList = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);

    // Sort vaults by the length of their paths, ensuring the deepest vault is deleted first
    vaultModelList.sort((VaultModel a, VaultModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (VaultModel vaultModel in vaultModelList) {
      await _secretsService.delete(vaultModel.filesystemPath);
      await _vaultsRepository.deleteById(vaultModel.id);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    VaultModel vaultModel = await getById(id);

    await _secretsService.delete(vaultModel.filesystemPath);
    await _vaultsRepository.deleteById(id);
  }

  Future<int> getLastIndex() async {
    int? lastIndex = await _vaultsRepository.getLastIndex();
    return lastIndex ?? -1;
  }

  Future<VaultModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    VaultEntity vaultEntity = await _vaultsRepository.getById(id);
    vaultEntity = vaultEntity.copyWith(filesystemPathString: parentFilesystemPath.add('vault$id').fullPath);
    await _vaultsRepository.save(vaultEntity);
    return globalLocator<VaultModelFactory>().createFromEntity(vaultEntity);
  }
}
