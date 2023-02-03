import 'package:get_it/get_it.dart';
import 'package:snggle/infra/repositories/private_key_repository.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/infra/services/authentication_service.dart';

import 'package:snggle/infra/services/settings_service.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initServices();
  _initRepositories();
}

void _initRepositories() {
  globalLocator
    ..registerLazySingleton<PrivateKeyRepository>(PrivateKeyRepository.new)
    ..registerLazySingleton<SettingsRepository>(SettingsRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<AuthenticationService>(AuthenticationService.new)
    ..registerLazySingleton<SettingsService>(SettingsService.new);
}
