// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i5;
import 'package:snggle/views/pages/bottom_navigation/settings_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/vault_list_page.dart'
    as _i8;
import 'package:snggle/views/pages/splash_page.dart' as _i7;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.SplashPage(key: args.key),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.VaultListPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AppAuthPage]
class AppAuthRoute extends _i9.PageRouteInfo<void> {
  const AppAuthRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i9.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i9.PageRouteInfo<void> {
  const AppsRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i9.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SecretsPage]
class SecretsRoute extends _i9.PageRouteInfo<void> {
  const SecretsRoute({List<_i9.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SettingsPage]
class SettingsRoute extends _i9.PageRouteInfo<void> {
  const SettingsRoute({List<_i9.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i9.PageInfo<SplashRouteArgs> page =
      _i9.PageInfo<SplashRouteArgs>(name);
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
/// [_i8.VaultListPage]
class VaultListRoute extends _i9.PageRouteInfo<void> {
  const VaultListRoute({List<_i9.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}
