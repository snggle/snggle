import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class GradientSwitch extends StatefulWidget {
  final bool enabledBool;
  final double size;

  const GradientSwitch({
    this.enabledBool = true,
    this.size = 30,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GradientSwitchState();
}

class _GradientSwitchState extends State<GradientSwitch> {
  late bool enabledBool = widget.enabledBool;

  @override
  void didUpdateWidget(covariant GradientSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabledBool != widget.enabledBool) {
      enabledBool = widget.enabledBool;
    }
  }

  @override
  Widget build(BuildContext context) {
    double switchWidth = widget.size;
    double switchHeight = widget.size * 0.46;
    double dotSize = widget.size * 0.33;
    double dotPadding = widget.size * 0.044;

    return SizedBox(
      width: switchWidth,
      height: switchHeight,
      child: Stack(
        children: <Widget>[
          AssetIcon(
            AppIcons.switch_border,
            width: switchWidth,
            height: switchHeight,
            color: enabledBool ? null : AppColors.middleGrey,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastEaseInToSlowEaseOut,
            left: enabledBool ? switchWidth - dotSize - dotPadding * 2 : 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dotPadding),
              child: AssetIcon(
                AppIcons.switch_dot,
                width: dotSize,
                height: switchHeight,
                color: enabledBool ? null : AppColors.middleGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
