// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i32;
import 'package:flutter/material.dart' as _i34;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i48;
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart'
    as _i39;
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart'
    as _i38;
import 'package:snggle/shared/models/entries/entry_model.dart' as _i41;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i47;
import 'package:snggle/shared/models/mnemonic_model.dart' as _i37;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i43;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i42;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i45;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i44;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i46;
import 'package:snggle/shared/native/app_launch_mode.dart' as _i35;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i40;
import 'package:snggle/views/pages/app_master_key/app_master_key_create_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_master_key/app_master_key_recover_page.dart'
    as _i3;
import 'package:snggle/views/pages/app_master_key/app_master_key_removed_page.dart'
    as _i4;
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart'
    as _i36;
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
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/read_only_entries_wrapper/read_only_entries_section_wrapper.dart'
    as _i15;
import 'package:snggle/views/pages/bottom_navigation/read_only_entries_wrapper/read_only_entry_details_page.dart'
    as _i16;
import 'package:snggle/views/pages/bottom_navigation/read_only_entries_wrapper/read_only_entry_list_page.dart'
    as _i17;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/privacy_policy_page/privacy_policy_page.dart'
    as _i14;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i18;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i26;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i19;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i24;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i27;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i28;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i30;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i31;
import 'package:snggle/views/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page.dart'
    as _i9;
import 'package:snggle/views/pages/splash_page.dart' as _i20;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i21;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i22;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i23;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i25;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i29;

/// generated route for
/// [_i1.AppEnterPinPage]
class AppEnterPinRoute extends _i32.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    _i33.AppPinType appPinType = _i33.AppPinType.enterPin,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         AppEnterPinRoute.name,
         args: AppEnterPinRouteArgs(appPinType: appPinType, key: key),
         initialChildren: children,
       );

  static const String name = 'AppEnterPinRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppEnterPinRouteArgs>(
        orElse: () => const AppEnterPinRouteArgs(),
      );
      return _i1.AppEnterPinPage(appPinType: args.appPinType, key: args.key);
    },
  );
}

class AppEnterPinRouteArgs {
  const AppEnterPinRouteArgs({
    this.appPinType = _i33.AppPinType.enterPin,
    this.key,
  });

  final _i33.AppPinType appPinType;

  final _i34.Key? key;

  @override
  String toString() {
    return 'AppEnterPinRouteArgs{appPinType: $appPinType, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppEnterPinRouteArgs) return false;
    return appPinType == other.appPinType && key == other.key;
  }

  @override
  int get hashCode => appPinType.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i2.AppMasterKeyCreatePage]
class AppMasterKeyCreateRoute extends _i32.PageRouteInfo<void> {
  const AppMasterKeyCreateRoute({List<_i32.PageRouteInfo>? children})
    : super(AppMasterKeyCreateRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyCreateRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppMasterKeyCreatePage();
    },
  );
}

/// generated route for
/// [_i3.AppMasterKeyRecoverPage]
class AppMasterKeyRecoverRoute extends _i32.PageRouteInfo<void> {
  const AppMasterKeyRecoverRoute({List<_i32.PageRouteInfo>? children})
    : super(AppMasterKeyRecoverRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyRecoverRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i3.AppMasterKeyRecoverPage();
    },
  );
}

