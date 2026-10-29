import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class EntryFormField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool readOnlyBool;
  final FocusNode? focusNode;
  final bool obscureTextBool;
  final bool obscureClipboardContentBool;
  final Widget? suffixWidget;
  final BoxConstraints? suffixWidgetConstraints;

  const EntryFormField({
    required this.label,
    required this.textEditingController,
    required this.readOnlyBool,
    this.focusNode,
    this.obscureTextBool = false,
    this.obscureClipboardContentBool = false,
    this.suffixWidget,
    this.suffixWidgetConstraints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: readOnlyBool
          ? CopyWrapper.withCopyAction(
              value: textEditingController.text,
              obscureContentBool: obscureClipboardContentBool,
              copyCallbackBuilder: (BuildContext context, VoidCallback copy) => LabelWrapperVertical.textField(
                label: label,
                labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                labelPadding: EdgeInsets.zero,
                child: CustomTextField(
                  readOnlyBool: readOnlyBool,
                  enableInteractiveSelectionBool: readOnlyBool == false,
                  textEditingController: textEditingController,
                  inputBorder: InputBorder.none,
                  keyboardType: TextInputType.text,
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  obscureTextBool: obscureTextBool,
                  onTap: copy,
                  suffixWidget: suffixWidget,
                  suffixWidgetConstraints: suffixWidgetConstraints,
                ),
              ),
            )
          : LabelWrapperVertical.textField(
              label: label,
              labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
              labelPadding: EdgeInsets.zero,
              child: CustomTextField(
                focusNode: focusNode,
                readOnlyBool: readOnlyBool,
                enableInteractiveSelectionBool: readOnlyBool == false,
                textEditingController: textEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                obscureTextBool: obscureTextBool,
                suffixWidget: suffixWidget,
                suffixWidgetConstraints: suffixWidgetConstraints,
              ),
            ),
    );
  }
}
