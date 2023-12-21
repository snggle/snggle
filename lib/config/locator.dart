import 'package:get_it/get_it.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/repositories/vaults_repository.dart';
import 'package:snggle/infra/repositories/wallets_repository.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/infra/services/vault_secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initCubits();
  _initRepositories();
  _initServices();
  _initFactories();
}

void _initCubits() {
  globalLocator.registerLazySingleton(AuthSingletonCubit.new);
}

void _initRepositories() {
  globalLocator
    ..registerLazySingleton<MasterKeyRepository>(MasterKeyRepository.new)
    ..registerLazySingleton<SecretsRepository>(SecretsRepository.new)
    ..registerLazySingleton<VaultsRepository>(VaultsRepository.new)
    ..registerLazySingleton<WalletsRepository>(WalletsRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<AppAuthService>(AppAuthService.new)
    ..registerLazySingleton<MasterKeyService>(MasterKeyService.new)
    ..registerLazySingleton<VaultSecretsService>(VaultSecretsService.new)
    ..registerLazySingleton<VaultsService>(VaultsService.new)
    ..registerLazySingleton<WalletsService>(WalletsService.new);
}

void _initFactories() {
  globalLocator
    ..registerLazySingleton<VaultModelFactory>(VaultModelFactory.new)
    ..registerLazySingleton<WalletModelFactory>(WalletModelFactory.new);
}
