import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip_item.dart';

class VaultListPageTooltip extends StatelessWidget {
  final VaultSelectionModel vaultSelectionModel;
  final VoidCallback onSelectAll;
  final ValueChanged<bool>? onPinValueChanged;
  final VoidCallback? onLockSelected;
  final VoidCallback? onBackupSelected;

  const VaultListPageTooltip({
    required this.vaultSelectionModel,
    required this.onSelectAll,
    this.onPinValueChanged,
    this.onLockSelected,
    this.onBackupSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBarTooltip(
      actions: <CustomBottomNavigationBarTooltipItem>[
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.success,
          label: 'All',
          onTap: onSelectAll,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.pin,
          label: 'Pin',
          onTap: vaultSelectionModel.canPin ? () => onPinValueChanged!(true) : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.unpin,
          label: 'Unpin',
          onTap: vaultSelectionModel.canUnpin ? () => onPinValueChanged!(false) : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.lock,
          label: 'Lock',
          onTap: vaultSelectionModel.canLock ? onLockSelected : null,
        ),
        CustomBottomNavigationBarTooltipItem(
          iconData: AppIcons.backup,
          label: 'Backup',
          onTap: onBackupSelected,
        ),
      ],
    );
  }
}
