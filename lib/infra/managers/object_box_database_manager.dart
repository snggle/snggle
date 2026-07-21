import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/objectbox.g.dart';

typedef DatabaseCall<T> = T Function(Store store);

class ObjectBoxDatabaseManager {
  static final Map<String, Store> _storesByDirectoryPath = <String, Store>{};
  static final Map<String, Admin> _adminsByDirectoryPath = <String, Admin>{};

  late Store _store;
  String? _databaseDirectoryPath;

  bool initializedBool = false;

  Store get store => _store;

  Future<void> initDatabase({String? name}) async {
    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();

    String databaseDirectoryName = name ?? Store.defaultDirectoryPath;
    String databaseDirectoryPath = '${rootDirectory.path}${Platform.pathSeparator}$databaseDirectoryName';

    Store? existingStore = _storesByDirectoryPath[databaseDirectoryPath];

    if (existingStore != null && existingStore.isClosed() == false) {
      _store = existingStore;
      _databaseDirectoryPath = databaseDirectoryPath;
      initializedBool = true;

      _startObjectBoxAdmin(databaseDirectoryPath, _store);

      return;
    }

    if (Store.isOpen(databaseDirectoryPath)) {
      _store = Store.attach(getObjectBoxModel(), databaseDirectoryPath);
    } else {
      _store = await openStore(directory: databaseDirectoryPath);
    }

    _storesByDirectoryPath[databaseDirectoryPath] = _store;
    _databaseDirectoryPath = databaseDirectoryPath;
    initializedBool = true;

    _startObjectBoxAdmin(databaseDirectoryPath, _store);
  }

  void _startObjectBoxAdmin(String databaseDirectoryPath, Store store) {
    if (!kDebugMode) {
      return;
    }

    if (!Admin.isAvailable()) {
      return;
    }

    if (_adminsByDirectoryPath.containsKey(databaseDirectoryPath)) {
      return;
    }

    Admin admin = Admin(store);
    _adminsByDirectoryPath[databaseDirectoryPath] = admin;
  }

  /// A wrapper for executing database queries that allows for simplification
  /// and shortening of the queries.
  ///
  /// Usage:
  /// objectBoxDatabaseManager.perform(
  ///   (Store store) => store.box<VaultEntity>().getAll(),
  /// );
  ///
  /// which works the same as:
  /// objectBoxDatabaseManager.store.box<VaultEntity>().getAll();
  T perform<T>(DatabaseCall<T> databaseCall) {
    if (initializedBool == false || _store.isClosed()) {
      throw StateError('ObjectBox database has not been initialized.');
    }

    return databaseCall(_store);
  }

  Future<void> close({bool deleteFromDisk = true}) async {
    if (initializedBool == false || _databaseDirectoryPath == null) {
      return;
    }

    String databaseDirectoryPath = _databaseDirectoryPath!;
    Store store = _store;

    initializedBool = false;
    _databaseDirectoryPath = null;
    _storesByDirectoryPath.remove(databaseDirectoryPath);

    if (store.isClosed() == false) {
      store.close();
    }

    if (deleteFromDisk == true) {
      Store.removeDbFiles(databaseDirectoryPath);
    }
  }
}
