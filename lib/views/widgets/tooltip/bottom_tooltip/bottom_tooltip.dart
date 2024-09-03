import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class BottomTooltip extends StatelessWidget {
  final List<Widget> actions;
  final Color? backgroundColor;

  const BottomTooltip({
    required this.actions,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.middleGrey),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < actions.length; i++) ...<Widget>[
            actions[i],
            if (i < actions.length - 1)
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: VerticalDivider(color: AppColors.middleGrey, width: 0.6, thickness: 0.6),
              ),
          ]
        ],
      ),
    );
  }
}
