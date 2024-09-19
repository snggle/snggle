import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<CustomDialogOption> options;

  const CustomDialog({
    required this.title,
    required this.content,
    required this.options,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    Widget separator = Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: VerticalDivider(color: AppColors.middleGrey, width: 0.6, thickness: 0.6),
    );

    Widget optionButtonsSection = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options.fold(
          <Widget>[],
          (List<Widget> acc, CustomDialogOption option) {
            if (acc.isNotEmpty) {
              acc.add(separator);
            }
            if (options.length == 1) {
              acc.add(DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.divider),
                  ),
                ),
                child: option,
              ));
            } else {
              acc.add(Expanded(child: option));
            }
            return acc;
          },
        ).toList(),
      ),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.middleGrey),
                    ),
                    padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title.toUpperCase(),
                          style: textTheme.bodyMedium!.copyWith(color: AppColors.body3),
                        ),
                        const SizedBox(height: 6),
                        content,
                        const SizedBox(height: 16),
                        optionButtonsSection
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
