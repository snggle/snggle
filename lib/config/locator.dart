import 'package:get_it/get_it.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/infra/repositories/salt_repository.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/infra/services/auth_service.dart';

import 'package:snggle/infra/services/settings_service.dart';

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
  globalLocator
    ..registerLazySingleton<SaltRepository>(SaltRepository.new)
    ..registerLazySingleton<SettingsRepository>(SettingsRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<AuthService>(AuthService.new)
    ..registerLazySingleton<SettingsService>(SettingsService.new);
}