/// generated route for
/// [_i4.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute
    extends _i32.PageRouteInfo<AppMasterKeyRemovedRouteArgs> {
  AppMasterKeyRemovedRoute({
    required _i35.AppLaunchMode appLaunchMode,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         AppMasterKeyRemovedRoute.name,
         args: AppMasterKeyRemovedRouteArgs(
           appLaunchMode: appLaunchMode,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AppMasterKeyRemovedRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppMasterKeyRemovedRouteArgs>();
      return _i4.AppMasterKeyRemovedPage(
        appLaunchMode: args.appLaunchMode,
        key: args.key,
      );
    },
  );
}

class AppMasterKeyRemovedRouteArgs {
  const AppMasterKeyRemovedRouteArgs({required this.appLaunchMode, this.key});

  final _i35.AppLaunchMode appLaunchMode;

  final _i34.Key? key;

  @override
  String toString() {
    return 'AppMasterKeyRemovedRouteArgs{appLaunchMode: $appLaunchMode, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppMasterKeyRemovedRouteArgs) return false;
    return appLaunchMode == other.appLaunchMode && key == other.key;
  }

  @override
  int get hashCode => appLaunchMode.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i5.AppSetUpPinPage]
class AppSetUpPinRoute extends _i32.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i36.AppMasterKeyType? appMasterKeyType,
    _i33.AppPinType appPinType = _i33.AppPinType.setUpPin,
    _i37.MnemonicModel? mnemonicModel,
    _i38.PinpadKeyboardState initPinpadKeyboardState =
        _i38.PinpadKeyboardState.initPinpadKeyboardState,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         AppSetUpPinRoute.name,
         args: AppSetUpPinRouteArgs(
           appMasterKeyType: appMasterKeyType,
           appPinType: appPinType,
           mnemonicModel: mnemonicModel,
           initPinpadKeyboardState: initPinpadKeyboardState,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AppSetUpPinRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppSetUpPinRouteArgs>(
        orElse: () => const AppSetUpPinRouteArgs(),
      );
      return _i5.AppSetUpPinPage(
        appMasterKeyType: args.appMasterKeyType,
        appPinType: args.appPinType,
        mnemonicModel: args.mnemonicModel,
        initPinpadKeyboardState: args.initPinpadKeyboardState,
        key: args.key,
      );
    },
  );
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.appMasterKeyType,
    this.appPinType = _i33.AppPinType.setUpPin,
    this.mnemonicModel,
    this.initPinpadKeyboardState =
        _i38.PinpadKeyboardState.initPinpadKeyboardState,
    this.key,
  });

  final _i36.AppMasterKeyType? appMasterKeyType;

  final _i33.AppPinType appPinType;

  final _i37.MnemonicModel? mnemonicModel;

  final _i38.PinpadKeyboardState initPinpadKeyboardState;

  final _i34.Key? key;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{appMasterKeyType: $appMasterKeyType, appPinType: $appPinType, mnemonicModel: $mnemonicModel, initPinpadKeyboardState: $initPinpadKeyboardState, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppSetUpPinRouteArgs) return false;
    return appMasterKeyType == other.appMasterKeyType &&
        appPinType == other.appPinType &&
        mnemonicModel == other.mnemonicModel &&
        initPinpadKeyboardState == other.initPinpadKeyboardState &&
        key == other.key;
  }

  @override
  int get hashCode =>
      appMasterKeyType.hashCode ^
      appPinType.hashCode ^
      mnemonicModel.hashCode ^
      initPinpadKeyboardState.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i6.AppsPage]
class AppsRoute extends _i32.PageRouteInfo<void> {
  const AppsRoute({List<_i32.PageRouteInfo>? children})
    : super(AppsRoute.name, initialChildren: children);

  static const String name = 'AppsRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i6.AppsPage();
    },
  );
}

/// generated route for
/// [_i7.BottomNavigationWrapper]
class BottomNavigationRoute extends _i32.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i32.PageRouteInfo>? children})
    : super(BottomNavigationRoute.name, initialChildren: children);

  static const String name = 'BottomNavigationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i7.BottomNavigationWrapper();
    },
  );
}

/// generated route for
/// [_i8.EntriesSectionWrapper]
class EntriesSectionWrapperRoute extends _i32.PageRouteInfo<void> {
  const EntriesSectionWrapperRoute({List<_i32.PageRouteInfo>? children})
    : super(EntriesSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'EntriesSectionWrapperRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i8.EntriesSectionWrapper();
    },
  );
}

