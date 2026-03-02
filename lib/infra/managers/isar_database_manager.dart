import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/entities/network_template_entity/embedded_network_template_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/services/isar_database_version_service.dart';

typedef DatabaseCall<T> = T Function(Isar isar);

class IsarDatabaseManager {
  final IsarDatabaseVersionService _isarDatabaseVersionService = globalLocator<IsarDatabaseVersionService>();
  late Isar _isar;
  bool initializedBool = false;

  Future<void> initDatabase({String? name}) async {
    String databaseName = name ?? Isar.defaultName;
    Isar? databaseIsar = Isar.getInstance(databaseName);

    if (databaseIsar != null) {
      _isar = databaseIsar;
      initializedBool = true;
      return;
    }

    Directory rootDirectory = await globalLocator<RootDirectoryBuilder>().call();
    _isar = await Isar.open(
      <CollectionSchema<dynamic>>[
        VaultEntitySchema,
        WalletEntitySchema,
        NetworkGroupEntitySchema,
        GroupEntitySchema,
        TransactionEntitySchema,
      ],
      name: databaseName,
      directory: rootDirectory.path,
    );

    /// On application startup, check if migration is needed
    await _migrate();

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
      await _isar.close(deleteFromDisk: true);
    }
    initializedBool = false;
  }

  Future<void> _migrate() async {
    int expectedIsarDatabaseVersion = 1;
    int storedIsarDatabaseVersion = await _isarDatabaseVersionService.getIsarDatabaseVersion();

    /// If stored isar database version is older than expected, execute all required migration steps
    if (storedIsarDatabaseVersion < 1) {
      print('migrating to db version 1');
      await _migrateNetworkType();
    }

    /// After migration, ensure the isar database version is updated
    if (storedIsarDatabaseVersion != expectedIsarDatabaseVersion) {
      print('Setting stored db version: from $storedIsarDatabaseVersion to $expectedIsarDatabaseVersion');
      await _isarDatabaseVersionService.setIsarDatabaseVersion(expectedIsarDatabaseVersion);
    }
  }

  Future<void> _migrateNetworkType() async {
    /// Example of a migration:
    /// A new field, enum NetworkType, has been added to EmbeddedNetworkTemplateEntity in an application update
    /// During migration, we want to ensure that NetworkType parameter is set for all existing entries in the database
    /// So we set it everywhere where it is missing
    /*await _isar.writeTxn(() async {
      IsarCollection<NetworkGroupEntity> networkGroupsCollection = _isar.collection<NetworkGroupEntity>();
      List<NetworkGroupEntity> networkGroupEntitiesList = await networkGroupsCollection.where().findAll();

      for (NetworkGroupEntity networkGroupEntity in networkGroupEntitiesList) {

        EmbeddedNetworkTemplateEntity embeddedNetworkTemplateEntity = networkGroupEntity.embeddedNetworkTemplate;

        if (embeddedNetworkTemplateEntity.networkType == null) {
          NetworkGroupEntity updatedGroup = networkGroupEntity.copyWith(
            embeddedNetworkTemplate: embeddedNetworkTemplateEntity.copyWith(
              networkType: NetworkType.ethereum,
            ),
          );

          await networkGroupsCollection.put(updatedGroup);
        }
      }
    });*/
  }
}
