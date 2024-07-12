import 'dart:async';

import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultListPageCubit extends AListCubit<VaultModel> {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();

  VaultListPageCubit({
    required super.depth,
    required super.filesystemPath,
  });

  @override
  Future<void> moveItem(AListItemModel item, FilesystemPath newFilesystemPath) async {
    FilesystemPath movedFilesystemPath = item.filesystemPath.replace(item.filesystemPath.parentPath, newFilesystemPath.fullPath);

    await _walletsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);
    await _networkGroupsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);
    await _vaultsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);
    await groupsService.moveByParentPath(item.filesystemPath, movedFilesystemPath);

    if (item is VaultModel) {
      await _vaultsService.move(item, movedFilesystemPath);
    } else if (item is GroupModel) {
      await groupsService.move(item, movedFilesystemPath);
    } else {
      throw UnsupportedError('Unsupported item type: ${item.runtimeType}');
    }

    await refreshAll();
  }

  @override
  Future<void> deleteItem(AListItemModel item) async {
    if (item is VaultModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _networkGroupsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteAllByParentPath(item.filesystemPath);
      await _vaultsService.deleteById(item.id);
    } else if (item is GroupModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _networkGroupsService.deleteAllByParentPath(item.filesystemPath);
      await _vaultsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteById(item.id);
    } else {
      throw UnsupportedError('Unsupported item type: ${item.runtimeType}');
    }

    await refreshAll();
  }

  @override
  Future<List<VaultModel>> fetchAllItems() async {
    List<VaultModel> vaultModelList = await _vaultsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return vaultModelList;
  }

  @override
  Future<List<GroupModel>> fetchAllGroups() async {
    List<GroupModel> groupModelList = await groupsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return groupModelList;
  }

  @override
  Future<VaultModel> fetchSingleItem(VaultModel item) async {
    VaultModel vaultModel = await _vaultsService.getById(item.id);
    return vaultModel;
  }

  @override
  Future<GroupModel> fetchSingleGroup(GroupModel group) async {
    GroupModel groupModel = await groupsService.getById(group.id);
    return groupModel;
  }

  @override
  Future<void> saveItem(VaultModel item) async {
    await _vaultsService.save(item);
  }

  @override
  Future<void> saveGroup(GroupModel group) async {
    await groupsService.save(group);
  }
}
