
import 'package:snuggle/infra/storage_manager.dart';

class MockStorageManager implements StorageManager {
  final Map<String, String> storage;

  MockStorageManager({
    Map<String, String>? mockStorage,
  }) : storage = mockStorage ?? <String, String>{};

  @override
  Future<bool> containsKeyData({required String key}) async {
    return storage.containsKey(key);
  }

  @override
  Future<String> getKeyData({required String key}) async {
    String? value = storage[key];
    if (value == null) {
      throw Exception('No data found for key: $key');
    }
    return value;
  }

  @override
  Future<Map<String, String>> readAll() async {
    return storage;
  }

  @override
  Future<void> writeKeyData({required String key, required String data}) async {
    storage[key] = data;
  }

}