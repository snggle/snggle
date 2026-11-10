import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class PasswordGeneratorInitPage extends StatelessWidget {
  const PasswordGeneratorInitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'PASSWORD CHARACTERS',
      popAvailableBool: true,
      popButtonVisible: true,
      customPopCallback: () {
        StackRouter? parentRouter = context.router.parent<StackRouter>();

        bool parentAvailableBool = parentRouter != null;
        if (parentAvailableBool) {
          parentRouter.maybePop();
        }
      },
      body: Column(
        children: <Widget>[
          const Spacer(flex: 75),
          Stack(
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(passwordCharacterSetMode: PasswordCharacterSetMode.ascii)),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AssetIcon(AppIcons.password_generator_standard, size: 114),
                    SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: Center(child: Text('STANDARD')),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 12,
                bottom: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showStandardHintDialog(context),
                    child: const SizedBox(
                      width: 34,
                      height: 34,
                      child: AssetIcon(AppIcons.icon_help, size: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 75),
          Stack(
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(passwordCharacterSetMode: PasswordCharacterSetMode.sip2)),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AssetIcon(AppIcons.password_generator_snggle, size: 114),
                    SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: Center(child: Text('DISAMBIGUATED')),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 12,
                bottom: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showDisambiguatedHintDialog(context),
                    child: const SizedBox(
                      width: 34,
                      height: 34,
                      child: AssetIcon(AppIcons.icon_help, size: 25),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 75),
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(passwordCharacterSetMode: PasswordCharacterSetMode.advanced)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.password_generator_advanced, size: 114),
                SizedBox(height: 4),
                Text('ADVANCED'),
              ],
            ),
          ),
          const Spacer(flex: 200),
        ],
      ),
    );
  }

  Future<void> _showDisambiguatedHintDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Disambiguated character set',
        content: const Text(
          'This character set contains\n64 characters.'
          '\n\nUppercase letters:'
          '\nABCDEFGHJKLMNPQRSTUVWXYZ'
          '\n- all uppercase characters excluding I and O'
          '\n\nLowercase letters:'
          '\nabcdefghijkmnopqrstuvwxyz'
          '\n- all lowercase characters excluding l'
          '\n\nDigits:'
          '\n0123456789'
          '\n\nSymbols:'
          '\n!+-@='
          '\n\nDepending on password length, the last one or two characters in a password are not random, but constitute a checksum.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }

  Future<void> _showStandardHintDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Standard ASCII character set',
        content: const Text(
          'This character set contains\n94 characters.'
          '\n\nUppercase letters:'
          '\nABCDEFGHIJKLMNOPQRSTUVWXYZ'
          '\n\nLowercase letters:'
          '\nabcdefghijklmnopqrstuvwxyz'
          '\n\nDigits:'
          '\n0123456789'
          '\n\nSymbols:\n'
          r'''!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }
}
