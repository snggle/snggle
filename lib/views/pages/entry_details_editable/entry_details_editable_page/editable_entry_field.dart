import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class EditableEntryField extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool autofocusBool;
  final bool obscureTextBool;
  final bool readOnlyBool;
  final FocusNode? focusNode;
  final BoxConstraints? suffixWidgetConstraints;
  final Widget? suffixWidget;

  const EditableEntryField({
    required this.label,
    required this.textEditingController,
    this.autofocusBool = false,
    this.obscureTextBool = false,
    this.readOnlyBool = false,
    this.focusNode,
    this.suffixWidgetConstraints,
    this.suffixWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LabelWrapperVertical.textField(
        label: label,
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
        labelPadding: EdgeInsets.zero,
        child: CustomTextField(
          autofocusBool: autofocusBool,
          readOnlyBool: readOnlyBool,
          focusNode: focusNode,
          enableInteractiveSelectionBool: true,
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
