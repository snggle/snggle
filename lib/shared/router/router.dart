import 'package:auto_route/auto_route.dart';
import 'package:snuggle/views/pages/auth_page.dart';
import 'package:snuggle/views/pages/initial_page.dart';
import 'package:snuggle/views/pages/main_page.dart';
import 'package:snuggle/views/pages/setup_pin_page.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: InitPage,
    initial: true,
  ),
  AutoRoute<void>(
    page: SetupPinPage,
  ),
  AutoRoute<void>(
    page: MainPage,
  ),
  AutoRoute<void>(
    page: AuthPage,
  ),
])
class $AppRouter {}
