import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart';

@RoutePage<VaultCreateRecoverStatus?>(name: 'VaultCreateRecoverRoute')
class VaultCreateRecoverWrapper extends StatelessWidget {
  const VaultCreateRecoverWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
