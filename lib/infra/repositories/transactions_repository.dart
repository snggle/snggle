import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class TransactionsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  Future<List<ATransactionEntity>> getByWallet(int walletId) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<EthereumTransactionEntity> ethereumTransactionList = await isar.ethereumTransactions.filter().walletIdEqualTo(walletId).findAll();
      List<SolanaTransactionEntity> solanaTransactionList = await isar.solanaTransactions.filter().walletIdEqualTo(walletId).findAll();
      return <ATransactionEntity>[...ethereumTransactionList, ...solanaTransactionList];
    });
  }

  Future<int> save(ATransactionEntity transactionEntity) async {
    return isarDatabaseManager.perform((Isar isar) async {
      return isar.writeTxn(() async {
        if (transactionEntity is EthereumTransactionEntity) {
          return isar.ethereumTransactions.put(transactionEntity);
        } else if (transactionEntity is SolanaTransactionEntity) {
          return isar.solanaTransactions.put(transactionEntity);
        } else {
          throw UnsupportedError('Unsupported transaction type: ${transactionEntity.runtimeType}');
        }
      });
    });
  }

  Future<void> deleteAll(List<ATransactionEntity> txEntityList) async {
    return isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        List<Id> ethereumTransactionIdList = txEntityList.whereType<EthereumTransactionEntity>().map((EthereumTransactionEntity e) => e.id).toList();
        List<Id> solanaTransactionIdList = txEntityList.whereType<SolanaTransactionEntity>().map((SolanaTransactionEntity e) => e.id).toList();

        if (ethereumTransactionIdList.isNotEmpty) {
          await isar.ethereumTransactions.deleteAll(ethereumTransactionIdList);
        }
        if (solanaTransactionIdList.isNotEmpty) {
          await isar.solanaTransactions.deleteAll(solanaTransactionIdList);
        }
      });
    });
  }

  Future<void> deleteByWallet(int walletId) async {
    await isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        await isar.ethereumTransactions.filter().walletIdEqualTo(walletId).deleteAll();
        await isar.solanaTransactions.filter().walletIdEqualTo(walletId).deleteAll();
      });
    });
  }
}
