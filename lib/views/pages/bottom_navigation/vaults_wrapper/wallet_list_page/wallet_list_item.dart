import 'package:auto_route/auto_route.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_list_item_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_item_tooltip.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item.dart';
import 'package:snggle/views/widgets/generic/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/generic/wallet_icon.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

class WalletListItem extends StatefulWidget {
  final bool selectedBool;
  final bool selectionEnabledBool;
  final VoidCallback onDelete;
  final ValueChanged<bool> onSelectValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final ValueChanged<bool> onPinValueChanged;
  final WalletListItemModel walletListItemModel;

  const WalletListItem({
    required this.selectedBool,
    required this.selectionEnabledBool,
    required this.onDelete,
    required this.onSelectValueChanged,
    required this.onLockValueChanged,
    required this.onPinValueChanged,
    required this.walletListItemModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletListItemState();
}

class _WalletListItemState extends State<WalletListItem> with TickerProviderStateMixin {
  final CustomPopupMenuController actionsPopupController = CustomPopupMenuController();
  final PasswordModel mockedPasswordModel = PasswordModel.fromPlaintext('1111');

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
    actionsPopupController.dispose();
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
      horizontalListItemAnimationType: HorizontalListItemAnimationType.slideBottomToUp,
      selectedBool: widget.selectedBool,
      selectionEnabledBool: widget.selectionEnabledBool,
      onSelectValueChanged: widget.onSelectValueChanged,
      iconWidget: WalletIcon(
        address: widget.walletListItemModel.walletModel.address,
        lockedBool: widget.walletListItemModel.encryptedBool,
        pinnedBool: widget.walletListItemModel.pinnedBool,
      ),
      titleWidget: Text(widget.walletListItemModel.name, style: textTheme.bodyMedium),
      subtitleWidget: GradientText(widget.walletListItemModel.shortenedAddress,
          textStyle: textTheme.bodyMedium,
          gradient: RadialGradient(
            radius: 7,
            center: const Alignment(-1, 1.5),
            colors: AppColors.primaryGradient.colors,
          )),
      trailingWidget: Text(
        widget.walletListItemModel.walletModel.derivationPath,
        style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey, fontSize: 11),
      ),
    );

    if (widget.selectionEnabledBool == false) {
      itemWidget = ContextTooltipWrapper(
        controller: actionsPopupController,
        content: WalletListItemTooltip(
          encryptedBool: widget.walletListItemModel.encryptedBool,
          pinnedBool: widget.walletListItemModel.pinnedBool,
          name: widget.walletListItemModel.name,
          onPinValueChanged: _handlePinValueChanged,
          onLockValueChanged: _handleLockValueChanged,
          onSelect: _handleItemSelected,
          onDelete: _handleItemDeleted,
        ),
        child: GestureDetector(
          onTap: _navigateToWalletDetailsPage,
          onLongPress: _showActionsTooltip,
          child: itemWidget,
        ),
      );
    }

    if (widget.walletListItemModel.encryptedBool) {
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

  void _handleItemDeleted() {
    widget.onDelete();
    actionsPopupController.hideMenu();
  }

  Future<void> _navigateToWalletDetailsPage() async {
    await AutoRouter.of(context).push<void>(WalletDetailsRoute(walletModel: widget.walletListItemModel.walletModel));
  }

  void _showActionsTooltip() {
    FocusScope.of(context).requestFocus(FocusNode());
    HapticFeedback.lightImpact();
    actionsPopupController.showMenu();
  }
}
