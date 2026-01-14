// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i29;
import 'package:flutter/material.dart' as _i32;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i45;
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart'
    as _i36;
import 'package:snggle/shared/models/entries/entry_model.dart' as _i38;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i44;
import 'package:snggle/shared/models/mnemonic_model.dart' as _i34;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i40;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i39;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i42;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i31;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i41;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i43;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i37;
import 'package:snggle/views/pages/app_master_key/app_master_key_create_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_master_key/app_master_key_recover_page.dart'
    as _i3;
import 'package:snggle/views/pages/app_master_key/app_master_key_removed_page.dart'
    as _i4;
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart'
    as _i35;
import 'package:snggle/views/pages/app_pin_page/app_enter_pin_page.dart' as _i1;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i33;
import 'package:snggle/views/pages/app_pin_page/app_set_up_pin_page.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i7;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entries_section_wrapper.dart'
    as _i8;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_create_edit_status.dart'
    as _i30;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/privacy_policy_page/privacy_policy_page.dart'
    as _i14;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i15;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i23;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i16;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i21;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i24;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i25;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i27;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i28;
import 'package:snggle/views/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page.dart'
    as _i9;
import 'package:snggle/views/pages/splash_page.dart' as _i17;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i18;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i19;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i20;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i22;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i26;

abstract class $AppRouter extends _i29.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i29.PageFactory> pagesMap = {
    AppEnterPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppEnterPinRouteArgs>(
          orElse: () => const AppEnterPinRouteArgs());
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppEnterPinPage(
          key: args.key,
          appPinType: args.appPinType,
        ),
      );
    },
    AppMasterKeyCreateRoute.name: (routeData) {
      final args = routeData.argsAs<AppMasterKeyCreateRouteArgs>(
          orElse: () => const AppMasterKeyCreateRouteArgs());
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AppMasterKeyCreatePage(key: args.key),
      );
    },
    AppMasterKeyRecoverRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppMasterKeyRecoverPage(),
      );
    },
    AppMasterKeyRemovedRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AppMasterKeyRemovedPage(),
      );
    },
    AppSetUpPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppSetUpPinRouteArgs>(
          orElse: () => const AppSetUpPinRouteArgs());
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.AppSetUpPinPage(
          mnemonicModel: args.mnemonicModel,
          appPinType: args.appPinType,
          appMasterKeyType: args.appMasterKeyType,
          key: args.key,
        ),
      );
    },
    AppsRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.BottomNavigationWrapper(),
      );
    },
    EntriesSectionWrapperRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.EntriesSectionWrapper(),
      );
    },
    EntryDetailsEditableRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsEditableRouteArgs>();
      return _i29.AutoRoutePage<_i30.EntryCreateEditStatus?>(
        routeData: routeData,
        child: _i9.EntryDetailsEditablePage(
          entryPageType: args.entryPageType,
          parentFilesystemPath: args.parentFilesystemPath,
          entryModel: args.entryModel,
          obscurePasswordBool: args.obscurePasswordBool,
          key: args.key,
        ),
      );
    },
    EntryDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsRouteArgs>();
      return _i29.AutoRoutePage<_i30.EntryCreateEditStatus?>(
        routeData: routeData,
        child: _i10.EntryDetailsPage(
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryListRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.EntryListPage(),
      );
    },
    EthereumTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.EthereumTransactionDetailsPage(
          ethereumTransactionModel: args.ethereumTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          key: args.key,
        ),
      );
    },
    PrivacyPolicyRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.PrivacyPolicyPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.SettingsPage(),
      );
    },
    SolanaTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.SolanaTransactionDetailsPage(
          solanaTransactionModel: args.solanaTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i29.AutoRoutePage<_i31.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i18.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i29.AutoRoutePage<_i31.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i19.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i29.AutoRoutePage<_i31.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i20.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i29.AutoRoutePage<_i31.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i22.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.VaultsSectionWrapper(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i24.VaultsSectionWrapper(),
      );
    },
    WalletConnectRoute.name: (routeData) {
      final args = routeData.argsAs<WalletConnectRouteArgs>();
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i25.WalletConnectPage(
          vaultModel: args.vaultModel,
          walletModel: args.walletModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    WalletCreateRoute.name: (routeData) {
      final args = routeData.argsAs<WalletCreateRouteArgs>();
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i26.WalletCreatePage(
          vaultModel: args.vaultModel,
          parentFilesystemPath: args.parentFilesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i29.AutoRoutePage<void>(
        routeData: routeData,
        child: _i27.WalletDetailsPage(
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
      return _i29.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i28.WalletListPage(
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
class AppEnterPinRoute extends _i29.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    _i32.Key? key,
    _i33.AppPinType appPinType = _i33.AppPinType.enterPin,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          AppEnterPinRoute.name,
          args: AppEnterPinRouteArgs(
            key: key,
            appPinType: appPinType,
          ),
          initialChildren: children,
        );

  static const String name = 'AppEnterPinRoute';

  static const _i29.PageInfo<AppEnterPinRouteArgs> page =
      _i29.PageInfo<AppEnterPinRouteArgs>(name);
}

class AppEnterPinRouteArgs {
  const AppEnterPinRouteArgs({
    this.key,
    this.appPinType = _i33.AppPinType.enterPin,
  });

  final _i32.Key? key;

  final _i33.AppPinType appPinType;

  @override
  String toString() {
    return 'AppEnterPinRouteArgs{key: $key, appPinType: $appPinType}';
  }
}

/// generated route for
/// [_i2.AppMasterKeyCreatePage]
class AppMasterKeyCreateRoute
    extends _i29.PageRouteInfo<AppMasterKeyCreateRouteArgs> {
  AppMasterKeyCreateRoute({
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          AppMasterKeyCreateRoute.name,
          args: AppMasterKeyCreateRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyCreateRoute';

  static const _i29.PageInfo<AppMasterKeyCreateRouteArgs> page =
      _i29.PageInfo<AppMasterKeyCreateRouteArgs>(name);
}

class AppMasterKeyCreateRouteArgs {
  const AppMasterKeyCreateRouteArgs({this.key});

  final _i32.Key? key;

  @override
  String toString() {
    return 'AppMasterKeyCreateRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.AppMasterKeyRecoverPage]
class AppMasterKeyRecoverRoute extends _i29.PageRouteInfo<void> {
  const AppMasterKeyRecoverRoute({List<_i29.PageRouteInfo>? children})
      : super(
          AppMasterKeyRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyRecoverRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i4.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute extends _i29.PageRouteInfo<void> {
  const AppMasterKeyRemovedRoute({List<_i29.PageRouteInfo>? children})
      : super(
          AppMasterKeyRemovedRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyRemovedRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i5.AppSetUpPinPage]
class AppSetUpPinRoute extends _i29.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i34.MnemonicModel? mnemonicModel,
    _i33.AppPinType appPinType = _i33.AppPinType.setUpPin,
    _i35.AppMasterKeyType? appMasterKeyType,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          AppSetUpPinRoute.name,
          args: AppSetUpPinRouteArgs(
            mnemonicModel: mnemonicModel,
            appPinType: appPinType,
            appMasterKeyType: appMasterKeyType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AppSetUpPinRoute';

  static const _i29.PageInfo<AppSetUpPinRouteArgs> page =
      _i29.PageInfo<AppSetUpPinRouteArgs>(name);
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.mnemonicModel,
    this.appPinType = _i33.AppPinType.setUpPin,
    this.appMasterKeyType,
    this.key,
  });

  final _i34.MnemonicModel? mnemonicModel;

  final _i33.AppPinType appPinType;

  final _i35.AppMasterKeyType? appMasterKeyType;

  final _i32.Key? key;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{mnemonicModel: $mnemonicModel, appPinType: $appPinType, appMasterKeyType: $appMasterKeyType, key: $key}';
  }
}

/// generated route for
/// [_i6.AppsPage]
class AppsRoute extends _i29.PageRouteInfo<void> {
  const AppsRoute({List<_i29.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i7.BottomNavigationWrapper]
class BottomNavigationRoute extends _i29.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i29.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i8.EntriesSectionWrapper]
class EntriesSectionWrapperRoute extends _i29.PageRouteInfo<void> {
  const EntriesSectionWrapperRoute({List<_i29.PageRouteInfo>? children})
      : super(
          EntriesSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntriesSectionWrapperRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i9.EntryDetailsEditablePage]
class EntryDetailsEditableRoute
    extends _i29.PageRouteInfo<EntryDetailsEditableRouteArgs> {
  EntryDetailsEditableRoute({
    required _i36.EntryPageType entryPageType,
    _i37.FilesystemPath? parentFilesystemPath,
    _i38.EntryModel? entryModel,
    bool? obscurePasswordBool = true,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          EntryDetailsEditableRoute.name,
          args: EntryDetailsEditableRouteArgs(
            entryPageType: entryPageType,
            parentFilesystemPath: parentFilesystemPath,
            entryModel: entryModel,
            obscurePasswordBool: obscurePasswordBool,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryDetailsEditableRoute';

  static const _i29.PageInfo<EntryDetailsEditableRouteArgs> page =
      _i29.PageInfo<EntryDetailsEditableRouteArgs>(name);
}

class EntryDetailsEditableRouteArgs {
  const EntryDetailsEditableRouteArgs({
    required this.entryPageType,
    this.parentFilesystemPath,
    this.entryModel,
    this.obscurePasswordBool = true,
    this.key,
  });

  final _i36.EntryPageType entryPageType;

  final _i37.FilesystemPath? parentFilesystemPath;

  final _i38.EntryModel? entryModel;

  final bool? obscurePasswordBool;

  final _i32.Key? key;

  @override
  String toString() {
    return 'EntryDetailsEditableRouteArgs{entryPageType: $entryPageType, parentFilesystemPath: $parentFilesystemPath, entryModel: $entryModel, obscurePasswordBool: $obscurePasswordBool, key: $key}';
  }
}

/// generated route for
/// [_i10.EntryDetailsPage]
class EntryDetailsRoute extends _i29.PageRouteInfo<EntryDetailsRouteArgs> {
  EntryDetailsRoute({
    required _i38.EntryModel entryModel,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          EntryDetailsRoute.name,
          args: EntryDetailsRouteArgs(
            entryModel: entryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryDetailsRoute';

  static const _i29.PageInfo<EntryDetailsRouteArgs> page =
      _i29.PageInfo<EntryDetailsRouteArgs>(name);
}

class EntryDetailsRouteArgs {
  const EntryDetailsRouteArgs({
    required this.entryModel,
    this.key,
  });

  final _i38.EntryModel entryModel;

  final _i32.Key? key;

  @override
  String toString() {
    return 'EntryDetailsRouteArgs{entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i11.EntryListPage]
class EntryListRoute extends _i29.PageRouteInfo<void> {
  const EntryListRoute({List<_i29.PageRouteInfo>? children})
      : super(
          EntryListRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntryListRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i12.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i29.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i39.EthereumTransactionModel ethereumTransactionModel,
    required _i40.NetworkTemplateModel networkTemplateModel,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<EthereumTransactionDetailsRouteArgs> page =
      _i29.PageInfo<EthereumTransactionDetailsRouteArgs>(name);
}

class EthereumTransactionDetailsRouteArgs {
  const EthereumTransactionDetailsRouteArgs({
    required this.ethereumTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i39.EthereumTransactionModel ethereumTransactionModel;

  final _i40.NetworkTemplateModel networkTemplateModel;

  final _i32.Key? key;

  @override
  String toString() {
    return 'EthereumTransactionDetailsRouteArgs{ethereumTransactionModel: $ethereumTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i13.NetworkListPage]
class NetworkListRoute extends _i29.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i41.VaultModel vaultModel,
    required _i37.FilesystemPath filesystemPath,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<NetworkListRouteArgs> page =
      _i29.PageInfo<NetworkListRouteArgs>(name);
}

class NetworkListRouteArgs {
  const NetworkListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    this.key,
  });

  final String name;

  final _i41.VaultModel vaultModel;

  final _i37.FilesystemPath filesystemPath;

  final _i32.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i14.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i29.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i29.PageRouteInfo>? children})
      : super(
          PrivacyPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i15.SettingsPage]
class SettingsRoute extends _i29.PageRouteInfo<void> {
  const SettingsRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i29.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i42.SolanaTransactionModel solanaTransactionModel,
    required _i40.NetworkTemplateModel networkTemplateModel,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<SolanaTransactionDetailsRouteArgs> page =
      _i29.PageInfo<SolanaTransactionDetailsRouteArgs>(name);
}

class SolanaTransactionDetailsRouteArgs {
  const SolanaTransactionDetailsRouteArgs({
    required this.solanaTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i42.SolanaTransactionModel solanaTransactionModel;

  final _i40.NetworkTemplateModel networkTemplateModel;

  final _i32.Key? key;

  @override
  String toString() {
    return 'SolanaTransactionDetailsRouteArgs{solanaTransactionModel: $solanaTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i17.SplashPage]
class SplashRoute extends _i29.PageRouteInfo<void> {
  const SplashRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i18.VaultCreatePage]
class VaultCreateRoute extends _i29.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i37.FilesystemPath parentFilesystemPath,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i29.PageInfo<VaultCreateRouteArgs> page =
      _i29.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i37.FilesystemPath parentFilesystemPath;

  final _i32.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i19.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i29.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i29.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i20.VaultInitPage]
class VaultInitRoute extends _i29.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i37.FilesystemPath parentFilesystemPath,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i29.PageInfo<VaultInitRouteArgs> page =
      _i29.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i37.FilesystemPath parentFilesystemPath;

  final _i32.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i21.VaultListPage]
class VaultListRoute extends _i29.PageRouteInfo<void> {
  const VaultListRoute({List<_i29.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i22.VaultRecoverPage]
class VaultRecoverRoute extends _i29.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i37.FilesystemPath parentFilesystemPath,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i29.PageInfo<VaultRecoverRouteArgs> page =
      _i29.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i37.FilesystemPath parentFilesystemPath;

  final _i32.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i23.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i29.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i24.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i29.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i29.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i29.PageInfo<void> page = _i29.PageInfo<void>(name);
}

/// generated route for
/// [_i25.WalletConnectPage]
class WalletConnectRoute extends _i29.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i41.VaultModel vaultModel,
    required _i43.WalletModel walletModel,
    required _i40.NetworkTemplateModel networkTemplateModel,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<WalletConnectRouteArgs> page =
      _i29.PageInfo<WalletConnectRouteArgs>(name);
}

class WalletConnectRouteArgs {
  const WalletConnectRouteArgs({
    required this.vaultModel,
    required this.walletModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i41.VaultModel vaultModel;

  final _i43.WalletModel walletModel;

  final _i40.NetworkTemplateModel networkTemplateModel;

  final _i32.Key? key;

  @override
  String toString() {
    return 'WalletConnectRouteArgs{vaultModel: $vaultModel, walletModel: $walletModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i26.WalletCreatePage]
class WalletCreateRoute extends _i29.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i41.VaultModel vaultModel,
    required _i37.FilesystemPath parentFilesystemPath,
    required _i44.NetworkGroupModel networkGroupModel,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<WalletCreateRouteArgs> page =
      _i29.PageInfo<WalletCreateRouteArgs>(name);
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.vaultModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final _i41.VaultModel vaultModel;

  final _i37.FilesystemPath parentFilesystemPath;

  final _i44.NetworkGroupModel networkGroupModel;

  final _i32.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{vaultModel: $vaultModel, parentFilesystemPath: $parentFilesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}

/// generated route for
/// [_i27.WalletDetailsPage]
class WalletDetailsRoute extends _i29.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i41.VaultModel vaultModel,
    required _i44.NetworkGroupModel networkGroupModel,
    required _i43.WalletModel walletModel,
    required _i45.WalletDetailsPageCubit walletDetailsPageCubit,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<WalletDetailsRouteArgs> page =
      _i29.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.vaultModel,
    required this.networkGroupModel,
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i41.VaultModel vaultModel;

  final _i44.NetworkGroupModel networkGroupModel;

  final _i43.WalletModel walletModel;

  final _i45.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i32.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{vaultModel: $vaultModel, networkGroupModel: $networkGroupModel, walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i28.WalletListPage]
class WalletListRoute extends _i29.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i41.VaultModel vaultModel,
    required _i37.FilesystemPath filesystemPath,
    required _i44.NetworkGroupModel networkGroupModel,
    _i32.Key? key,
    List<_i29.PageRouteInfo>? children,
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

  static const _i29.PageInfo<WalletListRouteArgs> page =
      _i29.PageInfo<WalletListRouteArgs>(name);
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

  final _i41.VaultModel vaultModel;

  final _i37.FilesystemPath filesystemPath;

  final _i44.NetworkGroupModel networkGroupModel;

  final _i32.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}
