// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i23;
import 'package:flutter/material.dart' as _i26;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i34;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i33;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i28;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i27;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i31;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i24;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i29;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i32;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i30;
import 'package:snggle/views/pages/app_master_key_removed_page/app_master_key_removed_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_pin_page/app_enter_pin_page.dart' as _i1;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i25;
import 'package:snggle/views/pages/app_pin_page/app_set_up_pin_page.dart'
    as _i3;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i4;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i8;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i18;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i7;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i6;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i15;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i17;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i19;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i21;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i22;
import 'package:snggle/views/pages/splash_page.dart' as _i11;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i12;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i13;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i14;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i16;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i20;

abstract class $AppRouter extends _i23.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i23.PageFactory> pagesMap = {
    AppEnterPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppEnterPinRouteArgs>(
          orElse: () => const AppEnterPinRouteArgs());
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppEnterPinPage(
          appPinType: args.appPinType,
          key: args.key,
        ),
      );
    },
    AppMasterKeyRemovedRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppMasterKeyRemovedPage(),
      );
    },
    AppSetUpPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppSetUpPinRouteArgs>(
          orElse: () => const AppSetUpPinRouteArgs());
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.AppSetUpPinPage(
          key: args.key,
          appPinType: args.appPinType,
        ),
      );
    },
    AppsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.BottomNavigationWrapper(),
      );
    },
    EthereumTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.EthereumTransactionDetailsPage(
          ethereumTransactionModel: args.ethereumTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          key: args.key,
        ),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SettingsPage(),
      );
    },
    SolanaTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.SolanaTransactionDetailsPage(
          solanaTransactionModel: args.solanaTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i23.AutoRoutePage<_i24.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i12.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i23.AutoRoutePage<_i24.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i13.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i23.AutoRoutePage<_i24.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i14.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i23.AutoRoutePage<_i24.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i16.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.VaultsSectionWrapper(),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.VaultsSectionWrapper(),
      );
    },
    WalletConnectRoute.name: (routeData) {
      final args = routeData.argsAs<WalletConnectRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.WalletConnectPage(
          vaultModel: args.vaultModel,
          walletModel: args.walletModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    WalletCreateRoute.name: (routeData) {
      final args = routeData.argsAs<WalletCreateRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.WalletCreatePage(
          vaultModel: args.vaultModel,
          parentFilesystemPath: args.parentFilesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i23.AutoRoutePage<void>(
        routeData: routeData,
        child: _i21.WalletDetailsPage(
          vaultModel: args.vaultModel,
          networkGroupModel: args.networkGroupModel,
          walletModel: args.walletModel,
          walletDetailsPageCubit: args.walletDetailsPageCubit,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i23.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i22.WalletListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppEnterPinPage]
class AppEnterPinRoute extends _i23.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    _i25.AppPinType appPinType = _i25.AppPinType.enterPin,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          AppEnterPinRoute.name,
          args: AppEnterPinRouteArgs(
            appPinType: appPinType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AppEnterPinRoute';

  static const _i23.PageInfo<AppEnterPinRouteArgs> page =
      _i23.PageInfo<AppEnterPinRouteArgs>(name);
}

class AppEnterPinRouteArgs {
  const AppEnterPinRouteArgs({
    this.appPinType = _i25.AppPinType.enterPin,
    this.key,
  });

  final _i25.AppPinType appPinType;

  final _i26.Key? key;

  @override
  String toString() {
    return 'AppEnterPinRouteArgs{appPinType: $appPinType, key: $key}';
  }
}

/// generated route for
/// [_i2.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute extends _i23.PageRouteInfo<void> {
  const AppMasterKeyRemovedRoute({List<_i23.PageRouteInfo>? children})
      : super(
          AppMasterKeyRemovedRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyRemovedRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppSetUpPinPage]
class AppSetUpPinRoute extends _i23.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i26.Key? key,
    _i25.AppPinType appPinType = _i25.AppPinType.setUpPin,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          AppSetUpPinRoute.name,
          args: AppSetUpPinRouteArgs(
            key: key,
            appPinType: appPinType,
          ),
          initialChildren: children,
        );

  static const String name = 'AppSetUpPinRoute';

  static const _i23.PageInfo<AppSetUpPinRouteArgs> page =
      _i23.PageInfo<AppSetUpPinRouteArgs>(name);
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.key,
    this.appPinType = _i25.AppPinType.setUpPin,
  });

  final _i26.Key? key;

  final _i25.AppPinType appPinType;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{key: $key, appPinType: $appPinType}';
  }
}

