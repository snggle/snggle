import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/passkeys_wrapper/passkeys_list_page/passkey_list_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_tab_dir.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/passkeys_wrapper/passkey_list_page/passkey_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_group_list_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_wrapper.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/list_item_actions_wrapper.dart';
import 'package:snggle/views/widgets/list/list_page_scaffold.dart';
import 'package:snggle/views/widgets/list/sliver_page_list.dart';

@RoutePage()
class PasskeyListPage extends StatefulWidget {
  const PasskeyListPage({super.key});

  @override
  State<PasskeyListPage> createState() => _PasskeyListPageState();
}

class _PasskeyListPageState extends State<PasskeyListPage> {
  final String _tabDirName = FilesystemStorageTabDir.passkeys.name;

  late final FilesystemPath _passkeysRootPath =
  FilesystemPath.fromString(_tabDirName);

  late final String defaultPageTitle = _tabDirName.toUpperCase();

  final DraggedItemNotifier draggedItemNotifier = DraggedItemNotifier();

  late final PasskeyListPageCubit passkeyListPageCubit =
  PasskeyListPageCubit(
    depth: 0,
    filesystemPath: _passkeysRootPath,
    onGroupNavigateBack:
    globalLocator<PasswordController>().removeByFilesystemPath,
  );

  @override
  void initState() {
    super.initState();
    passkeyListPageCubit.refreshAll();
  }

  @override
  void dispose() {
    passkeyListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold<PasskeyModel, PasskeyListPageCubit>(
      defaultPageTitle: defaultPageTitle,
      listCubit: passkeyListPageCubit,
      bodyBuilder: (BuildContext context, ListState listState) {
        return CustomScrollView(
          shrinkWrap: listState.isScrollDisabled,
          physics: listState.isScrollDisabled
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          slivers: <Widget>[
            if (listState.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: CustomBottomNavigationBar.contentHeight,
                    ),
                    child: Text('No passkeys yet'),
                  ),
                ),
              )
            else ...<Widget>[
              SliverPageList(
                loadingBool: listState.loadingBool,
                items: listState.visibleItems,
                selectedItems: listState.selectedItems,
                addButtonVisibleBool: false,
                itemBuilder: (AListItemModel listItemModel) {
                  return HorizontalListItemAnimationWrapper(
                    key: Key(
                      'item${listItemModel.filesystemPath.fullPath}',
                    ),
                    childBuilder: (
                        AnimationController fadeAnimationController,
                        AnimationController slideAnimationController,
                        ) {
                      return ListItemActionsWrapper<
                          PasskeyModel,
                          PasskeyListPageCubit>(
                        allowItemRenamingBool:
                        passkeyListPageCubit.canBeRenamedBool(
                          listItemModel,
                        ),
                        defaultPageTitle: defaultPageTitle,
                        draggedItemNotifier: draggedItemNotifier,
                        listItemSize:
                        HorizontalListItemLayout.listItemSize,
                        listCubit: passkeyListPageCubit,
                        listItemModel: listItemModel,
                        onNavigate: _navigateToNextPage,
                        selectionPadding: const EdgeInsets.all(5),
                        child: switch (listItemModel) {
                          PasskeyModel passkeyModel => PasskeyListItem(
                            passkeyModel: passkeyModel,
                            fadeAnimationController:
                            fadeAnimationController,
                            slideAnimationController:
                            slideAnimationController,
                          ),
                          GroupModel groupModel => WalletGroupListItem(
                            groupModel: groupModel,
                            fadeAnimationController:
                            fadeAnimationController,
                            slideAnimationController:
                            slideAnimationController,
                          ),
                          (_) => const SizedBox(),
                        },
                      );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _navigateToNextPage(
      AListItemModel listItemModel,
      PasswordModel passwordModel,
      ) async {
    globalLocator<PasswordController>().addPassword(
      passwordModel,
      listItemModel.filesystemPath,
    );

    if (listItemModel is PasskeyModel) {
      await AutoRouter.of(context).push(
        PasskeyDetailsRoute(
          passkeyModel: listItemModel,
        ),
      );

      await passkeyListPageCubit.refreshAll();
    } else if (listItemModel is GroupModel) {
      await passkeyListPageCubit.navigateNext(
        filesystemPath: listItemModel.filesystemPath,
      );
    }
  }
}