import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/isar_database_version_repository.dart';

class IsarDatabaseVersionService {
  final IsarDatabaseVersionRepository _isarDatabaseVersionRepository = globalLocator<IsarDatabaseVersionRepository>();

  Future<bool> isIsarDatabaseVersionExists() async {
    return _isarDatabaseVersionRepository.isIsarDatabaseVersionExists();
  }

  Future<int> getIsarDatabaseVersion() async {
    bool isarDatabaseVersionExistsBool = await isIsarDatabaseVersionExists();
    if (isarDatabaseVersionExistsBool == false) {
      return 0;
    }

    String storedIsarDatabaseVersion = await _isarDatabaseVersionRepository.getIsarDatabaseVersion();
    return int.tryParse(storedIsarDatabaseVersion) ?? 0;
  }

  Future<void> setIsarDatabaseVersion(int isarDatabaseVersion) async {
    await _isarDatabaseVersionRepository.setIsarDatabaseVersion(isarDatabaseVersion.toString());
  }
}
