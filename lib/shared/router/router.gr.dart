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

import '../../views/pages/auth_page.dart' as _i4;
import '../../views/pages/initial_page.dart' as _i1;
import '../../views/pages/main_page.dart' as _i3;
import '../../views/pages/setup_pin_page.dart' as _i2;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    InitRoute.name: (routeData) {
      final args =
          routeData.argsAs<InitRouteArgs>(orElse: () => const InitRouteArgs());
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: _i1.InitPage(key: args.key),
      );
    },
    SetupPinRoute.name: (routeData) {
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: const _i2.SetupPinPage(),
      );
    },
    MainRoute.name: (routeData) {
      final args =
          routeData.argsAs<MainRouteArgs>(orElse: () => const MainRouteArgs());
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: _i3.MainPage(key: args.key),
      );
    },
    AuthRoute.name: (routeData) {
      return _i5.MaterialPageX<void>(
        routeData: routeData,
        child: const _i4.AuthPage(),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          InitRoute.name,
          path: '/',
        ),
        _i5.RouteConfig(
          SetupPinRoute.name,
          path: '/setup-pin-page',
        ),
        _i5.RouteConfig(
          MainRoute.name,
          path: '/main-page',
        ),
        _i5.RouteConfig(
          AuthRoute.name,
          path: '/auth-page',
        ),
      ];
}

/// generated route for
/// [_i1.InitPage]
class InitRoute extends _i5.PageRouteInfo<InitRouteArgs> {
  InitRoute({_i6.Key? key})
      : super(
          InitRoute.name,
          path: '/',
          args: InitRouteArgs(key: key),
        );

  static const String name = 'InitRoute';
}

class InitRouteArgs {
  const InitRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'InitRouteArgs{key: $key}';
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
/// [_i3.MainPage]
class MainRoute extends _i5.PageRouteInfo<MainRouteArgs> {
  MainRoute({_i6.Key? key})
      : super(
          MainRoute.name,
          path: '/main-page',
          args: MainRouteArgs(key: key),
        );

  static const String name = 'MainRoute';
}

class MainRouteArgs {
  const MainRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'MainRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.AuthPage]
class AuthRoute extends _i5.PageRouteInfo<void> {
  const AuthRoute()
      : super(
          AuthRoute.name,
          path: '/auth-page',
        );

  static const String name = 'AuthRoute';
}
