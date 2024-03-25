import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class WalletListItemTemplate extends StatelessWidget {
  final Widget iconWidget;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final Widget? trailingWidget;

  const WalletListItemTemplate({
    required this.iconWidget,
    this.titleWidget,
    this.subtitleWidget,
    this.trailingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 68,
          height: 68,
          padding: const EdgeInsets.all(8),
          child: iconWidget,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (titleWidget != null) titleWidget!,
              const SizedBox(height: 1),
              if (subtitleWidget != null) subtitleWidget!,
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (trailingWidget != null) trailingWidget!,
          ],
        )
      ],
    );
  }
}
