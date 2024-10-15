import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletListPageCubit extends AListCubit<WalletModel> {
  WalletListPageCubit({
    required super.depth,
    required super.filesystemPath,
  }) : super(
          listItemsService: globalLocator<WalletsService>(),
          childItemsServices: <IListItemsService<AListItemModel>>[],
        );
}
