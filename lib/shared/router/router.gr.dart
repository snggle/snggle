// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i31;
import 'package:flutter/cupertino.dart' as _i38;
import 'package:flutter/material.dart' as _i34;
import 'package:snggle/autofill_credential_picker_page.dart' as _i7;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i48;
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart'
    as _i39;
import 'package:snggle/shared/models/entries/entry_model.dart' as _i41;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i47;
import 'package:snggle/shared/models/mnemonic_model.dart' as _i36;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i43;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i42;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i45;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i33;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i44;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i46;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i40;
import 'package:snggle/views/pages/app_master_key/app_master_key_create_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_master_key/app_master_key_recover_page.dart'
    as _i3;
import 'package:snggle/views/pages/app_master_key/app_master_key_removed_page.dart'
    as _i4;
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart'
    as _i37;
import 'package:snggle/views/pages/app_pin_page/app_enter_pin_page.dart' as _i1;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i35;
import 'package:snggle/views/pages/app_pin_page/app_set_up_pin_page.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i8;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entries_section_wrapper.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_export_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_create_edit_status.dart'
    as _i32;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/privacy_policy_page/privacy_policy_page.dart'
    as _i16;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i17;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i25;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i15;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i14;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i18;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i23;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i26;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i27;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i29;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i30;
import 'package:snggle/views/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page.dart'
    as _i10;
import 'package:snggle/views/pages/splash_page.dart' as _i19;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i20;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i21;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i22;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i24;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i28;

