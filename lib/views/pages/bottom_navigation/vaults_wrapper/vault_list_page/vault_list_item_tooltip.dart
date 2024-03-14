import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_content.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_item.dart';

class VaultListItemTooltip extends StatelessWidget {
  final bool encryptedBool;
  final bool pinnedBool;
  final String name;
  final ValueChanged<bool> onPinValueChanged;
  final ValueChanged<bool> onLockValueChanged;
  final VoidCallback onRemove;
  final VoidCallback onSelect;

  const VaultListItemTooltip({
    required this.encryptedBool,
    required this.pinnedBool,
    required this.name,
    required this.onPinValueChanged,
    required this.onLockValueChanged,
    required this.onRemove,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ActionsTooltipContent(
      title: name,
      actions: <ActionsTooltipItem>[
        if (pinnedBool)
          ActionsTooltipItem(
            iconData: AppIcons.unpin,
            label: 'Unpin',
            onTap: () => onPinValueChanged(false),
          )
        else
          ActionsTooltipItem(
            iconData: AppIcons.pin,
            label: 'Pin',
            onTap: () => onPinValueChanged(true),
          ),
        ActionsTooltipItem(
          iconData: AppIcons.select_container_selected,
          label: 'Select',
          onTap: onSelect,
        ),
        if (encryptedBool)
          ActionsTooltipItem(
            iconData: AppIcons.unlock,
            label: 'Unlock',
            onTap: () => onLockValueChanged(false),
          )
        else
          ActionsTooltipItem(
            iconData: AppIcons.lock,
            label: 'Lock',
            onTap: () => onLockValueChanged(true),
          ),
        ActionsTooltipItem(
          iconData: AppIcons.delete_2,
          label: 'Remove',
          onTap: onRemove,
        ),
      ],
    );
  }
}
