import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class BottomTooltipWrapper extends StatelessWidget {
  final Widget _child;
  final Widget _tooltip;
  final bool _tooltipVisibleBool;
  final bool _blurBackgroundBool;

  const BottomTooltipWrapper({
    required this._tooltip,
    required this._child,
    this._tooltipVisibleBool = true,
    this._blurBackgroundBool = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget styledTooltip = _tooltip;
    if (_blurBackgroundBool) {
      styledTooltip = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: styledTooltip,
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(child: _child),
        if (_tooltipVisibleBool)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: CustomBottomNavigationBar.contentHeight,
              width: double.infinity,
              child: styledTooltip,
            ),
          ),
      ],
    );
  }
}
