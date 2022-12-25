import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  Future<String> getKeyData({required String key}) async {
    String? value = await _flutterSecureStorage.read(key: key);
    if (value == null) {
      throw Exception('No data found for key: $key');
    } else {
      return value;
    }
  }

  Future<void> writeKeyData({required String key, required String data}) async {
    await _flutterSecureStorage.write(key: key, value: data.toString());
  }

  Future<bool> containsKeyData({required String key}) async {
    return _flutterSecureStorage.containsKey(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return _flutterSecureStorage.readAll();
  }
}
