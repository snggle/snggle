import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/selection_model.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

class WalletListPageTooltip extends StatefulWidget {
  final SelectionModel<AListItemModel> selectionModel;
  final VoidCallback onSelectAll;
  final VoidCallback? onLockSelected;
  final ValueChanged<bool>? onPinValueChanged;

  const WalletListPageTooltip({
    required this.selectionModel,
    required this.onSelectAll,
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
    return BottomTooltip(
      actions: <BottomTooltipItem>[
        BottomTooltipItem(
          iconData: widget.selectionModel.areAllItemsSelected ? AppIcons.close_1 : AppIcons.check,
          label: widget.selectionModel.areAllItemsSelected ? 'Clear' : 'All',
          onTap: widget.onSelectAll,
        ),
        BottomTooltipItem(
          iconData: AppIcons.pin,
          label: 'Pin',
          onTap: widget.selectionModel.canPinAll ? () => _pressPinButton(true) : null,
        ),
        BottomTooltipItem(
          iconData: AppIcons.unpin,
          label: 'Unpin',
          onTap: widget.selectionModel.canUnpinAll ? () => _pressPinButton(false) : null,
        ),
        BottomTooltipItem(
          iconData: AppIcons.lock,
          label: 'Lock',
          onTap: widget.selectionModel.canLockAll ? _pressLockButton : null,
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
