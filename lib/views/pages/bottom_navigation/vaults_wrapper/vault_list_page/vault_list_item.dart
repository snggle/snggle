import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/password_entry_result_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/secrets_auth_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_icon.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_template.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_item_tooltip.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_wrapper.dart';
import 'package:snggle/views/widgets/generic/selection_wrapper.dart';

class VaultListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectingEnabledBool;
  final VaultListItemModel vaultListItemModel;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;
  final ValueChanged<bool> onSelectValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final ValueChanged<bool> onPinValueChanged;

  const VaultListItem({
    required this.selectedBool,
    required this.selectingEnabledBool,
    required this.vaultListItemModel,
    required this.onDelete,
    required this.onRefresh,
    required this.onSelectValueChanged,
    required this.onLockValueChanged,
    required this.onPinValueChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _VaultListItemState();
}

class _VaultListItemState extends State<VaultListItem> {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();
  final PasswordModel mockedPasswordModel = PasswordModel.fromPlaintext('1111');

  @override
  Widget build(BuildContext context) {
    Widget itemWidget = VaultListItemTemplate(
      iconWidget: VaultIcon(
        lockedBool: widget.vaultListItemModel.isEncrypted,
        pinnedBool: widget.vaultListItemModel.isPinned,
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

    if (widget.selectingEnabledBool) {
      return SelectionWrapper(
        selectedBool: widget.selectedBool,
        onSelectValueChanged: widget.onSelectValueChanged,
        child: itemWidget,
      );
    } else {
      return ActionsTooltipWrapper(
        controller: actionsPopupController,
        content: VaultListItemTooltip(
          encryptedBool: widget.vaultListItemModel.isEncrypted,
          pinnedBool: widget.vaultListItemModel.isPinned,
          name: widget.vaultListItemModel.name,
          onPinValueChanged: (bool pinnedBool) {
            actionsPopupController.hideMenu();
            widget.onPinValueChanged(pinnedBool);
          },
          onLockValueChanged: (bool lockedBool) {
            actionsPopupController.hideMenu();
            widget.onLockValueChanged(lockedBool);
          },
          onSelect: () {
            widget.onSelectValueChanged(true);
            actionsPopupController.hideMenu();
          },
          onRemove: () {
            widget.onDelete();
            actionsPopupController.hideMenu();
          },
        ),
        child: GestureDetector(
          onTap: _navigateToWalletsPage,
          onLongPress: _showActionsTooltip,
          child: itemWidget,
        ),
      );
    }
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
    if (widget.vaultListItemModel.isEncrypted) {
      passwordModel = await _queryPassword();
      if (passwordModel == null) {
        return;
      }
    }

    await AutoRouter.of(context).push<void>(
      WalletListRoute(
        vaultModel: widget.vaultListItemModel.vaultModel,
        vaultPasswordModel: passwordModel ?? PasswordModel.defaultPassword(),
      ),
    );
  }

  Future<PasswordModel?> _queryPassword() async {
    PasswordEntryResultModel? passwordEntryResultModel = await showDialog<PasswordEntryResultModel?>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SecretsAuthPagePage(containerModel: widget.vaultListItemModel.vaultModel);
      },
    );

    if (passwordEntryResultModel?.validBool == true) {
      return passwordEntryResultModel?.passwordModel;
    } else {
      return null;
    }
  }
}
