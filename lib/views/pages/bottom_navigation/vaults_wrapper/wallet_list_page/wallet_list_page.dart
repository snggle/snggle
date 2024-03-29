import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_tooltip.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class WalletListPage extends StatefulWidget {
  final String pageName;
  final VaultModel vaultModel;
  final AContainerModel parentContainerModel;
  final PasswordModel vaultPasswordModel;

  const WalletListPage({
    required this.pageName,
    required this.vaultModel,
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
    return BlocBuilder<WalletListPageCubit, ListState<AListItemModel>>(
      bloc: walletListPageCubit,
      builder: (BuildContext context, ListState<AListItemModel> listState) {
        bool addButtonVisibleBool = listState.isSelectionEnabled == false;

        return CustomScaffold(
          title: widget.pageName,
          popAvailableBool: listState.isSelectionEnabled == false,
          popButtonVisible: true,
          customPopCallback: listState.isSelectionEnabled ? _cancelSelection : null,
          body: CustomScrollView(
            shrinkWrap: listState.isScrollDisabled,
            physics: listState.isScrollDisabled ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
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

                    AListItemModel listItemModel = listState.visibleItems[index];
                    if (listItemModel is WalletListItemModel) {
                      return WalletListItem(
                        key: Key(listItemModel.walletModel.uuid),
                        walletListItemModel: listItemModel,
                        selectedBool: listState.selectedItems.contains(listItemModel),
                        selectionEnabledBool: listState.isSelectionEnabled,
                        onPinValueChanged: (bool pinnedBool) => walletListPageCubit.pinSelection(
                          selectedItems: <WalletListItemModel>[listItemModel],
                          pinnedBool: pinnedBool,
                        ),
                        onDelete: () => _deleteWallet(listItemModel),
                        onSelectValueChanged: (bool selectedBool) => _updateWalletSelection(
                          listItemModel: listItemModel,
                          selectedBool: selectedBool,
                        ),
                        onLockValueChanged: (bool lockedBool) {
                          if (lockedBool) {
                            _lock(<WalletListItemModel>[listItemModel]);
                          } else {
                            _unlock(listItemModel);
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
          ),
        );
      },
    );
  }

  Future<void> _deleteWallet(AListItemModel listItemModel) async {
    await walletListPageCubit.delete(listItemModel);
  }

  void _updateWalletSelection({required AListItemModel listItemModel, required bool selectedBool}) {
    if (walletListPageCubit.state.isSelectionEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      walletListPageCubit.selectSingle(listItemModel);
    } else {
      walletListPageCubit.unselectSingle(listItemModel);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<WalletListPageCubit, ListState<AListItemModel>>(
        bloc: walletListPageCubit,
        builder: (BuildContext context, ListState<AListItemModel> listState) {
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
          );
        },
      ),
    );
  }

  Future<void> _lock(List<AListItemModel> selectedWallets) async {
    await walletListPageCubit.updateEncryptionStatus(selectedItems: selectedWallets, encryptedBool: true);
  }

  Future<void> _unlock(AListItemModel listItemModel) async {
    await walletListPageCubit.updateEncryptionStatus(selectedItems: <AListItemModel>[listItemModel], encryptedBool: false);
  }

  void _cancelSelection() {
    if (walletListPageCubit.state.isSelectionEnabled) {
      walletListPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
