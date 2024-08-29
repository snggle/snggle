import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupsService implements IListItemsService<GroupModel> {
  final GroupsRepository _groupsRepository = globalLocator<GroupsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  @override
  Future<List<GroupModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    GroupModelFactory groupModelFactory = globalLocator<GroupModelFactory>();

    List<GroupEntity> groupEntityList = await _groupsRepository.getAllByParentPath(parentFilesystemPath);
    groupEntityList = groupEntityList.where((GroupEntity groupEntity) {
      return groupEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<GroupModel> groupModelList = await groupModelFactory.createFromEntities(groupEntityList, previewEmptyBool: previewEmptyBool);
    return groupModelList;
  }

  @override
  Future<GroupModel> getById(int id) async {
    GroupEntity groupEntity = await _groupsRepository.getById(id);
    return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
  }

  @override
  Future<void> move(GroupModel listItem, FilesystemPath newFilesystemPath) async {
    GroupModel movedGroupModel = listItem.copyWith(filesystemPath: newFilesystemPath);
    await save(movedGroupModel);
    await _secretsService.move(listItem.filesystemPath, movedGroupModel.filesystemPath);
  }

  @override
  Future<void> moveAllByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<GroupModel> groupModelsToMove = await getAllByParentPath(previousFilesystemPath, firstLevelBool: false, previewEmptyBool: true);
    for (int i = 0; i < groupModelsToMove.length; i++) {
      GroupModel groupModel = groupModelsToMove[i];
      GroupModel updatedGroupModel = groupModel.copyWith(
        filesystemPath: groupModel.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath),
      );

      groupModelsToMove[i] = updatedGroupModel;
      await _secretsService.move(groupModel.filesystemPath, updatedGroupModel.filesystemPath);
    }

    await saveAll(groupModelsToMove);
  }

  @override
  Future<int> save(GroupModel listItem) async {
    return _groupsRepository.save(GroupEntity.fromGroupModel(listItem));
  }

  @override
  Future<List<int>> saveAll(List<GroupModel> listItems) async {
    return _groupsRepository.saveAll(listItems.map(GroupEntity.fromGroupModel).toList());
  }

  @override
  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<GroupModel> groupModels = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);

    // Sort groups by the length of their paths, ensuring the deepest group is deleted first
    groupModels.sort((GroupModel a, GroupModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (GroupModel groupModel in groupModels) {
      await _secretsService.delete(groupModel.filesystemPath);
      await _groupsRepository.deleteById(groupModel.id);
    }
  }

  @override
  Future<void> deleteById(int id) async {
    GroupModel? groupModel = await getById(id);

    await _secretsService.delete(groupModel.filesystemPath);
    await _groupsRepository.deleteById(groupModel.id);
  }

  Future<GroupModel?> getByPath(FilesystemPath filesystemPath) async {
    try {
      GroupEntity groupEntity = await _groupsRepository.getByPath(filesystemPath);
      return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
    } catch (_) {
      return null;
    }
  }

  Future<GroupModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    GroupEntity groupEntity = await _groupsRepository.getById(id);
    groupEntity = groupEntity.copyWith(filesystemPathString: parentFilesystemPath.add('group$id').fullPath);
    await _groupsRepository.save(groupEntity);
    return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
  }
}
