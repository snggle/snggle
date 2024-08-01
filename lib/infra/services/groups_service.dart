import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupsService {
  final GroupsRepository _groupsRepository = globalLocator<GroupsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<GroupModel> updateFilesystemPath(int id, FilesystemPath parentFilesystemPath) async {
    GroupEntity groupEntity = await _groupsRepository.getById(id);
    groupEntity = groupEntity.copyWith(filesystemPathString: parentFilesystemPath.add('group$id').fullPath);
    await _groupsRepository.save(groupEntity);
    return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
  }

  Future<GroupModel> getById(int id) async {
    GroupEntity groupEntity = await _groupsRepository.getById(id);
    return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
  }

  Future<GroupModel?> getByPath(FilesystemPath filesystemPath) async {
    try {
      GroupEntity groupEntity = await _groupsRepository.getByPath(filesystemPath);
      return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
    } catch (_) {
      return null;
    }
  }

  Future<List<GroupModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    GroupModelFactory groupModelFactory = globalLocator<GroupModelFactory>();

    List<GroupEntity> groupEntityList = await _groupsRepository.getAllByParentPath(parentFilesystemPath);
    groupEntityList = groupEntityList.where((GroupEntity groupEntity) {
      return groupEntity.filesystemPath.isSubPathOf(parentFilesystemPath, firstLevelBool: firstLevelBool);
    }).toList();

    List<GroupModel> groupModelList = await groupModelFactory.createFromEntities(groupEntityList, previewEmptyBool: previewEmptyBool);
    return groupModelList;
  }

  Future<void> move(GroupModel groupModel, FilesystemPath newFilesystemPath) async {
    GroupModel movedGroupModel = groupModel.copyWith(filesystemPath: newFilesystemPath);
    await save(movedGroupModel);
    await _secretsService.move(groupModel.filesystemPath, movedGroupModel.filesystemPath);
  }

  Future<void> moveByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
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

  Future<int> save(GroupModel groupModel) async {
    return _groupsRepository.save(GroupEntity.fromGroupModel(groupModel));
  }

  Future<List<int>> saveAll(List<GroupModel> groupModelList) async {
    return _groupsRepository.saveAll(groupModelList.map(GroupEntity.fromGroupModel).toList());
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<GroupModel> groupModels = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    groupModels.sort((GroupModel a, GroupModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (GroupModel groupModel in groupModels) {
      await _secretsService.delete(groupModel.filesystemPath);
      await _groupsRepository.deleteById(groupModel.id);
    }
  }

  Future<void> deleteById(int id) async {
    GroupModel? groupModel = await getById(id);

    await _secretsService.delete(groupModel.filesystemPath);
    await _groupsRepository.deleteById(groupModel.id);
  }
}
