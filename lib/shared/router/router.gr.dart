// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i24;
import 'package:flutter/material.dart' as _i28;
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_cubit.dart'
    as _i34;
import 'package:snggle/shared/models/groups/network_group_model.dart' as _i32;
import 'package:snggle/shared/models/networks/network_template_model.dart'
    as _i27;
import 'package:snggle/shared/models/password_model.dart' as _i30;
import 'package:snggle/shared/models/transactions/transaction_model.dart'
    as _i31;
import 'package:snggle/shared/models/vaults/vault_create_recover_status.dart'
    as _i25;
import 'package:snggle/shared/models/vaults/vault_model.dart' as _i29;
import 'package:snggle/shared/models/wallets/wallet_model.dart' as _i33;
import 'package:snggle/shared/utils/filesystem_path.dart' as _i26;
import 'package:snggle/views/pages/app_auth_page.dart' as _i1;
import 'package:snggle/views/pages/app_setup_pin_page.dart' as _i2;
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart' as _i3;
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart'
    as _i4;
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart' as _i10;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/settings_page.dart'
    as _i11;
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_section_wrapper.dart'
    as _i20;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/network_list_page/network_list_page.dart'
    as _i7;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/transaction_details_page/transaction_details_page.dart'
    as _i13;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vault_list_page/vault_list_page.dart'
    as _i17;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/vaults_section_wrapper.dart'
    as _i19;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page.dart'
    as _i22;
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_list_page/wallet_list_page.dart'
    as _i23;
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
    as _i14;
import 'package:snggle/views/pages/vault_create_recover/vault_create_recover_wrapper.dart'
    as _i15;
import 'package:snggle/views/pages/vault_create_recover/vault_init_page/vault_init_page.dart'
    as _i16;
import 'package:snggle/views/pages/vault_create_recover/vault_recover_page/vault_recover_page.dart'
    as _i18;
import 'package:snggle/views/pages/wallet_create_page/wallet_create_page.dart'
    as _i21;

