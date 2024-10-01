import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';

class CustomLargeListTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Gradient? titleGradient;
  final VoidCallback? onTap;

  const CustomLargeListTile({
    required this.title,
    this.leading,
    this.titleGradient,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 14),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.lightGrey1, width: 0.6),
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(height: 42, width: 42, child: leading),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    if (titleGradient != null)
                      GradientText(
                        title,
                        gradient: titleGradient!,
                        textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                      )
                    else
                      Text(
                        title,
                        textAlign: TextAlign.end,
                        style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
