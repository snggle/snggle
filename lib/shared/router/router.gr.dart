// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i26;
import 'package:flutter/material.dart' as _i28;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i38;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i37;
import 'package:snggle/shared/models/mnemonic_model.dart' as _i30;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i32;
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart'
    as _i31;
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart'
    as _i35;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i33;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i36;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i34;
import 'package:snggle/views/pages/app_master_key/app_master_key_create_page.dart'
    as _i2;
import 'package:snggle/views/pages/app_master_key/app_master_key_recover_page.dart'
    as _i3;
import 'package:snggle/views/pages/app_master_key/app_master_key_removed_page.dart'
    as _i4;
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart'
    as _i29;
import 'package:snggle/views/pages/app_pin_page/app_enter_pin_page.dart' as _i1;
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart' as _i27;
import 'package:snggle/views/pages/app_pin_page/app_set_up_pin_page.dart'
    as _i5;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i6;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i7;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i11;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/privacy_policy_page/privacy_policy_page.dart'
    as _i10;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i12;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i20;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i9;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/ethereum_transaction_details_page.dart'
    as _i8;
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

/// generated route for
/// [_i1.AppEnterPinPage]
class AppEnterPinRoute extends _i26.PageRouteInfo<AppEnterPinRouteArgs> {
  AppEnterPinRoute({
    _i27.AppPinType appPinType = _i27.AppPinType.enterPin,
    _i28.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         AppEnterPinRoute.name,
         args: AppEnterPinRouteArgs(appPinType: appPinType, key: key),
         initialChildren: children,
       );

  static const String name = 'AppEnterPinRoute';

  static _i26.PageInfo page = _i26.PageInfo(
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
    this.appPinType = _i27.AppPinType.enterPin,
    this.key,
  });

  final _i27.AppPinType appPinType;

  final _i28.Key? key;

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
class AppMasterKeyCreateRoute extends _i26.PageRouteInfo<void> {
  const AppMasterKeyCreateRoute({List<_i26.PageRouteInfo>? children})
    : super(AppMasterKeyCreateRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyCreateRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppMasterKeyCreatePage();
    },
  );
}

/// generated route for
/// [_i3.AppMasterKeyRecoverPage]
class AppMasterKeyRecoverRoute extends _i26.PageRouteInfo<void> {
  const AppMasterKeyRecoverRoute({List<_i26.PageRouteInfo>? children})
    : super(AppMasterKeyRecoverRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyRecoverRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i3.AppMasterKeyRecoverPage();
    },
  );
}

/// generated route for
/// [_i4.AppMasterKeyRemovedPage]
class AppMasterKeyRemovedRoute extends _i26.PageRouteInfo<void> {
  const AppMasterKeyRemovedRoute({List<_i26.PageRouteInfo>? children})
    : super(AppMasterKeyRemovedRoute.name, initialChildren: children);

  static const String name = 'AppMasterKeyRemovedRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i4.AppMasterKeyRemovedPage();
    },
  );
}

/// generated route for
/// [_i5.AppSetUpPinPage]
class AppSetUpPinRoute extends _i26.PageRouteInfo<AppSetUpPinRouteArgs> {
  AppSetUpPinRoute({
    _i29.AppMasterKeyType? appMasterKeyType,
    _i27.AppPinType appPinType = _i27.AppPinType.setUpPin,
    _i30.MnemonicModel? mnemonicModel,
    _i28.Key? key,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         AppSetUpPinRoute.name,
         args: AppSetUpPinRouteArgs(
           appMasterKeyType: appMasterKeyType,
           appPinType: appPinType,
           mnemonicModel: mnemonicModel,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AppSetUpPinRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppSetUpPinRouteArgs>(
        orElse: () => const AppSetUpPinRouteArgs(),
      );
      return _i5.AppSetUpPinPage(
        appMasterKeyType: args.appMasterKeyType,
        appPinType: args.appPinType,
        mnemonicModel: args.mnemonicModel,
        key: args.key,
      );
    },
  );
}

class AppSetUpPinRouteArgs {
  const AppSetUpPinRouteArgs({
    this.appMasterKeyType,
    this.appPinType = _i27.AppPinType.setUpPin,
    this.mnemonicModel,
    this.key,
  });

