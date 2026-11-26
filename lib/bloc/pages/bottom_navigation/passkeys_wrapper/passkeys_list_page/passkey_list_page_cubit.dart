import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/passkeys_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasskeyListPageCubit extends AListCubit<PasskeyModel> {
  PasskeyListPageCubit({
    required super.depth,
    required super.filesystemPath,
    required ValueChanged<FilesystemPath> onGroupNavigateBack,
  }) : super(
    listItemsService: globalLocator<PasskeysService>(),
    childItemsServices: <IListItemsService<AListItemModel>>[
      globalLocator<GroupsService>(),
      globalLocator<PasskeysService>(),
    ],
    onGroupNavigateBack: onGroupNavigateBack,
  );

  @override
  bool canBeRenamedBool(AListItemModel item) => item is GroupModel;
}