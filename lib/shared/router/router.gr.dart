// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:snggle/shared/models/password_model.dart' as _i16;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i15;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i14;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i5;
import 'package:snggle/views/pages/bottom_navigation/settings_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i8;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i11;
import 'package:snggle/views/pages/splash_page.dart' as _i7;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.SplashPage(key: args.key),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.VaultListPage(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.VaultsSectionWrapper(),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.WalletDetailsPage(
          walletModel: args.walletModel,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.WalletListPage(
          vaultModel: args.vaultModel,
          vaultPasswordModel: args.vaultPasswordModel,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppAuthPage]
class AppAuthRoute extends _i12.PageRouteInfo<void> {
  const AppAuthRoute({List<_i12.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i12.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i12.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i12.PageRouteInfo<void> {
  const AppsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i12.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i12.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SecretsPage]
class SecretsRoute extends _i12.PageRouteInfo<void> {
  const SecretsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SettingsPage]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i13.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i12.PageInfo<SplashRouteArgs> page =
      _i12.PageInfo<SplashRouteArgs>(name);
}

class SplashRouteArgs {
  const SplashRouteArgs({this.key});

  final _i13.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.VaultListPage]
class VaultListRoute extends _i12.PageRouteInfo<void> {
  const VaultListRoute({List<_i12.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i9.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i12.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i12.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i10.WalletDetailsPage]
class WalletDetailsRoute extends _i12.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i14.WalletModel walletModel,
    _i13.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          WalletDetailsRoute.name,
          args: WalletDetailsRouteArgs(
            walletModel: walletModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletDetailsRoute';

  static const _i12.PageInfo<WalletDetailsRouteArgs> page =
      _i12.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.walletModel,
    this.key,
  });

  final _i14.WalletModel walletModel;

  final _i13.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{walletModel: $walletModel, key: $key}';
  }
}

/// generated route for
/// [_i11.WalletListPage]
class WalletListRoute extends _i12.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required _i15.VaultModel vaultModel,
    required _i16.PasswordModel vaultPasswordModel,
    _i13.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          WalletListRoute.name,
          args: WalletListRouteArgs(
            vaultModel: vaultModel,
            vaultPasswordModel: vaultPasswordModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletListRoute';

  static const _i12.PageInfo<WalletListRouteArgs> page =
      _i12.PageInfo<WalletListRouteArgs>(name);
}

class WalletListRouteArgs {
  const WalletListRouteArgs({
    required this.vaultModel,
    required this.vaultPasswordModel,
    this.key,
  });

  final _i15.VaultModel vaultModel;

  final _i16.PasswordModel vaultPasswordModel;

  final _i13.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{vaultModel: $vaultModel, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}
