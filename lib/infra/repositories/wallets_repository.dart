import 'dart:async';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/object_box_database_manager.dart';
import 'package:snggle/objectbox.g.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletsRepository {
  final ObjectBoxDatabaseManager objectBoxDatabaseManager = globalLocator<ObjectBoxDatabaseManager>();

  Future<List<String>> getAllDerivationPaths(FilesystemPath parentFilesystemPath) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<WalletEntity> box = store.box<WalletEntity>();
      bool hasParentsBool = parentFilesystemPath.fullPath.isEmpty;

      if (hasParentsBool) {
        return box.getAll().map((WalletEntity entity) => entity.derivationPath).toList();
      }

      String baseDerivationPath = '${parentFilesystemPath.fullPath}/';
      Query<WalletEntity> query = box
          .query(
            WalletEntity_.filesystemPathString.startsWith(baseDerivationPath),
          )
          .build();

      try {
        return query.find().map((WalletEntity entity) => entity.derivationPath).toList();
      } finally {
        query.close();
      }
    });
  }

  Future<List<WalletEntity>> getAll() async => objectBoxDatabaseManager.perform((Store store) => store.box<WalletEntity>().getAll());

  Future<List<WalletEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<WalletEntity> query = store
          .box<WalletEntity>()
          .query(
            WalletEntity_.filesystemPathString.startsWith(parentFilesystemPath.fullPath),
          )
          .build();

      try {
        return query.find();
      } finally {
        query.close();
      }
    });
  }

  Future<WalletEntity> getByAddress(String address) async {
    WalletEntity? walletEntity = objectBoxDatabaseManager.perform((Store store) {
      Query<WalletEntity> query = store
          .box<WalletEntity>()
          .query(
            WalletEntity_.address.equals(address, caseSensitive: false),
          )
          .build();

      try {
        return query.findFirst();
      } finally {
        query.close();
      }
    });

    if (walletEntity == null) {
      throw ChildKeyNotFoundException();
    }

    return walletEntity;
  }

  Future<WalletEntity> getById(int id) async {
    WalletEntity? walletEntity = objectBoxDatabaseManager.perform((Store store) => store.box<WalletEntity>().get(id));

    if (walletEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return walletEntity;
  }

  Future<int> save(WalletEntity walletEntity) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<WalletEntity> box = store.box<WalletEntity>();
      return store.runInTransaction(TxMode.write, () => box.put(walletEntity));
    });
  }

  Future<List<int>> saveAll(List<WalletEntity> walletEntityList) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Box<WalletEntity> box = store.box<WalletEntity>();
      return store.runInTransaction(TxMode.write, () => box.putMany(walletEntityList));
    });
  }

  Future<void> deleteById(int id) async {
    objectBoxDatabaseManager.perform((Store store) {
      Box<WalletEntity> box = store.box<WalletEntity>();
      bool deletedBool = store.runInTransaction(TxMode.write, () => box.remove(id));

      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
