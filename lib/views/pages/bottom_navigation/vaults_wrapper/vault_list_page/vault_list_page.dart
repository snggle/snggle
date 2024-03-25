import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_cubit.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/pin_removal_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/pin_setup_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_template.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page_tooltip.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar/custom_app_bar.dart';
import 'package:snggle/views/widgets/custom/custom_dialog.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

@RoutePage()
class VaultListPage extends StatefulWidget {
  const VaultListPage({super.key});

  @override
  State<StatefulWidget> createState() => _VaultListPageState();
}

class _VaultListPageState extends State<VaultListPage> {
  final VaultListPageCubit vaultListPageCubit = VaultListPageCubit();

  @override
  void initState() {
    super.initState();
    vaultListPageCubit.refresh();
  }

  @override
  void dispose() {
    vaultListPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultListPageCubit, VaultListPageState>(
      bloc: vaultListPageCubit,
      builder: (BuildContext context, VaultListPageState vaultListPageState) {
        bool popAvailableBool = vaultListPageState.isSelectingEnabled;
        return PopScope(
          canPop: popAvailableBool == false,
          onPopInvoked: (_) => _cancelSelection(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Vaults',
                popButtonVisible: popAvailableBool,
                leadingPressedCallback: _cancelSelection,
                onSearch: vaultListPageCubit.searchVaults,
                initialSearchPattern: vaultListPageState.searchPattern,
              ),
              body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.symmetric(vertical: BorderSide(color: AppColors.lightGrey2)),
                ),
                child: CustomScrollView(
                  shrinkWrap: vaultListPageState.loadingBool,
                  physics: vaultListPageState.loadingBool ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      sliver: SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 96,
                          mainAxisExtent: 133,
                          crossAxisSpacing: 20,
                        ),
                        itemCount: vaultListPageState.loadingBool
                            ? 24
                            : (vaultListPageState.visibleVaults.length + (vaultListPageState.searchPattern == null ? 1 : 0)),
                        itemBuilder: (BuildContext context, int index) {
                          if (vaultListPageState.loadingBool) {
                            return const VaultListItemTemplate(
                              iconWidget: LoadingContainer(radius: 26),
                              titleWidget: LoadingContainer(height: 16, radius: 8),
                            );
                          }
                          bool buttonItemBool = index == vaultListPageState.visibleVaults.length;
                          if (buttonItemBool) {
                            return _GridAddButton(onTap: _createNewVault);
                          }
                          VaultListItemModel vaultListItemModel = vaultListPageState.visibleVaults[index];
                          return VaultListItem(
                            onRefresh: vaultListPageCubit.refresh,
                            selectedBool: vaultListPageState.selectedVaults.contains(vaultListItemModel),
                            selectingEnabledBool: vaultListPageState.isSelectingEnabled,
                            key: Key(vaultListItemModel.vaultModel.uuid),
                            vaultListItemModel: vaultListItemModel,
                            onPinValueChanged: (bool pinnedBool) {
                              vaultListPageCubit.changeSelectionPinStatus(
                                selectedVaults: <VaultListItemModel>[vaultListItemModel],
                                pinnedBool: pinnedBool,
                              );
                            },
                            onDelete: () => _removeVault(vaultListItemModel.vaultModel),
                            onSelectValueChanged: (bool selectedBool) {
                              _updateVaultSelection(
                                vaultListItemModel: vaultListItemModel,
                                selectedBool: selectedBool,
                              );
                            },
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _createNewVault() async {
    try {
      await vaultListPageCubit.createNewVault();
    } catch (e) {
      AppLogger().log(message: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create a new vault')));
    }
  }

  void _removeVault(VaultModel vaultModel) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Remove',
        content: 'Are you sure you want to remove selected vault?',
        onConfirm: () async {
          await vaultListPageCubit.deleteVault(vaultModel);
        },
      ),
    );
  }

  void _updateVaultSelection({required VaultListItemModel vaultListItemModel, required bool selectedBool}) {
    if (vaultListPageCubit.state.isSelectingEnabled == false) {
      _showBottomNavigationTooltip();
    }
    if (selectedBool) {
      vaultListPageCubit.selectVault(vaultListItemModel);
    } else {
      vaultListPageCubit.unselectVault(vaultListItemModel);
    }
  }

  void _showBottomNavigationTooltip() {
    BottomNavigationWrapper.of(context).showTooltip(
      BlocBuilder<VaultListPageCubit, VaultListPageState>(
        bloc: vaultListPageCubit,
        builder: (BuildContext context, VaultListPageState vaultListPageState) {
          if (vaultListPageState.vaultSelectionModel == null) {
            return const SizedBox();
          }

          return VaultListPageTooltip(
            vaultSelectionModel: vaultListPageState.vaultSelectionModel!,
            onSelectAll: vaultListPageCubit.selectAll,
            onPinValueChanged: (bool pinBool) {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) => CustomAgreementDialog(
                  title: pinBool ? 'Pin' : 'Unpin',
                  content: 'Are you sure you want to ${pinBool ? 'pin' : 'unpin'} selected vaults?',
                  onConfirm: () {
                    vaultListPageCubit.changeSelectionPinStatus(selectedVaults: vaultListPageState.selectedVaults, pinnedBool: pinBool);
                    _cancelSelection();
                  },
                ),
              );
            },
            onLockSelected: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) => CustomAgreementDialog(
                  title: 'Lock',
                  content: 'Are you sure you want to lock selected vaults?',
                  onConfirm: () {
                    _lockVaults(vaultListPageState.selectedVaults);
                    _cancelSelection();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _lockVaults(List<VaultListItemModel> selectedVaults) async {
    bool? successBool = await showDialog<bool?>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsSetupPinPage<VaultSecretsModel>(containerModels: selectedVaults.map((VaultListItemModel e) => e.vaultModel).toList());
      },
    );

    if (successBool == true) {
      await vaultListPageCubit.changeSelectionEncryptionStatus(selectedVaults: selectedVaults, encryptedBool: true);
    }
  }

  Future<void> _unlockVault(VaultListItemModel vaultListItemModel) async {
    bool? successBool = await showDialog<bool?>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return PinRemovalPage<VaultSecretsModel>(containerModel: vaultListItemModel.vaultModel);
      },
    );
    if (successBool == true) {
      await vaultListPageCubit.changeSelectionEncryptionStatus(
        selectedVaults: <VaultListItemModel>[vaultListItemModel],
        encryptedBool: false,
      );
    }
  }

  void _cancelSelection() {
    if (vaultListPageCubit.state.isSelectingEnabled) {
      vaultListPageCubit.disableSelection();
    }
    BottomNavigationWrapper.of(context).hideTooltip();
  }
}

class _GridAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GridAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  border: GradientBoxBorder(
                    gradient: AppColors.primaryGradient,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: AppColors.middleGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
