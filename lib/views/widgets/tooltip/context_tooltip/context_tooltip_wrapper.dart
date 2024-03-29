import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class ContextTooltipWrapper extends StatelessWidget {
  final Widget child;
  final Widget content;
  final CustomPopupMenuController controller;

  const ContextTooltipWrapper({
    required this.child,
    required this.content,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: controller,
      menuBuilder: () => content,
      pressType: PressType.singleClick,
      barrierColor: Colors.transparent,
      arrowColor: AppColors.middleGrey,
      enablePassEvent: false,
      verticalMargin: -10,
      child: child,
    );
  }
}
