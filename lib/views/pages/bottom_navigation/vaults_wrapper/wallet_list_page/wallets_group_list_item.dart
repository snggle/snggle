import 'package:auto_route/auto_route.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/shared/models/groups/wallet_group_list_item_model.dart';
import 'package:snggle/shared/models/network_config_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_page/network_group_list_item_tooltip.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_wrapper.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/wallets_preview_icon.dart';

class WalletsGroupListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final VaultModel vaultModel;
  final VoidCallback onRemove;
  final ValueChanged<bool> onSelectValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final ValueChanged<bool> onPinValueChanged;
  final WalletGroupListItemModel walletGroupListItemModel;
  final NetworkConfigModel networkConfigModel;

  const WalletsGroupListItem({
    required this.selectedBool,
    required this.vaultModel,
    required this.selectionEnabledBool,
    required this.onRemove,
    required this.onSelectValueChanged,
    required this.onLockValueChanged,
    required this.onPinValueChanged,
    required this.walletGroupListItemModel,
    required this.networkConfigModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletsGroupListItem();
}

class _WalletsGroupListItem extends State<WalletsGroupListItem> {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    Widget itemWidget = HorizontalListItem(
      selectedBool: widget.selectedBool,
      selectionEnabledBool: widget.selectionEnabledBool,
      onSelectValueChanged: widget.onSelectValueChanged,
      iconWidget: WalletsPreviewIcon(
        radius: 17,
        lockedBool: widget.walletGroupListItemModel.encryptedBool,
        pinnedBool: widget.walletGroupListItemModel.pinnedBool,
        wallets: widget.walletGroupListItemModel.walletsPreview,
        padding: 8,
      ),
      titleWidget: Text(widget.walletGroupListItemModel.walletGroupModel.name),
    );

    if (widget.selectionEnabledBool == false) {
      itemWidget = ActionsTooltipWrapper(
        controller: actionsPopupController,
        content: NetworkGroupListItemTooltip(
          encryptedBool: widget.walletGroupListItemModel.encryptedBool,
          pinnedBool: widget.walletGroupListItemModel.pinnedBool,
          name: widget.walletGroupListItemModel.walletGroupModel.name,
          onPinValueChanged: _handlePinValueChanged,
          onLockValueChanged: _handleLockValueChanged,
          onSelect: _handleItemSelected,
          onRemove: _handleItemRemoved,
        ),
        child: GestureDetector(
          onTap: _navigateToWalletListPage,
          onLongPress: _showActionsTooltip,
          child: itemWidget,
        ),
      );
    }

    if (widget.walletGroupListItemModel.encryptedBool) {
      itemWidget = Container(
        color: const Color(0x26DADADA),
        child: itemWidget,
      );
    }

    return itemWidget;
  }

  void _handlePinValueChanged(bool pinnedBool) {
    actionsPopupController.hideMenu();
    widget.onPinValueChanged(pinnedBool);
  }

  void _handleLockValueChanged(bool lockedBool) {
    actionsPopupController.hideMenu();
    widget.onLockValueChanged(lockedBool);
  }

  void _handleItemSelected() {
    widget.onSelectValueChanged(true);
    actionsPopupController.hideMenu();
  }

  void _handleItemRemoved() {
    widget.onRemove();
    actionsPopupController.hideMenu();
  }

  Future<void> _navigateToWalletListPage() async {
    await AutoRouter.of(context).push<void>(
      WalletListRoute(
        pageName: widget.walletGroupListItemModel.walletGroupModel.name,
        vaultPasswordModel: PasswordModel.defaultPassword(),
        networkConfigModel: widget.networkConfigModel,
        vaultModel: widget.vaultModel,
        parentContainerModel: widget.walletGroupListItemModel.walletGroupModel,
      ),
    );
  }

  void _showActionsTooltip() {
    FocusScope.of(context).requestFocus(FocusNode());
    HapticFeedback.lightImpact();
    actionsPopupController.showMenu();
  }
}
