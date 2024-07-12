import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_group_entity/network_group_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<List<NetworkGroupEntity>> getAll() async {
    List<NetworkGroupEntity> networkGroupEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.networkGroups.where().findAll();
    });

    return networkGroupEntities;
  }

  Future<List<NetworkGroupEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<NetworkGroupEntity> networkGroupEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.networkGroups.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).findAll();
    });

    return networkGroupEntities;
  }

  Future<NetworkGroupEntity> getById(Id id) async {
    NetworkGroupEntity? networkGroupEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.networkGroups.get(id);
    });

    if (networkGroupEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return networkGroupEntity;
  }

  Future<Id> save(NetworkGroupEntity networkGroupEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.networkGroups.put(networkGroupEntity);
      });
      return createdId;
    });
  }

  Future<List<Id>> saveAll(List<NetworkGroupEntity> networkGroupEntityList) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<Id> createdIds = await isar.writeTxn(() async {
        return isar.networkGroups.putAll(networkGroupEntityList);
      });
      return createdIds;
    });
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      bool deletedBool = await isar.writeTxn(() async {
        return isar.networkGroups.delete(id);
      });
      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
