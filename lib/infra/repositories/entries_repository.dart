import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/entry_entity/entry_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntriesRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<int?> getLastIndex() async {
    int? lastIndex = await isarDatabaseManager.perform((Isar isar) {
      return isar.entries.where().sortByIndexDesc().indexProperty().findFirst();
    });
    return lastIndex;
  }

  Future<List<EntryEntity>> getAll() async {
    List<EntryEntity> entryEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.entries.where().findAll();
    });

    return entryEntities;
  }

  Future<List<EntryEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<EntryEntity> entryEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.entries.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).findAll();
    });

    return entryEntities;
  }

  Future<EntryEntity> getById(Id id) async {
    EntryEntity? entryEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.entries.get(id);
    });

    if (entryEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return entryEntity;
  }

  Future<Id> save(EntryEntity entryEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.entries.put(entryEntity);
      });
      return createdId;
    });
  }

  Future<List<Id>> saveAll(List<EntryEntity> entryEntityList) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<Id> createdIds = await isar.writeTxn(() async {
        return isar.entries.putAll(entryEntityList);
      });
      return createdIds;
    });
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      bool deletedBool = await isar.writeTxn(() async {
        return isar.entries.delete(id);
      });
      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
