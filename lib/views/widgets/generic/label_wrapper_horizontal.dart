import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class LabelWrapperHorizontal extends StatelessWidget {
  final String label;
  final Widget child;
  final bool bottomBorderVisibleBool;
  final double labelGap;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;

  const LabelWrapperHorizontal({
    required this.label,
    required this.child,
    this.bottomBorderVisibleBool = true,
    this.labelGap = 8,
    this.labelStyle,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  style: (labelStyle ?? textTheme.labelMedium)?.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
                Expanded(child: Align(alignment: Alignment.centerRight, child: child)),
              ],
            ),
          ),
          if (bottomBorderVisibleBool) ...<Widget>[
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.lightGrey1,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ],
        ],
      ),
    );
  }
}
