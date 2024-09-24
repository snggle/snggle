import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class QRResultScaffoldLayout extends StatelessWidget {
  final Widget body;
  final Widget tooltip;
  final Widget? addressPreview;

  const QRResultScaffoldLayout({
    required this.body,
    required this.tooltip,
    this.addressPreview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: body),
        if (addressPreview != null) ...<Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Column(
                  children: <Widget>[
                    addressPreview!,
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
            child: tooltip,
          ),
        ),
      ],
    );
  }
}
