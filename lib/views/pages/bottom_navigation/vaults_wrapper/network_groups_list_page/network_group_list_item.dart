import 'package:auto_route/auto_route.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/password_entry_result_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_auth_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_list_page/network_group_list_item_tooltip.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/generic/wallets_preview_icon.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

class NetworkGroupListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;
  final ValueChanged<bool> onSelectValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final ValueChanged<bool> onPinValueChanged;
  final VaultListItemModel vaultListItemModel;
  final PasswordModel vaultPasswordModel;
  final NetworkGroupListItemModel networkGroupListItemModel;

  const NetworkGroupListItem({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.onRefresh,
    required this.onDelete,
    required this.onSelectValueChanged,
    required this.onLockValueChanged,
    required this.onPinValueChanged,
    required this.vaultListItemModel,
    required this.vaultPasswordModel,
    required this.networkGroupListItemModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupListItemState();
}

class _NetworkGroupListItemState extends State<NetworkGroupListItem> with TickerProviderStateMixin {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();
  late final AnimationController fadeAnimationController;
  late final AnimationController slideAnimationController;

  @override
  void initState() {
    fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    super.initState();
  }

  @override
  void dispose() {
    fadeAnimationController.dispose();
    slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    Widget itemWidget = HorizontalListItem(
      fadeAnimationController: fadeAnimationController,
      slideAnimationController: slideAnimationController,
      horizontalListItemAnimationType: HorizontalListItemAnimationType.slideLeftToRight,
      selectedBool: widget.selectedBool,
      selectionEnabledBool: widget.selectionEnabledBool,
      onSelectValueChanged: widget.onSelectValueChanged,
      iconWidget: WalletsPreviewIcon(
        radius: 17,
        lockedBool: widget.networkGroupListItemModel.encryptedBool,
        pinnedBool: widget.networkGroupListItemModel.pinnedBool,
        walletAddresses: widget.networkGroupListItemModel.walletAddressesPreview,
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
            widget.networkGroupListItemModel.walletAddressesPreview.length.toString(),
            style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey),
          ),
        ],
      ),
    );

    if (widget.selectionEnabledBool == false) {
      itemWidget = ContextTooltipWrapper(
        controller: actionsPopupController,
        content: NetworkGroupListItemTooltip(
          encryptedBool: widget.networkGroupListItemModel.encryptedBool,
          pinnedBool: widget.networkGroupListItemModel.pinnedBool,
          name: widget.networkGroupListItemModel.networkConfigModel.name,
          onPinValueChanged: _handlePinValueChanged,
          onLockValueChanged: _handleLockValueChanged,
          onSelect: _handleItemSelected,
          onDelete: _handleItemDeleted,
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

  void _handleItemDeleted() {
    widget.onDelete();
    actionsPopupController.hideMenu();
  }

  Future<void> _navigateToWalletListPage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    actionsPopupController.hideMenu();

    PasswordModel? passwordModel;
    if (widget.networkGroupListItemModel.encryptedBool) {
      passwordModel = await _queryPassword();
      if (passwordModel == null) {
        return;
      }
    }

    await AutoRouter.of(context).push<void>(
      WalletListRoute(
        pageName: widget.networkGroupListItemModel.networkConfigModel.name,
        vaultModel: widget.vaultListItemModel.vaultModel,
        vaultPasswordModel: widget.vaultPasswordModel,
        parentContainerModel: widget.networkGroupListItemModel.walletGroupModel,
        networkConfigModel: widget.networkGroupListItemModel.networkConfigModel,
      ),
    );
    widget.onRefresh();
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

  void _showActionsTooltip() {
    FocusScope.of(context).requestFocus(FocusNode());
    HapticFeedback.lightImpact();
    actionsPopupController.showMenu();
  }
}
