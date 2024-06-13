import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  static const double height = 80;

  final List<Widget> bottomNavigationBarItems;

  const CustomBottomNavigationBar({
    required this.bottomNavigationBarItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CustomBottomNavigationBar.height,
      width: double.infinity,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            color: AppColors.body2.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: bottomNavigationBarItems.map((Widget item) {
                return Expanded(child: Center(child: item));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
