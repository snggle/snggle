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
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;

import '../../views/pages/app_auth_page.dart' as _i3;
import '../../views/pages/app_setup_pin_page.dart' as _i2;
import '../../views/pages/bottom_navigation/apps_page.dart' as _i9;
import '../../views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import '../../views/pages/bottom_navigation/secrets_page.dart' as _i8;
import '../../views/pages/bottom_navigation/settings_page.dart' as _i10;
import '../../views/pages/bottom_navigation/vault_list_page.dart' as _i7;
import '../../views/pages/complete_scan_page.dart' as _i6;
import '../../views/pages/qr_code_scan_page.dart' as _i5;
import '../../views/pages/splash_page.dart' as _i1;

class AppRouter extends _i11.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: _i1.SplashPage(key: args.key),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppAuthRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i3.AppAuthPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    QrCodeScanRoute.name: (routeData) {
      final args = routeData.argsAs<QrCodeScanRouteArgs>(
          orElse: () => const QrCodeScanRouteArgs());
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: _i5.QrCodeScanPage(key: args.key),
      );
    },
    CompleteScanRoute.name: (routeData) {
      final args = routeData.argsAs<CompleteScanRouteArgs>();
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: _i6.CompleteScanPage(
          decodedString: args.decodedString,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i7.VaultListPage(),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i8.SecretsPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i9.AppsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i11.MaterialPageX<void>(
        routeData: routeData,
        child: const _i10.SettingsPage(),
      );
    },
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i11.RouteConfig(
          AppSetupPinRoute.name,
          path: '/app-setup-pin-page',
        ),
        _i11.RouteConfig(
          AppAuthRoute.name,
          path: '/app-auth-page',
        ),
        _i11.RouteConfig(
          BottomNavigationRoute.name,
          path: '/bottom-navigation-wrapper',
          children: [
            _i11.RouteConfig(
              VaultListRoute.name,
              path: 'vault-list-page',
              parent: BottomNavigationRoute.name,
            ),
            _i11.RouteConfig(
              SecretsRoute.name,
              path: 'secrets-page',
              parent: BottomNavigationRoute.name,
            ),
            _i11.RouteConfig(
              AppsRoute.name,
              path: 'apps-page',
              parent: BottomNavigationRoute.name,
            ),
            _i11.RouteConfig(
              SettingsRoute.name,
              path: 'settings-page',
              parent: BottomNavigationRoute.name,
            ),
          ],
        ),
        _i11.RouteConfig(
          QrCodeScanRoute.name,
          path: '/qr-code-scan-page',
        ),
        _i11.RouteConfig(
          CompleteScanRoute.name,
          path: '/complete-scan-page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i11.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({_i12.Key? key})
      : super(
          SplashRoute.name,
          path: '/',
          args: SplashRouteArgs(key: key),
        );

  static const String name = 'SplashRoute';
}

class SplashRouteArgs {
  const SplashRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i11.PageRouteInfo<void> {
  const AppSetupPinRoute()
      : super(
          AppSetupPinRoute.name,
          path: '/app-setup-pin-page',
        );

  static const String name = 'AppSetupPinRoute';
}

/// generated route for
/// [_i3.AppAuthPage]
class AppAuthRoute extends _i11.PageRouteInfo<void> {
  const AppAuthRoute()
      : super(
          AppAuthRoute.name,
          path: '/app-auth-page',
        );

  static const String name = 'AppAuthRoute';
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i11.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i11.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          path: '/bottom-navigation-wrapper',
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';
}

/// generated route for
/// [_i5.QrCodeScanPage]
class QrCodeScanRoute extends _i11.PageRouteInfo<QrCodeScanRouteArgs> {
  QrCodeScanRoute({_i12.Key? key})
      : super(
          QrCodeScanRoute.name,
          path: '/qr-code-scan-page',
          args: QrCodeScanRouteArgs(key: key),
        );

  static const String name = 'QrCodeScanRoute';
}

class QrCodeScanRouteArgs {
  const QrCodeScanRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'QrCodeScanRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.CompleteScanPage]
class CompleteScanRoute extends _i11.PageRouteInfo<CompleteScanRouteArgs> {
  CompleteScanRoute({
    required String decodedString,
    _i12.Key? key,
  }) : super(
          CompleteScanRoute.name,
          path: '/complete-scan-page',
          args: CompleteScanRouteArgs(
            decodedString: decodedString,
            key: key,
          ),
        );

  static const String name = 'CompleteScanRoute';
}

class CompleteScanRouteArgs {
  const CompleteScanRouteArgs({
    required this.decodedString,
    this.key,
  });

  final String decodedString;

  final _i12.Key? key;

  @override
  String toString() {
    return 'CompleteScanRouteArgs{decodedString: $decodedString, key: $key}';
  }
}

/// generated route for
/// [_i7.VaultListPage]
class VaultListRoute extends _i11.PageRouteInfo<void> {
  const VaultListRoute()
      : super(
          VaultListRoute.name,
          path: 'vault-list-page',
        );

  static const String name = 'VaultListRoute';
}

/// generated route for
/// [_i8.SecretsPage]
class SecretsRoute extends _i11.PageRouteInfo<void> {
  const SecretsRoute()
      : super(
          SecretsRoute.name,
          path: 'secrets-page',
        );

  static const String name = 'SecretsRoute';
}

/// generated route for
/// [_i9.AppsPage]
class AppsRoute extends _i11.PageRouteInfo<void> {
  const AppsRoute()
      : super(
          AppsRoute.name,
          path: 'apps-page',
        );

  static const String name = 'AppsRoute';
}

/// generated route for
/// [_i10.SettingsPage]
class SettingsRoute extends _i11.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings-page',
        );

  static const String name = 'SettingsRoute';
}
