import 'package:get_it/get_it.dart';
import 'package:snuggle/infra/repositories/hash_mnemonic_repository.dart';
import 'package:snuggle/infra/repositories/settings_repository.dart';
import 'package:snuggle/infra/services/hash_mnemonic_service.dart';
import 'package:snuggle/infra/services/settings_service.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initServices();
  _initRepositories();
}

void _initRepositories() {
  globalLocator
    ..registerLazySingleton<HashMnemonicRepository>(HashMnemonicRepository.new)
    ..registerLazySingleton<SettingsRepository>(SettingsRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<HashMnemonicService>(HashMnemonicService.new)
    ..registerLazySingleton<SettingsService>(SettingsService.new);
}
