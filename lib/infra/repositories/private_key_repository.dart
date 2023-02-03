import 'package:snggle/infra/database_manager.dart';

class PrivateKeyRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  Future<void> setPrivateKey(String privateKey) async {
    await _databaseManager.write(databaseEntryKey: DatabaseEntryKey.privateKey, data: privateKey);
  }
}
