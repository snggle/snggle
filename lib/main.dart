import 'package:flutter/material.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/entity/vaults/vault_entity.dart';
import 'package:snuggle/infra/secure_collection_manager.dart';
import 'package:snuggle/shared/router/router.gr.dart';

void main() {
  initLocator();

  // TODO(dominik): Temporary solution to initialize the vaults database. This should be done in the "login" screen or some kind of splash screen.
  globalLocator.registerLazySingleton<SecureCollectionManager<VaultEntity>>(
    () => SecureCollectionManager<VaultEntity>(
      storageKey: 'vaults',
      entityJsonFactory: VaultEntity.fromJson,
      password: '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0',
    ),
  );
  runApp(const AppCore());
}

class AppCore extends StatefulWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppCoreState();
}

class _AppCoreState extends State<AppCore> {
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: appRouter.defaultRouteParser(),
      routerDelegate: appRouter.delegate(),
      debugShowCheckedModeBanner: false,
      builder: (_, Widget? routerWidget) {
        return routerWidget as Widget;
      },
    );
  }
}
