import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';

class SecureStorageManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  Future<bool> containsKey({required SecureStorageKey secureStorageKey}) async {
    return _flutterSecureStorage.containsKey(key: secureStorageKey.name);
  }

  Future<String> read({required SecureStorageKey secureStorageKey}) async {
    String? plaintextValue = await _flutterSecureStorage.read(key: secureStorageKey.name);
    if (plaintextValue == null) {
      throw ParentKeyNotFoundException('[${secureStorageKey.name}] parent key not found in secure storage');
    } else {
      return plaintextValue;
    }
  }

  Future<void> write({required SecureStorageKey secureStorageKey, required String plaintextValue}) async {
    await _flutterSecureStorage.write(key: secureStorageKey.name, value: plaintextValue);
  }
}
