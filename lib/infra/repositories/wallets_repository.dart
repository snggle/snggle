import 'dart:async';
import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_entity/wallet_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class WalletsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<int?> getLastIndex(FilesystemPath parentFilesystemPath) async {
    int? lastIndex = await isarDatabaseManager.perform((Isar isar) {
      return isar.wallets.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).sortByIndexDesc().indexProperty().findFirst();
    });
    return lastIndex;
  }

  Future<List<String>> getAllDerivationPaths(FilesystemPath parentFilesystemPath) async {
    List<String> derivationPaths = await isarDatabaseManager.perform((Isar isar) {
      return isar.wallets.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).derivationPathProperty().findAll();
    });
    return derivationPaths;
  }

  Future<List<WalletEntity>> getAll() async {
    List<WalletEntity> walletEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.wallets.where().findAll();
    });

    return walletEntities;
  }

  Future<List<WalletEntity>> getAllByParentPath(FilesystemPath parentFilesystemPath) async {
    List<WalletEntity> walletEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.wallets.where().filter().filesystemPathStringStartsWith(parentFilesystemPath.fullPath).findAll();
    });
    return walletEntities;
  }

  Future<WalletEntity> getByAddress(String address) async {
    WalletEntity? walletEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.wallets.where().filter().addressEqualTo(address, caseSensitive: false).findFirst();
    });

    if (walletEntity == null) {
      throw ChildKeyNotFoundException();
    }

    return walletEntity;
  }

  Future<WalletEntity> getById(Id id) async {
    WalletEntity? walletEntity = await isarDatabaseManager.perform((Isar isar) {
      return isar.wallets.get(id);
    });

    if (walletEntity == null) {
      throw ChildKeyNotFoundException();
    }
    return walletEntity;
  }

  Future<Id> save(WalletEntity walletEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.wallets.put(walletEntity);
      });
      return createdId;
    });
  }

  Future<List<Id>> saveAll(List<WalletEntity> walletEntityList) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<Id> createdIds = await isar.writeTxn(() async {
        return isar.wallets.putAll(walletEntityList);
      });
      return createdIds;
    });
  }

  Future<void> deleteById(Id id) async {
    await isarDatabaseManager.perform((Isar isar) async {
      bool deletedBool = await isar.writeTxn(() async {
        return isar.wallets.delete(id);
      });
      if (deletedBool == false) {
        throw ChildKeyNotFoundException();
      }
    });
  }
}
