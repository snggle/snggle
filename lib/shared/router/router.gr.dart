// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i18;
import 'package:snggle/shared/models/password_model.dart' as _i20;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i16;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i19;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i17;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i5;
import 'package:snggle/views/pages/bottom_navigation/settings_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i14;
import 'package:snggle/views/pages/splash_page.dart' as _i7;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i8;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i9;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i10;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      return _i15.AutoRoutePage<_i16.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i8.VaultCreatePage(),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i15.AutoRoutePage<_i16.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i9.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      return _i15.AutoRoutePage<_i16.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i10.VaultInitPage(),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.VaultListPage(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.VaultsSectionWrapper(),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.WalletDetailsPage(
          walletModel: args.walletModel,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.WalletListPage(
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
class AppAuthRoute extends _i15.PageRouteInfo<void> {
  const AppAuthRoute({List<_i15.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i15.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i15.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i15.PageRouteInfo<void> {
  const AppsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i15.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i15.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SecretsPage]
class SecretsRoute extends _i15.PageRouteInfo<void> {
  const SecretsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SettingsPage]
class SettingsRoute extends _i15.PageRouteInfo<void> {
  const SettingsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashPage]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i8.VaultCreatePage]
class VaultCreateRoute extends _i15.PageRouteInfo<void> {
  const VaultCreateRoute({List<_i15.PageRouteInfo>? children})
      : super(
          VaultCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i9.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i15.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i15.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i10.VaultInitPage]
class VaultInitRoute extends _i15.PageRouteInfo<void> {
  const VaultInitRoute({List<_i15.PageRouteInfo>? children})
      : super(
          VaultInitRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i11.VaultListPage]
class VaultListRoute extends _i15.PageRouteInfo<void> {
  const VaultListRoute({List<_i15.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i12.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i15.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i15.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i13.WalletDetailsPage]
class WalletDetailsRoute extends _i15.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i17.WalletModel walletModel,
    _i18.Key? key,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          WalletDetailsRoute.name,
          args: WalletDetailsRouteArgs(
            walletModel: walletModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletDetailsRoute';

  static const _i15.PageInfo<WalletDetailsRouteArgs> page =
      _i15.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.walletModel,
    this.key,
  });

  final _i17.WalletModel walletModel;

  final _i18.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{walletModel: $walletModel, key: $key}';
  }
}

/// generated route for
/// [_i14.WalletListPage]
class WalletListRoute extends _i15.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required _i19.VaultModel vaultModel,
    required _i20.PasswordModel vaultPasswordModel,
    _i18.Key? key,
    List<_i15.PageRouteInfo>? children,
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

  static const _i15.PageInfo<WalletListRouteArgs> page =
      _i15.PageInfo<WalletListRouteArgs>(name);
}

class WalletListRouteArgs {
  const WalletListRouteArgs({
    required this.vaultModel,
    required this.vaultPasswordModel,
    this.key,
  });

  final _i19.VaultModel vaultModel;

  final _i20.PasswordModel vaultPasswordModel;

  final _i18.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{vaultModel: $vaultModel, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}
