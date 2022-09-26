import 'package:auto_route/auto_route.dart';
import 'package:snuggle/views/pages/pages_wrapper.dart';

@CustomAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: PagesWrapper,
    initial: true,
  ),
])
class $AppRouter {}
