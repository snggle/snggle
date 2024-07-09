import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_manager.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';

/// Class to store data in secure storage in encrypted form.
/// Using [SecureStorageManager] data is stored as a plain text.
/// e.g.:
/// {
///    "some_key": "some_value"
/// }
/// [EncryptedSecureStorageManager] allows to store the same data in encrypted form:
/// e.g.:
/// {
///    "some_key": "9af15b336e6a9619928537df30b2e6a2376569f"
/// }
class EncryptedSecureStorageManager extends SecureStorageManager {
  final MasterKeyController _masterKeyController;

  EncryptedSecureStorageManager({
    MasterKeyController? masterKeyController,
  }) : _masterKeyController = masterKeyController ?? globalLocator<MasterKeyController>();

  @override
  Future<String> read({required SecureStorageKey secureStorageKey}) async {
    String? encryptedValue = await super.read(secureStorageKey: secureStorageKey);
    return _masterKeyController.decrypt(encryptedValue);
  }

  @override
  Future<void> write({required SecureStorageKey secureStorageKey, required String plaintextValue}) async {
    String encryptedValue = await _masterKeyController.encrypt(plaintextValue);
    await super.write(secureStorageKey: secureStorageKey, plaintextValue: encryptedValue);
  }
}
