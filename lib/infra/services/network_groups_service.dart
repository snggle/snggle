import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/repositories/network_groups_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/network_group_model_factory.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupsService {
  final NetworkGroupsRepository _networkGroupsRepository = globalLocator<NetworkGroupsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<NetworkGroupModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    NetworkGroupEntity networkGroupEntity = await _networkGroupsRepository.getById(id);
    networkGroupEntity = networkGroupEntity.copyWith(filesystemPathString: parentFilesystemPath.add('network$id').fullPath);
    await _networkGroupsRepository.save(networkGroupEntity);
    return globalLocator<NetworkGroupModelFactory>().createFromEntity(networkGroupEntity);
  }

  Future<NetworkGroupModel> getById(int id) async {
    NetworkGroupEntity networkGroupEntity = await _networkGroupsRepository.getById(id);
    return globalLocator<NetworkGroupModelFactory>().createFromEntity(networkGroupEntity);
  }

  Future<List<NetworkGroupModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    NetworkGroupModelFactory networkGroupModelFactory = globalLocator<NetworkGroupModelFactory>();

    List<NetworkGroupEntity> networkGroupEntityList = await _networkGroupsRepository.getAllByParentPath(parentFilesystemPath);
    networkGroupEntityList = networkGroupEntityList.where((NetworkGroupEntity networkGroupEntity) {
      return networkGroupEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<NetworkGroupModel> networkGroupModelList = await networkGroupModelFactory.createFromEntities(
      networkGroupEntityList,
      previewEmptyBool: previewEmptyBool,
    );
    return networkGroupModelList;
  }

  Future<NetworkGroupModel> move(NetworkGroupModel networkGroupModel, FilesystemPath newParentFilesystemPath) async {
    NetworkGroupModel movedNetworkGroupModel = networkGroupModel.copyWith(filesystemPath: newParentFilesystemPath);
    await save(movedNetworkGroupModel);
    await _secretsService.move(networkGroupModel.filesystemPath, movedNetworkGroupModel.filesystemPath);
    return movedNetworkGroupModel;
  }

  Future<void> moveByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<NetworkGroupModel> networkGroupModelsToMove = await getAllByParentPath(previousFilesystemPath, firstLevelBool: false, previewEmptyBool: true);
    for (int i = 0; i < networkGroupModelsToMove.length; i++) {
      NetworkGroupModel networkGroupModel = networkGroupModelsToMove[i];
      NetworkGroupModel updatedNetworkGroupModel = networkGroupModel.copyWith(
        filesystemPath: networkGroupModel.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath),
      );

      networkGroupModelsToMove[i] = updatedNetworkGroupModel;
      await _secretsService.move(networkGroupModel.filesystemPath, updatedNetworkGroupModel.filesystemPath);
    }

    await saveAll(networkGroupModelsToMove);
  }

  Future<int> save(NetworkGroupModel networkGroupModel) async {
    return _networkGroupsRepository.save(NetworkGroupEntity.fromNetworkGroupModel(networkGroupModel));
  }

  Future<List<int>> saveAll(List<NetworkGroupModel> networkGroupModelList) async {
    return _networkGroupsRepository.saveAll(networkGroupModelList.map(NetworkGroupEntity.fromNetworkGroupModel).toList());
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<NetworkGroupModel> networkGroupModels = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    networkGroupModels.sort((NetworkGroupModel a, NetworkGroupModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (NetworkGroupModel networkGroupModel in networkGroupModels) {
      await _secretsService.delete(networkGroupModel.filesystemPath);
      await _networkGroupsRepository.deleteById(networkGroupModel.id);
    }
  }

  Future<void> deleteById(int id) async {
    NetworkGroupModel networkGroupModel = await getById(id);

    await _secretsService.delete(networkGroupModel.filesystemPath);
    await _networkGroupsRepository.deleteById(networkGroupModel.id);
  }
}
