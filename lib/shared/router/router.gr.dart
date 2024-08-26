// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/material.dart' as _i25;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i24;
import 'package:snggle/shared/models/password_model.dart' as _i27;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i22;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i26;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i28;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i23;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i10;
import 'package:snggle/views/pages/bottom_navigation/settings_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i7;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i16;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i18;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i19;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i20;
import 'package:snggle/views/pages/network_create/network_create_wrapper.dart'
    as _i5;
import 'package:snggle/views/pages/network_create/network_group_create_page/network_group_create_page.dart'
    as _i6;
import 'package:snggle/views/pages/network_create/network_template_create_page/network_template_create_page.dart'
    as _i8;
import 'package:snggle/views/pages/network_create/network_template_select_page/network_template_select_page.dart'
    as _i9;
import 'package:snggle/views/pages/splash_page.dart' as _i12;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i13;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i14;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i15;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i17;

abstract class $AppRouter extends _i21.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i21.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    NetworkCreateRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.NetworkCreateWrapper(),
      );
    },
    NetworkGroupCreateRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkGroupCreateRouteArgs>();
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.NetworkGroupCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          vaultPasswordModel: args.vaultPasswordModel,
          key: args.key,
        ),
      );
    },
    NetworkTemplateCreateRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.NetworkTemplateCreatePage(),
      );
    },
    NetworkTemplateSelectRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkTemplateSelectRouteArgs>();
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.NetworkTemplateSelectPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i21.AutoRoutePage<_i22.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i13.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i21.AutoRoutePage<_i22.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i14.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i21.AutoRoutePage<_i22.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i15.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i21.AutoRoutePage<_i22.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i17.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.VaultsSectionWrapper(),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.WalletDetailsPage(
          walletModel: args.walletModel,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.WalletListPage(
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
class AppAuthRoute extends _i21.PageRouteInfo<void> {
  const AppAuthRoute({List<_i21.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i21.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i21.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i21.PageRouteInfo<void> {
  const AppsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i21.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i21.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NetworkCreateWrapper]
class NetworkCreateRoute extends _i21.PageRouteInfo<void> {
  const NetworkCreateRoute({List<_i21.PageRouteInfo>? children})
      : super(
          NetworkCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'NetworkCreateRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i6.NetworkGroupCreatePage]
class NetworkGroupCreateRoute
    extends _i21.PageRouteInfo<NetworkGroupCreateRouteArgs> {
  NetworkGroupCreateRoute({
    required _i23.FilesystemPath parentFilesystemPath,
    required _i24.NetworkTemplateModel networkTemplateModel,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          NetworkGroupCreateRoute.name,
          args: NetworkGroupCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            networkTemplateModel: networkTemplateModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworkGroupCreateRoute';

  static const _i21.PageInfo<NetworkGroupCreateRouteArgs> page =
      _i21.PageInfo<NetworkGroupCreateRouteArgs>(name);
}

class NetworkGroupCreateRouteArgs {
  const NetworkGroupCreateRouteArgs({
    required this.parentFilesystemPath,
    required this.networkTemplateModel,
    this.key,
  });

  final _i23.FilesystemPath parentFilesystemPath;

  final _i24.NetworkTemplateModel networkTemplateModel;

  final _i25.Key? key;

  @override
  String toString() {
    return 'NetworkGroupCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i7.NetworkListPage]
class NetworkListRoute extends _i21.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i26.VaultModel vaultModel,
    required _i23.FilesystemPath filesystemPath,
    required _i27.PasswordModel vaultPasswordModel,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<NetworkListRouteArgs> page =
      _i21.PageInfo<NetworkListRouteArgs>(name);
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

  final _i26.VaultModel vaultModel;

  final _i23.FilesystemPath filesystemPath;

  final _i27.PasswordModel vaultPasswordModel;

  final _i25.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}

/// generated route for
/// [_i8.NetworkTemplateCreatePage]
class NetworkTemplateCreateRoute extends _i21.PageRouteInfo<void> {
  const NetworkTemplateCreateRoute({List<_i21.PageRouteInfo>? children})
      : super(
          NetworkTemplateCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'NetworkTemplateCreateRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i9.NetworkTemplateSelectPage]
class NetworkTemplateSelectRoute
    extends _i21.PageRouteInfo<NetworkTemplateSelectRouteArgs> {
  NetworkTemplateSelectRoute({
    required _i23.FilesystemPath parentFilesystemPath,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          NetworkTemplateSelectRoute.name,
          args: NetworkTemplateSelectRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworkTemplateSelectRoute';

  static const _i21.PageInfo<NetworkTemplateSelectRouteArgs> page =
      _i21.PageInfo<NetworkTemplateSelectRouteArgs>(name);
}

class NetworkTemplateSelectRouteArgs {
  const NetworkTemplateSelectRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i23.FilesystemPath parentFilesystemPath;

  final _i25.Key? key;

  @override
  String toString() {
    return 'NetworkTemplateSelectRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i10.SecretsPage]
class SecretsRoute extends _i21.PageRouteInfo<void> {
  const SecretsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SettingsPage]
class SettingsRoute extends _i21.PageRouteInfo<void> {
  const SettingsRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SplashPage]
class SplashRoute extends _i21.PageRouteInfo<void> {
  const SplashRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i13.VaultCreatePage]
class VaultCreateRoute extends _i21.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i23.FilesystemPath parentFilesystemPath,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i21.PageInfo<VaultCreateRouteArgs> page =
      _i21.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i23.FilesystemPath parentFilesystemPath;

  final _i25.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i14.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i21.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i21.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i15.VaultInitPage]
class VaultInitRoute extends _i21.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i23.FilesystemPath parentFilesystemPath,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i21.PageInfo<VaultInitRouteArgs> page =
      _i21.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i23.FilesystemPath parentFilesystemPath;

  final _i25.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i16.VaultListPage]
class VaultListRoute extends _i21.PageRouteInfo<void> {
  const VaultListRoute({List<_i21.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i17.VaultRecoverPage]
class VaultRecoverRoute extends _i21.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i23.FilesystemPath parentFilesystemPath,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i21.PageInfo<VaultRecoverRouteArgs> page =
      _i21.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i23.FilesystemPath parentFilesystemPath;

  final _i25.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i18.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i21.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i21.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i19.WalletDetailsPage]
class WalletDetailsRoute extends _i21.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i28.WalletModel walletModel,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
          WalletDetailsRoute.name,
          args: WalletDetailsRouteArgs(
            walletModel: walletModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletDetailsRoute';

  static const _i21.PageInfo<WalletDetailsRouteArgs> page =
      _i21.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.walletModel,
    this.key,
  });

  final _i28.WalletModel walletModel;

  final _i25.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{walletModel: $walletModel, key: $key}';
  }
}

/// generated route for
/// [_i20.WalletListPage]
class WalletListRoute extends _i21.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i26.VaultModel vaultModel,
    required _i23.FilesystemPath filesystemPath,
    required _i27.PasswordModel vaultPasswordModel,
    _i25.Key? key,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<WalletListRouteArgs> page =
      _i21.PageInfo<WalletListRouteArgs>(name);
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

  final _i26.VaultModel vaultModel;

  final _i23.FilesystemPath filesystemPath;

  final _i27.PasswordModel vaultPasswordModel;

  final _i25.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}
