import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity.dart';
import 'package:snggle/infra/entities/wallet_entity.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class GroupsService {
  final GroupsRepository _groupsRepository;

  GroupsService({
    GroupsRepository? groupsRepository,
  }) : _groupsRepository = groupsRepository ?? globalLocator<GroupsRepository>();

  Future<List<GroupModel>> getGroupList(String path, {bool strictBool = false}) async {
    List<GroupEntity> groupEntityList = await _groupsRepository.getAll();
    groupEntityList = groupEntityList.where((GroupEntity groupEntity) {
      return strictBool ? groupEntity.parentPath == path : groupEntity.parentPath.startsWith(path);
    }).toList();

    List<GroupModel> groupModelList = groupEntityList.map((GroupEntity e) {
      return GroupModel(
        pinnedBool: e.pinnedBool,
        id: e.id,
        parentPath: e.parentPath,
        name: e.name,
      );
    }).toList();

    return groupModelList;
  }

  Future<GroupModel?> getGroupById(String path) async {
    try {
      GroupEntity groupEntity = await _groupsRepository.getByPath(path);
      return GroupModel(
        pinnedBool: groupEntity.pinnedBool,
        id: groupEntity.id,
        parentPath: groupEntity.parentPath,
        name: groupEntity.name,
      );
    } catch(_) {
      AppLogger().log(message: 'Group "not found', logLevel: LogLevel.debug);
      return null;
    }
  }

  Future<void> saveGroup(GroupModel groupModel) async {
    await _groupsRepository.save(GroupEntity.fromGroupModel(groupModel));
  }

  Future<void> deleteGroupByPath(String path) {
    return _groupsRepository.deleteByPath(path);
  }
}
