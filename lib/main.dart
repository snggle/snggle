import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/theme_config.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  initLocator();
  await globalLocator<IsarDatabaseManager>().initDatabase();

  await const FlutterSecureStorage().deleteAll();

// For each key in "snggle/test/mocks/fullDatabaseMock/secure_storage_mock.json"
  await const FlutterSecureStorage().write(key: 'encryptedMasterKey', value: 'FhSf0rK3enK3orHHM4McWIYhZ8YiT0V3mn6rTyWScdPYgaO+McvLXYtcGAX2CGNFQYLdYsEzwXO/DcMGjSICqa0nFdE=');

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
      theme: ThemeConfig().buildTheme(),
      debugShowCheckedModeBanner: false,
      builder: (_, Widget? routerWidget) {
        return routerWidget as Widget;
      },
    );
  }
}
