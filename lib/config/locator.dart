import 'package:get_it/get_it.dart';
import 'package:snuggle/infra/repository/vaults_repository.dart';
import 'package:snuggle/infra/repository/wallets_repository.dart';
import 'package:snuggle/infra/services/vaults_service.dart';
import 'package:snuggle/infra/services/wallets_service.dart';
import 'package:snuggle/shared/utils/vaults_secure_storage_manager.dart';

final GetIt globalLocator = GetIt.I;

Future<void> initLocator() async {
  globalLocator
    ..registerLazySingleton<VaultsSecureStorageManager>(VaultsSecureStorageManager.new)
    ..registerLazySingleton<VaultsRepository>(VaultsRepository.new)
    ..registerLazySingleton<VaultsService>(VaultsService.new)
    ..registerLazySingleton<WalletsRepository>(WalletsRepository.new)
    ..registerLazySingleton<WalletsService>(WalletsService.new);
}
