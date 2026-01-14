// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i26;
import 'package:flutter/material.dart' as _i29;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i39;
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart' as _i30;
import 'package:snggle/shared/models/entries/entry_model.dart' as _i32;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i38;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i34;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i33;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i36;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i27;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i35;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i37;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i31;
import 'package:snggle/views/pages/app_master_key_removed_page/app_master_key_removed_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_pin_page/app_enter_pin_page.dart' as _i1;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i28;
import 'package:snggle/views/pages/app_pin_page/app_set_up_pin_page.dart'
    as _i3;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i4;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entries_section_wrapper.dart'
    as _i6;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page.dart'
    as _i8;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_page.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i20;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i18;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i21;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i22;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i24;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i25;
import 'package:snggle/views/pages/entry_create_recover/entry_create_page/entry_create_page.dart'
    as _i7;
import 'package:snggle/views/pages/splash_page.dart' as _i14;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i15;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i16;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i17;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i19;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i23;

abstract class $AppRouter extends _i26.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i26.PageFactory> pagesMap = {
    AppEnterPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppEnterPinRouteArgs>(
          orElse: () => const AppEnterPinRouteArgs());
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppEnterPinPage(
          appPinType: args.appPinType,
          key: args.key,
        ),
      );
    },
    AppMasterKeyRemovedRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppMasterKeyRemovedPage(),
      );
    },
    AppSetUpPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppSetUpPinRouteArgs>(
          orElse: () => const AppSetUpPinRouteArgs());
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.AppSetUpPinPage(
          key: args.key,
          appPinType: args.appPinType,
        ),
      );
    },
    AppsRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.BottomNavigationWrapper(),
      );
    },
    EntriesSectionWrapperRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.EntriesSectionWrapper(),
      );
    },
    EntryCreateRoute.name: (routeData) {
      final args = routeData.argsAs<EntryCreateRouteArgs>();
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.EntryCreatePage(
          entryPageType: args.entryPageType,
          parentFilesystemPath: args.parentFilesystemPath,
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsRouteArgs>();
      return _i26.AutoRoutePage<void>(
        routeData: routeData,
        child: _i8.EntryDetailsPage(
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryListRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.EntryListPage(),
      );
    },
    EthereumTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.EthereumTransactionDetailsPage(
          ethereumTransactionModel: args.ethereumTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          key: args.key,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SettingsPage(),
      );
    },
    SolanaTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.SolanaTransactionDetailsPage(
          solanaTransactionModel: args.solanaTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i26.AutoRoutePage<_i27.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i15.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i26.AutoRoutePage<_i27.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i16.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i26.AutoRoutePage<_i27.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i17.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i26.AutoRoutePage<_i27.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i19.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.VaultsSectionWrapper(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.VaultsSectionWrapper(),
      );
    },
    WalletConnectRoute.name: (routeData) {
      final args = routeData.argsAs<WalletConnectRouteArgs>();
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i22.WalletConnectPage(
          vaultModel: args.vaultModel,
          walletModel: args.walletModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    WalletCreateRoute.name: (routeData) {
      final args = routeData.argsAs<WalletCreateRouteArgs>();
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i23.WalletCreatePage(
          vaultModel: args.vaultModel,
          parentFilesystemPath: args.parentFilesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i26.AutoRoutePage<void>(
        routeData: routeData,
        child: _i24.WalletDetailsPage(
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
      return _i26.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i25.WalletListPage(
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
class AppEnterPinRoute extends _i26.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    _i28.AppPinType appPinType = _i28.AppPinType.enterPin,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          AppEnterPinRoute.name,
          args: AppEnterPinRouteArgs(
            appPinType: appPinType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AppEnterPinRoute';

  static const _i26.PageInfo<AppEnterPinRouteArgs> page =
      _i26.PageInfo<AppEnterPinRouteArgs>(name);
}

class AppEnterPinRouteArgs {
  const AppEnterPinRouteArgs({
    this.appPinType = _i28.AppPinType.enterPin,
    this.key,
  });

  final _i28.AppPinType appPinType;

  final _i29.Key? key;

  @override
  String toString() {
    return 'AppEnterPinRouteArgs{appPinType: $appPinType, key: $key}';
  }
}

/// generated route for
/// [_i2.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute extends _i26.PageRouteInfo<void> {
  const AppMasterKeyRemovedRoute({List<_i26.PageRouteInfo>? children})
      : super(
          AppMasterKeyRemovedRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyRemovedRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppSetUpPinPage]
class AppSetUpPinRoute extends _i26.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i29.Key? key,
    _i28.AppPinType appPinType = _i28.AppPinType.setUpPin,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          AppSetUpPinRoute.name,
          args: AppSetUpPinRouteArgs(
            key: key,
            appPinType: appPinType,
          ),
          initialChildren: children,
        );

  static const String name = 'AppSetUpPinRoute';

  static const _i26.PageInfo<AppSetUpPinRouteArgs> page =
      _i26.PageInfo<AppSetUpPinRouteArgs>(name);
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.key,
    this.appPinType = _i28.AppPinType.setUpPin,
  });

  final _i29.Key? key;

  final _i28.AppPinType appPinType;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{key: $key, appPinType: $appPinType}';
  }
}

/// generated route for
/// [_i4.AppsPage]
class AppsRoute extends _i26.PageRouteInfo<void> {
  const AppsRoute({List<_i26.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i5.BottomNavigationWrapper]
class BottomNavigationRoute extends _i26.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i26.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i6.EntriesSectionWrapper]
class EntriesSectionWrapperRoute extends _i26.PageRouteInfo<void> {
  const EntriesSectionWrapperRoute({List<_i26.PageRouteInfo>? children})
      : super(
          EntriesSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntriesSectionWrapperRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i7.EntryCreatePage]
class EntryCreateRoute extends _i26.PageRouteInfo<EntryCreateRouteArgs> {
  EntryCreateRoute({
    required _i30.EntryPageType entryPageType,
    _i31.FilesystemPath? parentFilesystemPath,
    _i32.EntryModel? entryModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          EntryCreateRoute.name,
          args: EntryCreateRouteArgs(
            entryPageType: entryPageType,
            parentFilesystemPath: parentFilesystemPath,
            entryModel: entryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryCreateRoute';

  static const _i26.PageInfo<EntryCreateRouteArgs> page =
      _i26.PageInfo<EntryCreateRouteArgs>(name);
}

class EntryCreateRouteArgs {
  const EntryCreateRouteArgs({
    required this.entryPageType,
    this.parentFilesystemPath,
    this.entryModel,
    this.key,
  });

  final _i30.EntryPageType entryPageType;

  final _i31.FilesystemPath? parentFilesystemPath;

  final _i32.EntryModel? entryModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'EntryCreateRouteArgs{entryPageType: $entryPageType, parentFilesystemPath: $parentFilesystemPath, entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i8.EntryDetailsPage]
class EntryDetailsRoute extends _i26.PageRouteInfo<EntryDetailsRouteArgs> {
  EntryDetailsRoute({
    required _i32.EntryModel entryModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          EntryDetailsRoute.name,
          args: EntryDetailsRouteArgs(
            entryModel: entryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryDetailsRoute';

  static const _i26.PageInfo<EntryDetailsRouteArgs> page =
      _i26.PageInfo<EntryDetailsRouteArgs>(name);
}

class EntryDetailsRouteArgs {
  const EntryDetailsRouteArgs({
    required this.entryModel,
    this.key,
  });

  final _i32.EntryModel entryModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'EntryDetailsRouteArgs{entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i9.EntryListPage]
class EntryListRoute extends _i26.PageRouteInfo<void> {
  const EntryListRoute({List<_i26.PageRouteInfo>? children})
      : super(
          EntryListRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntryListRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i10.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i26.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i33.EthereumTransactionModel ethereumTransactionModel,
    required _i34.NetworkTemplateModel networkTemplateModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<EthereumTransactionDetailsRouteArgs> page =
      _i26.PageInfo<EthereumTransactionDetailsRouteArgs>(name);
}

class EthereumTransactionDetailsRouteArgs {
  const EthereumTransactionDetailsRouteArgs({
    required this.ethereumTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i33.EthereumTransactionModel ethereumTransactionModel;

  final _i34.NetworkTemplateModel networkTemplateModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'EthereumTransactionDetailsRouteArgs{ethereumTransactionModel: $ethereumTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i11.NetworkListPage]
class NetworkListRoute extends _i26.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i35.VaultModel vaultModel,
    required _i31.FilesystemPath filesystemPath,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<NetworkListRouteArgs> page =
      _i26.PageInfo<NetworkListRouteArgs>(name);
}

class NetworkListRouteArgs {
  const NetworkListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    this.key,
  });

  final String name;

  final _i35.VaultModel vaultModel;

  final _i31.FilesystemPath filesystemPath;

  final _i29.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i12.SettingsPage]
class SettingsRoute extends _i26.PageRouteInfo<void> {
  const SettingsRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i26.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i36.SolanaTransactionModel solanaTransactionModel,
    required _i34.NetworkTemplateModel networkTemplateModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<SolanaTransactionDetailsRouteArgs> page =
      _i26.PageInfo<SolanaTransactionDetailsRouteArgs>(name);
}

class SolanaTransactionDetailsRouteArgs {
  const SolanaTransactionDetailsRouteArgs({
    required this.solanaTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i36.SolanaTransactionModel solanaTransactionModel;

  final _i34.NetworkTemplateModel networkTemplateModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'SolanaTransactionDetailsRouteArgs{solanaTransactionModel: $solanaTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i14.SplashPage]
class SplashRoute extends _i26.PageRouteInfo<void> {
  const SplashRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i15.VaultCreatePage]
class VaultCreateRoute extends _i26.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i31.FilesystemPath parentFilesystemPath,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i26.PageInfo<VaultCreateRouteArgs> page =
      _i26.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i31.FilesystemPath parentFilesystemPath;

  final _i29.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i16.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i26.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i26.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i17.VaultInitPage]
class VaultInitRoute extends _i26.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i31.FilesystemPath parentFilesystemPath,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i26.PageInfo<VaultInitRouteArgs> page =
      _i26.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i31.FilesystemPath parentFilesystemPath;

  final _i29.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i18.VaultListPage]
class VaultListRoute extends _i26.PageRouteInfo<void> {
  const VaultListRoute({List<_i26.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i19.VaultRecoverPage]
class VaultRecoverRoute extends _i26.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i31.FilesystemPath parentFilesystemPath,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i26.PageInfo<VaultRecoverRouteArgs> page =
      _i26.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i31.FilesystemPath parentFilesystemPath;

  final _i29.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i20.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i26.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i26.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i21.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i26.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i26.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i26.PageInfo<void> page = _i26.PageInfo<void>(name);
}

/// generated route for
/// [_i22.WalletConnectPage]
class WalletConnectRoute extends _i26.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i35.VaultModel vaultModel,
    required _i37.WalletModel walletModel,
    required _i34.NetworkTemplateModel networkTemplateModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<WalletConnectRouteArgs> page =
      _i26.PageInfo<WalletConnectRouteArgs>(name);
}

class WalletConnectRouteArgs {
  const WalletConnectRouteArgs({
    required this.vaultModel,
    required this.walletModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i35.VaultModel vaultModel;

  final _i37.WalletModel walletModel;

  final _i34.NetworkTemplateModel networkTemplateModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'WalletConnectRouteArgs{vaultModel: $vaultModel, walletModel: $walletModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i23.WalletCreatePage]
class WalletCreateRoute extends _i26.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i35.VaultModel vaultModel,
    required _i31.FilesystemPath parentFilesystemPath,
    required _i38.NetworkGroupModel networkGroupModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<WalletCreateRouteArgs> page =
      _i26.PageInfo<WalletCreateRouteArgs>(name);
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.vaultModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final _i35.VaultModel vaultModel;

  final _i31.FilesystemPath parentFilesystemPath;

  final _i38.NetworkGroupModel networkGroupModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{vaultModel: $vaultModel, parentFilesystemPath: $parentFilesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}

/// generated route for
/// [_i24.WalletDetailsPage]
class WalletDetailsRoute extends _i26.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i35.VaultModel vaultModel,
    required _i38.NetworkGroupModel networkGroupModel,
    required _i37.WalletModel walletModel,
    required _i39.WalletDetailsPageCubit walletDetailsPageCubit,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<WalletDetailsRouteArgs> page =
      _i26.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.vaultModel,
    required this.networkGroupModel,
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i35.VaultModel vaultModel;

  final _i38.NetworkGroupModel networkGroupModel;

  final _i37.WalletModel walletModel;

  final _i39.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i29.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{vaultModel: $vaultModel, networkGroupModel: $networkGroupModel, walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i25.WalletListPage]
class WalletListRoute extends _i26.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i35.VaultModel vaultModel,
    required _i31.FilesystemPath filesystemPath,
    required _i38.NetworkGroupModel networkGroupModel,
    _i29.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static const _i26.PageInfo<WalletListRouteArgs> page =
      _i26.PageInfo<WalletListRouteArgs>(name);
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

  final _i35.VaultModel vaultModel;

  final _i31.FilesystemPath filesystemPath;

  final _i38.NetworkGroupModel networkGroupModel;

  final _i29.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}
