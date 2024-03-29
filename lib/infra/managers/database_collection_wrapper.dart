import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/exceptions/invalid_collection_exception.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';
import 'package:snggle/infra/managers/i_database_manager.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

/// [DatabaseCollectionWrapper] is a class used to store and read collections (such as [List], [Set] or [Map]) in the database.
/// It stores collections as a key-value map, where key is a identification [String] and value is a [T] (which must be json serializable and deserializable)
///
/// [FlutterSecureStorage] stores database as a Map<String, String> which is problematic for complex types (e.g. Objects, Lists, Sets or Maps).
/// They must be deserialized/serialized before reading or saving them in database (when using [EncryptedDatabaseManager], they are also encrypted/decrypted).
/// By default those operations are performed every time when accessing the database which may reduce the application performance and make the development more complicated.
/// [DatabaseCollectionWrapper] was created to reduce the number of conversions for collections, by using cache.
///
class DatabaseCollectionWrapper<T> {
  /// Key representing the collection in the database
  final DatabaseParentKey databaseParentKey;

  /// [IDatabaseManager] used to read and write data
  /// - [DecryptedDatabaseManager] for values that don't need to be encrypted
  /// - [EncryptedDatabaseManager] for values that need to be encrypted
  final IDatabaseManager databaseManager;

  /// Completer used to ensure that the cache is initialized before performing any operation
  @visibleForTesting
  final Completer<void> collectionCacheInitCompleter = Completer<void>();

  /// Cache used to store the collection
  /// We use the cache to avoid decoding, encoding, encrypting and decrypting every time on each access to database
  @visibleForTesting
  Map<String, T> collectionCacheMap = <String, T>{};

  DatabaseCollectionWrapper({
    required this.databaseParentKey,
    required this.databaseManager,
  }) {
    _initCollectionCache();
  }

  Future<bool> containsId(String id) async {
    await collectionCacheInitCompleter.future;
    return collectionCacheMap.containsKey(id);
  }

  Future<List<T>> getAll() async {
    await collectionCacheInitCompleter.future;
    return collectionCacheMap.values.toList();
  }

  Future<T> getById(String id) async {
    await collectionCacheInitCompleter.future;
    T? value = collectionCacheMap[id];
    if (value == null) {
      throw ChildKeyNotFoundException('[${id}] child key not found in [${databaseParentKey.name}] parent key');
    }
    return value;
  }

  Future<void> saveWithId(String id, T value) async {
    await collectionCacheInitCompleter.future;
    collectionCacheMap[id] = value;
    await _saveCollectionCacheInDatabase();
  }

  Future<void> deleteById(String id) async {
    await collectionCacheInitCompleter.future;
    if (collectionCacheMap.containsKey(id) == false) {
      throw ChildKeyNotFoundException('[${id}] child key not found in [${databaseParentKey.name}] parent key');
    }
    collectionCacheMap.remove(id);
    await _saveCollectionCacheInDatabase();
  }

  Future<void> _initCollectionCache() async {
    try {
      collectionCacheMap = await _getCollectionFromDatabase();
    } catch (e) {
      AppLogger().log(message: 'Cannot read value for [${databaseParentKey.name}] parent key: $e', logLevel: LogLevel.warning);
      collectionCacheMap = <String, T>{};
    } finally {
      collectionCacheInitCompleter.complete();
    }
  }

  Future<Map<String, T>> _getCollectionFromDatabase() async {
    bool collectionExistBool = await databaseManager.containsKey(databaseParentKey: databaseParentKey);
    if (collectionExistBool == false) {
      throw ParentKeyNotFoundException('[${databaseParentKey.name}] parent key not found in database');
    }

    String collectionString = await databaseManager.read(databaseParentKey: databaseParentKey);
    Map<String, T> collectionCacheMap = _deserializeCollection(collectionString);
    return collectionCacheMap;
  }

  Map<String, T> _deserializeCollection(String collectionString) {
    try {
      Map<String, dynamic> collectionMap = jsonDecode(collectionString) as Map<String, dynamic>;
      return collectionMap.map((String key, dynamic value) => MapEntry<String, T>(key, value as T));
    } catch (_) {
      AppLogger().log(message: 'Cannot deserialize collection string: $collectionString', logLevel: LogLevel.fatal);
      throw InvalidCollectionException();
    }
  }

  Future<void> _saveCollectionCacheInDatabase() async {
    String cacheJsonString = jsonEncode(collectionCacheMap);
    await databaseManager.write(databaseParentKey: databaseParentKey, plaintextValue: cacheJsonString);
  }
}
