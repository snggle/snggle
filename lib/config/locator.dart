import 'package:get_it/get_it.dart';
import 'package:snuggle/infra/repositories/auth_repository.dart';
import 'package:snuggle/infra/services/authentication/auth_service.dart';

final GetIt globalLocator = GetIt.I;

void initLocator() {
  _initRepositories();
  _initServices();
}

void _initRepositories() {
  globalLocator.registerLazySingleton<AuthRepository>(AuthRepository.new);
}

void _initServices() {
  globalLocator.registerLazySingleton<AuthService>(AuthService.new);
}
