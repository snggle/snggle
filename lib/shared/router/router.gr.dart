// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i40;
import 'package:flutter/material.dart' as _i42;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i57;
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart'
    as _i47;
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart'
    as _i46;
import 'package:snggle/shared/models/entries/entry_model.dart' as _i49;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i56;
import 'package:snggle/shared/models/mnemonic_model.dart' as _i45;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i51;
import 'package:snggle/shared/models/passkeys/passkey_model.dart' as _i53;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i50;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i54;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i52;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i55;
import 'package:snggle/shared/native/app_launch_mode.dart' as _i41;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i48;
import 'package:snggle/views/pages/app_master_key/app_master_key_create_page.dart'
    as _i1;
import 'package:snggle/views/pages/app_master_key/app_master_key_recover_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_master_key/app_master_key_removed_page.dart'
    as _i3;
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart'
    as _i44;
import 'package:snggle/views/pages/app_pin_page/app_pin_auth_page.dart' as _i4;
import 'package:snggle/views/pages/app_pin_page/app_pin_change_wrapper.dart'
    as _i5;
import 'package:snggle/views/pages/app_pin_page/app_pin_set_up_page.dart'
    as _i6;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i43;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i8;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entries_section_wrapper.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_list_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/passkeys_wrapper/passkey_details_page/passkey_details_page.dart'
    as _i16;
import 'package:snggle/views/pages/bottom_navigation/passkeys_wrapper/passkey_list_page/passkey_list_page.dart'
    as _i17;
import 'package:snggle/views/pages/bottom_navigation/passkeys_wrapper/passkeys_section_wrapper.dart'
    as _i18;
import 'package:snggle/views/pages/bottom_navigation/read_only_entries_wrapper/read_only_entries_section_wrapper.dart'
    as _i20;
import 'package:snggle/views/pages/bottom_navigation/read_only_entries_wrapper/read_only_entry_details_page.dart'
    as _i21;
import 'package:snggle/views/pages/bottom_navigation/read_only_entries_wrapper/read_only_entry_list_page.dart'
    as _i22;
import 'package:snggle/views/pages/bottom_navigation/read_only_passkeys_wrapper/read_only_passkey_details_page.dart'
    as _i23;
import 'package:snggle/views/pages/bottom_navigation/read_only_passkeys_wrapper/read_only_passkey_list_page.dart'
    as _i24;
import 'package:snggle/views/pages/bottom_navigation/read_only_passkeys_wrapper/read_only_passkeys_section_wrapper.dart'
    as _i25;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/privacy_policy_page/privacy_policy_page.dart'
    as _i19;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i26;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i34;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i14;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/solana_transaction_details_page.dart'
    as _i27;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i32;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i35;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page.dart'
    as _i36;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i38;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i39;
import 'package:snggle/views/pages/entry_details_editable/entry_details_editable_page/autofill_save_entry_page.dart'
    as _i7;
import 'package:snggle/views/pages/entry_details_editable/entry_details_editable_page/entry_details_editable_page.dart'
    as _i10;
import 'package:snggle/views/pages/passkey_create_page/passkey_create_page.dart'
    as _i15;
import 'package:snggle/views/pages/splash_page.dart' as _i28;
import 'package:snggle/views/pages/vault_create_recover/vault_create_page/vault_create_page.dart'
    as _i29;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i30;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i31;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i33;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i37;

/// generated route for
/// [_i1.AppMasterKeyCreatePage]
class AppMasterKeyCreateRoute extends _i40.PageRouteInfo<void> {
  const AppMasterKeyCreateRoute({List<_i40.PageRouteInfo>? children})
    : super(AppMasterKeyCreateRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyCreateRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppMasterKeyCreatePage();
    },
  );
}

/// generated route for
/// [_i2.AppMasterKeyRecoverPage]
class AppMasterKeyRecoverRoute extends _i40.PageRouteInfo<void> {
  const AppMasterKeyRecoverRoute({List<_i40.PageRouteInfo>? children})
    : super(AppMasterKeyRecoverRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyRecoverRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppMasterKeyRecoverPage();
    },
  );
}

