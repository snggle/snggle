import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class DisplayModeLayout extends StatefulWidget {
  final String label;
  final Widget child;
  final VoidCallback onShowDialogPressed;
  final double labelGap;
  final EdgeInsets childPadding;
  final TextStyle? labelTextStyle;
  final TextStyle? textStyle;

  const DisplayModeLayout({
    required this.label,
    required this.child,
    required this.onShowDialogPressed,
    this.labelGap = 8,
    this.childPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.labelTextStyle,
    this.textStyle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DisplayModeLayoutState();
}

class _DisplayModeLayoutState extends State<DisplayModeLayout> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.label,
                  style: (widget.labelTextStyle ?? theme.textTheme.labelMedium)?.copyWith(color: AppColors.darkGrey),
                ),
              ),
              IconButton(
                onPressed: widget.onShowDialogPressed,
                visualDensity: VisualDensity.compact,
                icon: const AssetIcon(AppIcons.text_display_mode, size: 18),
              ),
            ],
          ),
        ),
        Padding(
          padding: widget.childPadding,
          child: widget.child,
        ),
        SizedBox(height: widget.labelGap),
        Divider(height: 1, thickness: 1, color: AppColors.lightGrey1),
      ],
    );
  }
}
