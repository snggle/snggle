import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/generic/list/list_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/network_groups_list_page/network_groups_list_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_remove_pin_page.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_setup_pin_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_list_page/network_group_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_list_page/network_groups_list_page_tooltip.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class NetworkGroupsListPage extends StatefulWidget {
  final VaultListItemModel vaultListItemModel;
  final PasswordModel vaultPasswordModel;

  const NetworkGroupsListPage({
    required this.vaultListItemModel,
    required this.vaultPasswordModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupsListPageState();
}

class _NetworkGroupsListPageState extends State<NetworkGroupsListPage> {
  static const int loadingItemsCount = 24;

  late final NetworkGroupsListPageCubit networkGroupsListPageCubit = NetworkGroupsListPageCubit(
    vaultModel: widget.vaultListItemModel.vaultModel,
    vaultPasswordModel: widget.vaultPasswordModel,
  );

  @override
  void initState() {
    networkGroupsListPageCubit.refreshAll();
    super.initState();
  }

  @override
  void dispose() {
    networkGroupsListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkGroupsListPageCubit, ListState<NetworkGroupListItemModel>>(
      bloc: networkGroupsListPageCubit,
      builder: (BuildContext context, ListState<NetworkGroupListItemModel> listState) {
        bool addButtonVisibleBool = listState.isSelectionEnabled == false;

        return CustomScaffold(
          title: widget.vaultListItemModel.name,
          popButtonVisible: true,
          popAvailableBool: listState.isSelectionEnabled == false,
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
                          radius: 17,
                          icon: Icon(AppIcons.add, size: 35, color: AppColors.middleGrey),
                          onTap: () {
                            // TODO(dominik): Temporary solution to generate wallets associated with specified network. This should be replaced with a proper page.
                            showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  child: Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Add wallet'),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () => networkGroupsListPageCubit.createNewWallet('kira'),
                                          child: const Text('KIRA'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => networkGroupsListPageCubit.createNewWallet('ethereum'),
                                          child: const Text('Ethereum'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => networkGroupsListPageCubit.createNewWallet('polkadot'),
                                          child: const Text('Polkadot'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => networkGroupsListPageCubit.createNewWallet('bitcoin'),
                                          child: const Text('Bitcoin'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => networkGroupsListPageCubit.createNewWallet('cosmos'),
                                          child: const Text('Cosmos'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }

                    NetworkGroupListItemModel networkGroupListItemModel = listState.visibleItems[index];

                    return NetworkGroupListItem(
                      key: Key(networkGroupListItemModel.networkConfigModel.name),
                      selectedBool: listState.selectedItems.contains(networkGroupListItemModel),
                      selectionEnabledBool: listState.isSelectionEnabled,
                      onRefresh: () => networkGroupsListPageCubit.refreshSingle(networkGroupListItemModel),
                      onDelete: () => _deleteGroup(networkGroupListItemModel),
                      onSelectValueChanged: (bool selectedBool) => _updateGroupSelection(
                        networkGroupListItemModel: networkGroupListItemModel,
                        selectedBool: selectedBool,
                      ),
                      onLockValueChanged: (bool lockedBool) {
                        if (lockedBool) {
                          _lockGroups(<NetworkGroupListItemModel>[networkGroupListItemModel]);
                        } else {
                          _unlockGroup(networkGroupListItemModel);
                        }
                      },
                      onPinValueChanged: (bool pinnedBool) {
                        networkGroupsListPageCubit.pinSelection(selectedItems: <NetworkGroupListItemModel>[networkGroupListItemModel], pinnedBool: pinnedBool);
                        _cancelSelection();
                      },
                      vaultListItemModel: widget.vaultListItemModel,
                      vaultPasswordModel: widget.vaultPasswordModel,
                      networkGroupListItemModel: networkGroupListItemModel,
                    );
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

  Future<void> _deleteGroup(NetworkGroupListItemModel networkGroupListItemModel) async {
    await networkGroupsListPageCubit.delete(networkGroupListItemModel);
  }

  void _updateGroupSelection({required NetworkGroupListItemModel networkGroupListItemModel, required bool selectedBool}) {
    if (networkGroupsListPageCubit.state.isSelectionEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      networkGroupsListPageCubit.selectSingle(networkGroupListItemModel);
    } else {
      networkGroupsListPageCubit.unselectSingle(networkGroupListItemModel);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<NetworkGroupsListPageCubit, ListState<NetworkGroupListItemModel>>(
        bloc: networkGroupsListPageCubit,
        builder: (BuildContext context, ListState<NetworkGroupListItemModel> listState) {
          return NetworkGroupsListPageTooltip(
            selectionModel: listState.selectionModel!,
            onSelectAll: networkGroupsListPageCubit.selectAll,
            onPinValueChanged: (bool pinnedBool) {
              networkGroupsListPageCubit.pinSelection(selectedItems: networkGroupsListPageCubit.state.selectedItems, pinnedBool: pinnedBool);
              _cancelSelection();
            },
            onLockSelected: () {
              _lockGroups(listState.selectedItems);
              _cancelSelection();
            },
          );
        },
      ),
    );
  }

  void _cancelSelection() {
    if (networkGroupsListPageCubit.state.isSelectionEnabled) {
      networkGroupsListPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }

  Future<void> _lockGroups(List<NetworkGroupListItemModel> selectedGroups) async {
    bool? successBool = await showDialog<bool?>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsSetupPinPage(containerModels: selectedGroups.map((NetworkGroupListItemModel e) => e.walletGroupModel).toList());
      },
    );

    if (successBool == true) {
      await networkGroupsListPageCubit.updateEncryptionStatus(selectedItems: selectedGroups, encryptedBool: true);
    }
  }

  Future<void> _unlockGroup(NetworkGroupListItemModel networkGroupListItemModel) async {
    bool? successBool = await showDialog<bool?>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsRemovePinPage(containerModel: networkGroupListItemModel.walletGroupModel);
      },
    );
    if (successBool == true) {
      await networkGroupsListPageCubit.updateEncryptionStatus(selectedItems: <NetworkGroupListItemModel>[networkGroupListItemModel], encryptedBool: false);
    }
  }
}