abstract class $AppRouter extends _i31.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i31.PageFactory> pagesMap = {
    AppEnterPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppEnterPinRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AppEnterPinPage(
          autofillBool: args.autofillBool,
          key: args.key,
          appPinType: args.appPinType,
        ),
      );
    },
    AppMasterKeyCreateRoute.name: (routeData) {
      final args = routeData.argsAs<AppMasterKeyCreateRouteArgs>(
          orElse: () => const AppMasterKeyCreateRouteArgs());
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AppMasterKeyCreatePage(key: args.key),
      );
    },
    AppMasterKeyRecoverRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppMasterKeyRecoverPage(),
      );
    },
    AppMasterKeyRemovedRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AppMasterKeyRemovedPage(),
      );
    },
    AppSetUpPinRoute.name: (routeData) {
      final args = routeData.argsAs<AppSetUpPinRouteArgs>(
          orElse: () => const AppSetUpPinRouteArgs());
      return _i31.AutoRoutePage<dynamic>(
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
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.AppsPage(),
      );
    },
    AutofillCredentialPickerRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.AutofillCredentialPickerPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.BottomNavigationWrapper(),
      );
    },
    EntriesSectionWrapperRoute.name: (routeData) {
      final args = routeData.argsAs<EntriesSectionWrapperRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.EntriesSectionWrapper(
          readOnlyBool: args.readOnlyBool,
          key: args.key,
        ),
      );
    },
    EntryDetailsEditableRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsEditableRouteArgs>();
      return _i31.AutoRoutePage<_i32.EntryCreateEditStatus?>(
        routeData: routeData,
        child: _i10.EntryDetailsEditablePage(
          entryPageType: args.entryPageType,
          parentFilesystemPath: args.parentFilesystemPath,
          entryModel: args.entryModel,
          obscurePasswordBool: args.obscurePasswordBool,
          key: args.key,
        ),
      );
    },
    EntryDetailsExportRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsExportRouteArgs>();
      return _i31.AutoRoutePage<_i32.EntryCreateEditStatus?>(
        routeData: routeData,
        child: _i11.EntryDetailsExportPage(
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EntryDetailsRouteArgs>();
      return _i31.AutoRoutePage<_i32.EntryCreateEditStatus?>(
        routeData: routeData,
        child: _i12.EntryDetailsPage(
          entryModel: args.entryModel,
          key: args.key,
        ),
      );
    },
    EntryListRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.EntryListPage(),
      );
    },
    EthereumTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.EthereumTransactionDetailsPage(
          ethereumTransactionModel: args.ethereumTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    NetworkListRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkListRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.NetworkListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          key: args.key,
        ),
      );
    },
    PrivacyPolicyRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.PrivacyPolicyPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.SettingsPage(),
      );
    },
    SolanaTransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.SolanaTransactionDetailsPage(
          solanaTransactionModel: args.solanaTransactionModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.SplashPage(),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i31.AutoRoutePage<_i33.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i20.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i31.AutoRoutePage<_i33.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i21.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i31.AutoRoutePage<_i33.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i22.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i31.AutoRoutePage<_i33.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i24.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i25.VaultsSectionWrapper(),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i26.VaultsSectionWrapper(),
      );
    },
    WalletConnectRoute.name: (routeData) {
      final args = routeData.argsAs<WalletConnectRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i27.WalletConnectPage(
          vaultModel: args.vaultModel,
          walletModel: args.walletModel,
          networkTemplateModel: args.networkTemplateModel,
          key: args.key,
        ),
      );
    },
    WalletCreateRoute.name: (routeData) {
      final args = routeData.argsAs<WalletCreateRouteArgs>();
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i28.WalletCreatePage(
          vaultModel: args.vaultModel,
          parentFilesystemPath: args.parentFilesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i31.AutoRoutePage<void>(
        routeData: routeData,
        child: _i29.WalletDetailsPage(
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
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i30.WalletListPage(
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
class AppEnterPinRoute extends _i31.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    required bool autofillBool,
    _i34.Key? key,
    _i35.AppPinType appPinType = _i35.AppPinType.enterPin,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          AppEnterPinRoute.name,
          args: AppEnterPinRouteArgs(
            autofillBool: autofillBool,
            key: key,
            appPinType: appPinType,
          ),
          initialChildren: children,
        );

  static const String name = 'AppEnterPinRoute';

  static const _i31.PageInfo<AppEnterPinRouteArgs> page =
      _i31.PageInfo<AppEnterPinRouteArgs>(name);
}

class AppEnterPinRouteArgs {
  const AppEnterPinRouteArgs({
    required this.autofillBool,
    this.key,
    this.appPinType = _i35.AppPinType.enterPin,
  });

  final bool autofillBool;

  final _i34.Key? key;

  final _i35.AppPinType appPinType;

  @override
  String toString() {
    return 'AppEnterPinRouteArgs{autofillBool: $autofillBool, key: $key, appPinType: $appPinType}';
  }
}

/// generated route for
/// [_i2.AppMasterKeyCreatePage]
class AppMasterKeyCreateRoute
    extends _i31.PageRouteInfo<AppMasterKeyCreateRouteArgs> {
  AppMasterKeyCreateRoute({
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          AppMasterKeyCreateRoute.name,
          args: AppMasterKeyCreateRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyCreateRoute';

  static const _i31.PageInfo<AppMasterKeyCreateRouteArgs> page =
      _i31.PageInfo<AppMasterKeyCreateRouteArgs>(name);
}

class AppMasterKeyCreateRouteArgs {
  const AppMasterKeyCreateRouteArgs({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return 'AppMasterKeyCreateRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.AppMasterKeyRecoverPage]
class AppMasterKeyRecoverRoute extends _i31.PageRouteInfo<void> {
  const AppMasterKeyRecoverRoute({List<_i31.PageRouteInfo>? children})
      : super(
          AppMasterKeyRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyRecoverRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i4.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute extends _i31.PageRouteInfo<void> {
  const AppMasterKeyRemovedRoute({List<_i31.PageRouteInfo>? children})
      : super(
          AppMasterKeyRemovedRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMasterKeyRemovedRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i5.AppSetUpPinPage]
class AppSetUpPinRoute extends _i31.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i36.MnemonicModel? mnemonicModel,
    _i35.AppPinType appPinType = _i35.AppPinType.setUpPin,
    _i37.AppMasterKeyType? appMasterKeyType,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<AppSetUpPinRouteArgs> page =
      _i31.PageInfo<AppSetUpPinRouteArgs>(name);
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.mnemonicModel,
    this.appPinType = _i35.AppPinType.setUpPin,
    this.appMasterKeyType,
    this.key,
  });

  final _i36.MnemonicModel? mnemonicModel;

  final _i35.AppPinType appPinType;

  final _i37.AppMasterKeyType? appMasterKeyType;

  final _i34.Key? key;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{mnemonicModel: $mnemonicModel, appPinType: $appPinType, appMasterKeyType: $appMasterKeyType, key: $key}';
  }
}

/// generated route for
/// [_i6.AppsPage]
class AppsRoute extends _i31.PageRouteInfo<void> {
  const AppsRoute({List<_i31.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i7.AutofillCredentialPickerPage]
class AutofillCredentialPickerRoute extends _i31.PageRouteInfo<void> {
  const AutofillCredentialPickerRoute({List<_i31.PageRouteInfo>? children})
      : super(
          AutofillCredentialPickerRoute.name,
          initialChildren: children,
        );

  static const String name = 'AutofillCredentialPickerRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i8.BottomNavigationWrapper]
class BottomNavigationRoute extends _i31.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i31.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i9.EntriesSectionWrapper]
class EntriesSectionWrapperRoute
    extends _i31.PageRouteInfo<EntriesSectionWrapperRouteArgs> {
  EntriesSectionWrapperRoute({
    required bool readOnlyBool,
    _i38.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          EntriesSectionWrapperRoute.name,
          args: EntriesSectionWrapperRouteArgs(
            readOnlyBool: readOnlyBool,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntriesSectionWrapperRoute';

  static const _i31.PageInfo<EntriesSectionWrapperRouteArgs> page =
      _i31.PageInfo<EntriesSectionWrapperRouteArgs>(name);
}

class EntriesSectionWrapperRouteArgs {
  const EntriesSectionWrapperRouteArgs({
    required this.readOnlyBool,
    this.key,
  });

  final bool readOnlyBool;

  final _i38.Key? key;

  @override
  String toString() {
    return 'EntriesSectionWrapperRouteArgs{readOnlyBool: $readOnlyBool, key: $key}';
  }
}

/// generated route for
/// [_i10.EntryDetailsEditablePage]
class EntryDetailsEditableRoute
    extends _i31.PageRouteInfo<EntryDetailsEditableRouteArgs> {
  EntryDetailsEditableRoute({
    required _i39.EntryPageType entryPageType,
    _i40.FilesystemPath? parentFilesystemPath,
    _i41.EntryModel? entryModel,
    bool? obscurePasswordBool = true,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<EntryDetailsEditableRouteArgs> page =
      _i31.PageInfo<EntryDetailsEditableRouteArgs>(name);
}

class EntryDetailsEditableRouteArgs {
  const EntryDetailsEditableRouteArgs({
    required this.entryPageType,
    this.parentFilesystemPath,
    this.entryModel,
    this.obscurePasswordBool = true,
    this.key,
  });

  final _i39.EntryPageType entryPageType;

  final _i40.FilesystemPath? parentFilesystemPath;

  final _i41.EntryModel? entryModel;

  final bool? obscurePasswordBool;

  final _i34.Key? key;

  @override
  String toString() {
    return 'EntryDetailsEditableRouteArgs{entryPageType: $entryPageType, parentFilesystemPath: $parentFilesystemPath, entryModel: $entryModel, obscurePasswordBool: $obscurePasswordBool, key: $key}';
  }
}

/// generated route for
/// [_i11.EntryDetailsExportPage]
class EntryDetailsExportRoute
    extends _i31.PageRouteInfo<EntryDetailsExportRouteArgs> {
  EntryDetailsExportRoute({
    required _i41.EntryModel entryModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          EntryDetailsExportRoute.name,
          args: EntryDetailsExportRouteArgs(
            entryModel: entryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryDetailsExportRoute';

  static const _i31.PageInfo<EntryDetailsExportRouteArgs> page =
      _i31.PageInfo<EntryDetailsExportRouteArgs>(name);
}

class EntryDetailsExportRouteArgs {
  const EntryDetailsExportRouteArgs({
    required this.entryModel,
    this.key,
  });

  final _i41.EntryModel entryModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'EntryDetailsExportRouteArgs{entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i12.EntryDetailsPage]
class EntryDetailsRoute extends _i31.PageRouteInfo<EntryDetailsRouteArgs> {
  EntryDetailsRoute({
    required _i41.EntryModel entryModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          EntryDetailsRoute.name,
          args: EntryDetailsRouteArgs(
            entryModel: entryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'EntryDetailsRoute';

  static const _i31.PageInfo<EntryDetailsRouteArgs> page =
      _i31.PageInfo<EntryDetailsRouteArgs>(name);
}

class EntryDetailsRouteArgs {
  const EntryDetailsRouteArgs({
    required this.entryModel,
    this.key,
  });

  final _i41.EntryModel entryModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'EntryDetailsRouteArgs{entryModel: $entryModel, key: $key}';
  }
}

/// generated route for
/// [_i13.EntryListPage]
class EntryListRoute extends _i31.PageRouteInfo<void> {
  const EntryListRoute({List<_i31.PageRouteInfo>? children})
      : super(
          EntryListRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntryListRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i14.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i31.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i42.EthereumTransactionModel ethereumTransactionModel,
    required _i43.NetworkTemplateModel networkTemplateModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<EthereumTransactionDetailsRouteArgs> page =
      _i31.PageInfo<EthereumTransactionDetailsRouteArgs>(name);
}

class EthereumTransactionDetailsRouteArgs {
  const EthereumTransactionDetailsRouteArgs({
    required this.ethereumTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i42.EthereumTransactionModel ethereumTransactionModel;

  final _i43.NetworkTemplateModel networkTemplateModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'EthereumTransactionDetailsRouteArgs{ethereumTransactionModel: $ethereumTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i15.NetworkListPage]
class NetworkListRoute extends _i31.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i44.VaultModel vaultModel,
    required _i40.FilesystemPath filesystemPath,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<NetworkListRouteArgs> page =
      _i31.PageInfo<NetworkListRouteArgs>(name);
}

class NetworkListRouteArgs {
  const NetworkListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    this.key,
  });

  final String name;

  final _i44.VaultModel vaultModel;

  final _i40.FilesystemPath filesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i16.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i31.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i31.PageRouteInfo>? children})
      : super(
          PrivacyPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i17.SettingsPage]
class SettingsRoute extends _i31.PageRouteInfo<void> {
  const SettingsRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i18.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i31.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i45.SolanaTransactionModel solanaTransactionModel,
    required _i43.NetworkTemplateModel networkTemplateModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<SolanaTransactionDetailsRouteArgs> page =
      _i31.PageInfo<SolanaTransactionDetailsRouteArgs>(name);
}

class SolanaTransactionDetailsRouteArgs {
  const SolanaTransactionDetailsRouteArgs({
    required this.solanaTransactionModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i45.SolanaTransactionModel solanaTransactionModel;

  final _i43.NetworkTemplateModel networkTemplateModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'SolanaTransactionDetailsRouteArgs{solanaTransactionModel: $solanaTransactionModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i19.SplashPage]
class SplashRoute extends _i31.PageRouteInfo<void> {
  const SplashRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i20.VaultCreatePage]
class VaultCreateRoute extends _i31.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i40.FilesystemPath parentFilesystemPath,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i31.PageInfo<VaultCreateRouteArgs> page =
      _i31.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i40.FilesystemPath parentFilesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i21.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i31.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i31.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i22.VaultInitPage]
class VaultInitRoute extends _i31.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i40.FilesystemPath parentFilesystemPath,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i31.PageInfo<VaultInitRouteArgs> page =
      _i31.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i40.FilesystemPath parentFilesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i23.VaultListPage]
class VaultListRoute extends _i31.PageRouteInfo<void> {
  const VaultListRoute({List<_i31.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i24.VaultRecoverPage]
class VaultRecoverRoute extends _i31.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i40.FilesystemPath parentFilesystemPath,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i31.PageInfo<VaultRecoverRouteArgs> page =
      _i31.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i40.FilesystemPath parentFilesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i25.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i31.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i26.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i31.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i31.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i27.WalletConnectPage]
class WalletConnectRoute extends _i31.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i44.VaultModel vaultModel,
    required _i46.WalletModel walletModel,
    required _i43.NetworkTemplateModel networkTemplateModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<WalletConnectRouteArgs> page =
      _i31.PageInfo<WalletConnectRouteArgs>(name);
}

class WalletConnectRouteArgs {
  const WalletConnectRouteArgs({
    required this.vaultModel,
    required this.walletModel,
    required this.networkTemplateModel,
    this.key,
  });

  final _i44.VaultModel vaultModel;

  final _i46.WalletModel walletModel;

  final _i43.NetworkTemplateModel networkTemplateModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletConnectRouteArgs{vaultModel: $vaultModel, walletModel: $walletModel, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i28.WalletCreatePage]
class WalletCreateRoute extends _i31.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i44.VaultModel vaultModel,
    required _i40.FilesystemPath parentFilesystemPath,
    required _i47.NetworkGroupModel networkGroupModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<WalletCreateRouteArgs> page =
      _i31.PageInfo<WalletCreateRouteArgs>(name);
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.vaultModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final _i44.VaultModel vaultModel;

  final _i40.FilesystemPath parentFilesystemPath;

  final _i47.NetworkGroupModel networkGroupModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{vaultModel: $vaultModel, parentFilesystemPath: $parentFilesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}

/// generated route for
/// [_i29.WalletDetailsPage]
class WalletDetailsRoute extends _i31.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i44.VaultModel vaultModel,
    required _i47.NetworkGroupModel networkGroupModel,
    required _i46.WalletModel walletModel,
    required _i48.WalletDetailsPageCubit walletDetailsPageCubit,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<WalletDetailsRouteArgs> page =
      _i31.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.vaultModel,
    required this.networkGroupModel,
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i44.VaultModel vaultModel;

  final _i47.NetworkGroupModel networkGroupModel;

  final _i46.WalletModel walletModel;

  final _i48.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{vaultModel: $vaultModel, networkGroupModel: $networkGroupModel, walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i30.WalletListPage]
class WalletListRoute extends _i31.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i44.VaultModel vaultModel,
    required _i40.FilesystemPath filesystemPath,
    required _i47.NetworkGroupModel networkGroupModel,
    _i34.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<WalletListRouteArgs> page =
      _i31.PageInfo<WalletListRouteArgs>(name);
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

  final _i44.VaultModel vaultModel;

  final _i40.FilesystemPath filesystemPath;

  final _i47.NetworkGroupModel networkGroupModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}
