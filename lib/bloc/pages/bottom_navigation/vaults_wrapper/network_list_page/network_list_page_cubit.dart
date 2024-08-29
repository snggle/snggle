import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';

class NetworkListPageCubit extends AListCubit<NetworkGroupModel> {
  NetworkListPageCubit({
    required super.depth,
    required super.filesystemPath,
  }) : super(
          listItemsService: globalLocator<NetworkGroupsService>(),
          childItemsServices: <IListItemsService<AListItemModel>>[
            globalLocator<WalletsService>(),
            globalLocator<GroupsService>(),
          ],
        );
}
