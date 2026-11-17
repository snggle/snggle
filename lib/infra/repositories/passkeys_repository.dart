import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/passkey_entity/passkey_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasskeysRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<List<PasskeyEntity>> getAll() async {
    return isarDatabaseManager.perform((Isar isar) => isar.passkeys.where().findAll());
  }

  Future<List<PasskeyEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    return isarDatabaseManager.perform((Isar isar) =>
        isar.passkeys.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).findAll());
  }

  Future<List<PasskeyEntity>> getAllByRpId(String rpId) async {
    return isarDatabaseManager.perform((Isar isar) =>
        isar.passkeys.where().filter().rpIdEqualTo(rpId).findAll());
  }

  Future<PasskeyEntity> getByCredentialId(List<int> credentialId) async {
    // Comparing binary IDs in Dart avoids relying on a generated Isar list-equality filter.
    List<PasskeyEntity> entities = await getAll();
    for (PasskeyEntity entity in entities) {
      if (listEquals<int>(entity.credentialId, credentialId)) {
        return entity;
      }
    }
    throw ChildKeyNotFoundException();
  }

  Future<PasskeyEntity> getById(Id id) async {
    PasskeyEntity? entity = await isarDatabaseManager.perform((Isar isar) => isar.passkeys.get(id));
    if (entity == null) {
      throw ChildKeyNotFoundException();
    }
    return entity;
  }

  Future<Id> save(PasskeyEntity entity) async {
    return isarDatabaseManager.perform((Isar isar) => isar.writeTxn(() => isar.passkeys.put(entity)));
  }

  Future<List<Id>> saveAll(List<PasskeyEntity> entities) async {
    return isarDatabaseManager.perform((Isar isar) => isar.writeTxn(() => isar.passkeys.putAll(entities)));
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      bool deletedBool = await isar.writeTxn(() => isar.passkeys.delete(id));
      if (!deletedBool) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
