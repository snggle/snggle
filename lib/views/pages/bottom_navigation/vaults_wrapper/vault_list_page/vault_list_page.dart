import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/list/list_state.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_template.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_tooltip.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class VaultListPage extends StatefulWidget {
  const VaultListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VaultListPageState();
}

class _VaultListPageState extends State<VaultListPage> {
  static const int loadingItemsCount = 24;

  final VaultListPageCubit vaultListPageCubit = VaultListPageCubit();

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
    return BlocBuilder<VaultListPageCubit, ListState<VaultListItemModel>>(
      bloc: vaultListPageCubit,
      builder: (BuildContext context, ListState<VaultListItemModel> listState) {
        bool addButtonVisibleBool = true;
        if (listState.searchPattern != null || listState.isSelectingEnabled) {
          addButtonVisibleBool = false;
        }
        return CustomScaffold(
          popAvailableBool: listState.isSelectingEnabled,
          customPopCallback: _cancelSelection,
          title: 'Vaults',
          popButtonVisible: listState.isSelectingEnabled,
          onSearch: vaultListPageCubit.search,
          searchBoxVisible: listState.searchPattern != null,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDisabledBool: listState.isScrollDisabled,
          boxDecoration: BoxDecoration(
            border: Border.symmetric(vertical: BorderSide(color: AppColors.lightGrey2)),
          ),
          slivers: <Widget>[
            if (listState.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: IconButton(
                    onPressed: _createNewVault,
                    icon: GradientIcon(AppIcons.add_circle, size: 54, gradient: AppColors.primaryGradient),
                  ),
                ),
              )
            else ...<Widget>[
              SliverPadding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 90,
                    mainAxisExtent: 133,
                    crossAxisSpacing: 18,
                  ),
                  itemCount: listState.loadingBool ? loadingItemsCount : (listState.visibleItems.length + (addButtonVisibleBool ? 1 : 0)),
                  itemBuilder: (BuildContext context, int index) {
                    if (listState.loadingBool) {
                      return const VaultListItemTemplate(
                        iconWidget: LoadingContainer(radius: 26),
                        titleWidget: LoadingContainer(height: 16, radius: 8),
                      );
                    }

                    bool buttonItemBool = index == listState.visibleItems.length;
                    if (buttonItemBool) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: SquareOutlinedButton(
                          icon: Icon(
                            AppIcons.add,
                            size: 54,
                            color: AppColors.middleGrey,
                          ),
                          onTap: _createNewVault,
                        ),
                      );
                    }

                    VaultListItemModel vaultListItemModel = listState.visibleItems[index];

                    return VaultListItem(
                      key: Key(vaultListItemModel.vaultModel.uuid),
                      onRefreshWallets: () => vaultListPageCubit.refreshSingle(vaultListItemModel),
                      selectedBool: listState.selectedItems.contains(vaultListItemModel),
                      selectionEnabledBool: listState.isSelectingEnabled,
                      vaultListItemModel: vaultListItemModel,
                      onPinValueChanged: (bool pinnedBool) => vaultListPageCubit.pinSelection(
                        selectedItems: <VaultListItemModel>[vaultListItemModel],
                        pinnedBool: pinnedBool,
                      ),
                      onRemove: () => _removeVault(vaultListItemModel),
                      onSelectValueChanged: (bool selectedBool) => _updateVaultSelection(
                        vaultListItemModel: vaultListItemModel,
                        selectedBool: selectedBool,
                      ),
                      onLockValueChanged: (bool lockedBool) {
                        if (lockedBool) {
                          _lockVaults(<VaultListItemModel>[vaultListItemModel]);
                        } else {
                          _unlockVault(vaultListItemModel);
                        }
                      },
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ],
        );
      },
    );
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be removed.
  Future<void> _createNewVault() async {
    try {
      await vaultListPageCubit.createNewVault();
    } catch (e) {
      AppLogger().log(message: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create a new vault')));
    }
  }

  void _removeVault(VaultListItemModel vaultListItemModel) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Remove',
        content: 'Are you sure you want to remove selected vault?',
        onConfirm: () async {
          await vaultListPageCubit.delete(vaultListItemModel);
        },
      ),
    );
  }

  void _updateVaultSelection({required VaultListItemModel vaultListItemModel, required bool selectedBool}) {
    if (vaultListPageCubit.state.isSelectingEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      vaultListPageCubit.selectSingle(vaultListItemModel);
    } else {
      vaultListPageCubit.unselectSingle(vaultListItemModel);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<VaultListPageCubit, ListState<VaultListItemModel>>(
        bloc: vaultListPageCubit,
        builder: (BuildContext context, ListState<VaultListItemModel> listState) {
          return VaultListPageTooltip(
            selectionModel: listState.selectionModel!,
            onSelectAll: vaultListPageCubit.selectAll,
            onPinValueChanged: (bool pinBool) {
              vaultListPageCubit.pinSelection(selectedItems: listState.selectedItems, pinnedBool: pinBool);
              _cancelSelection();
            },
            onLockSelected: () {
              _lockVaults(listState.selectedItems);
              _cancelSelection();
            },
          );
        },
      ),
    );
  }

  Future<void> _lockVaults(List<VaultListItemModel> selectedVaults) async {
    await vaultListPageCubit.updateEncryptionStatus(selectedItems: selectedVaults, encryptedBool: true);
  }

  Future<void> _unlockVault(VaultListItemModel vaultListItemModel) async {
    await vaultListPageCubit.updateEncryptionStatus(selectedItems: <VaultListItemModel>[vaultListItemModel], encryptedBool: false);
  }

  void _cancelSelection() {
    if (vaultListPageCubit.state.isSelectingEnabled) {
      vaultListPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}
