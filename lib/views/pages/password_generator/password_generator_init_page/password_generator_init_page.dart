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

        if (parentRouter != null) {
          parentRouter.maybePop();
        }
      },
      body: Column(
        children: <Widget>[
          const Spacer(flex: 75),
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(characterSetMode: PasswordCharacterSetMode.ascii)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.password_generator_standard, size: 114),
                SizedBox(height: 4),
                Text('STANDARD'),
              ],
            ),
          ),
          const Spacer(flex: 75),
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(characterSetMode: PasswordCharacterSetMode.sip2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const AssetIcon(AppIcons.password_generator_snggle, size: 114),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    const Text('DISAMBIGUATED'),
                    InkWell(
                      onTap: () => _showDisambiguatedHintDialog(context),
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: AssetIcon(
                          AppIcons.icon_help,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(flex: 75),
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(characterSetMode: PasswordCharacterSetMode.advanced)),
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
        title: 'Special and ambiguous characters',
        content: const Text(
          'Full list of special characters:'
          '\n\n!"#\$%&\'()*+, -./:;<=>?@[\\]^_`{|}~'
          '\n\nRemoving ambiguous letters disables uppercase I and O, as well as lowercase l.',
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
        title: 'Special and ambiguous characters',
        content: const Text(
          'Full list of special characters:'
          '\n\n!"#\$%&\'()*+, -./:;<=>?@[\\]^_`{|}~'
          '\n\nRemoving ambiguous letters disables uppercase I and O, as well as lowercase l.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Close', onPressed: () {}),
        ],
      ),
    );
  }
}