/// generated route for
/// [_i3.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute
    extends _i40.PageRouteInfo<AppMasterKeyRemovedRouteArgs> {
  AppMasterKeyRemovedRoute({
    required _i41.AppLaunchMode appLaunchMode,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         AppMasterKeyRemovedRoute.name,
         args: AppMasterKeyRemovedRouteArgs(
           appLaunchMode: appLaunchMode,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AppMasterKeyRemovedRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppMasterKeyRemovedRouteArgs>();
      return _i3.AppMasterKeyRemovedPage(
        appLaunchMode: args.appLaunchMode,
        key: args.key,
      );
    },
  );
}

class AppMasterKeyRemovedRouteArgs {
  const AppMasterKeyRemovedRouteArgs({required this.appLaunchMode, this.key});

  final _i41.AppLaunchMode appLaunchMode;

  final _i42.Key? key;

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
/// [_i4.AppPinAuthPage]
class AppPinAuthRoute extends _i40.PageRouteInfo<AppPinAuthRouteArgs> {
  AppPinAuthRoute({
    _i43.AppPinType appPinType = _i43.AppPinType.auth,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         AppPinAuthRoute.name,
         args: AppPinAuthRouteArgs(appPinType: appPinType, key: key),
         initialChildren: children,
       );

  static const String name = 'AppPinAuthRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppPinAuthRouteArgs>(
        orElse: () => const AppPinAuthRouteArgs(),
      );
      return _i4.AppPinAuthPage(appPinType: args.appPinType, key: args.key);
    },
  );
}

class AppPinAuthRouteArgs {
  const AppPinAuthRouteArgs({this.appPinType = _i43.AppPinType.auth, this.key});

  final _i43.AppPinType appPinType;

  final _i42.Key? key;

  @override
  String toString() {
    return 'AppPinAuthRouteArgs{appPinType: $appPinType, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppPinAuthRouteArgs) return false;
    return appPinType == other.appPinType && key == other.key;
  }

  @override
  int get hashCode => appPinType.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i5.AppPinChangeWrapper]
class AppPinChangeRoute extends _i40.PageRouteInfo<void> {
  const AppPinChangeRoute({List<_i40.PageRouteInfo>? children})
    : super(AppPinChangeRoute.name, initialChildren: children);

  static const String name = 'AppPinChangeRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AppPinChangeWrapper();
    },
  );
}

/// generated route for
/// [_i6.AppPinSetUpPage]
class AppPinSetUpRoute extends _i40.PageRouteInfo<AppPinSetUpRouteArgs> {
  AppPinSetUpRoute({
    _i44.AppMasterKeyType? appMasterKeyType,
    _i43.AppPinType appPinType = _i43.AppPinType.setUp,
    _i45.MnemonicModel? mnemonicModel,
    _i46.PinpadKeyboardState initPinpadKeyboardState =
        _i46.PinpadKeyboardState.initPinpadKeyboardState,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         AppPinSetUpRoute.name,
         args: AppPinSetUpRouteArgs(
           appMasterKeyType: appMasterKeyType,
           appPinType: appPinType,
           mnemonicModel: mnemonicModel,
           initPinpadKeyboardState: initPinpadKeyboardState,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AppPinSetUpRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppPinSetUpRouteArgs>(
        orElse: () => const AppPinSetUpRouteArgs(),
      );
      return _i6.AppPinSetUpPage(
        appMasterKeyType: args.appMasterKeyType,
        appPinType: args.appPinType,
        mnemonicModel: args.mnemonicModel,
        initPinpadKeyboardState: args.initPinpadKeyboardState,
        key: args.key,
      );
    },
  );
}

class AppPinSetUpRouteArgs {
  const AppPinSetUpRouteArgs({
    this.appMasterKeyType,
    this.appPinType = _i43.AppPinType.setUp,
    this.mnemonicModel,
    this.initPinpadKeyboardState =
        _i46.PinpadKeyboardState.initPinpadKeyboardState,
    this.key,
  });

  final _i44.AppMasterKeyType? appMasterKeyType;

