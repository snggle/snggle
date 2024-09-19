import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class LabelWrapperVertical extends StatelessWidget {
  final String label;
  final Widget child;
  final bool bottomBorderVisibleBool;
  final double labelGap;
  final TextStyle? labelStyle;
  final EdgeInsets labelPadding;
  final EdgeInsets childPadding;

  const LabelWrapperVertical({
    required this.label,
    required this.child,
    this.bottomBorderVisibleBool = true,
    this.labelStyle,
    EdgeInsets? labelPadding,
    EdgeInsets? childPadding,
    super.key,
  })  : labelGap = 8,
        labelPadding = labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        childPadding = childPadding ?? const EdgeInsets.symmetric(horizontal: 16);

  const LabelWrapperVertical.textField({
    required this.label,
    required this.child,
    this.labelStyle,
    this.bottomBorderVisibleBool = true,
    EdgeInsets? labelPadding,
    EdgeInsets? childPadding,
    super.key,
  })  : labelGap = 4,
        labelPadding = labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        childPadding = childPadding ?? const EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: labelPadding,
            child: Text(
              label,
              style: (labelStyle ?? theme.textTheme.labelMedium)?.copyWith(color: AppColors.darkGrey),
            ),
          ),
          SizedBox(height: labelGap),
          Padding(
            padding: childPadding,
            child: child,
          ),
          SizedBox(height: labelGap),
          if (bottomBorderVisibleBool) ...<Widget>[
            Divider(height: 0.6, thickness: 0.6, color: AppColors.lightGrey1),
          ],
        ],
      ),
    );
  }
}
