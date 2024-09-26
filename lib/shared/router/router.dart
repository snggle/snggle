import 'package:auto_route/auto_route.dart';
import 'package:snggle/shared/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType {
    return const RouteType.custom(
      opaque: false,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 100,
      reverseDurationInMilliseconds: 100,
    );
  }

  @override
  List<AutoRoute> get routes {
    return <AutoRoute>[
      AutoRoute(
        page: SplashRoute.page,
        initial: true,
      ),
      AutoRoute(page: AppSetupPinRoute.page),
      AutoRoute(page: AppAuthRoute.page),
      AutoRoute(
        page: VaultCreateRecoverRoute.page,
        children: <AutoRoute>[
          AutoRoute(page: VaultInitRoute.page, initial: true),
          AutoRoute(page: VaultCreateRoute.page),
          AutoRoute(page: VaultRecoverRoute.page),
        ],
      ),
      AutoRoute(page: WalletCreateRoute.page),
      AutoRoute(page: TransactionDetailsRoute.page),
      AutoRoute(
        page: BottomNavigationRoute.page,
        maintainState: true,
        children: <AutoRoute>[
          AutoRoute(
            page: VaultsSectionWrapperRoute.page,
            children: <AutoRoute>[
              AutoRoute(page: VaultListRoute.page, initial: true),
              AutoRoute(page: NetworkListRoute.page),
              AutoRoute(page: WalletListRoute.page),
              AutoRoute(page: WalletDetailsRoute.page),
              AutoRoute(page: TransactionDetailsRoute.page),
              AutoRoute(page: WalletConnectRoute.page),
            ],
          ),
          AutoRoute(page: VaultListRoute.page),
          AutoRoute(page: WalletListRoute.page),
          AutoRoute(page: SecretsRoute.page),
          AutoRoute(page: AppsRoute.page),
          AutoRoute(
            page: SettingsSectionWrapperRoute.page,
            children: <AutoRoute>[
              AutoRoute(page: SettingsRoute.page, initial: true),
            ],
          ),
        ],
      ),
    ];
  }
}