  final _i29.AppMasterKeyType? appMasterKeyType;

  final _i27.AppPinType appPinType;

  final _i30.MnemonicModel? mnemonicModel;

  final _i28.Key? key;

  @override
  String toString() {
    return 'AppSetUpPinRouteArgs{appMasterKeyType: $appMasterKeyType, appPinType: $appPinType, mnemonicModel: $mnemonicModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppSetUpPinRouteArgs) return false;
    return appMasterKeyType == other.appMasterKeyType &&
        appPinType == other.appPinType &&
        mnemonicModel == other.mnemonicModel &&
        key == other.key;
  }

  @override
  int get hashCode =>
      appMasterKeyType.hashCode ^
      appPinType.hashCode ^
      mnemonicModel.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i6.AppsPage]
class AppsRoute extends _i26.PageRouteInfo<void> {
  const AppsRoute({List<_i26.PageRouteInfo>? children})
    : super(AppsRoute.name, initialChildren: children);

  static const String name = 'AppsRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i6.AppsPage();
    },
  );
}

/// generated route for
/// [_i7.BottomNavigationWrapper]
class BottomNavigationRoute extends _i26.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i26.PageRouteInfo>? children})
    : super(BottomNavigationRoute.name, initialChildren: children);

  static const String name = 'BottomNavigationRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i7.BottomNavigationWrapper();
    },
  );
}

/// generated route for
/// [_i8.EthereumTransactionDetailsPage]
class EthereumTransactionDetailsRoute
    extends _i26.PageRouteInfo<EthereumTransactionDetailsRouteArgs> {
  EthereumTransactionDetailsRoute({
    required _i31.EthereumTransactionModel ethereumTransactionModel,
    required _i32.NetworkTemplateModel networkTemplateModel,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EthereumTransactionDetailsRouteArgs>();
      return _i8.EthereumTransactionDetailsPage(
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

  final _i31.EthereumTransactionModel ethereumTransactionModel;

  final _i32.NetworkTemplateModel networkTemplateModel;

  final _i28.Key? key;

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
/// [_i9.NetworkListPage]
class NetworkListRoute extends _i26.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i33.VaultModel vaultModel,
    required _i34.FilesystemPath filesystemPath,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NetworkListRouteArgs>();
      return _i9.NetworkListPage(
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

  final _i33.VaultModel vaultModel;

  final _i34.FilesystemPath filesystemPath;

  final _i28.Key? key;

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
/// [_i10.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i26.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i26.PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i10.PrivacyPolicyPage();
    },
  );
}

/// generated route for
/// [_i11.SecretsPage]
class SecretsRoute extends _i26.PageRouteInfo<void> {
  const SecretsRoute({List<_i26.PageRouteInfo>? children})
    : super(SecretsRoute.name, initialChildren: children);

  static const String name = 'SecretsRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i11.SecretsPage();
    },
  );
}

/// generated route for
/// [_i12.SettingsPage]
class SettingsRoute extends _i26.PageRouteInfo<void> {
  const SettingsRoute({List<_i26.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i12.SettingsPage();
    },
  );
}

/// generated route for
/// [_i13.SolanaTransactionDetailsPage]
class SolanaTransactionDetailsRoute
    extends _i26.PageRouteInfo<SolanaTransactionDetailsRouteArgs> {
  SolanaTransactionDetailsRoute({
    required _i35.SolanaTransactionModel solanaTransactionModel,
    required _i32.NetworkTemplateModel networkTemplateModel,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SolanaTransactionDetailsRouteArgs>();
      return _i13.SolanaTransactionDetailsPage(
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

  final _i35.SolanaTransactionModel solanaTransactionModel;

  final _i32.NetworkTemplateModel networkTemplateModel;

  final _i28.Key? key;

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
/// [_i14.SplashPage]
class SplashRoute extends _i26.PageRouteInfo<void> {
  const SplashRoute({List<_i26.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i14.SplashPage();
    },
  );
}

/// generated route for
/// [_i15.VaultCreatePage]
class VaultCreateRoute extends _i26.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i34.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultCreateRouteArgs>();
      return _i15.VaultCreatePage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({required this.parentFilesystemPath, this.key});

  final _i34.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

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
/// [_i16.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i26.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i26.PageRouteInfo>? children})
    : super(VaultCreateRecoverRoute.name, initialChildren: children);

  static const String name = 'VaultCreateRecoverRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i16.VaultCreateRecoverWrapper();
    },
  );
}

/// generated route for
/// [_i17.VaultInitPage]
class VaultInitRoute extends _i26.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i34.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultInitRouteArgs>();
      return _i17.VaultInitPage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({required this.parentFilesystemPath, this.key});

  final _i34.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

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
/// [_i18.VaultListPage]
class VaultListRoute extends _i26.PageRouteInfo<void> {
  const VaultListRoute({List<_i26.PageRouteInfo>? children})
    : super(VaultListRoute.name, initialChildren: children);

  static const String name = 'VaultListRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i18.VaultListPage();
    },
  );
}

