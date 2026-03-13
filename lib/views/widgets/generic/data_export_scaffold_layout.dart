import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class DataExportScaffoldLayout extends StatelessWidget {
  final Widget body;
  final bool tooltipDisabledBool;
  final Widget? tooltip;
  final Widget? footer;

  const DataExportScaffoldLayout({
    required this.body,
    this.tooltipDisabledBool = false,
    this.tooltip,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: body),
        if (footer != null) ...<Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Column(
                  children: <Widget>[
                    footer!,
                    const SizedBox(height: CustomBottomNavigationBar.height),
                  ],
                ),
              ),
            ),
          ),
        ],
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: CustomBottomNavigationBar.height,
            width: double.infinity,
            child: Opacity(
              opacity: tooltipDisabledBool ? 0.5 : 1.0,
              child: IgnorePointer(
                ignoring: tooltipDisabledBool,
                child: tooltip,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
