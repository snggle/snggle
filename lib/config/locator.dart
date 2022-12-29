import 'package:get_it/get_it.dart';
import 'package:snuggle/infra/repositories/commons_repository.dart';
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
    ..registerLazySingleton<SetupRepository>(SetupRepository.new)
    ..registerLazySingleton<CommonRepository>(CommonRepository.new);
}

void _initServices() {
  globalLocator
    ..registerLazySingleton<InitialService>(InitialService.new)
    ..registerLazySingleton<SetupService>(SetupService.new);
}
