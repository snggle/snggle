import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class WalletConnectOptionButton extends StatelessWidget {
  final bool selectedBool;
  final String label;
  final AssetIconData icon;
  final VoidCallback onTap;

  const WalletConnectOptionButton({
    required this.selectedBool,
    required this.label,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color? iconColor = selectedBool ? null : AppColors.darkGrey;
    Color? textColor = selectedBool ? AppColors.body3 : AppColors.darkGrey;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AssetIcon(icon, size: 100, color: iconColor),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(color: textColor),
              )
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: CustomCheckbox(selectedBool: selectedBool, size: 14),
          ),
        ],
      ),
    );
  }
}
