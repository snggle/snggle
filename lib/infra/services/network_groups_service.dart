import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/repositories/network_groups_repository.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/network_group_model_factory.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupsService implements IListItemsService<NetworkGroupModel> {
  final NetworkGroupsRepository _networkGroupsRepository = globalLocator<NetworkGroupsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  @override
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

  @override
  Future<NetworkGroupModel> getById(int id) async {
    NetworkGroupEntity networkGroupEntity = await _networkGroupsRepository.getById(id);
    return globalLocator<NetworkGroupModelFactory>().createFromEntity(networkGroupEntity);
  }

  @override
  Future<void> move(NetworkGroupModel listItem, FilesystemPath newFilesystemPath) async {
    NetworkGroupModel movedNetworkGroupModel = listItem.copyWith(filesystemPath: newFilesystemPath);
    await save(movedNetworkGroupModel);
    await _secretsService.move(listItem.filesystemPath, movedNetworkGroupModel.filesystemPath);
  }

  @override
  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
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

  @override
  Future<int> save(NetworkGroupModel listItem) async {
    return _networkGroupsRepository.save(NetworkGroupEntity.fromNetworkGroupModel(listItem));
  }

  @override
  Future<List<int>> saveAll(List<NetworkGroupModel> listItems) async {
    return _networkGroupsRepository.saveAll(listItems.map(NetworkGroupEntity.fromNetworkGroupModel).toList());
  }

  @override
  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<NetworkGroupModel> networkGroupModels = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);

    // Sort networks by the length of their paths, ensuring the deepest network group is deleted first
    networkGroupModels.sort((NetworkGroupModel a, NetworkGroupModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (NetworkGroupModel networkGroupModel in networkGroupModels) {
      await _secretsService.delete(networkGroupModel.filesystemPath);
      await _networkGroupsRepository.deleteById(networkGroupModel.id);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    NetworkGroupModel networkGroupModel = await getById(id);

    await _secretsService.delete(networkGroupModel.filesystemPath);
    await _networkGroupsRepository.deleteById(networkGroupModel.id);
  }

  Future<NetworkGroupModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    NetworkGroupEntity networkGroupEntity = await _networkGroupsRepository.getById(id);
    networkGroupEntity = networkGroupEntity.copyWith(filesystemPathString: parentFilesystemPath.add('network$id').fullPath);
    await _networkGroupsRepository.save(networkGroupEntity);
    return globalLocator<NetworkGroupModelFactory>().createFromEntity(networkGroupEntity);
  }
}
