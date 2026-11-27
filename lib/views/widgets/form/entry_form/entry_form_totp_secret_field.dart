import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class EntryFormTotpSecretField extends StatelessWidget {
  final bool obscureSecretBool;
  final bool secretInvalidBool;
  final TextEditingController secretTextEditingController;
  final VoidCallback onToggleSecretVisibility;

  const EntryFormTotpSecretField({
    required this.obscureSecretBool,
    required this.secretTextEditingController,
    required this.onToggleSecretVisibility,
    this.secretInvalidBool = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        EntryFormField(
          label: 'TOTP Secret Key',
          textEditingController: secretTextEditingController,
          readOnlyBool: false,
          autofocusBool: true,
          obscureTextBool: obscureSecretBool,
          tapToCopyBool: false,
          suffixWidget: InkWell(
            onTap: onToggleSecretVisibility,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: AssetIcon(obscureSecretBool ? AppIcons.details_hide : AppIcons.details_show),
            ),
          ),
          suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
        ),
        if (secretInvalidBool)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ErrorMessageListTile(message: 'Secret is invalid'),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
