import 'dart:async';

import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class VaultListPageCubit extends AListCubit<VaultModel> {
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();

  VaultListPageCubit({
    required super.filesystemPath,
  });

  @override
  Future<void> deleteItem(AListItemModel item) async {
    if (item is VaultModel) {
      await _walletsService.deleteAllByParentPath(item.filesystemPath);
      await _vaultsService.deleteById(item.uuid);
    }
    await refreshAll();
  }

  @override
  Future<List<VaultModel>> fetchAllItems() async {
    List<VaultModel> vaultModelList = await _vaultsService.getAllByParentPath(state.filesystemPath, firstLevelBool: true);
    return vaultModelList;
  }

  @override
  Future<VaultModel?> fetchSingleItem(VaultModel item) async {
    VaultModel vaultModel = await _vaultsService.getById(item.uuid);
    return vaultModel;
  }

  @override
  Future<void> saveItem(VaultModel item) async {
    await _vaultsService.save(item);
  }
}
