import 'package:get_it/get_it.dart';
import 'package:snuggle/infra/repositories/initial_repository.dart';
import 'package:snuggle/infra/repositories/setup_repository.dart';
import 'package:snuggle/infra/services/initial_service.dart';
import 'package:snuggle/infra/services/setup_service.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initServices();
  _initRepositories();
}

void _initRepositories() {
  globalLocator
    ..registerLazySingleton<InitialRepository>(InitialRepository.new)
    ..registerLazySingleton<SetupRepository>(SetupRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<InitialService>(InitialService.new)
    ..registerLazySingleton<SetupService>(SetupService.new);
}
