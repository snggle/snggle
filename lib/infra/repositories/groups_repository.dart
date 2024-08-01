import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/group_entity/group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class GroupsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<List<GroupEntity>> getAll() async {
    List<GroupEntity> groupEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.groups.where().findAll();
    });

    return groupEntities;
  }

  Future<List<GroupEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<GroupEntity> groupEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.groups.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).findAll();
    });

    return groupEntities;
  }

  Future<GroupEntity> getById(Id id) async {
    GroupEntity? groupEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.groups.get(id);
    });

    if (groupEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return groupEntity;
  }

  Future<GroupEntity> getByPath(FilesystemPath filesystemPath) async {
    GroupEntity? groupEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.groups.where().filesystemPathStringEqualTo(filesystemPath.fullPath).findFirst();
    });

    if (groupEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return groupEntity;
  }

  Future<Id> save(GroupEntity groupEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.groups.put(groupEntity);
      });
      return createdId;
    });
  }

  Future<List<Id>> saveAll(List<GroupEntity> groupEntityList) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<Id> createdIds = await isar.writeTxn(() async {
        return isar.groups.putAll(groupEntityList);
      });
      return createdIds;
    });
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      bool deletedBool = await isar.writeTxn(() async {
        return isar.groups.delete(id);
      });
      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
