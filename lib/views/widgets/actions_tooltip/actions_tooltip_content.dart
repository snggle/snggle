import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/actions_tooltip/actions_tooltip_item.dart';

class ActionsTooltipContent extends StatelessWidget {
  final String title;
  final List<ActionsTooltipItem> actions;

  const ActionsTooltipContent({
    required this.title,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 270),
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
                    children: <Widget>[
                      for (int i = 0; i < actions.length; i++) ...<Widget>[
                        Expanded(child: actions[i]),
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
