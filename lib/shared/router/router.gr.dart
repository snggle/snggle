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
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../../views/pages/empty_page.dart' as _i3;
import '../../views/pages/setup_pin_page.dart' as _i2;
import '../../views/pages/splash_page.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i4.MaterialPageX<void>(
        routeData: routeData,
        child: _i1.SplashPage(key: args.key),
      );
    },
    SetupPinRoute.name: (routeData) {
      return _i4.MaterialPageX<void>(
        routeData: routeData,
        child: const _i2.SetupPinPage(),
      );
    },
    EmptyRoute.name: (routeData) {
      return _i4.MaterialPageX<void>(
        routeData: routeData,
        child: const _i3.EmptyPage(),
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          SetupPinRoute.name,
          path: '/setup-pin-page',
        ),
        _i4.RouteConfig(
          EmptyRoute.name,
          path: '/empty-page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i4.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({_i5.Key? key})
      : super(
          SplashRoute.name,
          path: '/',
          args: SplashRouteArgs(key: key),
        );

  static const String name = 'SplashRoute';
}

class SplashRouteArgs {
  const SplashRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SetupPinPage]
class SetupPinRoute extends _i4.PageRouteInfo<void> {
  const SetupPinRoute()
      : super(
          SetupPinRoute.name,
          path: '/setup-pin-page',
        );

  static const String name = 'SetupPinRoute';
}

/// generated route for
/// [_i3.EmptyPage]
class EmptyRoute extends _i4.PageRouteInfo<void> {
  const EmptyRoute()
      : super(
          EmptyRoute.name,
          path: '/empty-page',
        );

  static const String name = 'EmptyRoute';
}
