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
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../../views/pages/empty_page.dart' as _i2;
import '../../views/pages/vault_list_page/vault_list_page.dart' as _i1;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    VaultListRoute.name: (routeData) {
      return _i3.CustomPage<void>(
        routeData: routeData,
        child: const _i1.VaultListPage(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    EmptyRoute.name: (routeData) {
      return _i3.CustomPage<void>(
        routeData: routeData,
        child: const _i2.EmptyPage(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(
          VaultListRoute.name,
          path: '/',
        ),
        _i3.RouteConfig(
          EmptyRoute.name,
          path: '/empty-page',
        ),
      ];
}

/// generated route for
/// [_i1.VaultListPage]
class VaultListRoute extends _i3.PageRouteInfo<void> {
  const VaultListRoute()
      : super(
          VaultListRoute.name,
          path: '/',
        );

  static const String name = 'VaultListRoute';
}

/// generated route for
/// [_i2.EmptyPage]
class EmptyRoute extends _i3.PageRouteInfo<void> {
  const EmptyRoute()
      : super(
          EmptyRoute.name,
          path: '/empty-page',
        );

  static const String name = 'EmptyRoute';
}
