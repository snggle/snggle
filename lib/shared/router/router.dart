import 'package:auto_route/auto_route.dart';
import 'package:snuggle/views/pages/empty_page.dart';
import 'package:snuggle/views/pages/vault_list_page/vault_list_page.dart';

@CustomAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: VaultListPage,
    initial: true,
  ),
  AutoRoute<void>(
    page: EmptyPage,
  ),
])
class $AppRouter {}
