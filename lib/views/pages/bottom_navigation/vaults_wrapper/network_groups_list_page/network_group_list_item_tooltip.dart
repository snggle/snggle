import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_agreement_dialog.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_content.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class NetworkGroupListItemTooltip extends StatefulWidget {
  final bool encryptedBool;
  final bool pinnedBool;
  final String name;
  final ValueChanged<bool> onPinValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const NetworkGroupListItemTooltip({
    required this.encryptedBool,
    required this.pinnedBool,
    required this.name,
    required this.onPinValueChanged,
    required this.onLockValueChanged,
    required this.onDelete,
    required this.onSelect,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupListItemTooltipState();
}

class _NetworkGroupListItemTooltipState extends State<NetworkGroupListItemTooltip> {
  @override
  Widget build(BuildContext context) {
    return ContextTooltipContent(
      title: widget.name,
      actions: <ContextTooltipItem>[
        if (widget.pinnedBool)
          ContextTooltipItem(
            iconData: AppIcons.unpin,
            label: 'Unpin',
            onTap: () => widget.onPinValueChanged(false),
          )
        else
          ContextTooltipItem(
            iconData: AppIcons.pin,
            label: 'Pin',
            onTap: () => widget.onPinValueChanged(true),
          ),
        ContextTooltipItem(
          iconData: AppIcons.select_container_unselected,
          label: 'Select',
          onTap: widget.onSelect,
        ),
        if (widget.encryptedBool)
          ContextTooltipItem(
            iconData: AppIcons.unlock,
            label: 'Unlock',
            onTap: _pressUnlockButton,
          )
        else
          ContextTooltipItem(
            iconData: AppIcons.lock,
            label: 'Lock',
            onTap: () => widget.onLockValueChanged(true),
          ),
        if (widget.encryptedBool == false)
          ContextTooltipItem(
            iconData: AppIcons.close_1,
            label: 'Delete',
            onTap: _pressDeleteButton,
          ),
      ],
    );
  }

  void _pressUnlockButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Lock',
        content: 'Are you sure you want to unlock this item?',
        onConfirm: () {
          widget.onLockValueChanged.call(false);
        },
      ),
    );
  }

  void _pressDeleteButton() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomAgreementDialog(
        title: 'Delete',
        content: 'Are you sure you want to delete this item??',
        onConfirm: () {
          widget.onDelete.call();
        },
      ),
    );
  }
}
