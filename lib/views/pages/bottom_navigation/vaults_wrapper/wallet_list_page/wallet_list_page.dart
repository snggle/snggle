import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/wallet_list_page/wallet_list_page_cubit.dart';
import 'package:snggle/bloc/wallet_list_page/wallet_list_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page_tooltip.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class WalletListPage extends StatefulWidget {
  final VaultListItemModel vaultListItemModel;
  final AContainerModel parentContainerModel;
  final PasswordModel vaultPasswordModel;

  const WalletListPage({
    required this.vaultListItemModel,
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
    containerModel: widget.parentContainerModel,
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
    return BlocBuilder<WalletListPageCubit, WalletListPageState>(
      bloc: walletListPageCubit,
      builder: (BuildContext context, WalletListPageState walletListPageState) {
        bool popAvailableBool = walletListPageState.isSelectingEnabled;

        return PopScope(
          canPop: popAvailableBool == false,
          onPopInvoked: (_) => _cancelSelection(),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              appBar: CustomAppBar(
                title: widget.vaultListItemModel.name,
                popButtonVisible: true,
                leadingPressedCallback: walletListPageState.isSelectingEnabled ? _cancelSelection : null,
              ),
              body: CustomScrollView(
                shrinkWrap: walletListPageState.isScrollDisabled,
                physics: walletListPageState.isScrollDisabled ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.builder(
                      itemCount: walletListPageState.loadingBool
                          ? loadingItemsCount
                          : (walletListPageState.visibleWallets.length + (walletListPageState.searchPattern == null ? 1 : 0)),
                      itemBuilder: (BuildContext context, int index) {
                        if (walletListPageState.loadingBool) {
                          return const HorizontalListItem(
                            iconWidget: LoadingContainer(radius: 26),
                            titleWidget: LoadingContainer(height: 16, width: 64, radius: 8),
                            subtitleWidget: LoadingContainer(height: 16, width: 128, radius: 8),
                            trailingWidget: LoadingContainer(height: 16, width: 64, radius: 8),
                          );
                        }

                        bool buttonItemBool = index == walletListPageState.visibleWallets.length;
                        if (buttonItemBool) {
                          return HorizontalListItem(
                            iconWidget: SquareOutlinedButton(
                              icon: Icon(AppIcons.add, size: 35, color: AppColors.middleGrey),
                              onTap: () {},
                              radius: 17,
                            ),
                          );
                        }

                        WalletListItemModel walletListItemModel = walletListPageState.visibleWallets[index];
                        return WalletListItem(
                          key: Key(walletListItemModel.walletModel.uuid),
                          walletListItemModel: walletListItemModel,
                          selectedBool: walletListPageState.selectedWallets.contains(walletListItemModel),
                          selectionEnabledBool: walletListPageState.isSelectingEnabled,
                          onPinValueChanged: (bool pinnedBool) => walletListPageCubit.updatePinnedWallets(
                            selectedWallets: <WalletListItemModel>[walletListItemModel],
                            pinnedBool: pinnedBool,
                          ),
                          onRemove: () => _removeWallet(walletListItemModel),
                          onSelectValueChanged: (bool selectedBool) => _updateWalletSelection(
                            walletListItemModel: walletListItemModel,
                            selectedBool: selectedBool,
                          ),
                          onLockValueChanged: (bool lockedBool) {
                            if (lockedBool) {
                              _lockWallets(<WalletListItemModel>[walletListItemModel]);
                            } else {
                              _unlockWallet(walletListItemModel);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeWallet(WalletListItemModel walletListItemModel) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Remove',
        content: 'Are you sure you want to remove selected wallet?',
        onConfirm: () async {
          await walletListPageCubit.deleteWallet(walletListItemModel);
        },
      ),
    );
  }

  void _updateWalletSelection({required WalletListItemModel walletListItemModel, required bool selectedBool}) {
    if (walletListPageCubit.state.isSelectingEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      walletListPageCubit.selectWallet(walletListItemModel);
    } else {
      walletListPageCubit.unselectWallet(walletListItemModel);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<WalletListPageCubit, WalletListPageState>(
        bloc: walletListPageCubit,
        builder: (BuildContext context, WalletListPageState walletListPageState) {
          return WalletListPageTooltip(
            walletSelectionModel: walletListPageState.walletSelectionModel!,
            onSelectAll: walletListPageCubit.selectAll,
            onPinValueChanged: (bool pinBool) {
              walletListPageCubit.updatePinnedWallets(selectedWallets: walletListPageState.selectedWallets, pinnedBool: pinBool);
              _cancelSelection();
            },
            onLockSelected: () {
              _lockWallets(walletListPageState.selectedWallets);
              _cancelSelection();
            },
          );
        },
      ),
    );
  }

  Future<void> _lockWallets(List<WalletListItemModel> selectedWallets) async {
    await walletListPageCubit.updateEncryptedWallets(selectedWallets: selectedWallets, encryptedBool: true);
  }

  Future<void> _unlockWallet(WalletListItemModel walletListItemModel) async {
    await walletListPageCubit.updateEncryptedWallets(
      selectedWallets: <WalletListItemModel>[walletListItemModel],
      encryptedBool: false,
    );
  }

  void _cancelSelection() {
    if (walletListPageCubit.state.isSelectingEnabled) {
      walletListPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
