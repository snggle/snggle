import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/list/list_state.dart';
import 'package:snggle/bloc/network_groups_page/network_groups_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_page/network_group_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_page/network_groups_page_tooltip.dart';
import 'package:snggle/views/widgets/button/square_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class NetworkGroupsPage extends StatefulWidget {
  final VaultListItemModel vaultListItemModel;
  final PasswordModel vaultPasswordModel;

  const NetworkGroupsPage({
    required this.vaultListItemModel,
    required this.vaultPasswordModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupsPageState();
}

class _NetworkGroupsPageState extends State<NetworkGroupsPage> {
  static const int loadingItemsCount = 24;

  late final NetworkGroupsPageCubit networkGroupsPageCubit = NetworkGroupsPageCubit(
    vaultModel: widget.vaultListItemModel.vaultModel,
    vaultPasswordModel: widget.vaultPasswordModel,
  );

  @override
  void initState() {
    networkGroupsPageCubit.refreshAll();
    super.initState();
  }

  @override
  void dispose() {
    networkGroupsPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkGroupsPageCubit, ListState<NetworkGroupListItemModel>>(
      bloc: networkGroupsPageCubit,
      builder: (BuildContext context, ListState<NetworkGroupListItemModel> listState) {
        bool addButtonVisibleBool = true;
        if (listState.searchPattern != null || listState.isSelectingEnabled) {
          addButtonVisibleBool = false;
        }

        return CustomScaffold(
          popAvailableBool: listState.isSelectingEnabled,
          customPopCallback: listState.isSelectingEnabled ? _cancelSelection : null,
          title: widget.vaultListItemModel.name,
          onSearch: networkGroupsPageCubit.search,
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
                        radius: 17,
                        icon: Icon(AppIcons.add, size: 35, color: AppColors.middleGrey),
                        onTap: () {
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
                                        onPressed: () => networkGroupsPageCubit.createNewWallet('kira'),
                                        child: const Text('KIRA'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => networkGroupsPageCubit.createNewWallet('ethereum'),
                                        child: const Text('Ethereum'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => networkGroupsPageCubit.createNewWallet('polkadot'),
                                        child: const Text('Polkadot'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => networkGroupsPageCubit.createNewWallet('bitcoin'),
                                        child: const Text('Bitcoin'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => networkGroupsPageCubit.createNewWallet('cosmos'),
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
                    selectionEnabledBool: listState.isSelectingEnabled,
                    onRemove: () => _removeGroup(networkGroupListItemModel),
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
                      networkGroupsPageCubit.pinSelection(selectedItems: <NetworkGroupListItemModel>[networkGroupListItemModel], pinnedBool: pinnedBool);
                      _cancelSelection();
                    },
                    vaultListItemModel: widget.vaultListItemModel,
                    networkGroupListItemModel: networkGroupListItemModel,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeGroup(NetworkGroupListItemModel networkGroupListItemModel) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Remove',
        content: 'Are you sure you want to remove selected network?',
        onConfirm: () async {
          await networkGroupsPageCubit.delete(networkGroupListItemModel);
        },
      ),
    );
  }

  void _updateGroupSelection({required NetworkGroupListItemModel networkGroupListItemModel, required bool selectedBool}) {
    if (networkGroupsPageCubit.state.isSelectingEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      networkGroupsPageCubit.selectSingle(networkGroupListItemModel);
    } else {
      networkGroupsPageCubit.unselectSingle(networkGroupListItemModel);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<NetworkGroupsPageCubit, ListState<NetworkGroupListItemModel>>(
        bloc: networkGroupsPageCubit,
        builder: (BuildContext context, ListState<NetworkGroupListItemModel> listState) {
          return NetworkGroupsPageTooltip(
            selectionModel: listState.selectionModel!,
            onSelectAll: networkGroupsPageCubit.selectAll,
            onPinValueChanged: (bool pinnedBool) {
              networkGroupsPageCubit.pinSelection(selectedItems: networkGroupsPageCubit.state.selectedItems, pinnedBool: pinnedBool);
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
    if (networkGroupsPageCubit.state.isSelectingEnabled) {
      networkGroupsPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }

  Future<void> _lockGroups(List<NetworkGroupListItemModel> selectedGroups) async {
    await networkGroupsPageCubit.updateEncryptionStatus(selectedItems: selectedGroups, encryptedBool: true);
  }

  Future<void> _unlockGroup(NetworkGroupListItemModel networkGroupListItemModel) async {
    await networkGroupsPageCubit.updateEncryptionStatus(selectedItems: <NetworkGroupListItemModel>[networkGroupListItemModel], encryptedBool: false);
  }
}
