import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';

typedef DatabaseCall<T> = T Function(Isar isar);

class IsarDatabaseManager {
  late Isar _isar;
  bool initializedBool = false;

  Future<void> initDatabase({String? name}) async {
    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();
    _isar = await Isar.open(
      <CollectionSchema<dynamic>>[
        VaultEntitySchema,
        WalletEntitySchema,
        NetworkGroupEntitySchema,
        NetworkTemplateEntitySchema,
        GroupEntitySchema,
        TransactionEntitySchema,
      ],
      name: name ?? Isar.defaultName,
      directory: rootDirectory.path,
    );
    initializedBool = true;
  }

  /// A wrapper for executing database queries that allows for simplification and shortening of the queries.
  ///
  /// Usage:
  /// isarDatabaseManager.perform((Isar isar) => isar.<collection>.where().findAll());
  ///
  /// which works the same as:
  /// isarDatabaseManager.isar.<collection>.where().findAll();
  T perform<T>(DatabaseCall<T> databaseCall) {
    return databaseCall(_isar);
  }

  Future<void> close() async {
    if (initializedBool == true && _isar.isOpen) {
      await _isar.close();
    }
  }
}
