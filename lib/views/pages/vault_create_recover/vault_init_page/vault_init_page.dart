import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/button/gif_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class VaultInitPage extends StatelessWidget {
  final FilesystemPath parentFilesystemPath;

  const VaultInitPage({
    required this.parentFilesystemPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '',
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
          const Text(
            'VAULT',
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
            assetAnimatedIconData: AppAnimatedIcons.vault_create,
            onPressed: () => AutoRouter.of(context).push(VaultCreateRoute(parentFilesystemPath: parentFilesystemPath)),
          ),
          const Spacer(flex: 30),
          GifButton(
            label: 'RECOVER',
            assetAnimatedIconData: AppAnimatedIcons.vault_recover,
            onPressed: () => context.router.push(VaultRecoverRoute(parentFilesystemPath: parentFilesystemPath)),
          ),
          const Spacer(flex: 200),
        ],
      ),
    );
  }
}
