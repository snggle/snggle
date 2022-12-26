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
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../views/pages/authenticate_page.dart' as _i4;
import '../../views/pages/empty_page.dart' as _i3;
import '../../views/pages/initial_page.dart' as _i1;
import '../../views/pages/setup_pin_page.dart' as _i2;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    InitialRoute.name: (routeData) {
      final args = routeData.argsAs<InitialRouteArgs>(
          orElse: () => const InitialRouteArgs());
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: _i1.InitialPage(key: args.key),
      );
    },
    SetupPinRoute.name: (routeData) {
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: const _i2.SetupPinPage(),
      );
    },
    EmptyRoute.name: (routeData) {
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: const _i3.EmptyPage(),
      );
    },
    AuthenticateRoute.name: (routeData) {
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: const _i4.AuthenticatePage(),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          InitialRoute.name,
          path: '/',
        ),
        _i5.RouteConfig(
          SetupPinRoute.name,
          path: '/setup-pin-page',
        ),
        _i5.RouteConfig(
          EmptyRoute.name,
          path: '/empty-page',
        ),
        _i5.RouteConfig(
          AuthenticateRoute.name,
          path: '/authenticate-page',
        ),
      ];
}

/// generated route for
/// [_i1.InitialPage]
class InitialRoute extends _i5.PageRouteInfo<InitialRouteArgs> {
  InitialRoute({_i6.Key? key})
      : super(
          InitialRoute.name,
          path: '/',
          args: InitialRouteArgs(key: key),
        );

  static const String name = 'InitialRoute';
}

class InitialRouteArgs {
  const InitialRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'InitialRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SetupPinPage]
class SetupPinRoute extends _i5.PageRouteInfo<void> {
  const SetupPinRoute()
      : super(
          SetupPinRoute.name,
          path: '/setup-pin-page',
        );

  static const String name = 'SetupPinRoute';
}

/// generated route for
/// [_i3.EmptyPage]
class EmptyRoute extends _i5.PageRouteInfo<void> {
  const EmptyRoute()
      : super(
          EmptyRoute.name,
          path: '/empty-page',
        );

  static const String name = 'EmptyRoute';
}

/// generated route for
/// [_i4.AuthenticatePage]
class AuthenticateRoute extends _i5.PageRouteInfo<void> {
  const AuthenticateRoute()
      : super(
          AuthenticateRoute.name,
          path: '/authenticate-page',
        );

  static const String name = 'AuthenticateRoute';
}
