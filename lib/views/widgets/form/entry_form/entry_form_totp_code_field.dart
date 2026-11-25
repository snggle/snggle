import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form_field.dart';

class EntryFormTotpCodeField extends StatelessWidget {
  final int remainingSeconds;
  final TextEditingController totpTextEditingController;

  const EntryFormTotpCodeField({
    required this.remainingSeconds,
    required this.totpTextEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: EntryFormField(
        label: 'One-Time Password',
        textEditingController: totpTextEditingController,
        readOnlyBool: true,
        obscureClipboardContentBool: true,
        suffixWidget: TweenAnimationBuilder<double>(
          key: ValueKey<String>(totpTextEditingController.text),
          tween: Tween<double>(begin: remainingSeconds / 30, end: 0),
          duration: Duration(seconds: remainingSeconds),
          builder: (BuildContext context, double animatedProgress, Widget? child) {
            bool childAvailableBool = child != null;
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.flip(
                  flipX: true,
                  child: CircularProgressIndicator(
                    value: animatedProgress,
                    strokeWidth: 2.2,
                    backgroundColor: AppColors.lightGrey3,
                    color: AppColors.warningOrange,
                  ),
                ),
                if (childAvailableBool) child,
              ],
            );
          },
          child: Text(
            '$remainingSeconds',
            style: textTheme.labelLarge?.copyWith(color: AppColors.body3),
          ),
        ),
        suffixWidgetConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
