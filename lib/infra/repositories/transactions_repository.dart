import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/a_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/ethereum_transaction_entity.dart';
import 'package:snggle/infra/entities/transaction_entity/solana_transaction_entity.dart';
import 'package:snggle/infra/managers/objectbox_database_manager.dart';
import 'package:snggle/shared/objectbox/objectbox.g.dart';

class TransactionsRepository {
  final ObjectboxDatabaseManager objectBoxDatabaseManager = globalLocator<ObjectboxDatabaseManager>();

  Future<List<ATransactionEntity>> getByWallet(int walletId) async {
    return objectBoxDatabaseManager.perform((Store store) {
      Query<EthereumTransactionEntity> ethereumQuery = store
          .box<EthereumTransactionEntity>()
          .query(
            EthereumTransactionEntity_.walletId.equals(walletId),
          )
          .build();
      Query<SolanaTransactionEntity> solanaQuery = store
          .box<SolanaTransactionEntity>()
          .query(
            SolanaTransactionEntity_.walletId.equals(walletId),
          )
          .build();

      try {
        List<EthereumTransactionEntity> ethereumTransactionList = ethereumQuery.find();
        List<SolanaTransactionEntity> solanaTransactionList = solanaQuery.find();

        return <ATransactionEntity>[...ethereumTransactionList, ...solanaTransactionList];
      } finally {
        ethereumQuery.close();
        solanaQuery.close();
      }
    });
  }

  Future<int> save(ATransactionEntity transactionEntity) async {
    return objectBoxDatabaseManager.perform((Store store) {
      return store.runInTransaction(TxMode.write, () {
        if (transactionEntity is EthereumTransactionEntity) {
          return store.box<EthereumTransactionEntity>().put(transactionEntity);
        } else if (transactionEntity is SolanaTransactionEntity) {
          return store.box<SolanaTransactionEntity>().put(transactionEntity);
        } else {
          throw UnsupportedError('Unsupported transaction type: ${transactionEntity.runtimeType}');
        }
      });
    });
  }

  Future<void> deleteAll(List<ATransactionEntity> txEntityList) async {
    objectBoxDatabaseManager.perform((Store store) {
      store.runInTransaction(TxMode.write, () {
        List<int> ethereumTransactionIdList = txEntityList.whereType<EthereumTransactionEntity>().map((EthereumTransactionEntity e) => e.id).toList();
        List<int> solanaTransactionIdList = txEntityList.whereType<SolanaTransactionEntity>().map((SolanaTransactionEntity e) => e.id).toList();

        if (ethereumTransactionIdList.isNotEmpty) {
          store.box<EthereumTransactionEntity>().removeMany(ethereumTransactionIdList);
        }
        if (solanaTransactionIdList.isNotEmpty) {
          store.box<SolanaTransactionEntity>().removeMany(solanaTransactionIdList);
        }
      });
    });
  }

  Future<void> deleteByWallet(int walletId) async {
    objectBoxDatabaseManager.perform((Store store) {
      Query<EthereumTransactionEntity> ethereumQuery = store
          .box<EthereumTransactionEntity>()
          .query(
            EthereumTransactionEntity_.walletId.equals(walletId),
          )
          .build();
      Query<SolanaTransactionEntity> solanaQuery = store
          .box<SolanaTransactionEntity>()
          .query(
            SolanaTransactionEntity_.walletId.equals(walletId),
          )
          .build();

      try {
        List<int> ethereumIds = ethereumQuery.findIds();
        List<int> solanaIds = solanaQuery.findIds();

        store.runInTransaction(TxMode.write, () {
          if (ethereumIds.isNotEmpty) {
            store.box<EthereumTransactionEntity>().removeMany(ethereumIds);
          }
          if (solanaIds.isNotEmpty) {
            store.box<SolanaTransactionEntity>().removeMany(solanaIds);
          }
        });
      } finally {
        ethereumQuery.close();
        solanaQuery.close();
      }
    });
  }
}
