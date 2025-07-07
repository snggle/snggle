import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_group_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_item.dart';
import 'package:snggle/views/widgets/button/list_item_creation_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_notifier.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_wrapper.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/list_page_scaffold.dart';
import 'package:snggle/views/widgets/list/sliver_page_list.dart';

@RoutePage<List<WalletModel>>()
class WalletSelectItemListPage extends StatefulWidget {
  final String name;
  final VaultModel vaultModel;
  final FilesystemPath filesystemPath;
  final NetworkGroupModel networkGroupModel;

  const WalletSelectItemListPage({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    required this.networkGroupModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletSelectItemListPageState();
}

class _WalletSelectItemListPageState extends State<WalletSelectItemListPage> {
  final NetworkGroupsService _networkGroupsService = globalLocator<NetworkGroupsService>();
  final DraggedItemNotifier draggedItemNotifier = DraggedItemNotifier();
  late final WalletListPageCubit walletListPageCubit;
  final Set<WalletModel> _selectedWallets = <WalletModel>{};

  @override
  void initState() {
    walletListPageCubit = WalletListPageCubit(
      depth: 0,
      filesystemPath: widget.filesystemPath,
      onGroupNavigateBack: globalLocator<PasswordController>().removeByFilesystemPath,
    );
    walletListPageCubit.refreshAll();
    super.initState();
  }

  @override
  void dispose() {
    draggedItemNotifier.dispose();
    walletListPageCubit.close();
    super.dispose();
  }

  void _toggleSelection(WalletModel wallet) {
    setState(() {
      _selectedWallets.contains(wallet) ? _selectedWallets.remove(wallet) : _selectedWallets.add(wallet);
    });
  }

  Future<void> _confirmSelection() async {
    await AutoRouter.of(context).pop<List<WalletModel>>(_selectedWallets.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedWallets.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 84),
              child: FloatingActionButton.extended(
                onPressed: _confirmSelection,
                label: Text('Export ${_selectedWallets.length} wallet(s)'),
                icon: const Icon(Icons.check),
              ),
            )
          : null,
      body: ListPageScaffold<WalletModel, WalletListPageCubit>(
        defaultPageTitle: widget.name,
        listCubit: walletListPageCubit,
        bodyBuilder: (BuildContext context, ListState listState) {
          return CustomScrollView(
            shrinkWrap: listState.isScrollDisabled,
            physics: listState.isScrollDisabled ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            slivers: <Widget>[
              if (listState.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
                      child: IconButton(
                        onPressed: _navigateToWalletCreatePage,
                        icon: const AssetIcon(AppIcons.page_add_button, size: 54),
                      ),
                    ),
                  ),
                )
              else
                SliverPageList(
                  addButtonVisibleBool: false,
                  loadingBool: listState.loadingBool,
                  items: listState.visibleItems,
                  selectedItems: listState.selectedItems,
                  loadingPlaceholder: const HorizontalListItemLayout.loading(),
                  creationButton: HorizontalListItemLayout(
                    iconWidget: ListItemCreationButton(
                      size: HorizontalListItemLayout.listItemIconSize,
                      onTap: _navigateToWalletCreatePage,
                    ),
                  ),
                  itemBuilder: (AListItemModel listItemModel) {
                    return HorizontalListItemAnimationWrapper(
                      key: Key('item${listItemModel.filesystemPath.fullPath}'),
                      childBuilder: (AnimationController fadeAnimationController, AnimationController slideAnimationController) {
                        return switch (listItemModel) {
                          WalletModel walletModel => GestureDetector(
                              onTap: () => _toggleSelection(walletModel),
                              child: WalletListItem(
                                walletModel: walletModel,
                                fadeAnimationController: fadeAnimationController,
                                slideAnimationController: slideAnimationController,
                                isSelected: _selectedWallets.contains(walletModel),
                              ),
                            ),
                          GroupModel groupModel => GestureDetector(
                              onTap: () => _openGroup(groupModel),
                              onLongPress: () => _toggleGroupSelect(listItemModel),
                              child: WalletGroupListItem(
                                groupModel: groupModel,
                                fadeAnimationController: fadeAnimationController,
                                slideAnimationController: slideAnimationController,
                              ),
                            ),
                          _ => const SizedBox(),
                        };
                      },
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Future<void> _navigateToWalletCreatePage() async {
    await AutoRouter.of(context).push<void>(WalletCreateRoute(
      vaultModel: widget.vaultModel,
      networkGroupModel: widget.networkGroupModel,
      parentFilesystemPath: walletListPageCubit.state.filesystemPath,
    ));
    await walletListPageCubit.refreshAll();
  }

  Future<void> _toggleGroupSelect(GroupModel group) async {
    List<WalletModel> allWallets = await globalLocator<WalletsService>().getAllByParentPath(group.filesystemPath, firstLevelBool: false);

    setState(() {
      bool anySelected = allWallets.any(_selectedWallets.contains);
      if (anySelected) {
        _selectedWallets.removeAll(allWallets);
      } else {
        _selectedWallets.addAll(allWallets);
      }
    });
  }

  Future<void> _openGroup(GroupModel group) async {
    await walletListPageCubit.navigateNext(filesystemPath: group.filesystemPath);
    setState(() {});
  }
}
