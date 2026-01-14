// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:flutter/material.dart' as _i30;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i41;
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart' as _i32;
import 'package:snggle/shared/models/entries/entries_create_recover_status.dart'
    as _i28;
import 'package:snggle/shared/models/entries/entry_model.dart' as _i34;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i40;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i36;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i35;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i38;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i29;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i37;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i39;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i33;
import 'package:snggle/views/pages/app_pin_page/app_enter_pin_page.dart' as _i1;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i31;
import 'package:snggle/views/pages/app_pin_page/app_set_up_pin_page.dart'
    as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entries_section_wrapper.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page.dart'
    as _i8;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_page.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i21;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i14;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i19;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i22;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i23;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i25;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i26;
import 'package:snggle/views/pages/entry_create_recover/entry_create_page/entry_create_page.dart'
    as _i6;
import 'package:snggle/views/pages/entry_create_recover/entry_create_recover_wrapper.dart'
    as _i7;
import 'package:snggle/views/pages/entry_create_recover/entry_init_page/entry_init_page.dart'
    as _i9;
import 'package:snggle/views/pages/splash_page.dart' as _i15;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i16;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i17;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i18;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i20;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i24;

abstract class $AppRouter extends _i27.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i27.PageFactory> pagesMap = {
    AppEnterPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppEnterPinRouteArgs>(
          orElse: () => const AppEnterPinRouteArgs());
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppEnterPinPage(
          key: args.key,
          appPinType: args.appPinType,
        ),
      );
    },
    AppSetUpPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppSetUpPinRouteArgs>(
          orElse: () => const AppSetUpPinRouteArgs());
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AppSetUpPinPage(
          key: args.key,
          appPinType: args.appPinType,
        ),
      );
    },
    AppsRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    EntriesSectionWrapperRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.EntriesSectionWrapper(),
      );
    },
    EntryCreateRoute.name: (routeData) {
      final args = routeData.argsAs<EntryCreateRouteArgs>();
      return _i27.AutoRoutePage<_i28.EntryCreateRecoverStatus?>(
        routeData: routeData,
        child: _i6.EntryCreatePage(
          entryPageType: args.entryPageType,
          parentFilesystemPath: args.parentFilesystemPath,
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryCreateRecoverRoute.name: (routeData) {
      return _i27.AutoRoutePage<_i28.EntryCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i7.EntryCreateRecoverWrapper(),
      );
    },
    EntryDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsRouteArgs>();
      return _i27.AutoRoutePage<void>(
        routeData: routeData,
        child: _i8.EntryDetailsPage(
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryInitRoute.name: (routeData) {
      final args = routeData.argsAs<EntryInitRouteArgs>();
      return _i27.AutoRoutePage<_i28.EntryCreateRecoverStatus?>(
        routeData: routeData,
        child: _i9.EntryInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    EntryListRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.EntryListPage(),
      );
    },
    EthereumTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.EthereumTransactionDetailsPage(
          ethereumTransactionModel: args.ethereumTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          key: args.key,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SettingsPage(),
      );
    },
    SolanaTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.SolanaTransactionDetailsPage(
          solanaTransactionModel: args.solanaTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i27.AutoRoutePage<_i29.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i16.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i27.AutoRoutePage<_i29.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i17.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i27.AutoRoutePage<_i29.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i18.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i27.AutoRoutePage<_i29.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i20.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.VaultsSectionWrapper(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.VaultsSectionWrapper(),
      );
    },
    WalletConnectRoute.name: (routeData) {
      final args = routeData.argsAs<WalletConnectRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i23.WalletConnectPage(
          vaultModel: args.vaultModel,
          walletModel: args.walletModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    WalletCreateRoute.name: (routeData) {
      final args = routeData.argsAs<WalletCreateRouteArgs>();
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i24.WalletCreatePage(
          vaultModel: args.vaultModel,
          parentFilesystemPath: args.parentFilesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i27.AutoRoutePage<void>(
        routeData: routeData,
        child: _i25.WalletDetailsPage(
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
      return _i27.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i26.WalletListPage(
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
class AppEnterPinRoute extends _i27.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    _i30.Key? key,
    _i31.AppPinType appPinType = _i31.AppPinType.enterPin,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AppEnterPinRoute.name,
          args: AppEnterPinRouteArgs(
            key: key,
            appPinType: appPinType,
          ),
          initialChildren: children,
        );

  static const String name = 'AppEnterPinRoute';

  static const _i27.PageInfo<AppEnterPinRouteArgs> page =
      _i27.PageInfo<AppEnterPinRouteArgs>(name);
}

class AppEnterPinRouteArgs {
  const AppEnterPinRouteArgs({
    this.key,
    this.appPinType = _i31.AppPinType.enterPin,
  });

  final _i30.Key? key;

  final _i31.AppPinType appPinType;

  @override
  String toString() {
    return 'AppEnterPinRouteArgs{key: $key, appPinType: $appPinType}';
  }
}

/// generated route for
/// [_i2.AppSetUpPinPage]
class AppSetUpPinRoute extends _i27.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i30.Key? key,
    _i31.AppPinType appPinType = _i31.AppPinType.setUpPin,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AppSetUpPinRoute.name,
          args: AppSetUpPinRouteArgs(
            key: key,
            appPinType: appPinType,
          ),
          initialChildren: children,
        );

  static const String name = 'AppSetUpPinRoute';

  static const _i27.PageInfo<AppSetUpPinRouteArgs> page =
      _i27.PageInfo<AppSetUpPinRouteArgs>(name);
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.key,
    this.appPinType = _i31.AppPinType.setUpPin,
  });

  final _i30.Key? key;

  final _i31.AppPinType appPinType;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{key: $key, appPinType: $appPinType}';
  }
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i27.PageRouteInfo<void> {
  const AppsRoute({List<_i27.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i27.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i27.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i5.EntriesSectionWrapper]
class EntriesSectionWrapperRoute extends _i27.PageRouteInfo<void> {
  const EntriesSectionWrapperRoute({List<_i27.PageRouteInfo>? children})
      : super(
          EntriesSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntriesSectionWrapperRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i6.EntryCreatePage]
class EntryCreateRoute extends _i27.PageRouteInfo<EntryCreateRouteArgs> {
  EntryCreateRoute({
    required _i32.EntryPageType entryPageType,
    _i33.FilesystemPath? parentFilesystemPath,
    _i34.EntryModel? entryModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<EntryCreateRouteArgs> page =
      _i27.PageInfo<EntryCreateRouteArgs>(name);
}

class EntryCreateRouteArgs {
  const EntryCreateRouteArgs({
    required this.entryPageType,
    this.parentFilesystemPath,
    this.entryModel,
    this.key,
  });

  final _i32.EntryPageType entryPageType;

  final _i33.FilesystemPath? parentFilesystemPath;

  final _i34.EntryModel? entryModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'EntryCreateRouteArgs{entryPageType: $entryPageType, parentFilesystemPath: $parentFilesystemPath, entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i7.EntryCreateRecoverWrapper]
class EntryCreateRecoverRoute extends _i27.PageRouteInfo<void> {
  const EntryCreateRecoverRoute({List<_i27.PageRouteInfo>? children})
      : super(
          EntryCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntryCreateRecoverRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i8.EntryDetailsPage]
class EntryDetailsRoute extends _i27.PageRouteInfo<EntryDetailsRouteArgs> {
  EntryDetailsRoute({
    required _i34.EntryModel entryModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          EntryDetailsRoute.name,
          args: EntryDetailsRouteArgs(
            entryModel: entryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryDetailsRoute';

  static const _i27.PageInfo<EntryDetailsRouteArgs> page =
      _i27.PageInfo<EntryDetailsRouteArgs>(name);
}

class EntryDetailsRouteArgs {
  const EntryDetailsRouteArgs({
    required this.entryModel,
    this.key,
  });

  final _i34.EntryModel entryModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'EntryDetailsRouteArgs{entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i9.EntryInitPage]
class EntryInitRoute extends _i27.PageRouteInfo<EntryInitRouteArgs> {
  EntryInitRoute({
    required _i33.FilesystemPath parentFilesystemPath,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          EntryInitRoute.name,
          args: EntryInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryInitRoute';

  static const _i27.PageInfo<EntryInitRouteArgs> page =
      _i27.PageInfo<EntryInitRouteArgs>(name);
}

class EntryInitRouteArgs {
  const EntryInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i33.FilesystemPath parentFilesystemPath;

  final _i30.Key? key;

  @override
  String toString() {
    return 'EntryInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i10.EntryListPage]
class EntryListRoute extends _i27.PageRouteInfo<void> {
  const EntryListRoute({List<_i27.PageRouteInfo>? children})
      : super(
          EntryListRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntryListRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i11.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i27.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i35.EthereumTransactionModel ethereumTransactionModel,
    required _i36.NetworkTemplateModel networkTemplateModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<EthereumTransactionDetailsRouteArgs> page =
      _i27.PageInfo<EthereumTransactionDetailsRouteArgs>(name);
}

class EthereumTransactionDetailsRouteArgs {
  const EthereumTransactionDetailsRouteArgs({
    required this.ethereumTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i35.EthereumTransactionModel ethereumTransactionModel;

  final _i36.NetworkTemplateModel networkTemplateModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'EthereumTransactionDetailsRouteArgs{ethereumTransactionModel: $ethereumTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i12.NetworkListPage]
class NetworkListRoute extends _i27.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i37.VaultModel vaultModel,
    required _i33.FilesystemPath filesystemPath,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<NetworkListRouteArgs> page =
      _i27.PageInfo<NetworkListRouteArgs>(name);
}

class NetworkListRouteArgs {
  const NetworkListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    this.key,
  });

  final String name;

  final _i37.VaultModel vaultModel;

  final _i33.FilesystemPath filesystemPath;

  final _i30.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i13.SettingsPage]
class SettingsRoute extends _i27.PageRouteInfo<void> {
  const SettingsRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i27.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i38.SolanaTransactionModel solanaTransactionModel,
    required _i36.NetworkTemplateModel networkTemplateModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<SolanaTransactionDetailsRouteArgs> page =
      _i27.PageInfo<SolanaTransactionDetailsRouteArgs>(name);
}

class SolanaTransactionDetailsRouteArgs {
  const SolanaTransactionDetailsRouteArgs({
    required this.solanaTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i38.SolanaTransactionModel solanaTransactionModel;

  final _i36.NetworkTemplateModel networkTemplateModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'SolanaTransactionDetailsRouteArgs{solanaTransactionModel: $solanaTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i15.SplashPage]
class SplashRoute extends _i27.PageRouteInfo<void> {
  const SplashRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i16.VaultCreatePage]
class VaultCreateRoute extends _i27.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i33.FilesystemPath parentFilesystemPath,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i27.PageInfo<VaultCreateRouteArgs> page =
      _i27.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i33.FilesystemPath parentFilesystemPath;

  final _i30.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i17.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i27.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i27.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i18.VaultInitPage]
class VaultInitRoute extends _i27.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i33.FilesystemPath parentFilesystemPath,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i27.PageInfo<VaultInitRouteArgs> page =
      _i27.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i33.FilesystemPath parentFilesystemPath;

  final _i30.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i19.VaultListPage]
class VaultListRoute extends _i27.PageRouteInfo<void> {
  const VaultListRoute({List<_i27.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i20.VaultRecoverPage]
class VaultRecoverRoute extends _i27.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i33.FilesystemPath parentFilesystemPath,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i27.PageInfo<VaultRecoverRouteArgs> page =
      _i27.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i33.FilesystemPath parentFilesystemPath;

  final _i30.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i21.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i27.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i22.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i27.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i27.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i27.PageInfo<void> page = _i27.PageInfo<void>(name);
}

/// generated route for
/// [_i23.WalletConnectPage]
class WalletConnectRoute extends _i27.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i37.VaultModel vaultModel,
    required _i39.WalletModel walletModel,
    required _i36.NetworkTemplateModel networkTemplateModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<WalletConnectRouteArgs> page =
      _i27.PageInfo<WalletConnectRouteArgs>(name);
}

class WalletConnectRouteArgs {
  const WalletConnectRouteArgs({
    required this.vaultModel,
    required this.walletModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i37.VaultModel vaultModel;

  final _i39.WalletModel walletModel;

  final _i36.NetworkTemplateModel networkTemplateModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'WalletConnectRouteArgs{vaultModel: $vaultModel, walletModel: $walletModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i24.WalletCreatePage]
class WalletCreateRoute extends _i27.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i37.VaultModel vaultModel,
    required _i33.FilesystemPath parentFilesystemPath,
    required _i40.NetworkGroupModel networkGroupModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<WalletCreateRouteArgs> page =
      _i27.PageInfo<WalletCreateRouteArgs>(name);
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.vaultModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final _i37.VaultModel vaultModel;

  final _i33.FilesystemPath parentFilesystemPath;

  final _i40.NetworkGroupModel networkGroupModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{vaultModel: $vaultModel, parentFilesystemPath: $parentFilesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}

/// generated route for
/// [_i25.WalletDetailsPage]
class WalletDetailsRoute extends _i27.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i37.VaultModel vaultModel,
    required _i40.NetworkGroupModel networkGroupModel,
    required _i39.WalletModel walletModel,
    required _i41.WalletDetailsPageCubit walletDetailsPageCubit,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<WalletDetailsRouteArgs> page =
      _i27.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.vaultModel,
    required this.networkGroupModel,
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i37.VaultModel vaultModel;

  final _i40.NetworkGroupModel networkGroupModel;

  final _i39.WalletModel walletModel;

  final _i41.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i30.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{vaultModel: $vaultModel, networkGroupModel: $networkGroupModel, walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i26.WalletListPage]
class WalletListRoute extends _i27.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i37.VaultModel vaultModel,
    required _i33.FilesystemPath filesystemPath,
    required _i40.NetworkGroupModel networkGroupModel,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static const _i27.PageInfo<WalletListRouteArgs> page =
      _i27.PageInfo<WalletListRouteArgs>(name);
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

  final _i37.VaultModel vaultModel;

  final _i33.FilesystemPath filesystemPath;

  final _i40.NetworkGroupModel networkGroupModel;

  final _i30.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}