/// generated route for
/// [_i9.EntryDetailsEditablePage]
class EntryDetailsEditableRoute
    extends _i32.PageRouteInfo<EntryDetailsEditableRouteArgs> {
  EntryDetailsEditableRoute({
    required _i39.EntryPageType entryPageType,
    _i40.FilesystemPath? parentFilesystemPath,
    _i41.EntryModel? entryModel,
    bool? obscurePasswordBool = true,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EntryDetailsEditableRouteArgs>();
      return _i9.EntryDetailsEditablePage(
        entryPageType: args.entryPageType,
        parentFilesystemPath: args.parentFilesystemPath,
        entryModel: args.entryModel,
        obscurePasswordBool: args.obscurePasswordBool,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EntryDetailsEditableRouteArgs) return false;
    return entryPageType == other.entryPageType &&
        parentFilesystemPath == other.parentFilesystemPath &&
        entryModel == other.entryModel &&
        obscurePasswordBool == other.obscurePasswordBool &&
        key == other.key;
  }

  @override
  int get hashCode =>
      entryPageType.hashCode ^
      parentFilesystemPath.hashCode ^
      entryModel.hashCode ^
      obscurePasswordBool.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i10.EntryDetailsPage]
class EntryDetailsRoute extends _i32.PageRouteInfo<EntryDetailsRouteArgs> {
  EntryDetailsRoute({
    required _i41.EntryModel entryModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         EntryDetailsRoute.name,
         args: EntryDetailsRouteArgs(entryModel: entryModel, key: key),
         initialChildren: children,
       );

  static const String name = 'EntryDetailsRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EntryDetailsRouteArgs>();
      return _i10.EntryDetailsPage(entryModel: args.entryModel, key: args.key);
    },
  );
}

class EntryDetailsRouteArgs {
  const EntryDetailsRouteArgs({required this.entryModel, this.key});

  final _i41.EntryModel entryModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'EntryDetailsRouteArgs{entryModel: $entryModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EntryDetailsRouteArgs) return false;
    return entryModel == other.entryModel && key == other.key;
  }

  @override
  int get hashCode => entryModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i11.EntryListPage]
class EntryListRoute extends _i32.PageRouteInfo<void> {
  const EntryListRoute({List<_i32.PageRouteInfo>? children})
    : super(EntryListRoute.name, initialChildren: children);

  static const String name = 'EntryListRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i11.EntryListPage();
    },
  );
}

/// generated route for
/// [_i12.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i32.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i42.EthereumTransactionModel ethereumTransactionModel,
    required _i43.NetworkTemplateModel networkTemplateModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i12.EthereumTransactionDetailsPage(
        ethereumTransactionModel: args.ethereumTransactionModel,
        networkTemplateModel: args.networkTemplateModel,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EthereumTransactionDetailsRouteArgs) return false;
    return ethereumTransactionModel == other.ethereumTransactionModel &&
        networkTemplateModel == other.networkTemplateModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      ethereumTransactionModel.hashCode ^
      networkTemplateModel.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i13.NetworkListPage]
class NetworkListRoute extends _i32.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i44.VaultModel vaultModel,
    required _i40.FilesystemPath filesystemPath,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NetworkListRouteArgs>();
      return _i13.NetworkListPage(
        name: args.name,
        vaultModel: args.vaultModel,
        filesystemPath: args.filesystemPath,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NetworkListRouteArgs) return false;
    return name == other.name &&
        vaultModel == other.vaultModel &&
        filesystemPath == other.filesystemPath &&
        key == other.key;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      vaultModel.hashCode ^
      filesystemPath.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i14.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i32.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i32.PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i14.PrivacyPolicyPage();
    },
  );
}

/// generated route for
/// [_i15.ReadOnlyEntriesSectionWrapper]
class ReadOnlyEntriesSectionWrapperRoute extends _i32.PageRouteInfo<void> {
  const ReadOnlyEntriesSectionWrapperRoute({List<_i32.PageRouteInfo>? children})
    : super(ReadOnlyEntriesSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'ReadOnlyEntriesSectionWrapperRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i15.ReadOnlyEntriesSectionWrapper();
    },
  );
}

/// generated route for
/// [_i16.ReadOnlyEntryDetailsPage]
class ReadOnlyEntryDetailsRoute
    extends _i32.PageRouteInfo<ReadOnlyEntryDetailsRouteArgs> {
  ReadOnlyEntryDetailsRoute({
    required _i41.EntryModel entryModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         ReadOnlyEntryDetailsRoute.name,
         args: ReadOnlyEntryDetailsRouteArgs(entryModel: entryModel, key: key),
         initialChildren: children,
       );

  static const String name = 'ReadOnlyEntryDetailsRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReadOnlyEntryDetailsRouteArgs>();
      return _i16.ReadOnlyEntryDetailsPage(
        entryModel: args.entryModel,
        key: args.key,
      );
    },
  );
}

class ReadOnlyEntryDetailsRouteArgs {
  const ReadOnlyEntryDetailsRouteArgs({required this.entryModel, this.key});