  final _i43.AppPinType appPinType;

  final _i45.MnemonicModel? mnemonicModel;

  final _i46.PinpadKeyboardState initPinpadKeyboardState;

  final _i42.Key? key;

  @override
  String toString() {
    return 'AppPinSetUpRouteArgs{appMasterKeyType: $appMasterKeyType, appPinType: $appPinType, mnemonicModel: $mnemonicModel, initPinpadKeyboardState: $initPinpadKeyboardState, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppPinSetUpRouteArgs) return false;
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
/// [_i7.AutofillSaveEntryPage]
class AutofillSaveEntryRoute extends _i40.PageRouteInfo<void> {
  const AutofillSaveEntryRoute({List<_i40.PageRouteInfo>? children})
    : super(AutofillSaveEntryRoute.name, initialChildren: children);

  static const String name = 'AutofillSaveEntryRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i7.AutofillSaveEntryPage();
    },
  );
}

/// generated route for
/// [_i8.BottomNavigationWrapper]
class BottomNavigationRoute extends _i40.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i40.PageRouteInfo>? children})
    : super(BottomNavigationRoute.name, initialChildren: children);

  static const String name = 'BottomNavigationRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i8.BottomNavigationWrapper();
    },
  );
}

/// generated route for
/// [_i9.EntriesSectionWrapper]
class EntriesSectionWrapperRoute extends _i40.PageRouteInfo<void> {
  const EntriesSectionWrapperRoute({List<_i40.PageRouteInfo>? children})
    : super(EntriesSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'EntriesSectionWrapperRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i9.EntriesSectionWrapper();
    },
  );
}

/// generated route for
/// [_i10.EntryDetailsEditablePage]
class EntryDetailsEditableRoute
    extends _i40.PageRouteInfo<EntryDetailsEditableRouteArgs> {
  EntryDetailsEditableRoute({
    required _i47.EntryPageType entryPageType,
    _i48.FilesystemPath? parentFilesystemPath,
    _i49.EntryModel? entryModel,
    bool? obscurePasswordBool = true,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EntryDetailsEditableRouteArgs>();
      return _i10.EntryDetailsEditablePage(
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

  final _i47.EntryPageType entryPageType;

  final _i48.FilesystemPath? parentFilesystemPath;

  final _i49.EntryModel? entryModel;

  final bool? obscurePasswordBool;

  final _i42.Key? key;

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
/// [_i11.EntryDetailsPage]
class EntryDetailsRoute extends _i40.PageRouteInfo<EntryDetailsRouteArgs> {
  EntryDetailsRoute({
    required _i49.EntryModel entryModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         EntryDetailsRoute.name,
         args: EntryDetailsRouteArgs(entryModel: entryModel, key: key),
         initialChildren: children,
       );

  static const String name = 'EntryDetailsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EntryDetailsRouteArgs>();
      return _i11.EntryDetailsPage(entryModel: args.entryModel, key: args.key);
    },
  );
}

class EntryDetailsRouteArgs {
  const EntryDetailsRouteArgs({required this.entryModel, this.key});

  final _i49.EntryModel entryModel;

  final _i42.Key? key;

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
/// [_i12.EntryListPage]
class EntryListRoute extends _i40.PageRouteInfo<void> {
  const EntryListRoute({List<_i40.PageRouteInfo>? children})
    : super(EntryListRoute.name, initialChildren: children);

  static const String name = 'EntryListRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i12.EntryListPage();
    },
  );
}

/// generated route for
/// [_i13.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i40.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i50.EthereumTransactionModel ethereumTransactionModel,
    required _i51.NetworkTemplateModel networkTemplateModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i13.EthereumTransactionDetailsPage(
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

  final _i50.EthereumTransactionModel ethereumTransactionModel;

  final _i51.NetworkTemplateModel networkTemplateModel;

  final _i42.Key? key;

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
/// [_i14.NetworkListPage]
class NetworkListRoute extends _i40.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i52.VaultModel vaultModel,
    required _i48.FilesystemPath filesystemPath,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NetworkListRouteArgs>();
      return _i14.NetworkListPage(
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

  final _i52.VaultModel vaultModel;

  final _i48.FilesystemPath filesystemPath;

  final _i42.Key? key;

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
/// [_i15.PasskeyCreatePage]
class PasskeyCreateRoute extends _i40.PageRouteInfo<void> {
  const PasskeyCreateRoute({List<_i40.PageRouteInfo>? children})
    : super(PasskeyCreateRoute.name, initialChildren: children);

  static const String name = 'PasskeyCreateRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i15.PasskeyCreatePage();
    },
  );
}

/// generated route for
/// [_i16.PasskeyDetailsPage]
class PasskeyDetailsRoute extends _i40.PageRouteInfo<PasskeyDetailsRouteArgs> {
  PasskeyDetailsRoute({
    required _i53.PasskeyModel passkeyModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         PasskeyDetailsRoute.name,
         args: PasskeyDetailsRouteArgs(passkeyModel: passkeyModel, key: key),
         initialChildren: children,
       );

  static const String name = 'PasskeyDetailsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PasskeyDetailsRouteArgs>();
      return _i16.PasskeyDetailsPage(
        passkeyModel: args.passkeyModel,
        key: args.key,
      );
    },
  );
}

class PasskeyDetailsRouteArgs {
  const PasskeyDetailsRouteArgs({required this.passkeyModel, this.key});

  final _i53.PasskeyModel passkeyModel;

  final _i42.Key? key;

  @override
  String toString() {
    return 'PasskeyDetailsRouteArgs{passkeyModel: $passkeyModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PasskeyDetailsRouteArgs) return false;
    return passkeyModel == other.passkeyModel && key == other.key;
  }

  @override
  int get hashCode => passkeyModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i17.PasskeyListPage]
class PasskeyListRoute extends _i40.PageRouteInfo<void> {
  const PasskeyListRoute({List<_i40.PageRouteInfo>? children})
    : super(PasskeyListRoute.name, initialChildren: children);

  static const String name = 'PasskeyListRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i17.PasskeyListPage();
    },
  );
}

