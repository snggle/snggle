import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class BottomTooltipWrapper extends StatelessWidget {
  final Widget child;
  final Widget tooltip;
  final bool tooltipVisibleBool;
  final bool blurBackgroundBool;

  const BottomTooltipWrapper({
    required this.tooltip,
    required this.child,
    this.tooltipVisibleBool = true,
    this.blurBackgroundBool = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget styledTooltip = tooltip;
    if (blurBackgroundBool) {
      styledTooltip = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: styledTooltip,
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        if (tooltipVisibleBool)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: CustomBottomNavigationBar.height,
              width: double.infinity,
              child: styledTooltip,
            ),
          ),
      ],
    );
  }
}
