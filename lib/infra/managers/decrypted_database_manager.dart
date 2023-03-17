import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/infra/managers/database_entry_key.dart';
import 'package:snggle/infra/managers/i_database_manager.dart';

class DecryptedDatabaseManager implements IDatabaseManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  @override
  Future<bool> containsKey({required DatabaseEntryKey databaseEntryKey}) async {
    return _flutterSecureStorage.containsKey(key: databaseEntryKey.name);
  }

  @override
  Future<String> read({required DatabaseEntryKey databaseEntryKey}) async {
    String? value = await _flutterSecureStorage.read(key: databaseEntryKey.name);
    if (value == null) {
      throw Exception('No data found for key: ${databaseEntryKey.name}');
    } else {
      return value;
    }
  }

  @override
  Future<Map<String, String>> readAll() async {
    return _flutterSecureStorage.readAll();
  }

  @override
  Future<void> write({required DatabaseEntryKey databaseEntryKey, required String data}) async {
    await _flutterSecureStorage.write(key: databaseEntryKey.name, value: data.toString());
  }
}
