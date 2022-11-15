import 'package:auto_route/auto_route.dart';
import 'package:snuggle/views/pages/pages_wrapper.dart';
import 'package:snuggle/views/pages/vaults_list_page/vault_list_page.dart';
import 'package:snuggle/views/pages/wallets_list_page/wallets_list_page.dart';

@CustomAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: PagesWrapper,
  ),
  AutoRoute<void>(
    page: VaultListPage,
    initial: true,
  ),
  AutoRoute<void>(
    page: WalletsListPage,
  ),
])
class $AppRouter {}
