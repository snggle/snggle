import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class ContextTooltipWrapper extends StatelessWidget {
  final Widget child;
  final Widget content;
  final CustomPopupMenuController controller;
  final double verticalMargin;
  final PressType pressType;

  const ContextTooltipWrapper({
    required this.child,
    required this.content,
    required this.controller,
    this.verticalMargin = -10,
    this.pressType = PressType.singleClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: controller,
      menuBuilder: () => content,
      pressType: pressType,
      barrierColor: Colors.transparent,
      arrowColor: AppColors.middleGrey,
      enablePassEvent: false,
      verticalMargin: verticalMargin,
      child: child,
    );
  }
}
