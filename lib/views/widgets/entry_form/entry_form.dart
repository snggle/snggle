import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/entry_form/entry_form_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
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
          EntryFormField(
            readOnlyBool: readOnlyBool,
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
        EntryFormField(
          readOnlyBool: readOnlyBool,
          label: 'Website',
          textEditingController: websiteTextEditingController,
        ),
        const SizedBox(height: 12),
        EntryFormField(
          readOnlyBool: readOnlyBool,
          label: 'Email',
          textEditingController: emailTextEditingController,
        ),
        const SizedBox(height: 12),
        EntryFormField(
          readOnlyBool: readOnlyBool,
          label: 'Username',
          textEditingController: usernameTextEditingController,
        ),
        const SizedBox(height: 12),
        EntryFormField(
          readOnlyBool: readOnlyBool,
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
}
