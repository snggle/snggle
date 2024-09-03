import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool closeButtonVisible;
  final bool popButtonVisible;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? customPopCallback;

  const CustomAppBar({
    required this.title,
    this.closeButtonVisible = false,
    this.popButtonVisible = false,
    this.subtitle,
    this.actions,
    this.customPopCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    Widget? leadingWidget;

    bool popAvailableBool = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    if (popButtonVisible || popAvailableBool) {
      leadingWidget = Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () => customPopCallback != null ? customPopCallback!() : AutoRouter.of(context).pop(),
          icon: closeButtonVisible
              ? AssetIcon(AppIcons.app_bar_close, size: 20, color: AppColors.body1)
              : AssetIcon(AppIcons.app_bar_back, size: 24, color: AppColors.body1),
        ),
      );
    }

    Widget appBarWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 50, height: 40, child: leadingWidget),
            Expanded(
              child: Text(
                title.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: 1.2,
                  height: 1.25,
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
        ),
        if (subtitle != null) ...<Widget>[
          Text(
            subtitle!,
            style: textTheme.labelMedium?.copyWith(color: AppColors.body3),
          ),
        ],
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
