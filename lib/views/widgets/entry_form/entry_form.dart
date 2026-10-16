import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class EntryForm extends StatelessWidget {
  final TextEditingController? nameTextEditingController;
  final TextEditingController websiteTextEditingController;
  final TextEditingController emailTextEditingController;
  final TextEditingController usernameTextEditingController;
  final TextEditingController passwordTextEditingController;
  final bool readOnlyBool;
  final bool entryNameEmptyBool;
  final bool obscurePasswordBool;
  final VoidCallback onTogglePasswordVisibility;

  const EntryForm({
    required this.websiteTextEditingController,
    required this.emailTextEditingController,
    required this.usernameTextEditingController,
    required this.passwordTextEditingController,
    required this.readOnlyBool,
    required this.obscurePasswordBool,
    required this.onTogglePasswordVisibility,
    this.nameTextEditingController,
    this.entryNameEmptyBool = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        if (nameTextEditingController != null) ...<Widget>[
          _buildEntryField(
            context: context,
            label: 'Name',
            textEditingController: nameTextEditingController!,
          ),
          if (entryNameEmptyBool)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ErrorMessageListTile(
                message: 'Entry name cannot be empty',
              ),
            ),
          const SizedBox(height: 12),
        ],
        _buildEntryField(
          context: context,
          label: 'Website',
          textEditingController: websiteTextEditingController,
        ),
        const SizedBox(height: 12),
        _buildEntryField(
          context: context,
          label: 'Email',
          textEditingController: emailTextEditingController,
        ),
        const SizedBox(height: 12),
        _buildEntryField(
          context: context,
          label: 'Username',
          textEditingController: usernameTextEditingController,
        ),
        const SizedBox(height: 12),
        _buildEntryField(
          context: context,
          label: 'Password',
          textEditingController: passwordTextEditingController,
          obscureTextBool: obscurePasswordBool,
          obscureClipboardContentBool: true,
          suffixWidget: InkWell(
            onTap: onTogglePasswordVisibility,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: AssetIcon(
                obscurePasswordBool ? AppIcons.details_hide : AppIcons.details_show,
              ),
            ),
          ),
          suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
        ),
      ],
    );
  }

  Widget _buildEntryField({
    required BuildContext context,
    required String label,
    required TextEditingController textEditingController,
    bool obscureTextBool = false,
    bool obscureClipboardContentBool = false,
    Widget? suffixWidget,
    BoxConstraints? suffixWidgetConstraints,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: readOnlyBool
          ? CopyWrapper.withCopyAction(
              value: textEditingController.text,
              obscureContentBool: obscureClipboardContentBool,
              copyCallbackBuilder: (BuildContext context, VoidCallback copy) => _buildTextField(
                context: context,
                label: label,
                textEditingController: textEditingController,
                obscureTextBool: obscureTextBool,
                onTap: copy,
                suffixWidget: suffixWidget,
                suffixWidgetConstraints: suffixWidgetConstraints,
              ),
            )
          : _buildTextField(
              context: context,
              label: label,
              textEditingController: textEditingController,
              obscureTextBool: obscureTextBool,
              suffixWidget: suffixWidget,
              suffixWidgetConstraints: suffixWidgetConstraints,
            ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController textEditingController,
    bool obscureTextBool = false,
    VoidCallback? onTap,
    Widget? suffixWidget,
    BoxConstraints? suffixWidgetConstraints,
  }) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return LabelWrapperVertical.textField(
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
        onTap: onTap,
        suffixWidget: suffixWidget,
        suffixWidgetConstraints: suffixWidgetConstraints,
      ),
    );
  }
}
