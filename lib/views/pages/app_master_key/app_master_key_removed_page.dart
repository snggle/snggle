import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/button/gif_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class AppMasterKeyRemovedPage extends StatelessWidget {
  const AppMasterKeyRemovedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '',
      closeButtonVisible: false,
      popAvailableBool: false,
      popButtonVisible: false,
      body: Column(
        children: <Widget>[
          const Text(
            'NEW SNGGLE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500,
              letterSpacing: 4,
            ),
          ),
          const Spacer(flex: 60),
          GifButton(
            label: 'CREATE',
            assetAnimatedIconData: AppAnimatedIcons.snggle_face,
            onPressed: () => AutoRouter.of(context).push(AppMasterKeyCreateRoute()),
          ),
          const Spacer(flex: 30),
          GifButton(
            label: 'RECOVER',
            assetAnimatedIconData: AppAnimatedIcons.vault_recover,
            onPressed: () => AutoRouter.of(context).push(const AppMasterKeyRecoverRoute()),
          ),
          const Spacer(flex: 200),
        ],
      ),
    );
  }
}
