import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/button/gif_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage<VaultCreateRecoverStatus?>()
class VaultInitPage extends StatelessWidget {
  const VaultInitPage({super.key});

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
            gifPath: 'assets/gifs/vault_create.gif',
            onPressed: () => AutoRouter.of(context).push(const VaultCreateRoute()),
          ),
          const Spacer(flex: 30),
          GifButton(
            label: 'RECOVER',
            gifPath: 'assets/gifs/vault_recover.gif',
            onPressed: () => AutoRouter.of(context).push(const VaultRecoverRoute()),
          ),
          const Spacer(flex: 200),
        ],
      ),
    );
  }
}