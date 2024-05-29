import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class GroupsService {
  final GroupsRepository _groupsRepository = globalLocator<GroupsRepository>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<GroupModel?> getById(String id) async {
    try {
      GroupEntity groupEntity = await _groupsRepository.getById(id);
      return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
    } catch (_) {
      AppLogger().log(message: 'Group not found', logLevel: LogLevel.debug);
      return null;
    }
  }

  Future<GroupModel?> getByPath(FilesystemPath filesystemPath) async {
    try {
      List<GroupEntity> groupEntityList = await _groupsRepository.getAll();
      GroupEntity groupEntity = groupEntityList.firstWhere(
        (GroupEntity groupEntity) => FilesystemPath.fromString('${filesystemPath.parentPath}/${groupEntity.uuid}').fullPath == filesystemPath.fullPath,
      );
      return globalLocator<GroupModelFactory>().createFromEntity(groupEntity);
    } catch (_) {
      return null;
    }
  }

  Future<List<GroupModel>> getAllByParentPath(FilesystemPath parentFilesystemPath, {bool firstLevelBool = false, bool previewEmptyBool = false}) async {
    List<GroupEntity> groupEntityList = await _groupsRepository.getAll();
    groupEntityList = groupEntityList.where((GroupEntity groupEntity) {
      return groupEntity.filesystemPath.isSubPathOf(parentFilesystemPath, singleLevelBool: firstLevelBool);
    }).toList();

    List<GroupModel> groupModelList = <GroupModel>[];
    for (GroupEntity groupEntity in groupEntityList) {
      groupModelList.add(await globalLocator<GroupModelFactory>().createFromEntity(groupEntity, previewEmptyBool: previewEmptyBool));
    }

    return groupModelList;
  }

  Future<GroupModel> move(GroupModel groupModel, FilesystemPath newParentFilesystemPath) async {
    FilesystemPath previousFilesystemPath = groupModel.filesystemPath;
    FilesystemPath updatedFilesystemPath = groupModel.filesystemPath.replace(previousFilesystemPath.parentPath, newParentFilesystemPath.fullPath);

    GroupModel movedGroupModel = groupModel.copyWith(filesystemPath: updatedFilesystemPath);
    await save(movedGroupModel);
    await _secretsService.move(previousFilesystemPath, movedGroupModel.filesystemPath);
    return movedGroupModel;
  }

  Future<void> moveByParentPath(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    List<GroupModel> groupModelsToMove = await getAllByParentPath(previousFilesystemPath, firstLevelBool: false);
    for (GroupModel groupModel in groupModelsToMove) {
      FilesystemPath updatedFilesystemPath = groupModel.filesystemPath.replace(previousFilesystemPath.fullPath, newFilesystemPath.fullPath);
      GroupModel updatedGroupModel = groupModel.copyWith(filesystemPath: updatedFilesystemPath);

      await save(updatedGroupModel);
      await _secretsService.move(groupModel.filesystemPath, updatedFilesystemPath);
    }
  }

  Future<void> save(GroupModel groupModel) async {
    if (groupModel is NetworkGroupModel) {
      await _groupsRepository.save(NetworkGroupEntity.fromGroupModel(groupModel));
    } else {
      await _groupsRepository.save(GroupEntity.fromGroupModel(groupModel));
    }
  }

  Future<void> deleteAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<GroupModel> groupModels = await getAllByParentPath(parentFilesystemPath, firstLevelBool: false);
    groupModels.sort((GroupModel a, GroupModel b) => b.filesystemPath.fullPath.length.compareTo(a.filesystemPath.fullPath.length));

    for (GroupModel groupModel in groupModels) {
      await _secretsService.delete(groupModel.filesystemPath);
      await _groupsRepository.deleteById(groupModel.uuid);
    }
  }

  Future<void> deleteById(String uuid) async {
    GroupModel? groupModel = await getById(uuid);
    if (groupModel == null) {
      throw ChildKeyNotFoundException();
    }

    await _secretsService.delete(groupModel.filesystemPath);
    await _groupsRepository.deleteById(groupModel.uuid);
  }
}