/// generated route for
/// [_i18.PasskeysSectionWrapper]
class PasskeysSectionWrapperRoute extends _i40.PageRouteInfo<void> {
  const PasskeysSectionWrapperRoute({List<_i40.PageRouteInfo>? children})
    : super(PasskeysSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'PasskeysSectionWrapperRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i18.PasskeysSectionWrapper();
    },
  );
}

/// generated route for
/// [_i19.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i40.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i40.PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i19.PrivacyPolicyPage();
    },
  );
}

/// generated route for
/// [_i20.ReadOnlyEntriesSectionWrapper]
class ReadOnlyEntriesSectionWrapperRoute extends _i40.PageRouteInfo<void> {
  const ReadOnlyEntriesSectionWrapperRoute({List<_i40.PageRouteInfo>? children})
    : super(ReadOnlyEntriesSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'ReadOnlyEntriesSectionWrapperRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i20.ReadOnlyEntriesSectionWrapper();
    },
  );
}

/// generated route for
/// [_i21.ReadOnlyEntryDetailsPage]
class ReadOnlyEntryDetailsRoute
    extends _i40.PageRouteInfo<ReadOnlyEntryDetailsRouteArgs> {
  ReadOnlyEntryDetailsRoute({
    required _i49.EntryModel entryModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         ReadOnlyEntryDetailsRoute.name,
         args: ReadOnlyEntryDetailsRouteArgs(entryModel: entryModel, key: key),
         initialChildren: children,
       );

  static const String name = 'ReadOnlyEntryDetailsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReadOnlyEntryDetailsRouteArgs>();
      return _i21.ReadOnlyEntryDetailsPage(
        entryModel: args.entryModel,
        key: args.key,
      );
    },
  );
}

class ReadOnlyEntryDetailsRouteArgs {
  const ReadOnlyEntryDetailsRouteArgs({required this.entryModel, this.key});

  final _i49.EntryModel entryModel;

