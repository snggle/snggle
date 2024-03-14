import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_tooltip_item.dart';

class CustomBottomNavigationBarTooltip extends StatelessWidget {
  final List<CustomBottomNavigationBarTooltipItem> actions;

  const CustomBottomNavigationBarTooltip({
    required this.actions,
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
      ),
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
    );
  }
}
