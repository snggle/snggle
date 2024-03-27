import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/list/list_state.dart';
import 'package:snggle/bloc/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/a_list_item.dart';
import 'package:snggle/shared/models/groups/wallet_group_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_tooltip.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallets_group_list_item.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class WalletListPage extends StatefulWidget {
  final String pageName;
  final VaultModel vaultModel;
  final NetworkConfigModel networkConfigModel;
  final AContainerModel parentContainerModel;
  final PasswordModel vaultPasswordModel;

  const WalletListPage({
    required this.pageName,
    required this.vaultModel,
    required this.networkConfigModel,
    required this.parentContainerModel,
    required this.vaultPasswordModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletListPageState();
}

class _WalletListPageState extends State<WalletListPage> {
  static const int loadingItemsCount = 24;

  late final WalletListPageCubit walletListPageCubit = WalletListPageCubit(
    networkConfigModel: widget.networkConfigModel,
    vaultModel: widget.vaultModel,
    containerPathModel: widget.parentContainerModel.containerPathModel,
    vaultPasswordModel: widget.vaultPasswordModel,
  );

  @override
  void initState() {
    walletListPageCubit.refreshAll();
    super.initState();
  }

  @override
  void dispose() {
    walletListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletListPageCubit, ListState<AListItem>>(
      bloc: walletListPageCubit,
      builder: (BuildContext context, ListState<AListItem> listState) {
        bool addButtonVisibleBool = true;
        if (listState.searchPattern != null || listState.isSelectingEnabled) {
          addButtonVisibleBool = false;
        }

        return CustomScaffold(
          popAvailableBool: listState.isSelectingEnabled,
          customPopCallback: listState.isSelectingEnabled ? _cancelSelection : null,
          title: widget.pageName,
          onSearch: walletListPageCubit.search,
          searchBoxVisible: listState.searchPattern != null,
          expandedSearchbar: true,
          scrollDisabledBool: listState.isScrollDisabled,
          popButtonVisible: true,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.builder(
                itemCount: listState.loadingBool ? loadingItemsCount : (listState.visibleItems.length + (addButtonVisibleBool ? 1 : 0)),
                itemBuilder: (BuildContext context, int index) {
                  if (listState.loadingBool) {
                    return const HorizontalListItem(
                      iconWidget: LoadingContainer(radius: 26),
                      titleWidget: LoadingContainer(height: 16, width: 64, radius: 8),
                      subtitleWidget: LoadingContainer(height: 16, width: 128, radius: 8),
                      trailingWidget: LoadingContainer(height: 16, width: 64, radius: 8),
                    );
                  }

                  bool buttonItemBool = index == listState.visibleItems.length;
                  if (buttonItemBool) {
                    return HorizontalListItem(
                      iconWidget: SquareOutlinedButton(
                        icon: Icon(AppIcons.add, size: 35, color: AppColors.middleGrey),
                        onTap: walletListPageCubit.createNewWallet,
                        radius: 17,
                      ),
                    );
                  }

                  AListItem listItem = listState.visibleItems[index];
                  if (listItem is WalletListItemModel) {
                    return WalletListItem(
                      key: Key(listItem.walletModel.uuid),
                      walletListItemModel: listItem,
                      selectedBool: listState.selectedItems.contains(listItem),
                      selectionEnabledBool: listState.isSelectingEnabled,
                      onPinValueChanged: (bool pinnedBool) => walletListPageCubit.pinSelection(
                        selectedItems: <WalletListItemModel>[listItem],
                        pinnedBool: pinnedBool,
                      ),
                      onRemove: () => _removeWallet(listItem),
                      onSelectValueChanged: (bool selectedBool) => _updateWalletSelection(
                        listItem: listItem,
                        selectedBool: selectedBool,
                      ),
                      onLockValueChanged: (bool lockedBool) {
                        if (lockedBool) {
                          _lock(<WalletListItemModel>[listItem]);
                        } else {
                          _unlock(listItem);
                        }
                      },
                    );
                  } else if (listItem is WalletGroupListItemModel) {
                    return WalletsGroupListItem(
                      key: Key(listItem.walletGroupModel.id),
                      walletGroupListItemModel: listItem,
                      vaultModel: widget.vaultModel,
                      networkConfigModel: widget.networkConfigModel,
                      selectedBool: listState.selectedItems.contains(listItem),
                      selectionEnabledBool: listState.isSelectingEnabled,
                      onPinValueChanged: (bool pinnedBool) => walletListPageCubit.pinSelection(
                        selectedItems: <WalletGroupListItemModel>[listItem],
                        pinnedBool: pinnedBool,
                      ),
                      onRemove: () => _removeWallet(listItem),
                      onSelectValueChanged: (bool selectedBool) => _updateWalletSelection(
                        listItem: listItem,
                        selectedBool: selectedBool,
                      ),
                      onLockValueChanged: (bool lockedBool) {
                        if (lockedBool) {
                          _lock(<WalletGroupListItemModel>[listItem]);
                        } else {
                          _unlock(listItem);
                        }
                      },
                    );
                  } else {
                    throw StateError('List item not supported');
                  }
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  void _removeWallet(AListItem listItem) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Remove',
        content: 'Are you sure you want to remove selected wallet?',
        onConfirm: () async {
          await walletListPageCubit.delete(listItem);
        },
      ),
    );
  }

  void _updateWalletSelection({required AListItem listItem, required bool selectedBool}) {
    if (walletListPageCubit.state.isSelectingEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      walletListPageCubit.selectSingle(listItem);
    } else {
      walletListPageCubit.unselectSingle(listItem);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<WalletListPageCubit, ListState<AListItem>>(
        bloc: walletListPageCubit,
        builder: (BuildContext context, ListState<AListItem> listState) {
          return WalletListPageTooltip(
            selectionModel: listState.selectionModel!,
            onSelectAll: walletListPageCubit.selectAll,
            onPinValueChanged: (bool pinBool) {
              walletListPageCubit.pinSelection(selectedItems: listState.selectedItems, pinnedBool: pinBool);
              _cancelSelection();
            },
            onLockSelected: () {
              _lock(listState.selectedItems);
              _cancelSelection();
            },
            onGroupSelected: () {
              walletListPageCubit.groupSelection(selectedItems: listState.selectedItems);
              _cancelSelection();
            },
          );
        },
      ),
    );
  }

  Future<void> _lock(List<AListItem> selectedWallets) async {
    await walletListPageCubit.updateEncryptionStatus(selectedItems: selectedWallets, encryptedBool: true);
  }

  Future<void> _unlock(AListItem walletListItemModel) async {
    await walletListPageCubit.updateEncryptionStatus(selectedItems: <AListItem>[walletListItemModel], encryptedBool: false);
  }

  void _cancelSelection() {
    if (walletListPageCubit.state.isSelectingEnabled) {
      walletListPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