  final _i42.Key? key;

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
/// [_i22.ReadOnlyEntryListPage]
class ReadOnlyEntryListRoute extends _i40.PageRouteInfo<void> {
  const ReadOnlyEntryListRoute({List<_i40.PageRouteInfo>? children})
    : super(ReadOnlyEntryListRoute.name, initialChildren: children);

  static const String name = 'ReadOnlyEntryListRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i22.ReadOnlyEntryListPage();
    },
  );
}

/// generated route for
/// [_i23.ReadOnlyPasskeyDetailsPage]
class ReadOnlyPasskeyDetailsRoute
    extends _i40.PageRouteInfo<ReadOnlyPasskeyDetailsRouteArgs> {
  ReadOnlyPasskeyDetailsRoute({
    required _i53.PasskeyModel passkeyModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         ReadOnlyPasskeyDetailsRoute.name,
         args: ReadOnlyPasskeyDetailsRouteArgs(
           passkeyModel: passkeyModel,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ReadOnlyPasskeyDetailsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReadOnlyPasskeyDetailsRouteArgs>();
      return _i23.ReadOnlyPasskeyDetailsPage(
        passkeyModel: args.passkeyModel,
        key: args.key,
      );
    },
  );
}

class ReadOnlyPasskeyDetailsRouteArgs {
  const ReadOnlyPasskeyDetailsRouteArgs({required this.passkeyModel, this.key});

  final _i53.PasskeyModel passkeyModel;

  final _i42.Key? key;

  @override
  String toString() {
    return 'ReadOnlyPasskeyDetailsRouteArgs{passkeyModel: $passkeyModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReadOnlyPasskeyDetailsRouteArgs) return false;
    return passkeyModel == other.passkeyModel && key == other.key;
  }

  @override
  int get hashCode => passkeyModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i24.ReadOnlyPasskeyListPage]
class ReadOnlyPasskeyListRoute extends _i40.PageRouteInfo<void> {
  const ReadOnlyPasskeyListRoute({List<_i40.PageRouteInfo>? children})
    : super(ReadOnlyPasskeyListRoute.name, initialChildren: children);

  static const String name = 'ReadOnlyPasskeyListRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i24.ReadOnlyPasskeyListPage();
    },
  );
}

/// generated route for
/// [_i25.ReadOnlyPasskeysSectionWrapper]
class ReadOnlyPasskeysSectionWrapperRoute extends _i40.PageRouteInfo<void> {
  const ReadOnlyPasskeysSectionWrapperRoute({
    List<_i40.PageRouteInfo>? children,
  }) : super(
         ReadOnlyPasskeysSectionWrapperRoute.name,
         initialChildren: children,
       );

  static const String name = 'ReadOnlyPasskeysSectionWrapperRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i25.ReadOnlyPasskeysSectionWrapper();
    },
  );
}

/// generated route for
/// [_i26.SettingsPage]
class SettingsRoute extends _i40.PageRouteInfo<void> {
  const SettingsRoute({List<_i40.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i26.SettingsPage();
    },
  );
}

/// generated route for
/// [_i27.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i40.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i54.SolanaTransactionModel solanaTransactionModel,
    required _i51.NetworkTemplateModel networkTemplateModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i27.SolanaTransactionDetailsPage(
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

  final _i54.SolanaTransactionModel solanaTransactionModel;

  final _i51.NetworkTemplateModel networkTemplateModel;

  final _i42.Key? key;

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
/// [_i28.SplashPage]
class SplashRoute extends _i40.PageRouteInfo<void> {
  const SplashRoute({List<_i40.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i28.SplashPage();
    },
  );
}

/// generated route for
/// [_i29.VaultCreatePage]
class VaultCreateRoute extends _i40.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i48.FilesystemPath parentFilesystemPath,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         VaultCreateRoute.name,
         args: VaultCreateRouteArgs(
           parentFilesystemPath: parentFilesystemPath,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'VaultCreateRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultCreateRouteArgs>();
      return _i29.VaultCreatePage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({required this.parentFilesystemPath, this.key});

  final _i48.FilesystemPath parentFilesystemPath;

  final _i42.Key? key;

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
/// [_i30.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i40.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i40.PageRouteInfo>? children})
    : super(VaultCreateRecoverRoute.name, initialChildren: children);

  static const String name = 'VaultCreateRecoverRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i30.VaultCreateRecoverWrapper();
    },
  );
}