abstract class $AppRouter extends _i24.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i24.PageFactory> pagesMap = {
    AppAuthRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AppAuthPage(),
      );
    },
    AppSetupPinRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppSetupPinPage(),
      );
    },
    AppsRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AppsPage(),
      );
    },
    BottomNavigationRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.BottomNavigationWrapper(),
      );
    },
    NetworkCreateRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.NetworkCreateWrapper(),
      );
    },
    NetworkGroupCreateRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkGroupCreateRouteArgs>();
      return _i24.AutoRoutePage<dynamic>(
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
      return _i24.AutoRoutePage<dynamic>(
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
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.NetworkTemplateCreatePage(),
      );
    },
    NetworkTemplateSelectRoute.name: (routeData) {
      final args = routeData.argsAs<NetworkTemplateSelectRouteArgs>();
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.NetworkTemplateSelectPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    SecretsRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SecretsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SettingsPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SplashPage(),
      );
    },
    TransactionDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionDetailsRouteArgs>();
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.TransactionDetailsPage(
          transactionModel: args.transactionModel,
          key: args.key,
        ),
      );
    },
    VaultCreateRoute.name: (routeData) {
      final args = routeData.argsAs<VaultCreateRouteArgs>();
      return _i24.AutoRoutePage<_i25.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i14.VaultCreatePage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultCreateRecoverRoute.name: (routeData) {
      return _i24.AutoRoutePage<_i25.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: const _i15.VaultCreateRecoverWrapper(),
      );
    },
    VaultInitRoute.name: (routeData) {
      final args = routeData.argsAs<VaultInitRouteArgs>();
      return _i24.AutoRoutePage<_i25.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i16.VaultInitPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultListRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.VaultListPage(),
      );
    },
    VaultRecoverRoute.name: (routeData) {
      final args = routeData.argsAs<VaultRecoverRouteArgs>();
      return _i24.AutoRoutePage<_i25.VaultCreateRecoverStatus?>(
        routeData: routeData,
        child: _i18.VaultRecoverPage(
          parentFilesystemPath: args.parentFilesystemPath,
          key: args.key,
        ),
      );
    },
    VaultsSectionWrapperRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.VaultsSectionWrapper(),
      );
    },
    SettingsSectionWrapperRoute.name: (routeData) {
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.VaultsSectionWrapper(),
      );
    },
    WalletCreateRoute.name: (routeData) {
      final args = routeData.argsAs<WalletCreateRouteArgs>();
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i21.WalletCreatePage(
          vaultModel: args.vaultModel,
          vaultPasswordModel: args.vaultPasswordModel,
          parentFilesystemPath: args.parentFilesystemPath,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
    WalletDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<WalletDetailsRouteArgs>();
      return _i24.AutoRoutePage<void>(
        routeData: routeData,
        child: _i22.WalletDetailsPage(
          walletModel: args.walletModel,
          walletDetailsPageCubit: args.walletDetailsPageCubit,
          key: args.key,
        ),
      );
    },
    WalletListRoute.name: (routeData) {
      final args = routeData.argsAs<WalletListRouteArgs>();
      return _i24.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i23.WalletListPage(
          name: args.name,
          vaultModel: args.vaultModel,
          filesystemPath: args.filesystemPath,
          vaultPasswordModel: args.vaultPasswordModel,
          networkGroupModel: args.networkGroupModel,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AppAuthPage]
class AppAuthRoute extends _i24.PageRouteInfo<void> {
  const AppAuthRoute({List<_i24.PageRouteInfo>? children})
      : super(
          AppAuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppAuthRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppSetupPinPage]
class AppSetupPinRoute extends _i24.PageRouteInfo<void> {
  const AppSetupPinRoute({List<_i24.PageRouteInfo>? children})
      : super(
          AppSetupPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSetupPinRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AppsPage]
class AppsRoute extends _i24.PageRouteInfo<void> {
  const AppsRoute({List<_i24.PageRouteInfo>? children})
      : super(
          AppsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppsRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i4.BottomNavigationWrapper]
class BottomNavigationRoute extends _i24.PageRouteInfo<void> {
  const BottomNavigationRoute({List<_i24.PageRouteInfo>? children})
      : super(
          BottomNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavigationRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NetworkCreateWrapper]
class NetworkCreateRoute extends _i24.PageRouteInfo<void> {
  const NetworkCreateRoute({List<_i24.PageRouteInfo>? children})
      : super(
          NetworkCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'NetworkCreateRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i6.NetworkGroupCreatePage]
class NetworkGroupCreateRoute
    extends _i24.PageRouteInfo<NetworkGroupCreateRouteArgs> {
  NetworkGroupCreateRoute({
    required _i26.FilesystemPath parentFilesystemPath,
    required _i27.NetworkTemplateModel networkTemplateModel,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
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

  static const _i24.PageInfo<NetworkGroupCreateRouteArgs> page =
      _i24.PageInfo<NetworkGroupCreateRouteArgs>(name);
}

class NetworkGroupCreateRouteArgs {
  const NetworkGroupCreateRouteArgs({
    required this.parentFilesystemPath,
    required this.networkTemplateModel,
    this.key,
  });

  final _i26.FilesystemPath parentFilesystemPath;

  final _i27.NetworkTemplateModel networkTemplateModel;

  final _i28.Key? key;

  @override
  String toString() {
    return 'NetworkGroupCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, networkTemplateModel: $networkTemplateModel, key: $key}';
  }
}

/// generated route for
/// [_i7.NetworkListPage]
class NetworkListRoute extends _i24.PageRouteInfo<NetworkListRouteArgs> {
  NetworkListRoute({
    required String name,
    required _i29.VaultModel vaultModel,
    required _i26.FilesystemPath filesystemPath,
    required _i30.PasswordModel vaultPasswordModel,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
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

  static const _i24.PageInfo<NetworkListRouteArgs> page =
      _i24.PageInfo<NetworkListRouteArgs>(name);
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

  final _i29.VaultModel vaultModel;

  final _i26.FilesystemPath filesystemPath;

  final _i30.PasswordModel vaultPasswordModel;

  final _i28.Key? key;

  @override
  String toString() {
    return 'NetworkListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, vaultPasswordModel: $vaultPasswordModel, key: $key}';
  }
}

/// generated route for
/// [_i8.NetworkTemplateCreatePage]
class NetworkTemplateCreateRoute extends _i24.PageRouteInfo<void> {
  const NetworkTemplateCreateRoute({List<_i24.PageRouteInfo>? children})
      : super(
          NetworkTemplateCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'NetworkTemplateCreateRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i9.NetworkTemplateSelectPage]
class NetworkTemplateSelectRoute
    extends _i24.PageRouteInfo<NetworkTemplateSelectRouteArgs> {
  NetworkTemplateSelectRoute({
    required _i26.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          NetworkTemplateSelectRoute.name,
          args: NetworkTemplateSelectRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NetworkTemplateSelectRoute';

  static const _i24.PageInfo<NetworkTemplateSelectRouteArgs> page =
      _i24.PageInfo<NetworkTemplateSelectRouteArgs>(name);
}

class NetworkTemplateSelectRouteArgs {
  const NetworkTemplateSelectRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i26.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

  @override
  String toString() {
    return 'NetworkTemplateSelectRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i10.SecretsPage]
class SecretsRoute extends _i24.PageRouteInfo<void> {
  const SecretsRoute({List<_i24.PageRouteInfo>? children})
      : super(
          SecretsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecretsRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SettingsPage]
class SettingsRoute extends _i24.PageRouteInfo<void> {
  const SettingsRoute({List<_i24.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SplashPage]
class SplashRoute extends _i24.PageRouteInfo<void> {
  const SplashRoute({List<_i24.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i13.TransactionDetailsPage]
class TransactionDetailsRoute
    extends _i24.PageRouteInfo<TransactionDetailsRouteArgs> {
  TransactionDetailsRoute({
    required _i31.TransactionModel transactionModel,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          TransactionDetailsRoute.name,
          args: TransactionDetailsRouteArgs(
            transactionModel: transactionModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'TransactionDetailsRoute';

  static const _i24.PageInfo<TransactionDetailsRouteArgs> page =
      _i24.PageInfo<TransactionDetailsRouteArgs>(name);
}

class TransactionDetailsRouteArgs {
  const TransactionDetailsRouteArgs({
    required this.transactionModel,
    this.key,
  });

  final _i31.TransactionModel transactionModel;

  final _i28.Key? key;

  @override
  String toString() {
    return 'TransactionDetailsRouteArgs{transactionModel: $transactionModel, key: $key}';
  }
}

/// generated route for
/// [_i14.VaultCreatePage]
class VaultCreateRoute extends _i24.PageRouteInfo<VaultCreateRouteArgs> {
  VaultCreateRoute({
    required _i26.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          VaultCreateRoute.name,
          args: VaultCreateRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultCreateRoute';

  static const _i24.PageInfo<VaultCreateRouteArgs> page =
      _i24.PageInfo<VaultCreateRouteArgs>(name);
}

class VaultCreateRouteArgs {
  const VaultCreateRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i26.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

  @override
  String toString() {
    return 'VaultCreateRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i15.VaultCreateRecoverWrapper]
class VaultCreateRecoverRoute extends _i24.PageRouteInfo<void> {
  const VaultCreateRecoverRoute({List<_i24.PageRouteInfo>? children})
      : super(
          VaultCreateRecoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultCreateRecoverRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i16.VaultInitPage]
class VaultInitRoute extends _i24.PageRouteInfo<VaultInitRouteArgs> {
  VaultInitRoute({
    required _i26.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          VaultInitRoute.name,
          args: VaultInitRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultInitRoute';

  static const _i24.PageInfo<VaultInitRouteArgs> page =
      _i24.PageInfo<VaultInitRouteArgs>(name);
}

class VaultInitRouteArgs {
  const VaultInitRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i26.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

  @override
  String toString() {
    return 'VaultInitRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i17.VaultListPage]
class VaultListRoute extends _i24.PageRouteInfo<void> {
  const VaultListRoute({List<_i24.PageRouteInfo>? children})
      : super(
          VaultListRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultListRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i18.VaultRecoverPage]
class VaultRecoverRoute extends _i24.PageRouteInfo<VaultRecoverRouteArgs> {
  VaultRecoverRoute({
    required _i26.FilesystemPath parentFilesystemPath,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          VaultRecoverRoute.name,
          args: VaultRecoverRouteArgs(
            parentFilesystemPath: parentFilesystemPath,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VaultRecoverRoute';

  static const _i24.PageInfo<VaultRecoverRouteArgs> page =
      _i24.PageInfo<VaultRecoverRouteArgs>(name);
}

class VaultRecoverRouteArgs {
  const VaultRecoverRouteArgs({
    required this.parentFilesystemPath,
    this.key,
  });

  final _i26.FilesystemPath parentFilesystemPath;

  final _i28.Key? key;

  @override
  String toString() {
    return 'VaultRecoverRouteArgs{parentFilesystemPath: $parentFilesystemPath, key: $key}';
  }
}

/// generated route for
/// [_i19.VaultsSectionWrapper]
class VaultsSectionWrapperRoute extends _i24.PageRouteInfo<void> {
  const VaultsSectionWrapperRoute({List<_i24.PageRouteInfo>? children})
      : super(
          VaultsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'VaultsSectionWrapperRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i20.VaultsSectionWrapper]
class SettingsSectionWrapperRoute extends _i24.PageRouteInfo<void> {
  const SettingsSectionWrapperRoute({List<_i24.PageRouteInfo>? children})
      : super(
          SettingsSectionWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsSectionWrapperRoute';

  static const _i24.PageInfo<void> page = _i24.PageInfo<void>(name);
}

/// generated route for
/// [_i21.WalletCreatePage]
class WalletCreateRoute extends _i24.PageRouteInfo<WalletCreateRouteArgs> {
  WalletCreateRoute({
    required _i29.VaultModel vaultModel,
    required _i30.PasswordModel vaultPasswordModel,
    required _i26.FilesystemPath parentFilesystemPath,
    required _i32.NetworkGroupModel networkGroupModel,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          WalletCreateRoute.name,
          args: WalletCreateRouteArgs(
            vaultModel: vaultModel,
            vaultPasswordModel: vaultPasswordModel,
            parentFilesystemPath: parentFilesystemPath,
            networkGroupModel: networkGroupModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletCreateRoute';

  static const _i24.PageInfo<WalletCreateRouteArgs> page =
      _i24.PageInfo<WalletCreateRouteArgs>(name);
}

class WalletCreateRouteArgs {
  const WalletCreateRouteArgs({
    required this.vaultModel,
    required this.vaultPasswordModel,
    required this.parentFilesystemPath,
    required this.networkGroupModel,
    this.key,
  });

  final _i29.VaultModel vaultModel;

  final _i30.PasswordModel vaultPasswordModel;

  final _i26.FilesystemPath parentFilesystemPath;

  final _i32.NetworkGroupModel networkGroupModel;

  final _i28.Key? key;

  @override
  String toString() {
    return 'WalletCreateRouteArgs{vaultModel: $vaultModel, vaultPasswordModel: $vaultPasswordModel, parentFilesystemPath: $parentFilesystemPath, networkGroupModel: $networkGroupModel, key: $key}';
  }
}

/// generated route for
/// [_i22.WalletDetailsPage]
class WalletDetailsRoute extends _i24.PageRouteInfo<WalletDetailsRouteArgs> {
  WalletDetailsRoute({
    required _i33.WalletModel walletModel,
    required _i34.WalletDetailsPageCubit walletDetailsPageCubit,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
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

  static const _i24.PageInfo<WalletDetailsRouteArgs> page =
      _i24.PageInfo<WalletDetailsRouteArgs>(name);
}

class WalletDetailsRouteArgs {
  const WalletDetailsRouteArgs({
    required this.walletModel,
    required this.walletDetailsPageCubit,
    this.key,
  });

  final _i33.WalletModel walletModel;

  final _i34.WalletDetailsPageCubit walletDetailsPageCubit;

  final _i28.Key? key;

  @override
  String toString() {
    return 'WalletDetailsRouteArgs{walletModel: $walletModel, walletDetailsPageCubit: $walletDetailsPageCubit, key: $key}';
  }
}

/// generated route for
/// [_i23.WalletListPage]
class WalletListRoute extends _i24.PageRouteInfo<WalletListRouteArgs> {
  WalletListRoute({
    required String name,
    required _i29.VaultModel vaultModel,
    required _i26.FilesystemPath filesystemPath,
    required _i30.PasswordModel vaultPasswordModel,
    required _i32.NetworkGroupModel networkGroupModel,
    _i28.Key? key,
    List<_i24.PageRouteInfo>? children,
  }) : super(
          WalletListRoute.name,
          args: WalletListRouteArgs(
            name: name,
            vaultModel: vaultModel,
            filesystemPath: filesystemPath,
            vaultPasswordModel: vaultPasswordModel,
            networkGroupModel: networkGroupModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WalletListRoute';

  static const _i24.PageInfo<WalletListRouteArgs> page =
      _i24.PageInfo<WalletListRouteArgs>(name);
}

class WalletListRouteArgs {
  const WalletListRouteArgs({
    required this.name,
    required this.vaultModel,
    required this.filesystemPath,
    required this.vaultPasswordModel,
    required this.networkGroupModel,
    this.key,
  });

  final String name;

  final _i29.VaultModel vaultModel;

  final _i26.FilesystemPath filesystemPath;

  final _i30.PasswordModel vaultPasswordModel;

  final _i32.NetworkGroupModel networkGroupModel;

  final _i28.Key? key;

  @override
  String toString() {
    return 'WalletListRouteArgs{name: $name, vaultModel: $vaultModel, filesystemPath: $filesystemPath, vaultPasswordModel: $vaultPasswordModel, networkGroupModel: $networkGroupModel, key: $key}';
  }
}
