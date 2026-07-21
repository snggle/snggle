import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/objectbox/objectbox.g.dart';

typedef DatabaseCall<T> = T Function(Store store);

class ObjectboxDatabaseManager {
  late Store _store;
  Admin? _admin;
  String? _databaseDirectoryPath;

  bool initializedBool = false;

  Store get store => _store;

  Future<void> initDatabase({String? name}) async {
    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();

    String databaseDirectoryName = name ?? Store.defaultDirectoryPath;
    String databaseDirectoryPath = '${rootDirectory.path}${Platform.pathSeparator}$databaseDirectoryName';

    if (initializedBool == true && _store.isClosed() == false) {
      _startObjectBoxAdmin(_store);

      return;
    }

    if (initializedBool == true) {
      await close(deleteFromDisk: false);
    }

    if (Store.isOpen(databaseDirectoryPath)) {
      _store = Store.attach(getObjectBoxModel(), databaseDirectoryPath);
    } else {
      _store = await openStore(directory: databaseDirectoryPath);
    }

    _databaseDirectoryPath = databaseDirectoryPath;
    initializedBool = true;

    _startObjectBoxAdmin(_store);
  }

  void _startObjectBoxAdmin(Store store) {
    if (kDebugMode == false) {
      return;
    }

    if (Admin.isAvailable() == false) {
      return;
    }

    if (_admin != null && _admin!.isClosed() == false) {
      return;
    }

    _admin = Admin(store);
  }

  /// A wrapper for executing database queries that allows for simplification and shortening of the queries.
  ///
  /// Usage:
  /// objectBoxDatabaseManager.perform((Store store) => store.box<VaultEntity>().getAll());
  ///
  /// which works the same as:
  /// objectBoxDatabaseManager.store.box<VaultEntity>().getAll();
  T perform<T>(DatabaseCall<T> databaseCall) {
    return databaseCall(_store);
  }

  Future<void> close({bool deleteFromDisk = true}) async {
    if (initializedBool == false || _databaseDirectoryPath == null) {
      return;
    }

    String databaseDirectoryPath = _databaseDirectoryPath!;
    Store store = _store;
    Admin? admin = _admin;

    initializedBool = false;
    _databaseDirectoryPath = null;
    _admin = null;

    if (admin != null && admin.isClosed() == false) {
      admin.close();
    }

    if (store.isClosed() == false) {
      store.close();
    }

    if (deleteFromDisk == true) {
      Store.removeDbFiles(databaseDirectoryPath);
    }
  }
}
