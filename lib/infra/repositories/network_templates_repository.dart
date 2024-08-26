import 'dart:async';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class NetworkTemplatesRepository {
  final IsarDatabaseManager _isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<List<NetworkTemplateEntity>> getAll() async {
    List<NetworkTemplateEntity> networkTemplateEntities = await _isarDatabaseManager.perform((Isar isar) {
      return isar.networkTemplates.where().sortByName().findAll();
    });

    return networkTemplateEntities;
  }

  Future<NetworkTemplateEntity> getById(Id id) async {
    NetworkTemplateEntity? networkTemplateEntity = await _isarDatabaseManager.perform((Isar isar) {
      return isar.networkTemplates.get(id);
    });

    if (networkTemplateEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return networkTemplateEntity;
  }

  Future<Id> save(NetworkTemplateEntity networkTemplateEntity) async {
    return _isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.networkTemplates.put(networkTemplateEntity);
      });
      return createdId;
    });
  }

  Future<void> deleteAll(List<NetworkTemplateEntity> networkTemplateEntities) async {
    await _isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        return isar.networkTemplates.deleteAll(networkTemplateEntities.map((NetworkTemplateEntity e) => e.id).toList());
      });
    });
  }
}
