import 'package:auto_route/auto_route.dart';
import 'package:snuggle/views/pages/empty_page.dart';
import 'package:snuggle/views/pages/setup_pin_page.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: SetupPinPage,
    initial: true,
  ),
  AutoRoute<void>(
    page: EmptyPage,
  ),
])
class $AppRouter {}
