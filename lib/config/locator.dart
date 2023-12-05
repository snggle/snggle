import 'package:get_it/get_it.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initCubits();
  _initServices();
  _initRepositories();
}

void _initCubits() {
  globalLocator.registerLazySingleton(AuthSingletonCubit.new);
}

void _initRepositories() {
  globalLocator.registerLazySingleton<MasterKeyRepository>(MasterKeyRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<AppAuthService>(AppAuthService.new)
    ..registerLazySingleton<MasterKeyService>(MasterKeyService.new);
}
