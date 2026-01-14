import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/entries/entries_create_recover_status.dart';

@RoutePage<EntryCreateRecoverStatus?>(name: 'EntryCreateRecoverRoute')
class EntryCreateRecoverWrapper extends StatelessWidget {
  const EntryCreateRecoverWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
