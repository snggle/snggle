import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';

class VaultListItemLayout extends StatelessWidget {
  static const Size listItemSize = Size(96, 144);
  static const Size listItemIconSize = Size(80, 80);

  final Widget icon;
  final String? title;
  final Widget? titleWidget;

  const VaultListItemLayout({
    required this.icon,
    this.title,
    this.titleWidget,
    super.key,
  });

  VaultListItemLayout.loading({super.key})
      : title = '',
        icon = LoadingContainer(radius: 26, width: listItemIconSize.width, height: listItemIconSize.height),
        titleWidget = const LoadingContainer(height: 16, width: 30, radius: 8);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      color: Colors.transparent,
      width: listItemSize.width,
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 1,
            child: icon,
          ),
          const SizedBox(height: 11),
          titleWidget ??
              Text(
                title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(color: AppColors.body1),
              ),
        ],
      ),
    );
  }
}
