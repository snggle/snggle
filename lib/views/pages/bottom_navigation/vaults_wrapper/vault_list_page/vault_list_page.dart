import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_layout.dart';
import 'package:snggle/views/widgets/button/list_item_creation_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/list_item_actions_wrapper.dart';
import 'package:snggle/views/widgets/list/list_page_scaffold.dart';
import 'package:snggle/views/widgets/list/sliver_page_grid.dart';

@RoutePage()
class VaultListPage extends StatefulWidget {
  const VaultListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VaultListPageState();
}

class _VaultListPageState extends State<VaultListPage> {
  static const String defaultPageTitle = 'VAULTS';
  final DraggedItemNotifier draggedItemNotifier = DraggedItemNotifier();
  late final VaultListPageCubit vaultListPageCubit = VaultListPageCubit(
    depth: 0,
    filesystemPath: const FilesystemPath.empty(),
  );

  @override
  void initState() {
    super.initState();
    vaultListPageCubit.refreshAll();
  }

  @override
  void dispose() {
    vaultListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold<VaultModel, VaultListPageCubit>(
      defaultPageTitle: defaultPageTitle,
      listCubit: vaultListPageCubit,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      boxDecoration: BoxDecoration(
        border: Border.symmetric(vertical: BorderSide(color: AppColors.lightGrey2)),
      ),
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
                      onPressed: _navigateToVaultCreateRecoverRoute,
                      icon: const AssetIcon(AppIcons.page_add_button, size: 54),
                    ),
                  ),
                ),
              ),
            ] else ...<Widget>[
              SliverPageGrid(
                listItemSize: VaultListItemLayout.listItemSize,
                addButtonVisibleBool: listState.isSelectionEnabled == false,
                loadingBool: listState.loadingBool,
                items: listState.visibleItems,
                selectedItems: listState.selectedItems,
                loadingPlaceholder: VaultListItemLayout.loading(),
                vaultCreationButton: VaultListItemLayout(
                  icon: ListItemCreationButton(
                    size: VaultListItemLayout.listItemIconSize,
                    onTap: _navigateToVaultCreateRecoverRoute,
                  ),
                ),
                itemBuilder: (AListItemModel listItemModel) {
                  return ListItemActionsWrapper<VaultModel, VaultListPageCubit>(
                    key: Key('item${listItemModel.filesystemPath.fullPath}'),
                    defaultPageTitle: defaultPageTitle,
                    draggedItemNotifier: draggedItemNotifier,
                    listItemSize: VaultListItemLayout.listItemSize,
                    listCubit: vaultListPageCubit,
                    listItemModel: listItemModel,
                    onNavigate: _navigateToNextPage,
                    child: VaultListItemLayout(
                      title: listItemModel.name,
                      icon: ListItemIcon(
                        listItemModel: listItemModel,
                        size: VaultListItemLayout.listItemIconSize,
                      ),
                    ),
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

  Future<void> _navigateToVaultCreateRecoverRoute() async {
    VaultCreateRecoverStatus? vaultCreateRecoverStatus = await AutoRouter.of(context).push<VaultCreateRecoverStatus?>(
      VaultCreateRecoverRoute(children: <PageRouteInfo>[
        VaultInitRoute(parentFilesystemPath: vaultListPageCubit.state.filesystemPath),
      ]),
    );
    if (vaultCreateRecoverStatus != null) {
      unawaited(vaultListPageCubit.refreshAll());
      await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) => CustomDialog(
          title: 'Success',
          content: Text(
            switch (vaultCreateRecoverStatus) {
              VaultCreateRecoverStatus.creationSuccessful => 'The vault creation process has been completed',
              VaultCreateRecoverStatus.recoverySuccessful => 'The vault recovery process has been completed',
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
    if (listItemModel is VaultModel) {
      await AutoRouter.of(context).push<void>(
        NetworkListRoute(
          name: listItemModel.name,
          vaultModel: listItemModel,
          vaultPasswordModel: passwordModel,
          filesystemPath: listItemModel.filesystemPath,
        ),
      );
      await vaultListPageCubit.refreshAll();
    } else if (listItemModel is GroupModel) {
      await vaultListPageCubit.navigateNext(
        filesystemPath: listItemModel.filesystemPath,
      );
    }
  }
}
