import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class TransactionsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  /// Get all transactions (Ethereum + Solana) by wallet
  Future<List<ATransactionEntity>> getByWallet(int walletId) async {
    return isarDatabaseManager.perform((Isar isar) async {
      List<EthereumTransactionEntity> eth = await isar.ethereumTransactions.filter().walletIdEqualTo(walletId).findAll();
      List<SolanaTransactionEntity> sol = await isar.solanaTransactions.filter().walletIdEqualTo(walletId).findAll();
      return <ATransactionEntity>[...eth, ...sol];
    });
  }

  /// Save a transaction (detects Ethereum or Solana automatically)
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

  /// Delete a batch of transactions
  Future<void> deleteAll(List<ATransactionEntity> transactionEntities) async {
    return isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        List<Id> ethIds = transactionEntities.whereType<EthereumTransactionEntity>().map((EthereumTransactionEntity e) => e.id).toList();
        List<Id> solIds = transactionEntities.whereType<SolanaTransactionEntity>().map((SolanaTransactionEntity e) => e.id).toList();

        if (ethIds.isNotEmpty) {
          await isar.ethereumTransactions.deleteAll(ethIds);
        }
        if (solIds.isNotEmpty) {
          await isar.solanaTransactions.deleteAll(solIds);
        }
      });
    });
  }

  /// Delete all transactions for a wallet
  Future<void> deleteByWallet(int walletId) async {
    await isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        await isar.ethereumTransactions.filter().walletIdEqualTo(walletId).deleteAll();
        await isar.solanaTransactions.filter().walletIdEqualTo(walletId).deleteAll();
      });
    });
  }
}
