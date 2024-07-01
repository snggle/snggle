import 'dart:async';

import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultListPageCubit extends AListCubit<VaultModel> {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();

  VaultListPageCubit({
    required super.depth,
    required super.filesystemPath,
  });

  @override
  Future<void> moveItem(AListItemModel item, FilesystemPath newFilesystemPath) async {
    late FilesystemPath newChildrenParentPath;
    if (item is VaultModel) {
      VaultModel movedVaultModel = await _vaultsService.move(item, newFilesystemPath);
      newChildrenParentPath = movedVaultModel.filesystemPath;
    } else if (item is GroupModel) {
      GroupModel movedGroupModel = await groupsService.move(item, newFilesystemPath);
      newChildrenParentPath = movedGroupModel.filesystemPath;
    } else {
      throw StateError('List item not supported');
    }

    await _walletsService.moveByParentPath(item.filesystemPath, newChildrenParentPath);
    await _vaultsService.moveByParentPath(item.filesystemPath, newChildrenParentPath);
    await groupsService.moveByParentPath(item.filesystemPath, newChildrenParentPath);
    await refreshAll();
  }

  @override
  Future<void> deleteItem(AListItemModel item) async {
    if (item is VaultModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _vaultsService.deleteById(item.uuid);
    } else if (item is GroupModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _vaultsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteAllByParentPath(item.filesystemPath);
      await groupsService.deleteById(item.uuid);
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
  Future<VaultModel?> fetchSingleItem(VaultModel item) async {
    VaultModel vaultModel = await _vaultsService.getById(item.uuid);
    return vaultModel;
  }

  @override
  Future<GroupModel?> fetchSingleGroup(GroupModel group) async {
    GroupModel? groupModel = await groupsService.getById(group.uuid);
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
