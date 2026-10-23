import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
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
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(characterSetMode: PasswordCharacterSetMode.ascii)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.connect_wallet_qr, size: 144),
                SizedBox(height: 4),
                Text('STANDARD'),
              ],
            ),
          ),
          const Spacer(flex: 50),
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(characterSetMode: PasswordCharacterSetMode.sip2)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.connect_wallet_qr, size: 144),
                SizedBox(height: 4),
                Text('DISAMBIGUATED'),
              ],
            ),
          ),
          const Spacer(flex: 50),
          TextButton(
            onPressed: () => AutoRouter.of(context).push<String>(GeneratePasswordRoute(characterSetMode: PasswordCharacterSetMode.advanced)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.connect_wallet_qr, size: 144),
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
}
