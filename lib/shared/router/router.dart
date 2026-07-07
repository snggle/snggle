import 'package:auto_route/auto_route.dart';
import 'package:snggle/shared/router/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType {
    return RouteType.custom(
      opaque: false,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
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
      AutoRoute(page: AppSetUpPinRoute.page),
      AutoRoute(page: AppEnterPinRoute.page),
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
      AutoRoute(
        page: ReadOnlyEntriesSectionWrapperRoute.page,
        children: <AutoRoute>[
          AutoRoute(page: ReadOnlyEntryListRoute.page, initial: true),
          AutoRoute(page: ReadOnlyEntryDetailsRoute.page),
        ],
      ),
      AutoRoute(page: AutofillSaveEntryRoute.page),
      AutoRoute(page: EntryDetailsEditableRoute.page),
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
              AutoRoute(page: EntryDetailsRoute.page),
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
