import 'package:auto_route/auto_route.dart';
import 'package:snggle/views/pages/app_setup_pin_page.dart';
import 'package:snggle/views/pages/empty_page.dart';
import 'package:snggle/views/pages/splash_page.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: SplashPage,
    initial: true,
  ),
  AutoRoute<void>(
    page: AppSetupPinPage,
  ),
  AutoRoute<void>(
    page: EmptyPage,
  ),
])
class $AppRouter {}
