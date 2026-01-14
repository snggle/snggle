import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_list_page/entry_list_page_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/entries/entries_create_recover_status.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_group_list_item.dart';
import 'package:snggle/views/widgets/button/list_item_creation_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_wrapper.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/list_item_actions_wrapper.dart';
import 'package:snggle/views/widgets/list/list_page_scaffold.dart';
import 'package:snggle/views/widgets/list/sliver_page_list.dart';

@RoutePage()
class EntryListPage extends StatefulWidget {
  const EntryListPage({super.key});

  @override
  State<StatefulWidget> createState() => _EntryListPageState();
}

class _EntryListPageState extends State<EntryListPage> {
  static const String defaultPageTitle = 'SECRETS';
  final DraggedItemNotifier draggedItemNotifier = DraggedItemNotifier();

  late final EntryListPageCubit entryListPageCubit = EntryListPageCubit(
    depth: 0,
    filesystemPath: FilesystemPath.fromString('secrets'),
    onGroupNavigateBack: globalLocator<PasswordController>().removeByFilesystemPath,
  );

  @override
  void initState() {
    entryListPageCubit.refreshAll();
    super.initState();
  }

  @override
  void dispose() {
    entryListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold<EntryModel, EntryListPageCubit>(
      defaultPageTitle: defaultPageTitle,
      listCubit: entryListPageCubit,
      /*padding: const EdgeInsets.symmetric(horizontal: 16),
      boxDecoration: BoxDecoration(
        border: Border.symmetric(vertical: BorderSide(color: AppColors.lightGrey2)),
      ),*/
      bodyBuilder: (BuildContext context, ListState listState) {
        return CustomScrollView(
          shrinkWrap: listState.isScrollDisabled,
          physics: listState.isScrollDisabled ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
          slivers: <Widget>[
            if (listState.isEmpty) ...<Widget>[
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
                    child: IconButton(
                      onPressed: _navigateToEntryCreateRoute,
                      icon: const AssetIcon(AppIcons.page_add_button, size: 54),
                    ),
                  ),
                ),
              ),
            ] else ...<Widget>[
              SliverPageList(
                addButtonVisibleBool: listState.isSelectionEnabled == false,
                loadingBool: listState.loadingBool,
                items: listState.visibleItems,
                selectedItems: listState.selectedItems,
                loadingPlaceholder: const HorizontalListItemLayout.loading(),
                creationButton: HorizontalListItemLayout(
                  iconWidget: ListItemCreationButton(
                    size: HorizontalListItemLayout.listItemIconSize,
                    onTap: _navigateToEntryCreateRoute,
                  ),
                ),
                itemBuilder: (AListItemModel listItemModel) {
                  return HorizontalListItemAnimationWrapper(
                    key: Key('item${listItemModel.filesystemPath.fullPath}'),
                    childBuilder: (AnimationController fadeAnimationController, AnimationController slideAnimationController) {
                      return ListItemActionsWrapper<EntryModel, EntryListPageCubit>(
                        defaultPageTitle: defaultPageTitle,
                        draggedItemNotifier: draggedItemNotifier,
                        listItemSize: HorizontalListItemLayout.listItemSize,
                        listCubit: entryListPageCubit,
                        listItemModel: listItemModel,
                        onNavigate: _navigateToNextPage,
                        selectionPadding: const EdgeInsets.all(5),
                        child: switch (listItemModel) {
                          EntryModel entryModel => EntryListItem(
                              entryModel: entryModel,
                              fadeAnimationController: fadeAnimationController,
                              slideAnimationController: slideAnimationController,
                            ),
                          GroupModel groupModel => WalletGroupListItem(
                              groupModel: groupModel,
                              fadeAnimationController: fadeAnimationController,
                              slideAnimationController: slideAnimationController,
                            ),
                          (_) => const SizedBox(),
                        },
                      );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ],
        );
      },
    );
  }

  Future<void> _navigateToEntryCreateRoute() async {
    EntryCreateRecoverStatus? entryCreateRecoverStatus = await AutoRouter.of(context).push<EntryCreateRecoverStatus?>(
      EntryCreateRecoverRoute(children: <PageRouteInfo>[
        EntryInitRoute(parentFilesystemPath: entryListPageCubit.state.filesystemPath),
      ]),
    );
    if (entryCreateRecoverStatus != null) {
      unawaited(entryListPageCubit.refreshAll());
      await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) => CustomDialog(
          title: 'Success',
          content: Text(
            switch (entryCreateRecoverStatus) {
              EntryCreateRecoverStatus.creationSuccessful => 'The entry creation process has been completed',
              EntryCreateRecoverStatus.recoverySuccessful => 'The entry recovery process has been completed',
            },
            textAlign: TextAlign.center,
          ),
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Done',
              onPressed: () {},
            ),
          ],
        ),
      );
    }
  }

  Future<void> _navigateToNextPage(AListItemModel listItemModel, PasswordModel passwordModel) async {
    globalLocator<PasswordController>().addPassword(passwordModel, listItemModel.filesystemPath);

    if (listItemModel is EntryModel) {
      //EntryDetailsPageCubit entryDetailsPageCubit = EntryDetailsPageCubit(entryModel: listItemModel);

      await AutoRouter.of(context).push<void>(EntryDetailsRoute(
        entryModel: listItemModel,
        //entryDetailsPageCubit: entryDetailsPageCubit,
      ));
      await entryListPageCubit.refreshAll();
    } else if (listItemModel is GroupModel) {
      await entryListPageCubit.navigateNext(
        filesystemPath: listItemModel.filesystemPath,
      );
    }
  }
}
