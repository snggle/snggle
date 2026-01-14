import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntryListPageCubit extends AListCubit<EntryModel> {
  EntryListPageCubit({
    required super.depth,
    required super.filesystemPath,
    required ValueChanged<FilesystemPath> onGroupNavigateBack,
  }) : super(
          listItemsService: globalLocator<EntriesService>(),
          childItemsServices: <IListItemsService<AListItemModel>>[
            globalLocator<GroupsService>(),
            globalLocator<EntriesService>(),
          ],
          onGroupNavigateBack: onGroupNavigateBack,
        );

  @override
  bool get canBeRenamedBool => false;
}
