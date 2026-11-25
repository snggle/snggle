import 'package:auto_route/auto_route.dart';
import 'package:snggle/shared/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  static const Duration _fadeDuration = Duration(milliseconds: 100);

  @override
  RouteType get defaultRouteType {
    return RouteType.custom(
      opaque: false,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: _fadeDuration,
      reverseDuration: _fadeDuration,
    );
  }

  @override
  List<AutoRoute> get routes {
    return <AutoRoute>[
      AutoRoute(
        page: SplashRoute.page,
        initial: true,
      ),
      AutoRoute(page: AppMasterKeyRemovedRoute.page),
      AutoRoute(page: AppMasterKeyCreateRoute.page),
      AutoRoute(page: AppMasterKeyRecoverRoute.page),
      AutoRoute(
        page: AppPinChangeRoute.page,
        children: <AutoRoute>[
          AutoRoute(page: AppPinAuthRoute.page, initial: true),
          AutoRoute(page: AppPinSetUpRoute.page),
        ],
      ),
      AutoRoute(page: AppPinSetUpRoute.page),
      AutoRoute(page: AppPinAuthRoute.page),
      AutoRoute(page: PrivacyPolicyRoute.page),
      AutoRoute(
        page: VaultCreateRecoverRoute.page,
        children: <AutoRoute>[
          AutoRoute(page: VaultInitRoute.page, initial: true),
          AutoRoute(page: VaultCreateRoute.page),
          AutoRoute(page: VaultRecoverRoute.page),
        ],
      ),
      AutoRoute(page: WalletCreateRoute.page),
      AutoRoute(page: EntryCreateEditRoute.page),
      AutoRoute(page: TwoFactorOptionsRoute.page),
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
              AutoRoute(page: WalletConnectRoute.page),
              AutoRoute(page: EthereumTransactionDetailsRoute.page),
              AutoRoute(page: SolanaTransactionDetailsRoute.page),
            ],
          ),
          AutoRoute(
            page: EntriesSectionWrapperRoute.page,
            children: <AutoRoute>[
              AutoRoute(page: EntryListRoute.page, initial: true),
              CustomRoute<void>(
                page: EntryDetailsRoute.page,
                opaque: false,
                transitionsBuilder: TransitionsBuilders.fadeIn,
                duration: Duration.zero,
                reverseDuration: _fadeDuration,
              ),
            ],
          ),
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
