import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final List<Widget>? actions;
  final VoidCallback? customPopCallback;

  const CustomAppBar({
    required this.title,
    this.closeButtonVisible = false,
    this.popButtonVisible = false,
    this.actions,
    this.customPopCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    bool popAvailableBool = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    if (popButtonVisible || popAvailableBool) {
      leadingWidget = SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: () => customPopCallback != null ? customPopCallback!() : AutoRouter.of(context).pop(),
            icon: Icon(closeButtonVisible ? AppIcons.close_1 : AppIcons.back, size: 20, color: AppColors.body1),
          ),
        ),
      );
    }

    Widget appBarWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 50,
          height: 40,
          child: leadingWidget,
        ),
        Expanded(
          child: Text(
            title.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: 1.2,
              color: AppColors.body1,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ...?actions?.map((Widget action) => action).toList(),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 16, top: 10),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.topCenter,
        child: appBarWidget,
      ),
    );
  }
}
