import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/groups/network_group_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/views/widgets/custom/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip_item.dart';

class NetworkGroupsPageTooltip extends StatefulWidget {
  final SelectionModel<NetworkGroupListItemModel> selectionModel;
  final VoidCallback onSelectAll;
  final VoidCallback? onBackupSelected;
  final VoidCallback? onLockSelected;
  final ValueChanged<bool>? onPinValueChanged;

  const NetworkGroupsPageTooltip({
    required this.selectionModel,
    required this.onSelectAll,
    this.onBackupSelected,
    this.onLockSelected,
    this.onPinValueChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupsPageTooltipState();
}

class _NetworkGroupsPageTooltipState extends State<NetworkGroupsPageTooltip> {
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
          onTap: widget.selectionModel.canPinAll ? () => _pressPinButton(true) : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.unpin,
          label: 'Unpin',
          onTap: widget.selectionModel.canUnpinAll ? () => _pressPinButton(false) : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.lock,
          label: 'Lock',
          onTap: widget.selectionModel.canLockAll ? _pressLockButton : null,
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
