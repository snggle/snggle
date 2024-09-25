import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class TransactionListItemLayout extends StatelessWidget {
  final double backgroundOpacity;
  final double expansionHeight;
  final Widget titleWidget;
  final Widget expansionWidget;
  final AnimationController animationController;

  const TransactionListItemLayout({
    required this.backgroundOpacity,
    required this.expansionHeight,
    required this.titleWidget,
    required this.expansionWidget,
    required this.animationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA).withOpacity(backgroundOpacity),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: titleWidget,
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor: expansionHeight,
              child: expansionWidget,
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.lightGrey1, height: 1, thickness: 1),
        ],
      ),
    );
  }
}
