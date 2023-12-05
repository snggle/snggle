import 'package:auto_route/auto_route.dart';
import 'package:snggle/shared/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes {
    return <AutoRoute>[
      AutoRoute(
        page: SplashRoute.page,
        initial: true,
      ),
      AutoRoute(
        page: AppSetupPinRoute.page,
      ),
      AutoRoute(
        page: AppAuthRoute.page,
      ),
      AutoRoute(
        page: BottomNavigationRoute.page,
        maintainState: true,
        children: <AutoRoute>[
          AutoRoute(page: VaultListRoute.page),
          AutoRoute(page: SecretsRoute.page),
          AutoRoute(page: AppsRoute.page),
          AutoRoute(page: SettingsRoute.page),
        ],
      ),
    ];
  }
}
