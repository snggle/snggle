import 'package:auto_route/auto_route.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_page/network_group_list_item_tooltip.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_wrapper.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/wallets_preview_icon.dart';

class NetworkGroupListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final VoidCallback onRemove;
  final ValueChanged<bool> onSelectValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final ValueChanged<bool> onPinValueChanged;
  final VaultListItemModel vaultListItemModel;
  final NetworkGroupListItemModel networkGroupListItemModel;

  const NetworkGroupListItem({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.onRemove,
    required this.onSelectValueChanged,
    required this.onLockValueChanged,
    required this.onPinValueChanged,
    required this.vaultListItemModel,
    required this.networkGroupListItemModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupListItemState();
}

class _NetworkGroupListItemState extends State<NetworkGroupListItem> {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    Widget itemWidget = HorizontalListItem(
      selectedBool: widget.selectedBool,
      selectionEnabledBool: widget.selectionEnabledBool,
      onSelectValueChanged: widget.onSelectValueChanged,
      iconWidget: WalletsPreviewIcon(
        radius: 17,
        lockedBool: widget.networkGroupListItemModel.encryptedBool,
        pinnedBool: widget.networkGroupListItemModel.pinnedBool,
        wallets: widget.networkGroupListItemModel.walletsPreview,
        padding: 8,
      ),
      titleWidget: Text(widget.networkGroupListItemModel.networkConfigModel.name),
      trailingWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GradientIcon(
            widget.networkGroupListItemModel.networkConfigModel.iconData,
            gradient: AppColors.primaryGradient,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            widget.networkGroupListItemModel.walletsPreview.length.toString(),
            style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey),
          ),
        ],
      ),
    );

    if (widget.selectionEnabledBool == false) {
      itemWidget = ActionsTooltipWrapper(
        controller: actionsPopupController,
        content: NetworkGroupListItemTooltip(
          encryptedBool: widget.networkGroupListItemModel.encryptedBool,
          pinnedBool: widget.networkGroupListItemModel.pinnedBool,
          name: widget.networkGroupListItemModel.networkConfigModel.name,
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

    return itemWidget;
  }

  void _handlePinValueChanged(bool pinnedBool) {
    print('_handlePinValueChanged1($pinnedBool)');
    actionsPopupController.hideMenu();
    widget.onPinValueChanged(pinnedBool);
    print('_handlePinValueChanged1 end');
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
        vaultListItemModel: widget.vaultListItemModel,
        vaultPasswordModel: PasswordModel.defaultPassword(),
        parentContainerPathModel: widget.networkGroupListItemModel.containerPathModel,
      ),
    );
  }

  void _showActionsTooltip() {
    FocusScope.of(context).requestFocus(FocusNode());
    HapticFeedback.lightImpact();
    actionsPopupController.showMenu();
  }
}
