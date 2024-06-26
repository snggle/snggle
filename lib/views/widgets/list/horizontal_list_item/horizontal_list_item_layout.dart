import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

class HorizontalListItemLayout extends StatelessWidget {
  static const Size listItemSize = Size(double.infinity, 80);
  static const Size listItemIconSize = Size(52, 52);

  final Widget iconWidget;
  final bool lockedBool;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final Widget? trailingWidget;

  const HorizontalListItemLayout({
    required this.iconWidget,
    this.lockedBool = false,
    this.titleWidget,
    this.subtitleWidget,
    this.trailingWidget,
    super.key,
  });

  const HorizontalListItemLayout.loading({super.key})
      : iconWidget = const LoadingContainer(radius: 26),
        lockedBool = false,
        titleWidget = const LoadingContainer(height: 28, width: 64, radius: 8),
        subtitleWidget = const LoadingContainer(height: 28, width: 128, radius: 8),
        trailingWidget = const LoadingContainer(height: 28, width: 64, radius: 8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      height: listItemSize.height,
      decoration: BoxDecoration(
        color: lockedBool ? const Color(0x4FDADADA) : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey1, width: 0.6),
        ),
      ),
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (titleWidget != null) ...<Widget>[
                  titleWidget!,
                  const SizedBox(height: 1),
                ],
                if (subtitleWidget != null) subtitleWidget!,
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (trailingWidget != null) trailingWidget!,
            ],
          )
        ],
      ),
    );
  }
}
