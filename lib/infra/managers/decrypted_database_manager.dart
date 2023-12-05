import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/i_database_manager.dart';

class DecryptedDatabaseManager implements IDatabaseManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  @override
  Future<bool> containsKey({required DatabaseParentKey databaseParentKey}) async {
    return _flutterSecureStorage.containsKey(key: databaseParentKey.name);
  }

  @override
  Future<String> read({required DatabaseParentKey databaseParentKey}) async {
    String? plaintextValue = await _flutterSecureStorage.read(key: databaseParentKey.name);
    if (plaintextValue == null) {
      throw ParentKeyNotFoundException('[${databaseParentKey.name}] parent key not found in database');
    } else {
      return plaintextValue;
    }
  }

  @override
  Future<void> write({required DatabaseParentKey databaseParentKey, required String plaintextValue}) async {
    await _flutterSecureStorage.write(key: databaseParentKey.name, value: plaintextValue);
  }
}
