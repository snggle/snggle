import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class ErrorMessageListTile extends StatefulWidget {
  final String message;

  const ErrorMessageListTile({
    required this.message,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ErrorMessageListTileState();
}

class _ErrorMessageListTileState extends State<ErrorMessageListTile> with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> fadeInAnimation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    fadeInAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(animation);
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: FadeTransition(
        opacity: animation,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const AssetIcon(AppIcons.alert_small, size: 14.0),
            const SizedBox(width: 6),
            Expanded(
              child: GradientText(
                widget.message,
                gradient: LinearGradient(colors: AppColors.validationGradient.colors),
                textStyle: theme.textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
