import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultListPageCubit extends AListCubit<VaultModel> {
  VaultListPageCubit({
    required super.depth,
    required super.filesystemPath,
    required ValueChanged<FilesystemPath> onGroupNavigateBack,
  }) : super(
          listItemsService: globalLocator<VaultsService>(),
          childItemsServices: <IListItemsService<AListItemModel>>[
            globalLocator<WalletsService>(),
            globalLocator<NetworkGroupsService>(),
            globalLocator<GroupsService>(),
          ],
          onGroupNavigateBack: onGroupNavigateBack,
        );
}
