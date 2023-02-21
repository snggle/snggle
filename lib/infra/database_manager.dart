import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// TODO(Knight): In future, when there will be more than one manager, enum and class should be extracted into two files and moved to lib/infra/managers/

enum DatabaseEntryKey {
  salt,
  setupPinVisibleBool,
}

class DatabaseManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  Future<bool> containsKey({required DatabaseEntryKey databaseEntryKey}) async {
    return _flutterSecureStorage.containsKey(key: databaseEntryKey.name);
  }

  Future<String> read({required DatabaseEntryKey databaseEntryKey}) async {
    String? value = await _flutterSecureStorage.read(key: databaseEntryKey.name);
    if (value == null) {
      throw Exception('No data found for key: ${databaseEntryKey.name}');
    } else {
      return value;
    }
  }

  Future<Map<String, String>> readAll() async {
    return _flutterSecureStorage.readAll();
  }

  Future<void> write({required DatabaseEntryKey databaseEntryKey, required String data}) async {
    await _flutterSecureStorage.write(key: databaseEntryKey.name, value: data.toString());
  }
}
