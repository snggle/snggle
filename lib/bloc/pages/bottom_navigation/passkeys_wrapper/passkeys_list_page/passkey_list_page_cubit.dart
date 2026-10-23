import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/passkeys_service.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasskeyListPageCubit extends AListCubit<PasskeyModel> {
  PasskeyListPageCubit()
      : super(
    depth: 0,
    filesystemPath: FilesystemPath.fromString('passkeys'),
    listItemsService: globalLocator<PasskeysService>(),
    childItemsServices: <IListItemsService<AListItemModel>>[],
    onGroupNavigateBack: (FilesystemPath filesystemPath) {},
  );

  @override
  bool canBeRenamedBool(AListItemModel item) => false;

  @override
  Future<void> refreshAll() async {
    List<PasskeyModel> passkeys =
    await globalLocator<PasskeysService>().getAllByParentPath(
      state.filesystemPath,
      firstLevelBool: true,
    );

    passkeys.sort(
          (PasskeyModel a, PasskeyModel b) => a.compareTo(b),
    );

    emit(
      state.copyWith(
        loadingBool: false,
        allItems: passkeys,
      ),
    );
  }
}