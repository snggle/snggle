import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_selection_model.dart';
import 'package:snggle/views/widgets/custom/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip_item.dart';

class WalletListPageTooltip extends StatefulWidget {
  final WalletSelectionModel walletSelectionModel;
  final VoidCallback onSelectAll;
  final VoidCallback? onBackupSelected;
  final VoidCallback? onLockSelected;
  final ValueChanged<bool>? onPinValueChanged;

  const WalletListPageTooltip({
    required this.walletSelectionModel,
    required this.onSelectAll,
    this.onBackupSelected,
    this.onLockSelected,
    this.onPinValueChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WalletListPageTooltipState();
}

class _WalletListPageTooltipState extends State<WalletListPageTooltip> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBarTooltip(
      actions: <CustomBottomNavigationBarTooltipItem>[
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.success,
          label: 'All',
          onTap: widget.onSelectAll,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.pin,
          label: 'Pin',
          onTap: widget.walletSelectionModel.canPinAll ? () => _pressPinButton(true) : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.unpin,
          label: 'Unpin',
          onTap: widget.walletSelectionModel.canUnpinAll ? () => _pressPinButton(false) : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.lock,
          label: 'Lock',
          onTap: widget.walletSelectionModel.canLockAll ? _pressLockButton : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.backup,
          label: 'Backup',
          onTap: widget.onBackupSelected,
        ),
      ],
    );
  }

  void _pressPinButton(bool pinnedBool) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: pinnedBool ? 'Pin' : 'Unpin',
        content: 'Are you sure you want to ${pinnedBool ? 'pin' : 'unpin'} selected wallets?',
        onConfirm: () {
          widget.onPinValueChanged?.call(pinnedBool);
        },
      ),
    );
  }

  void _pressLockButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Lock',
        content: 'Are you sure you want to lock selected wallets?',
        onConfirm: () {
          widget.onLockSelected?.call();
        },
      ),
    );
  }
}
