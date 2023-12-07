import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item_model.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  static const double height = 80;
  final int selectedIndex;
  final List<CustomBottomNavigationBarItemModel> bottomNavigationBarItems;
  final ValueChanged<int> onChanged;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.bottomNavigationBarItems,
    required this.onChanged,
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
          child: Row(
            children: <Widget>[
              for (int i = 0; i < bottomNavigationBarItems.length; i++)
                CustomBottomNavigationBarItem(
                  selectedBool: i == selectedIndex,
                  customBottomNavigationBarItemModel: bottomNavigationBarItems[i],
                  onTap: () => onChanged(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
