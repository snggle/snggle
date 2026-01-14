import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/shared/models/entries/entries_create_recover_status.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/button/gif_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage<EntryCreateRecoverStatus?>()
class EntryInitPage extends StatelessWidget {
  final FilesystemPath parentFilesystemPath;

  const EntryInitPage({
    required this.parentFilesystemPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '',
      closeButtonVisible: true,
      popAvailableBool: true,
      popButtonVisible: true,
      body: Column(
        children: <Widget>[
          const Text(
            'SECRET',
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
            onPressed: () =>
                AutoRouter.of(context).push(EntryCreateRoute(parentFilesystemPath: parentFilesystemPath, entryPageType: EntryPageType.create)),
          ),
          const Spacer(flex: 30),
          /*GifButton(
            label: 'RECOVER',
            assetAnimatedIconData: AppAnimatedIcons.vault_recover,
            onPressed: () => AutoRouter.of(context).push(VaultRecoverRoute(parentFilesystemPath: parentFilesystemPath)),
          ),*/
          const Spacer(flex: 200),
        ],
      ),
    );
  }
}
