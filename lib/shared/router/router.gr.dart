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

import '../../views/pages/pages_wrapper.dart' as _i1;
import '../../views/pages/vaults_list_page/vault_list_page.dart' as _i2;
import '../../views/pages/wallets_list_page/wallets_list_page.dart' as _i3;
import '../models/vaults/vault_info_model.dart' as _i6;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    RoutesWrapper.name: (routeData) {
      return _i4.CustomPage<void>(
        routeData: routeData,
        child: const _i1.PagesWrapper(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    VaultListRoute.name: (routeData) {
      return _i4.CustomPage<void>(
        routeData: routeData,
        child: const _i2.VaultListPage(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    WalletsListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletsListRouteArgs>();
      return _i4.CustomPage<void>(
        routeData: routeData,
        child: _i3.WalletsListPage(
          vaultInfoModel: args.vaultInfoModel,
          key: args.key,
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          RoutesWrapper.name,
          path: '/pages-wrapper',
        ),
        _i4.RouteConfig(
          VaultListRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          WalletsListRoute.name,
          path: '/wallets-list-page',
        ),
      ];
}

/// generated route for
/// [_i1.PagesWrapper]
class RoutesWrapper extends _i4.PageRouteInfo<void> {
  const RoutesWrapper()
      : super(
          RoutesWrapper.name,
          path: '/pages-wrapper',
        );

  static const String name = 'RoutesWrapper';
}

/// generated route for
/// [_i2.VaultListPage]
class VaultListRoute extends _i4.PageRouteInfo<void> {
  const VaultListRoute()
      : super(
          VaultListRoute.name,
          path: '/',
        );

  static const String name = 'VaultListRoute';
}

/// generated route for
/// [_i3.WalletsListPage]
class WalletsListRoute extends _i4.PageRouteInfo<WalletsListRouteArgs> {
  WalletsListRoute({
    required _i6.VaultInfoModel vaultInfoModel,
    _i5.Key? key,
  }) : super(
          WalletsListRoute.name,
          path: '/wallets-list-page',
          args: WalletsListRouteArgs(
            vaultInfoModel: vaultInfoModel,
            key: key,
          ),
        );

  static const String name = 'WalletsListRoute';
}

class WalletsListRouteArgs {
  const WalletsListRouteArgs({
    required this.vaultInfoModel,
    this.key,
  });

  final _i6.VaultInfoModel vaultInfoModel;

  final _i5.Key? key;

  @override
  String toString() {
    return 'WalletsListRouteArgs{vaultInfoModel: $vaultInfoModel, key: $key}';
  }
}
