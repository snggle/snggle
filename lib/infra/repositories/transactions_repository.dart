import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class TransactionsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<List<TransactionEntity>> getByWallet(int walletId) async {
    List<TransactionEntity> transactionEntities = await isarDatabaseManager.perform((Isar isar) {
      return isar.transactions.where().filter().walletIdEqualTo(walletId).findAll();
    });

    return transactionEntities;
  }

  Future<int> save(TransactionEntity transactionEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      Id createdId = await isar.writeTxn(() async {
        return isar.transactions.put(transactionEntity);
      });
      return createdId;
    });
  }

  Future<void> deleteAll(List<TransactionEntity> transactionEntities) async {
    return isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        List<int> idsToDelete = transactionEntities.map((TransactionEntity e) => e.id).toList();
        return isar.transactions.deleteAll(idsToDelete);
      });
    });
  }

  Future<void> deleteByWallet(int walletId) async {
    await isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        return isar.transactions.where().filter().walletIdEqualTo(walletId).deleteAll();
      });
    });
  }
}