/// generated route for
/// [_i4.AppsPage]
class AppsRoute extends _i23.PageRouteInfo<void> {
  const AppsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i5.BottomNavigationWrapper]
class BottomNavigationRoute extends _i23.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i23.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i6.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i23.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i27.EthereumTransactionModel ethereumTransactionModel,
    required _i28.NetworkTemplateModel networkTemplateModel,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          EthereumTransactionDetailsRoute.name,
          args: EthereumTransactionDetailsRouteArgs(
            ethereumTransactionModel: ethereumTransactionModel,
            networkTemplateModel: networkTemplateModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EthereumTransactionDetailsRoute';

  static const _i23.PageInfo<EthereumTransactionDetailsRouteArgs> page =
      _i23.PageInfo<EthereumTransactionDetailsRouteArgs>(name);
}

class EthereumTransactionDetailsRouteArgs {
  const EthereumTransactionDetailsRouteArgs({
    required this.ethereumTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i27.EthereumTransactionModel ethereumTransactionModel;

  final _i28.NetworkTemplateModel networkTemplateModel;

  final _i26.Key? key;

  @override
  String toString() {
    return 'EthereumTransactionDetailsRouteArgs{ethereumTransactionModel: $ethereumTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i7.NetworkListPage]
class NetworkListRoute extends _i23.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i29.VaultModel vaultModel,
    required _i30.FilesystemPath filesystemPath,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          NetworkListRoute.name,
          args: NetworkListRouteArgs(
            name: name,
            vaultModel: vaultModel,
            filesystemPath: filesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworkListRoute';

  static const _i23.PageInfo<NetworkListRouteArgs> page =
      _i23.PageInfo<NetworkListRouteArgs>(name);
}

class NetworkListRouteArgs {
  const NetworkListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    this.key,
  });

  final String name;

  final _i29.VaultModel vaultModel;

  final _i30.FilesystemPath filesystemPath;

  final _i26.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i8.SecretsPage]
class SecretsRoute extends _i23.PageRouteInfo<void> {
  const SecretsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SettingsPage]
class SettingsRoute extends _i23.PageRouteInfo<void> {
  const SettingsRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i23.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i31.SolanaTransactionModel solanaTransactionModel,
    required _i28.NetworkTemplateModel networkTemplateModel,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          SolanaTransactionDetailsRoute.name,
          args: SolanaTransactionDetailsRouteArgs(
            solanaTransactionModel: solanaTransactionModel,
            networkTemplateModel: networkTemplateModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SolanaTransactionDetailsRoute';

  static const _i23.PageInfo<SolanaTransactionDetailsRouteArgs> page =
      _i23.PageInfo<SolanaTransactionDetailsRouteArgs>(name);
}

class SolanaTransactionDetailsRouteArgs {
  const SolanaTransactionDetailsRouteArgs({
    required this.solanaTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i31.SolanaTransactionModel solanaTransactionModel;

  final _i28.NetworkTemplateModel networkTemplateModel;

  final _i26.Key? key;

  @override
  String toString() {
    return 'SolanaTransactionDetailsRouteArgs{solanaTransactionModel: $solanaTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i11.SplashPage]
class SplashRoute extends _i23.PageRouteInfo<void> {
  const SplashRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i12.VaultCreatePage]
class VaultCreateRoute extends _i23.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i30.FilesystemPath parentFilesystemPath,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i23.PageInfo<VaultCreateRouteArgs> page =
      _i23.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i30.FilesystemPath parentFilesystemPath;

  final _i26.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i13.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i23.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i23.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i14.VaultInitPage]
class VaultInitRoute extends _i23.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i30.FilesystemPath parentFilesystemPath,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i23.PageInfo<VaultInitRouteArgs> page =
      _i23.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i30.FilesystemPath parentFilesystemPath;

  final _i26.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i15.VaultListPage]
class VaultListRoute extends _i23.PageRouteInfo<void> {
  const VaultListRoute({List<_i23.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i16.VaultRecoverPage]
class VaultRecoverRoute extends _i23.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i30.FilesystemPath parentFilesystemPath,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i23.PageInfo<VaultRecoverRouteArgs> page =
      _i23.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i30.FilesystemPath parentFilesystemPath;

  final _i26.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i17.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i23.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i23.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i18.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i23.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i23.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i23.PageInfo<void> page = _i23.PageInfo<void>(name);
}

/// generated route for
/// [_i19.WalletConnectPage]
class WalletConnectRoute extends _i23.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i29.VaultModel vaultModel,
    required _i32.WalletModel walletModel,
    required _i28.NetworkTemplateModel networkTemplateModel,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          WalletConnectRoute.name,
          args: WalletConnectRouteArgs(
            vaultModel: vaultModel,
            walletModel: walletModel,
            networkTemplateModel: networkTemplateModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletConnectRoute';

  static const _i23.PageInfo<WalletConnectRouteArgs> page =
      _i23.PageInfo<WalletConnectRouteArgs>(name);
}

class WalletConnectRouteArgs {
  const WalletConnectRouteArgs({
    required this.vaultModel,
    required this.walletModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i29.VaultModel vaultModel;

  final _i32.WalletModel walletModel;

  final _i28.NetworkTemplateModel networkTemplateModel;

  final _i26.Key? key;

  @override
  String toString() {
    return 'WalletConnectRouteArgs{vaultModel: $vaultModel, walletModel: $walletModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i20.WalletCreatePage]
class WalletCreateRoute extends _i23.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i29.VaultModel vaultModel,
    required _i30.FilesystemPath parentFilesystemPath,
    required _i33.NetworkGroupModel networkGroupModel,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          WalletCreateRoute.name,
          args: WalletCreateRouteArgs(
            vaultModel: vaultModel,
            parentFilesystemPath: parentFilesystemPath,
            networkGroupModel: networkGroupModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletCreateRoute';

  static const _i23.PageInfo<WalletCreateRouteArgs> page =
      _i23.PageInfo<WalletCreateRouteArgs>(name);
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.vaultModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final _i29.VaultModel vaultModel;

  final _i30.FilesystemPath parentFilesystemPath;

  final _i33.NetworkGroupModel networkGroupModel;

  final _i26.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{vaultModel: $vaultModel, parentFilesystemPath: $parentFilesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}

/// generated route for
/// [_i21.WalletDetailsPage]
class WalletDetailsRoute extends _i23.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i29.VaultModel vaultModel,
    required _i33.NetworkGroupModel networkGroupModel,
    required _i32.WalletModel walletModel,
    required _i34.WalletDetailsPageCubit walletDetailsPageCubit,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          WalletDetailsRoute.name,
          args: WalletDetailsRouteArgs(
            vaultModel: vaultModel,
            networkGroupModel: networkGroupModel,
            walletModel: walletModel,
            walletDetailsPageCubit: walletDetailsPageCubit,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletDetailsRoute';

  static const _i23.PageInfo<WalletDetailsRouteArgs> page =
      _i23.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.vaultModel,
    required this.networkGroupModel,
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i29.VaultModel vaultModel;

  final _i33.NetworkGroupModel networkGroupModel;

  final _i32.WalletModel walletModel;

  final _i34.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i26.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{vaultModel: $vaultModel, networkGroupModel: $networkGroupModel, walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i22.WalletListPage]
class WalletListRoute extends _i23.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i29.VaultModel vaultModel,
    required _i30.FilesystemPath filesystemPath,
    required _i33.NetworkGroupModel networkGroupModel,
    _i26.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
          WalletListRoute.name,
          args: WalletListRouteArgs(
            name: name,
            vaultModel: vaultModel,
            filesystemPath: filesystemPath,
            networkGroupModel: networkGroupModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletListRoute';

  static const _i23.PageInfo<WalletListRouteArgs> page =
      _i23.PageInfo<WalletListRouteArgs>(name);
}

class WalletListRouteArgs {
  const WalletListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final String name;

  final _i29.VaultModel vaultModel;

  final _i30.FilesystemPath filesystemPath;

  final _i33.NetworkGroupModel networkGroupModel;

  final _i26.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}
