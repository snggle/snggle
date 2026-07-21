import 'dart:async';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity/vault_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/object_box_database_manager.dart';
import 'package:snggle/objectbox.g.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultsRepository {
  final ObjectBoxDatabaseManager objectBoxDatabaseManager = globalLocator<ObjectBoxDatabaseManager>();

  Future<int?> getLastIndex() async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<VaultEntity> query = store.box<VaultEntity>().query().order(VaultEntity_.index, flags: Order.descending).build();

      try {
        return query.findFirst()?.index;
      } finally {
        query.close();
      }
    });
  }

  Future<List<VaultEntity>> getAll() async => objectBoxDatabaseManager.perform((Store store) => store.box<VaultEntity>().getAll());

  Future<List<VaultEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<VaultEntity> query = store
          .box<VaultEntity>()
          .query(
            VaultEntity_.filesystemPathString.startsWith(parentFilesystemPath.fullPath),
          )
          .build();

      try {
        return query.find();
      } finally {
        query.close();
      }
    });
  }

  Future<VaultEntity> getById(int id) async {
    VaultEntity? vaultEntity = objectBoxDatabaseManager.perform((Store store) => store.box<VaultEntity>().get(id));

    if (vaultEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return vaultEntity;
  }

  Future<VaultEntity> getByFingerprint(String fingerprint) async {
    VaultEntity? vaultEntity = objectBoxDatabaseManager.perform((Store store) {
      Query<VaultEntity> query = store
          .box<VaultEntity>()
          .query(
            VaultEntity_.fingerprint.equals(fingerprint),
          )
          .build();

      try {
        return query.findFirst();
      } finally {
        query.close();
      }
    });

    if (vaultEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return vaultEntity;
  }

  Future<int> save(VaultEntity vaultEntity) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<VaultEntity> box = store.box<VaultEntity>();
      return store.runInTransaction(TxMode.write, () => box.put(vaultEntity));
    });
  }

  Future<List<int>> saveAll(List<VaultEntity> vaultEntityList) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<VaultEntity> box = store.box<VaultEntity>();
      return store.runInTransaction(TxMode.write, () => box.putMany(vaultEntityList));
    });
  }

  Future<void> deleteById(int id) async {
    objectBoxDatabaseManager.perform((Store store) {
      Box<VaultEntity> box = store.box<VaultEntity>();
      bool deletedBool = store.runInTransaction(TxMode.write, () => box.remove(id));

      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