  final _i41.EntryModel entryModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'ReadOnlyEntryDetailsRouteArgs{entryModel: $entryModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReadOnlyEntryDetailsRouteArgs) return false;
    return entryModel == other.entryModel && key == other.key;
  }

  @override
  int get hashCode => entryModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i17.ReadOnlyEntryListPage]
class ReadOnlyEntryListRoute extends _i32.PageRouteInfo<void> {
  const ReadOnlyEntryListRoute({List<_i32.PageRouteInfo>? children})
    : super(ReadOnlyEntryListRoute.name, initialChildren: children);

  static const String name = 'ReadOnlyEntryListRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i17.ReadOnlyEntryListPage();
    },
  );
}

/// generated route for
/// [_i18.SettingsPage]
class SettingsRoute extends _i32.PageRouteInfo<void> {
  const SettingsRoute({List<_i32.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i18.SettingsPage();
    },
  );
}

/// generated route for
/// [_i19.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i32.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i45.SolanaTransactionModel solanaTransactionModel,
    required _i43.NetworkTemplateModel networkTemplateModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i19.SolanaTransactionDetailsPage(
        solanaTransactionModel: args.solanaTransactionModel,
        networkTemplateModel: args.networkTemplateModel,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SolanaTransactionDetailsRouteArgs) return false;
    return solanaTransactionModel == other.solanaTransactionModel &&
        networkTemplateModel == other.networkTemplateModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      solanaTransactionModel.hashCode ^
      networkTemplateModel.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i20.SplashPage]
class SplashRoute extends _i32.PageRouteInfo<void> {
  const SplashRoute({List<_i32.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i20.SplashPage();
    },
  );
}

/// generated route for
/// [_i21.VaultCreatePage]
class VaultCreateRoute extends _i32.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i40.FilesystemPath parentFilesystemPath,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         VaultCreateRoute.name,
         args: VaultCreateRouteArgs(
           parentFilesystemPath: parentFilesystemPath,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'VaultCreateRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultCreateRouteArgs>();
      return _i21.VaultCreatePage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({required this.parentFilesystemPath, this.key});

  final _i40.FilesystemPath parentFilesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VaultCreateRouteArgs) return false;
    return parentFilesystemPath == other.parentFilesystemPath &&
        key == other.key;
  }

  @override
  int get hashCode => parentFilesystemPath.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i22.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i32.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i32.PageRouteInfo>? children})
    : super(VaultCreateRecoverRoute.name, initialChildren: children);

  static const String name = 'VaultCreateRecoverRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i22.VaultCreateRecoverWrapper();
    },
  );
}

/// generated route for
/// [_i23.VaultInitPage]
class VaultInitRoute extends _i32.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i40.FilesystemPath parentFilesystemPath,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         VaultInitRoute.name,
         args: VaultInitRouteArgs(
           parentFilesystemPath: parentFilesystemPath,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'VaultInitRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultInitRouteArgs>();
      return _i23.VaultInitPage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({required this.parentFilesystemPath, this.key});

  final _i40.FilesystemPath parentFilesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VaultInitRouteArgs) return false;
    return parentFilesystemPath == other.parentFilesystemPath &&
        key == other.key;
  }

  @override
  int get hashCode => parentFilesystemPath.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i24.VaultListPage]
class VaultListRoute extends _i32.PageRouteInfo<void> {
  const VaultListRoute({List<_i32.PageRouteInfo>? children})
    : super(VaultListRoute.name, initialChildren: children);

  static const String name = 'VaultListRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i24.VaultListPage();
    },
  );
}

/// generated route for
/// [_i25.VaultRecoverPage]
class VaultRecoverRoute extends _i32.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i40.FilesystemPath parentFilesystemPath,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         VaultRecoverRoute.name,
         args: VaultRecoverRouteArgs(
           parentFilesystemPath: parentFilesystemPath,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'VaultRecoverRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultRecoverRouteArgs>();
      return _i25.VaultRecoverPage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({required this.parentFilesystemPath, this.key});

  final _i40.FilesystemPath parentFilesystemPath;

  final _i34.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VaultRecoverRouteArgs) return false;
    return parentFilesystemPath == other.parentFilesystemPath &&
        key == other.key;
  }

  @override
  int get hashCode => parentFilesystemPath.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i26.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i32.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i32.PageRouteInfo>? children})
    : super(SettingsSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'SettingsSectionWrapperRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i26.VaultsSectionWrapper();
    },
  );
}