/// generated route for
/// [_i19.VaultRecoverPage]
class VaultRecoverRoute extends _i26.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i34.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VaultRecoverRouteArgs>();
      return _i19.VaultRecoverPage(
        parentFilesystemPath: args.parentFilesystemPath,
        key: args.key,
      );
    },
  );
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({required this.parentFilesystemPath, this.key});

  final _i34.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

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
/// [_i20.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i26.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i26.PageRouteInfo>? children})
    : super(SettingsSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'SettingsSectionWrapperRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i20.VaultsSectionWrapper();
    },
  );
}

/// generated route for
/// [_i21.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i26.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i26.PageRouteInfo>? children})
    : super(VaultsSectionWrapperRoute.name, initialChildren: children);

  static const String name = 'VaultsSectionWrapperRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i21.VaultsSectionWrapper();
    },
  );
}

/// generated route for
/// [_i22.WalletConnectPage]
class WalletConnectRoute extends _i26.PageRouteInfo<WalletConnectRouteArgs> {
  WalletConnectRoute({
    required _i33.VaultModel vaultModel,
    required _i36.WalletModel walletModel,
    required _i32.NetworkTemplateModel networkTemplateModel,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletConnectRouteArgs>();
      return _i22.WalletConnectPage(
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

  final _i33.VaultModel vaultModel;

  final _i36.WalletModel walletModel;

  final _i32.NetworkTemplateModel networkTemplateModel;

  final _i28.Key? key;

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
/// [_i23.WalletCreatePage]
class WalletCreateRoute extends _i26.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i37.NetworkGroupModel networkGroupModel,
    required _i34.FilesystemPath parentFilesystemPath,
    required _i33.VaultModel vaultModel,
    _i28.Key? key,
    List<_i26.PageRouteInfo>? children,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletCreateRouteArgs>();
      return _i23.WalletCreatePage(
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

  final _i37.NetworkGroupModel networkGroupModel;

  final _i34.FilesystemPath parentFilesystemPath;

  final _i33.VaultModel vaultModel;

  final _i28.Key? key;

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
/// [_i24.WalletDetailsPage]
class WalletDetailsRoute extends _i26.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i33.VaultModel vaultModel,
    required _i37.NetworkGroupModel networkGroupModel,
    required _i36.WalletModel walletModel,
    required _i38.WalletDetailsPageCubit walletDetailsPageCubit,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletDetailsRouteArgs>();
      return _i24.WalletDetailsPage(
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

  final _i33.VaultModel vaultModel;

  final _i37.NetworkGroupModel networkGroupModel;

  final _i36.WalletModel walletModel;

  final _i38.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i28.Key? key;

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
/// [_i25.WalletListPage]
class WalletListRoute extends _i26.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i33.VaultModel vaultModel,
    required _i34.FilesystemPath filesystemPath,
    required _i37.NetworkGroupModel networkGroupModel,
    _i28.Key? key,
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

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletListRouteArgs>();
      return _i25.WalletListPage(
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

  final _i33.VaultModel vaultModel;

  final _i34.FilesystemPath filesystemPath;

  final _i37.NetworkGroupModel networkGroupModel;

  final _i28.Key? key;

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
