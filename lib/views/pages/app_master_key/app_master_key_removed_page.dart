import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/shared/native/app_launch_mode.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/button/gif_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/app_unavailable_dialog.dart';

@RoutePage()
class AppMasterKeyRemovedPage extends StatefulWidget {
  final AppLaunchMode appLaunchMode;

  const AppMasterKeyRemovedPage({
    required this.appLaunchMode,
    super.key,
  });

  @override
  State<AppMasterKeyRemovedPage> createState() => _AppMasterKeyRemovedPageState();
}

class _AppMasterKeyRemovedPageState extends State<AppMasterKeyRemovedPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '',
      closeButtonVisible: false,
      popAvailableBool: true,
      popButtonVisible: false,
      body: widget.appLaunchMode == AppLaunchMode.main
          ? Column(
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
                  onPressed: () => AutoRouter.of(context).push(const AppMasterKeyCreateRoute()),
                ),
                const Spacer(flex: 30),
                GifButton(
                  label: 'RECOVER',
                  assetAnimatedIconData: AppAnimatedIcons.vault_recover,
                  onPressed: () => AutoRouter.of(context).push(const AppMasterKeyRecoverRoute()),
                ),
                const Spacer(flex: 200),
              ],
            )
          : AppUnavailableDialog(
              appLaunchMode: widget.appLaunchMode,
            ),
    );
  }
}
