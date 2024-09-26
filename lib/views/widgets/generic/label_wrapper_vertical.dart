import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class LabelWrapperVertical extends StatelessWidget {
  final String label;
  final Widget child;
  final bool bottomBorderVisibleBool;
  final double labelGap;
  final TextStyle? labelStyle;
  final Color? bottomBorderColor;
  final EdgeInsets? padding;
  final EdgeInsets labelPadding;
  final EdgeInsets childPadding;

  LabelWrapperVertical({
    required this.label,
    required this.child,
    this.bottomBorderVisibleBool = true,
    this.labelStyle,
    this.padding,
    EdgeInsets? labelPadding,
    EdgeInsets? childPadding,
    super.key,
  })  : bottomBorderColor = AppColors.lightGrey1,
        labelGap = 8,
        labelPadding = labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        childPadding = childPadding ?? const EdgeInsets.symmetric(horizontal: 16);

  LabelWrapperVertical.dialog({
    required this.label,
    required this.child,
    this.bottomBorderVisibleBool = true,
    this.labelStyle,
    this.padding,
    double? labelGap,
    EdgeInsets? labelPadding,
    EdgeInsets? childPadding,
    super.key,
  })  : bottomBorderColor = AppColors.divider,
        labelGap = labelGap ?? 10,
        labelPadding = labelPadding ?? EdgeInsets.zero,
        childPadding = childPadding ?? EdgeInsets.zero;

  LabelWrapperVertical.textField({
    required this.label,
    required this.child,
    this.labelStyle,
    this.bottomBorderVisibleBool = true,
    this.padding,
    EdgeInsets? labelPadding,
    EdgeInsets? childPadding,
    super.key,
  })  : bottomBorderColor = AppColors.lightGrey1,
        labelGap = 4,
        labelPadding = labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        childPadding = childPadding ?? const EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 5),
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
            Divider(height: 0.6, thickness: 0.6, color: bottomBorderColor),
          ],
        ],
      ),
    );
  }
}
