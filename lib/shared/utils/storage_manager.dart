import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  late final _IStorage storage;

  StorageManager() {
    try {
      const FlutterSecureStorage().readAll();
      storage = _SecureStorage();
    } catch(_) {
      storage = _InsecureStorage();
    }
  }
  

  Future<String> read({required String key}) async {
    return storage.read(key: key);
  }

  Future<void> write({required String key, required String data}) async {
    await storage.write(key: key, data: data.toString());
  }

  Future<bool> containsKey({required String key}) async {
    return storage.containsKey(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return storage.readAll();
  }
}

abstract class _IStorage {
  Future<String> read({required String key});
  Future<void> write({required String key, required String data});
  Future<bool> containsKey({required String key});
  Future<Map<String, String>> readAll();
}

class _SecureStorage implements _IStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<String> read({required String key}) async {
    String? data = await storage.read(key: key);
    if(data == null ) {
      throw Exception('No data found for key: $key');
    } else {
      return data;
    }
  }

  @override
  Future<void> write({required String key, required String data}) async {
    await storage.write(key: key, value: data.toString());
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return storage.containsKey(key: key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    return storage.readAll();
  }
}

class _InsecureStorage implements _IStorage {
  final Map<String, String> _database = <String, String>{};
  
  @override
  Future<String> read({required String key}) async {
    return _database[key]!;
  }

  @override
  Future<void> write({required String key, required String data}) async {
    _database[key] = data;
  }

  @override
  Future<bool> containsKey({required String key}) async {
    return _database.containsKey(key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    return _database;
  }
}
