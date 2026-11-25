import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class EntryFormTotpSecretField extends StatelessWidget {
  final bool obscureSecretBool;
  final bool readOnlyBool;
  final bool secretFieldVisibleBool;
  final bool secretInvalidBool;
  final bool totpExistsBool;
  final FocusNode secretFocusNode;
  final TextEditingController secretTextEditingController;
  final VoidCallback onToggleSecretVisibility;
  final VoidCallback? onSelectTwoFactorType;

  const EntryFormTotpSecretField({
    required this.obscureSecretBool,
    required this.readOnlyBool,
    required this.secretFieldVisibleBool,
    required this.secretInvalidBool,
    required this.totpExistsBool,
    required this.secretFocusNode,
    required this.secretTextEditingController,
    required this.onToggleSecretVisibility,
    this.onSelectTwoFactorType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool optionsVisibleBool = onSelectTwoFactorType != null;

    return Column(
      children: <Widget>[
        if (secretFieldVisibleBool) ...<Widget>[
          const SizedBox(height: 12),
          EntryFormField(
            label: 'TOTP Secret Key',
            textEditingController: secretTextEditingController,
            readOnlyBool: readOnlyBool,
            autofocusBool: readOnlyBool == false,
            focusNode: secretFocusNode,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[A-Za-z2-7=]'))],
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
        if (optionsVisibleBool)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 25),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  GradientOutlinedButton.small(
                    width: 176,
                    label: totpExistsBool ? '2FA Options' : 'Enable 2FA',
                    onPressed: onSelectTwoFactorType,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showTotpHintDialog(context),
                        child: const SizedBox(
                          width: 34,
                          height: 34,
                          child: AssetIcon(AppIcons.help, size: 25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showTotpHintDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: '2 Factor Authentication\n',
        content: const Text(
          '2FA is an electronic authentication method in which a user is granted access to a service only after successfully presenting '
          'at least two distinct types of evidence (or factors) to an authentication mechanism. It prevents a single point of failure '
          '(e.g. leaked password) from compromising personal data.\n\n'
          'Time-based One-Time Password (TOTP) 2FA can be enabled by providing the TOTP secret, either inserting it manually or in a form of a QR code. '
          'Setting a new secret will overwrite the already existing one. Manually inserting an empty secret will disable 2FA.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }
}