/// generated route for
/// [_i27.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i32.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i32.PageRouteInfo>? children})
    : super(VaultsSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'VaultsSectionWrapperRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i27.VaultsSectionWrapper();
    },
  );
}

/// generated route for
/// [_i28.WalletConnectPage]
class WalletConnectRoute extends _i32.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i44.VaultModel vaultModel,
    required _i46.WalletModel walletModel,
    required _i43.NetworkTemplateModel networkTemplateModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletConnectRouteArgs>();
      return _i28.WalletConnectPage(
        vaultModel: args.vaultModel,
        walletModel: args.walletModel,
        networkTemplateModel: args.networkTemplateModel,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WalletConnectRouteArgs) return false;
    return vaultModel == other.vaultModel &&
        walletModel == other.walletModel &&
        networkTemplateModel == other.networkTemplateModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      vaultModel.hashCode ^
      walletModel.hashCode ^
      networkTemplateModel.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i29.WalletCreatePage]
class WalletCreateRoute extends _i32.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i47.NetworkGroupModel networkGroupModel,
    required _i40.FilesystemPath parentFilesystemPath,
    required _i44.VaultModel vaultModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
  }) : super(
         WalletCreateRoute.name,
         args: WalletCreateRouteArgs(
           networkGroupModel: networkGroupModel,
           parentFilesystemPath: parentFilesystemPath,
           vaultModel: vaultModel,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'WalletCreateRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletCreateRouteArgs>();
      return _i29.WalletCreatePage(
        networkGroupModel: args.networkGroupModel,
        parentFilesystemPath: args.parentFilesystemPath,
        vaultModel: args.vaultModel,
        key: args.key,
      );
    },
  );
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.networkGroupModel,
    required this.parentFilesystemPath,
    required this.vaultModel,
    this.key,
  });

  final _i47.NetworkGroupModel networkGroupModel;

  final _i40.FilesystemPath parentFilesystemPath;

  final _i44.VaultModel vaultModel;

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{networkGroupModel: $networkGroupModel, parentFilesystemPath: $parentFilesystemPath, vaultModel: $vaultModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WalletCreateRouteArgs) return false;
    return networkGroupModel == other.networkGroupModel &&
        parentFilesystemPath == other.parentFilesystemPath &&
        vaultModel == other.vaultModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      networkGroupModel.hashCode ^
      parentFilesystemPath.hashCode ^
      vaultModel.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i30.WalletDetailsPage]
class WalletDetailsRoute extends _i32.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i44.VaultModel vaultModel,
    required _i47.NetworkGroupModel networkGroupModel,
    required _i46.WalletModel walletModel,
    required _i48.WalletDetailsPageCubit walletDetailsPageCubit,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletDetailsRouteArgs>();
      return _i30.WalletDetailsPage(
        vaultModel: args.vaultModel,
        networkGroupModel: args.networkGroupModel,
        walletModel: args.walletModel,
        walletDetailsPageCubit: args.walletDetailsPageCubit,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WalletDetailsRouteArgs) return false;
    return vaultModel == other.vaultModel &&
        networkGroupModel == other.networkGroupModel &&
        walletModel == other.walletModel &&
        walletDetailsPageCubit == other.walletDetailsPageCubit &&
        key == other.key;
  }

  @override
  int get hashCode =>
      vaultModel.hashCode ^
      networkGroupModel.hashCode ^
      walletModel.hashCode ^
      walletDetailsPageCubit.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i31.WalletListPage]
class WalletListRoute extends _i32.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i44.VaultModel vaultModel,
    required _i40.FilesystemPath filesystemPath,
    required _i47.NetworkGroupModel networkGroupModel,
    _i34.Key? key,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletListRouteArgs>();
      return _i31.WalletListPage(
        name: args.name,
        vaultModel: args.vaultModel,
        filesystemPath: args.filesystemPath,
        networkGroupModel: args.networkGroupModel,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WalletListRouteArgs) return false;
    return name == other.name &&
        vaultModel == other.vaultModel &&
        filesystemPath == other.filesystemPath &&
        networkGroupModel == other.networkGroupModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      vaultModel.hashCode ^
      filesystemPath.hashCode ^
      networkGroupModel.hashCode ^
      key.hashCode;
}
