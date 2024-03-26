// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i16;
import 'package:snggle/shared/models/a_container_model.dart' as _i18;
import 'package:snggle/shared/models/password_model.dart' as _i15;
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart' as _i14;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i17;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/settings_page.dart' as _i7;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_groups_page/network_groups_page.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i12;
import 'package:snggle/views/pages/splash_page.dart' as _i8;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    NetworkGroupsRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkGroupsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NetworkGroupsPage(
          vaultListItemModel: args.vaultListItemModel,
          vaultPasswordModel: args.vaultPasswordModel,
          key: args.key,
        ),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.SplashPage(key: args.key),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.VaultListPage(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.VaultsSectionWrapper(),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.WalletDetailsPage(
          walletModel: args.walletModel,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.WalletListPage(
          vaultListItemModel: args.vaultListItemModel,
          parentContainerModel: args.parentContainerModel,
          vaultPasswordModel: args.vaultPasswordModel,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppAuthPage]
class AppAuthRoute extends _i13.PageRouteInfo<void> {
  const AppAuthRoute({List<_i13.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i13.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i13.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i13.PageRouteInfo<void> {
  const AppsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i13.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i13.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NetworkGroupsPage]
class NetworkGroupsRoute extends _i13.PageRouteInfo<NetworkGroupsRouteArgs> {
  NetworkGroupsRoute({
    required _i14.VaultListItemModel vaultListItemModel,
    required _i15.PasswordModel vaultPasswordModel,
    _i16.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          NetworkGroupsRoute.name,
          args: NetworkGroupsRouteArgs(
            vaultListItemModel: vaultListItemModel,
            vaultPasswordModel: vaultPasswordModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworkGroupsRoute';

  static const _i13.PageInfo<NetworkGroupsRouteArgs> page =
      _i13.PageInfo<NetworkGroupsRouteArgs>(name);
}

class NetworkGroupsRouteArgs {
  const NetworkGroupsRouteArgs({
    required this.vaultListItemModel,
    required this.vaultPasswordModel,
    this.key,
  });

  final _i14.VaultListItemModel vaultListItemModel;

  final _i15.PasswordModel vaultPasswordModel;

  final _i16.Key? key;

  @override
  String toString() {
    return 'NetworkGroupsRouteArgs{vaultListItemModel: $vaultListItemModel, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}

/// generated route for
/// [_i6.SecretsPage]
class SecretsRoute extends _i13.PageRouteInfo<void> {
  const SecretsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SettingsPage]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SplashPage]
class SplashRoute extends _i13.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i16.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i13.PageInfo<SplashRouteArgs> page =
      _i13.PageInfo<SplashRouteArgs>(name);
}

class SplashRouteArgs {
  const SplashRouteArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.VaultListPage]
class VaultListRoute extends _i13.PageRouteInfo<void> {
  const VaultListRoute({List<_i13.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i10.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i13.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i13.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i11.WalletDetailsPage]
class WalletDetailsRoute extends _i13.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i17.WalletModel walletModel,
    _i16.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          WalletDetailsRoute.name,
          args: WalletDetailsRouteArgs(
            walletModel: walletModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletDetailsRoute';

  static const _i13.PageInfo<WalletDetailsRouteArgs> page =
      _i13.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.walletModel,
    this.key,
  });

  final _i17.WalletModel walletModel;

  final _i16.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{walletModel: $walletModel, key: $key}';
  }
}

/// generated route for
/// [_i12.WalletListPage]
class WalletListRoute extends _i13.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required _i14.VaultListItemModel vaultListItemModel,
    required _i18.AContainerModel parentContainerModel,
    required _i15.PasswordModel vaultPasswordModel,
    _i16.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          WalletListRoute.name,
          args: WalletListRouteArgs(
            vaultListItemModel: vaultListItemModel,
            parentContainerModel: parentContainerModel,
            vaultPasswordModel: vaultPasswordModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletListRoute';

  static const _i13.PageInfo<WalletListRouteArgs> page =
      _i13.PageInfo<WalletListRouteArgs>(name);
}

class WalletListRouteArgs {
  const WalletListRouteArgs({
    required this.vaultListItemModel,
    required this.parentContainerModel,
    required this.vaultPasswordModel,
    this.key,
  });

  final _i14.VaultListItemModel vaultListItemModel;

  final _i18.AContainerModel parentContainerModel;

  final _i15.PasswordModel vaultPasswordModel;

  final _i16.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{vaultListItemModel: $vaultListItemModel, parentContainerModel: $parentContainerModel, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}
