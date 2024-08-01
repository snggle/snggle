import 'dart:async';

import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkListPageCubit extends AListCubit<NetworkGroupModel> {
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();

  NetworkListPageCubit({
    required super.depth,
    required super.filesystemPath,
  });

  @override
  Future<void> moveItem(AListItemModel item, FilesystemPath newFilesystemPath) async {
    FilesystemPath movedFilesystemPath = item.filesystemPath.replace(item.filesystemPath.parentPath, newFilesystemPath.fullPath);

    await _walletsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);
    await _networkGroupsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);
    await groupsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);

    if (item is NetworkGroupModel) {
      await _networkGroupsService.move(item, movedFilesystemPath);
    } else if (item is GroupModel) {
      await groupsService.move(item, movedFilesystemPath);
    } else {
      throw UnsupportedError('Unsupported item type: ${item.runtimeType}');
    }

    await refreshAll();
  }

  @override
  Future<void> deleteItem(AListItemModel item) async {
    if (item is NetworkGroupModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _networkGroupsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteAllByParentPath(item.filesystemPath);
      await _networkGroupsService.deleteById(item.id);
    } else if (item is GroupModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _networkGroupsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteById(item.id);
    } else {
      throw UnsupportedError('Unsupported item type: ${item.runtimeType}');
    }

    await refreshAll();
  }

  @override
  Future<List<NetworkGroupModel>> fetchAllItems() async {
    List<NetworkGroupModel> networkGroupModelList = await _networkGroupsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return networkGroupModelList.toList();
  }

  @override
  Future<List<GroupModel>> fetchAllGroups() async {
    List<GroupModel> networkGroupModelList = await groupsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return networkGroupModelList;
  }

  @override
  Future<NetworkGroupModel> fetchSingleItem(NetworkGroupModel item) async {
    NetworkGroupModel networkGroupModel = await _networkGroupsService.getById(item.id);
    return networkGroupModel;
  }

  @override
  Future<GroupModel> fetchSingleGroup(GroupModel group) async {
    GroupModel groupModel = await groupsService.getById(group.id);
    return groupModel;
  }

  @override
  Future<void> saveItem(NetworkGroupModel item) async {
    await _networkGroupsService.save(item);
  }

  @override
  Future<void> saveGroup(GroupModel group) async {
    await groupsService.save(group);
  }
}
