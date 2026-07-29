import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  static const double contentHeight = 80;

  final List<Widget> bottomNavigationBarItems;

  const CustomBottomNavigationBar({
    required this.bottomNavigationBarItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: ColoredBox(
          color: AppColors.body2.withValues(alpha: 0.3),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: CustomBottomNavigationBar.contentHeight,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: bottomNavigationBarItems.map((Widget item) {
                    return Expanded(
                      child: Center(child: item),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
