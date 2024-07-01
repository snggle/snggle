import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class DragTargetLayout extends StatelessWidget {
  static const Size listItemSize = Size(96, 144);
  static const Size listItemIconSize = Size(80, 80);

  final Widget icon;
  final String title;

  const DragTargetLayout({
    required this.icon,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: listItemSize.width,
      child: Column(
        children: <Widget>[
          icon,
          const SizedBox(height: 11),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.body1,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
