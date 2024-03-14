import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_template.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_tooltip.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_wrapper.dart';
import 'package:snggle/views/widgets/generic/selection_wrapper.dart';
import 'package:snggle/views/widgets/generic/wallets_preview_icon.dart';

class VaultListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final VoidCallback onRemove;
  final VoidCallback onRefreshWallets;
  final ValueChanged<bool> onSelectValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final ValueChanged<bool> onPinValueChanged;
  final VaultListItemModel vaultListItemModel;

  const VaultListItem({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.onRemove,
    required this.onRefreshWallets,
    required this.onSelectValueChanged,
    required this.onLockValueChanged,
    required this.onPinValueChanged,
    required this.vaultListItemModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VaultListItemState();
}

class _VaultListItemState extends State<VaultListItem> {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();

  // TODO(dominik): Temporary solution to get user password. After implementing "secrets-pin-pages-ui" this line should be replaced by custom page requesting user's password
  final PasswordModel mockedPasswordModel = PasswordModel.fromPlaintext('1111');

  @override
  Widget build(BuildContext context) {
    Widget itemWidget = VaultListItemTemplate(
      iconWidget: WalletsPreviewIcon(
        lockedBool: widget.vaultListItemModel.encryptedBool,
        pinnedBool: widget.vaultListItemModel.vaultModel.pinnedBool,
        wallets: widget.vaultListItemModel.vaultWalletsPreview,
      ),
      titleWidget: Text(
        widget.vaultListItemModel.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.body1,
          fontSize: 13,
        ),
      ),
    );

    if (widget.selectionEnabledBool) {
      return SelectionWrapper(
        selectedBool: widget.selectedBool,
        onSelectValueChanged: widget.onSelectValueChanged,
        child: itemWidget,
      );
    } else {
      return ActionsTooltipWrapper(
        controller: actionsPopupController,
        content: VaultListItemTooltip(
          encryptedBool: widget.vaultListItemModel.encryptedBool,
          pinnedBool: widget.vaultListItemModel.vaultModel.pinnedBool,
          name: widget.vaultListItemModel.name,
          onPinValueChanged: _handlePinValueChanged,
          onLockValueChanged: _handleLockValueChanged,
          onSelect: _handleItemSelected,
          onRemove: _handleItemRemoved,
        ),
        child: GestureDetector(
          onTap: _navigateToWalletsPage,
          onLongPress: _showActionsTooltip,
          child: itemWidget,
        ),
      );
    }
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

  void _showActionsTooltip() {
    FocusScope.of(context).requestFocus(FocusNode());
    HapticFeedback.lightImpact();
    actionsPopupController.showMenu();
  }

  Future<void> _navigateToWalletsPage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    actionsPopupController.hideMenu();

    PasswordModel? passwordModel;
    if (widget.vaultListItemModel.encryptedBool) {
      passwordModel = mockedPasswordModel;
    }

    await AutoRouter.of(context).push<void>(
      WalletListRoute(
        vaultModel: widget.vaultListItemModel.vaultModel,
        vaultPasswordModel: passwordModel ?? PasswordModel.defaultPassword(),
      ),
    );

    widget.onRefreshWallets();
  }
}
