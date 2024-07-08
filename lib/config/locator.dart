import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/groups_repository.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/infra/repositories/network_groups_repository.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/transactions_repository.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/factories/group_model_factory.dart';
import 'package:snggle/shared/factories/network_group_model_factory.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';

final GetIt globalLocator = GetIt.I;

typedef RootDirectoryBuilder = FutureOr<Directory> Function();

void initLocator() {
  _initControllers();
  _initRepositories();
  _initServices();
  _initFactories();

  globalLocator
    ..registerLazySingleton<ActiveWalletController>(ActiveWalletController.new)
    ..registerSingleton<RootDirectoryBuilder>(getApplicationSupportDirectory)
    ..registerSingleton<IsarDatabaseManager>(IsarDatabaseManager());
}

void _initControllers() {
  globalLocator.registerLazySingleton<MasterKeyController>(MasterKeyController.new);
}

void _initRepositories() {
  globalLocator
    ..registerLazySingleton<NetworkGroupsRepository>(NetworkGroupsRepository.new)
    ..registerLazySingleton<MasterKeyRepository>(MasterKeyRepository.new)
    ..registerLazySingleton<SecretsRepository>(SecretsRepository.new)
    ..registerLazySingleton<VaultsRepository>(VaultsRepository.new)
    ..registerLazySingleton<WalletsRepository>(WalletsRepository.new)
    ..registerLazySingleton<TransactionsRepository>(TransactionsRepository.new)
    ..registerLazySingleton<GroupsRepository>(GroupsRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<AppService>(AppService.new)
    ..registerLazySingleton<NetworkGroupsService>(NetworkGroupsService.new)
    ..registerLazySingleton<MasterKeyService>(MasterKeyService.new)
    ..registerLazySingleton<SecretsService>(SecretsService.new)
    ..registerLazySingleton<VaultsService>(VaultsService.new)
    ..registerLazySingleton<WalletsService>(WalletsService.new)
    ..registerLazySingleton<TransactionsService>(TransactionsService.new)
    ..registerLazySingleton<GroupsService>(GroupsService.new);
}

void _initFactories() {
  globalLocator
    ..registerLazySingleton<GroupModelFactory>(GroupModelFactory.new)
    ..registerLazySingleton<NetworkGroupModelFactory>(NetworkGroupModelFactory.new)
    ..registerLazySingleton<VaultModelFactory>(VaultModelFactory.new)
    ..registerLazySingleton<WalletModelFactory>(WalletModelFactory.new);
}
