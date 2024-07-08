// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i24;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i27;
import 'package:snggle/shared/models/password_model.dart' as _i23;
import 'package:snggle/shared/models/transactions/transaction_model.dart'
    as _i25;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i20;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i21;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i26;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i22;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i7;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i16;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/transaction_details_page.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i15;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i17;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i18;
import 'package:snggle/views/pages/splash_page.dart' as _i8;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i10;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i11;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i12;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i14;

abstract class $AppRouter extends _i19.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          vaultPasswordModel: args.vaultPasswordModel,
          key: args.key,
        ),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SplashPage(),
      );
    },
    TransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionDetailsRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.TransactionDetailsPage(
          transactionModel: args.transactionModel,
          key: args.key,
        ),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i19.AutoRoutePage<_i20.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i10.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i19.AutoRoutePage<_i20.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i11.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i19.AutoRoutePage<_i20.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i12.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i19.AutoRoutePage<_i20.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i14.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.VaultsSectionWrapper(),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.VaultsSectionWrapper(),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i19.AutoRoutePage<void>(
        routeData: routeData,
        child: _i17.WalletDetailsPage(
          walletModel: args.walletModel,
          walletDetailsPageCubit: args.walletDetailsPageCubit,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.WalletListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          vaultPasswordModel: args.vaultPasswordModel,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppAuthPage]
class AppAuthRoute extends _i19.PageRouteInfo<void> {
  const AppAuthRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i19.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i19.PageRouteInfo<void> {
  const AppsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i19.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i19.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NetworkListPage]
class NetworkListRoute extends _i19.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i21.VaultModel vaultModel,
    required _i22.FilesystemPath filesystemPath,
    required _i23.PasswordModel vaultPasswordModel,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          NetworkListRoute.name,
          args: NetworkListRouteArgs(
            name: name,
            vaultModel: vaultModel,
            filesystemPath: filesystemPath,
            vaultPasswordModel: vaultPasswordModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworkListRoute';

  static const _i19.PageInfo<NetworkListRouteArgs> page =
      _i19.PageInfo<NetworkListRouteArgs>(name);
}

class NetworkListRouteArgs {
  const NetworkListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    required this.vaultPasswordModel,
    this.key,
  });

  final String name;

  final _i21.VaultModel vaultModel;

  final _i22.FilesystemPath filesystemPath;

  final _i23.PasswordModel vaultPasswordModel;

  final _i24.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}

/// generated route for
/// [_i6.SecretsPage]
class SecretsRoute extends _i19.PageRouteInfo<void> {
  const SecretsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SettingsPage]
class SettingsRoute extends _i19.PageRouteInfo<void> {
  const SettingsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SplashPage]
class SplashRoute extends _i19.PageRouteInfo<void> {
  const SplashRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i9.TransactionDetailsPage]
class TransactionDetailsRoute
    extends _i19.PageRouteInfo<TransactionDetailsRouteArgs> {
  TransactionDetailsRoute({
    required _i25.TransactionModel transactionModel,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          TransactionDetailsRoute.name,
          args: TransactionDetailsRouteArgs(
            transactionModel: transactionModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionDetailsRoute';

  static const _i19.PageInfo<TransactionDetailsRouteArgs> page =
      _i19.PageInfo<TransactionDetailsRouteArgs>(name);
}

class TransactionDetailsRouteArgs {
  const TransactionDetailsRouteArgs({
    required this.transactionModel,
    this.key,
  });

  final _i25.TransactionModel transactionModel;

  final _i24.Key? key;

  @override
  String toString() {
    return 'TransactionDetailsRouteArgs{transactionModel: $transactionModel, key: $key}';
  }
}

/// generated route for
/// [_i10.VaultCreatePage]
class VaultCreateRoute extends _i19.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i22.FilesystemPath parentFilesystemPath,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i19.PageInfo<VaultCreateRouteArgs> page =
      _i19.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i22.FilesystemPath parentFilesystemPath;

  final _i24.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i11.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i19.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i19.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i12.VaultInitPage]
class VaultInitRoute extends _i19.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i22.FilesystemPath parentFilesystemPath,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i19.PageInfo<VaultInitRouteArgs> page =
      _i19.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i22.FilesystemPath parentFilesystemPath;

  final _i24.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i13.VaultListPage]
class VaultListRoute extends _i19.PageRouteInfo<void> {
  const VaultListRoute({List<_i19.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i14.VaultRecoverPage]
class VaultRecoverRoute extends _i19.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i22.FilesystemPath parentFilesystemPath,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i19.PageInfo<VaultRecoverRouteArgs> page =
      _i19.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i22.FilesystemPath parentFilesystemPath;

  final _i24.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i15.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i19.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i19.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i16.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i19.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i17.WalletDetailsPage]
class WalletDetailsRoute extends _i19.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i26.WalletModel walletModel,
    required _i27.WalletDetailsPageCubit walletDetailsPageCubit,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          WalletDetailsRoute.name,
          args: WalletDetailsRouteArgs(
            walletModel: walletModel,
            walletDetailsPageCubit: walletDetailsPageCubit,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletDetailsRoute';

  static const _i19.PageInfo<WalletDetailsRouteArgs> page =
      _i19.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i26.WalletModel walletModel;

  final _i27.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i24.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i18.WalletListPage]
class WalletListRoute extends _i19.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i21.VaultModel vaultModel,
    required _i22.FilesystemPath filesystemPath,
    required _i23.PasswordModel vaultPasswordModel,
    _i24.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          WalletListRoute.name,
          args: WalletListRouteArgs(
            name: name,
            vaultModel: vaultModel,
            filesystemPath: filesystemPath,
            vaultPasswordModel: vaultPasswordModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletListRoute';

  static const _i19.PageInfo<WalletListRouteArgs> page =
      _i19.PageInfo<WalletListRouteArgs>(name);
}

class WalletListRouteArgs {
  const WalletListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    required this.vaultPasswordModel,
    this.key,
  });

  final String name;

  final _i21.VaultModel vaultModel;

  final _i22.FilesystemPath filesystemPath;

  final _i23.PasswordModel vaultPasswordModel;

  final _i24.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}