/// generated route for
/// [_i31.VaultInitPage]
class VaultInitRoute extends _i40.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i48.FilesystemPath parentFilesystemPath,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         VaultInitRoute.name,
         args: VaultInitRouteArgs(
           parentFilesystemPath: parentFilesystemPath,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'VaultInitRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultInitRouteArgs>();
      return _i31.VaultInitPage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({required this.parentFilesystemPath, this.key});

  final _i48.FilesystemPath parentFilesystemPath;

  final _i42.Key? key;

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
/// [_i32.VaultListPage]
class VaultListRoute extends _i40.PageRouteInfo<void> {
  const VaultListRoute({List<_i40.PageRouteInfo>? children})
    : super(VaultListRoute.name, initialChildren: children);

  static const String name = 'VaultListRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i32.VaultListPage();
    },
  );
}

/// generated route for
/// [_i33.VaultRecoverPage]
class VaultRecoverRoute extends _i40.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i48.FilesystemPath parentFilesystemPath,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
         VaultRecoverRoute.name,
         args: VaultRecoverRouteArgs(
           parentFilesystemPath: parentFilesystemPath,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'VaultRecoverRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultRecoverRouteArgs>();
      return _i33.VaultRecoverPage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({required this.parentFilesystemPath, this.key});

  final _i48.FilesystemPath parentFilesystemPath;

  final _i42.Key? key;

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
/// [_i34.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i40.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i40.PageRouteInfo>? children})
    : super(SettingsSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'SettingsSectionWrapperRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i34.VaultsSectionWrapper();
    },
  );
}

/// generated route for
/// [_i35.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i40.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i40.PageRouteInfo>? children})
    : super(VaultsSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'VaultsSectionWrapperRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i35.VaultsSectionWrapper();
    },
  );
}

/// generated route for
/// [_i36.WalletConnectPage]
class WalletConnectRoute extends _i40.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i52.VaultModel vaultModel,
    required _i55.WalletModel walletModel,
    required _i51.NetworkTemplateModel networkTemplateModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletConnectRouteArgs>();
      return _i36.WalletConnectPage(
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

  final _i52.VaultModel vaultModel;

  final _i55.WalletModel walletModel;

  final _i51.NetworkTemplateModel networkTemplateModel;

  final _i42.Key? key;

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
/// [_i37.WalletCreatePage]
class WalletCreateRoute extends _i40.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i56.NetworkGroupModel networkGroupModel,
    required _i48.FilesystemPath parentFilesystemPath,
    required _i52.VaultModel vaultModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletCreateRouteArgs>();
      return _i37.WalletCreatePage(
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

  final _i56.NetworkGroupModel networkGroupModel;

  final _i48.FilesystemPath parentFilesystemPath;

  final _i52.VaultModel vaultModel;

  final _i42.Key? key;

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
/// [_i38.WalletDetailsPage]
class WalletDetailsRoute extends _i40.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i52.VaultModel vaultModel,
    required _i56.NetworkGroupModel networkGroupModel,
    required _i55.WalletModel walletModel,
    required _i57.WalletDetailsPageCubit walletDetailsPageCubit,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletDetailsRouteArgs>();
      return _i38.WalletDetailsPage(
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

  final _i52.VaultModel vaultModel;

  final _i56.NetworkGroupModel networkGroupModel;

  final _i55.WalletModel walletModel;

  final _i57.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i42.Key? key;

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
/// [_i39.WalletListPage]
class WalletListRoute extends _i40.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i52.VaultModel vaultModel,
    required _i48.FilesystemPath filesystemPath,
    required _i56.NetworkGroupModel networkGroupModel,
    _i42.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletListRouteArgs>();
      return _i39.WalletListPage(
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

  final _i52.VaultModel vaultModel;

  final _i48.FilesystemPath filesystemPath;

  final _i56.NetworkGroupModel networkGroupModel;

  final _i42.Key? key;

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
