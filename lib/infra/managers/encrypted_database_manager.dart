import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/i_database_manager.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';

/// Class to store data in database in encrypted form.
/// Using [DecryptedDatabaseManager] data is stored as a plain text.
/// e.g.:
/// {
///    "some_key": "some_value"
/// }
/// [EncryptedDatabaseManager] allows to store the same data in encrypted form:
/// e.g.:
/// {
///    "some_key": "9af15b336e6a9619928537df30b2e6a2376569f"
/// }
class EncryptedDatabaseManager implements IDatabaseManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();
  final MasterKeyController _masterKeyController;

  EncryptedDatabaseManager({
    MasterKeyController? masterKeyController,
  }) : _masterKeyController = masterKeyController ?? globalLocator<MasterKeyController>();

  @override
  Future<bool> containsKey({required DatabaseParentKey databaseParentKey}) async {
    return _flutterSecureStorage.containsKey(key: databaseParentKey.name);
  }

  @override
  Future<String> read({required DatabaseParentKey databaseParentKey}) async {
    String? encryptedValue = await _flutterSecureStorage.read(key: databaseParentKey.name);
    if (encryptedValue == null) {
      throw ParentKeyNotFoundException('${databaseParentKey.name} parent key not found in database');
    }
    return _masterKeyController.decrypt(encryptedValue);
  }

  @override
  Future<void> write({required DatabaseParentKey databaseParentKey, required String plaintextValue}) async {
    String encryptedValue = await _masterKeyController.encrypt(plaintextValue);
    await _flutterSecureStorage.write(key: databaseParentKey.name, value: encryptedValue);
  }
}
