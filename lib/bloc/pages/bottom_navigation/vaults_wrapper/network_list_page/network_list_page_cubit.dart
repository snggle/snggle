import 'dart:async';

import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

class NetworkListPageCubit extends AListCubit<NetworkGroupModel> {
  final WalletsService _walletsService = globalLocator<WalletsService>();

  NetworkListPageCubit({
    required super.depth,
    required super.filesystemPath,
  });

  @override
  Future<void> moveItem(AListItemModel item, FilesystemPath newFilesystemPath) async {
    GroupModel movedGroupModel = await groupsService.move(item as GroupModel, newFilesystemPath);

    await _walletsService.moveByParentPath(item.filesystemPath, movedGroupModel.filesystemPath);
    await groupsService.moveByParentPath(item.filesystemPath, movedGroupModel.filesystemPath);

    await refreshAll();
  }

  @override
  Future<void> deleteItem(AListItemModel item) async {
    await _walletsService.deleteAllByParentPath(item.filesystemPath);
    await groupsService.deleteAllByParentPath(item.filesystemPath);
    await groupsService.deleteById(item.uuid);

    await refreshAll();
  }

  @override
  Future<List<NetworkGroupModel>> fetchAllItems() async {
    List<GroupModel> networkGroupModelList = await groupsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return networkGroupModelList.whereType<NetworkGroupModel>().toList();
  }

  @override
  Future<List<GroupModel>> fetchAllGroups() async {
    List<GroupModel> networkGroupModelList = await groupsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return networkGroupModelList.where((GroupModel e) => (e is NetworkGroupModel) == false).toList();
  }

  @override
  Future<NetworkGroupModel?> fetchSingleItem(NetworkGroupModel item) async {
    GroupModel? groupModel = await fetchSingleGroup(item);
    return groupModel as NetworkGroupModel?;
  }

  @override
  Future<GroupModel?> fetchSingleGroup(GroupModel group) async {
    GroupModel? groupModel = await groupsService.getById(group.uuid);
    return groupModel;
  }

  @override
  Future<void> saveItem(NetworkGroupModel item) async {
    await saveGroup(item);
  }

  @override
  Future<void> saveGroup(GroupModel group) async {
    await groupsService.save(group);
  }

  // TODO(dominik): Temporary solution to create new network group. After implementing "network-groups-templates" this method should be removed.
  Future<void> createNewNetworkGroup(NetworkConfigModel networkConfigModel) async {
    String uuid = const Uuid().v4();

    NetworkGroupModel networkGroupModel = NetworkGroupModel(
      pinnedBool: false,
      encryptedBool: false,
      uuid: uuid,
      listItemsPreview: <AListItemModel>[],
      filesystemPath: FilesystemPath(<String>[...state.filesystemPath.pathSegments, uuid]),
      networkConfigModel: networkConfigModel,
    );
    GroupSecretsModel groupSecretsModel = GroupSecretsModel.generate(networkGroupModel.filesystemPath);

    await groupsService.save(networkGroupModel);
    await secretsService.save(groupSecretsModel, PasswordModel.defaultPassword());

    await refreshAll();
  }
}
