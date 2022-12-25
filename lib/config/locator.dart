import 'package:get_it/get_it.dart';
import 'package:snuggle/infra/repositories/vaults_repository.dart';
import 'package:snuggle/infra/services/vaults_service.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initRepositories();
  _initServices();
}

void _initRepositories() {
  globalLocator.registerLazySingleton<VaultsRepository>(VaultsRepository.new);
}

void _initServices() {
  globalLocator.registerLazySingleton<VaultsService>(VaultsService.new);
}

