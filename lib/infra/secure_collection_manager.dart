import 'dart:async';
import 'dart:convert';

import 'package:snuggle/infra/entity/i_collection_entity.dart';
import 'package:snuggle/infra/storage_manager.dart';
import 'package:snuggle/shared/utils/app_logger.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';

typedef EntityJsonFactory<T> = T Function(Map<String, dynamic> json);

/// [SecureCollectionManager] is a wrapper around [StorageManager] to provide encryption/decryption for collections
/// Collections are always stored as encrypted String inside database
/// [SecureCollectionManager] stores decrypted collection in a cache to avoid decryption every time the storage is accessed
/// It's used to store sensitive data such as vaults, wallets, etc.
/// [T] is a type of entity stored in collection
class SecureCollectionManager<T extends ICollectionEntity> {
  static const String _defaultPassword = '0000';
  
  final StorageManager _storageManager;
  final EntityJsonFactory<T> _entityJsonFactory;
  final String _storageKey;
  final String _password;

  Map<String, T> _decryptedCollectionCache = <String, T>{};
  Completer<bool> _initializationCompleter = Completer<bool>();

  SecureCollectionManager({
    required String storageKey,
    required EntityJsonFactory<T> entityJsonFactory,
    StorageManager? storageManager,
    String? password,
  })  : _storageKey = storageKey,
        _entityJsonFactory = entityJsonFactory,
        _storageManager = storageManager ?? StorageManager(),
        _password = password ?? _defaultPassword {
    _reloadCollectionCache();
  }

  Map<String, T>  get decryptedCollectionCache => _decryptedCollectionCache;

  Future<void> saveById(String id, T value) async {
    await _initializationCompleter.future;
    _decryptedCollectionCache[id] = value;
    await _saveCollectionInStorage();
  }

  Future<void> deleteById(String id) async {
    await _initializationCompleter.future;
    _decryptedCollectionCache.remove(id);
    await _saveCollectionInStorage();
  }

  Future<T?> getById(String key) async {
    await _initializationCompleter.future;
    return _decryptedCollectionCache[key];
  }

  Future<List<T>> readAll() async {
    await _initializationCompleter.future;
    return _decryptedCollectionCache.values.toList();
  }

  Future<void> _reloadCollectionCache() async {
    _initializationCompleter = Completer<bool>();
    try {
      bool collectionInitialized = await _storageManager.containsKeyData(key: _storageKey);
      if (collectionInitialized == false) {
        AppLogger().log(message: 'Collection $_storageKey is not initialized');
        await _saveCollectionInStorage();
      }

      String encryptedCollectionText = await _storageManager.getKeyData(key: _storageKey);
      String decryptedCollectionText = Aes256.decrypt(_password, encryptedCollectionText);

      _decryptedCollectionCache = _parseCollectionTextToMap(decryptedCollectionText);
      _initializationCompleter.complete(true);
    } catch (e) {
      AppLogger().log(message: 'Failed to reload $_storageKey collection: $e');
      _initializationCompleter.complete(false);
      rethrow;
    }
  }

  Future<void> _saveCollectionInStorage() async {
    String decryptedCollectionText = _parseMapToCollectionText(decryptedCollectionCache);
    String encryptedCollectionText = Aes256.encrypt(_password, decryptedCollectionText);

    await _storageManager.writeKeyData(key: _storageKey, data: encryptedCollectionText);
  }

  Map<String, T> _parseCollectionTextToMap(String collectionText) {
    Map<String, dynamic> collectionJson = jsonDecode(collectionText) as Map<String, dynamic>;
    Map<String, T> collectionMap = <String, T>{};
    collectionJson.forEach((String key, dynamic value) {
      collectionMap[key] = _entityJsonFactory(value as Map<String, dynamic>);
    });

    return collectionMap;
  }

  String _parseMapToCollectionText(Map<String, T> collectionMap) {
    Map<String, dynamic> collectionJson = <String, dynamic>{};
    collectionMap.forEach((String key, T collectionEntity) {
      collectionJson[key] = collectionEntity.toJson();
    });
    return jsonEncode(collectionJson);
  }
}
