import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_background.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class ContextTooltipContent extends StatelessWidget {
  final List<ContextTooltipItem> actions;
  final String? title;
  final Widget? titleWidget;

  const ContextTooltipContent({
    required this.actions,
    this.title,
    this.titleWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 32;
    double elementsWidth = min(screenWidth, max(actions.length, 3) * 72);
    double maxPopupWidth = elementsWidth;
    bool elementsSizeOverflowBool = false;

    if (elementsWidth > screenWidth) {
      elementsSizeOverflowBool = true;
      maxPopupWidth = screenWidth;
    }

    return ContextTooltipBackground(
      maxPopupWidth: maxPopupWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: titleWidget ??
                Text(
                  title ?? '',
                  style: TextStyle(
                    color: AppColors.body3,
                    fontSize: 14,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
          ),
          Divider(color: AppColors.middleGrey, height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < actions.length; i++) ...<Widget>[
                  if (elementsSizeOverflowBool) Expanded(child: actions[i]) else actions[i],
                  if (i < actions.length - 1)
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: VerticalDivider(color: AppColors.middleGrey, width: 0.6, thickness: 0.6),
                    ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
