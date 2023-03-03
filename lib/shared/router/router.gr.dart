// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../../views/pages/app_auth_page.dart' as _i3;
import '../../views/pages/app_setup_pin_page.dart' as _i2;
import '../../views/pages/bottom_navigation/apps_page.dart' as _i7;
import '../../views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import '../../views/pages/bottom_navigation/secrets_page.dart' as _i6;
import '../../views/pages/bottom_navigation/settings_page.dart' as _i8;
import '../../views/pages/bottom_navigation/vault_list_page.dart' as _i5;
import '../../views/pages/splash_page.dart' as _i1;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: _i1.SplashPage(key: args.key),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppAuthRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i3.AppAuthPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i5.VaultListPage(),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i6.SecretsPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i7.AppsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i9.MaterialPageX<void>(
        routeData: routeData,
        child: const _i8.SettingsPage(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i9.RouteConfig(
          AppSetupPinRoute.name,
          path: '/app-setup-pin-page',
        ),
        _i9.RouteConfig(
          AppAuthRoute.name,
          path: '/app-auth-page',
        ),
        _i9.RouteConfig(
          BottomNavigationRoute.name,
          path: '/bottom-navigation-wrapper',
          children: [
            _i9.RouteConfig(
              VaultListRoute.name,
              path: 'vault-list-page',
              parent: BottomNavigationRoute.name,
            ),
            _i9.RouteConfig(
              SecretsRoute.name,
              path: 'secrets-page',
              parent: BottomNavigationRoute.name,
            ),
            _i9.RouteConfig(
              AppsRoute.name,
              path: 'apps-page',
              parent: BottomNavigationRoute.name,
            ),
            _i9.RouteConfig(
              SettingsRoute.name,
              path: 'settings-page',
              parent: BottomNavigationRoute.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({_i10.Key? key})
      : super(
          SplashRoute.name,
          path: '/',
          args: SplashRouteArgs(key: key),
        );

  static const String name = 'SplashRoute';
}

class SplashRouteArgs {
  const SplashRouteArgs({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i9.PageRouteInfo<void> {
  const AppSetupPinRoute()
      : super(
          AppSetupPinRoute.name,
          path: '/app-setup-pin-page',
        );

  static const String name = 'AppSetupPinRoute';
}

/// generated route for
/// [_i3.AppAuthPage]
class AppAuthRoute extends _i9.PageRouteInfo<void> {
  const AppAuthRoute()
      : super(
          AppAuthRoute.name,
          path: '/app-auth-page',
        );

  static const String name = 'AppAuthRoute';
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i9.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          path: '/bottom-navigation-wrapper',
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';
}

/// generated route for
/// [_i5.VaultListPage]
class VaultListRoute extends _i9.PageRouteInfo<void> {
  const VaultListRoute()
      : super(
          VaultListRoute.name,
          path: 'vault-list-page',
        );

  static const String name = 'VaultListRoute';
}

/// generated route for
/// [_i6.SecretsPage]
class SecretsRoute extends _i9.PageRouteInfo<void> {
  const SecretsRoute()
      : super(
          SecretsRoute.name,
          path: 'secrets-page',
        );

  static const String name = 'SecretsRoute';
}

/// generated route for
/// [_i7.AppsPage]
class AppsRoute extends _i9.PageRouteInfo<void> {
  const AppsRoute()
      : super(
          AppsRoute.name,
          path: 'apps-page',
        );

  static const String name = 'AppsRoute';
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i9.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings-page',
        );

  static const String name = 'SettingsRoute';
}
