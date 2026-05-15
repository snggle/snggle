import 'dart:async';

import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/credential_entity/credential_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class CredentialsRepository {
  final IsarDatabaseManager isarDatabaseManager =
  globalLocator<IsarDatabaseManager>();

  Future<List<CredentialEntity>> getAll() async {
    final List<CredentialEntity> credentialEntities =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials.where().findAll();
    });

    return credentialEntities;
  }

  Future<CredentialEntity> getById(Id id) async {
    final CredentialEntity? credentialEntity =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials.get(id);
    });

    if (credentialEntity == null) {
      throw ChildKeyNotFoundException();
    }

    return credentialEntity;
  }

  Future<CredentialEntity> getBySecretId(String secretId) async {
    final CredentialEntity? credentialEntity =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials
          .where()
          .filter()
          .secretIdEqualTo(secretId)
          .findFirst();
    });

    if (credentialEntity == null) {
      throw ChildKeyNotFoundException();
    }

    return credentialEntity;
  }

  Future<List<CredentialEntity>> getAllByPackageName(
      String packageName,
      ) async {
    final List<CredentialEntity> credentialEntities =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials
          .where()
          .filter()
          .packageNameEqualTo(packageName)
          .findAll();
    });

    return credentialEntities;
  }

  Future<List<CredentialEntity>> searchByPackageName(
      String packageName,
      ) async {
    final List<CredentialEntity> credentialEntities =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials
          .where()
          .filter()
          .packageNameContains(packageName, caseSensitive: false)
          .findAll();
    });

    return credentialEntities;
  }

  Future<List<CredentialEntity>> searchByDisplayName(
      String query,
      ) async {
    final List<CredentialEntity> credentialEntities =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials
          .where()
          .filter()
          .displayNameContains(query, caseSensitive: false)
          .findAll();
    });

    return credentialEntities;
  }

  Future<List<CredentialEntity>> searchByWebsite(
      String query,
      ) async {
    final List<CredentialEntity> credentialEntities =
    await isarDatabaseManager.perform((Isar isar) {
      return isar.credentials
          .where()
          .filter()
          .websiteContains(query, caseSensitive: false)
          .findAll();
    });

    return credentialEntities;
  }

  Future<Id> save(CredentialEntity credentialEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      final Id createdId = await isar.writeTxn(() async {
        return isar.credentials.put(credentialEntity);
      });

      return createdId;
    });
  }

  Future<List<Id>> saveAll(
      List<CredentialEntity> credentialEntityList,
      ) async {
    return isarDatabaseManager.perform((Isar isar) async {
      final List<Id> createdIds = await isar.writeTxn(() async {
        return isar.credentials.putAll(credentialEntityList);
      });

      return createdIds;
    });
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      final bool deletedBool = await isar.writeTxn(() async {
        return isar.credentials.delete(id);
      });

      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }

  Future<void> deleteBySecretId(String secretId) async {
    await isarDatabaseManager.perform((Isar isar) async {
      final CredentialEntity? credentialEntity = await isar.credentials
          .where()
          .filter()
          .secretIdEqualTo(secretId)
          .findFirst();

      if (credentialEntity == null) {
        throw ChildKeyNotFoundException();
      }

      final bool deletedBool = await isar.writeTxn(() async {
        return isar.credentials.delete(credentialEntity.id);
      });

      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}