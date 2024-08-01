import 'dart:async';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<int?> getLastIndex() async {
    int? lastIndex = await isarDatabaseManager.perform((Isar isar) {
      return isar.vaults.where().sortByIndexDesc().indexProperty().findFirst();
    });
    return lastIndex;
  }

  Future<List<VaultEntity>> getAll() async {
    List<VaultEntity> vaultEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.vaults.where().findAll();
    });

    return vaultEntities;
  }

  Future<List<VaultEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<VaultEntity> vaultEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.vaults.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).findAll();
    });

    return vaultEntities;
  }

  Future<VaultEntity> getById(Id id) async {
    VaultEntity? vaultEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.vaults.get(id);
    });

    if (vaultEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return vaultEntity;
  }

  Future<Id> save(VaultEntity vaultEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.vaults.put(vaultEntity);
      });
      return createdId;
    });
  }

  Future<List<Id>> saveAll(List<VaultEntity> vaultEntityList) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<Id> createdIds = await isar.writeTxn(() async {
        return isar.vaults.putAll(vaultEntityList);
      });
      return createdIds;
    });
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      bool deletedBool = await isar.writeTxn(() async {
        return isar.vaults.delete(id);
      });
      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
