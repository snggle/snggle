import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_item.dart';

class ContextTooltipContent extends StatelessWidget {
  final String title;
  final List<ContextTooltipItem> actions;

  const ContextTooltipContent({
    required this.title,
    required this.actions,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxPopupWidth),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: AppColors.middleGrey),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.body3,
                      fontSize: 14,
                    ),
                  ),
                ),
                Divider(color: AppColors.middleGrey, height: 1),
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
                            child: VerticalDivider(color: AppColors.middleGrey, width: 1, thickness: 1),
                          ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
