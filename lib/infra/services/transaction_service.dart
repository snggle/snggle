import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/infra/repositories/transactions_repository.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';

class TransactionsService {
  final TransactionsRepository _transactionsRepository = globalLocator<TransactionsRepository>();

  Future<List<ATransactionModel>> getByWallet(int walletId) async {
    List<TransactionEntity> transactionEntity = await _transactionsRepository.getByWallet(walletId);
    return transactionEntity.map(ATransactionModel.fromEntity).toList();
  }

  Future<void> save(ATransactionModel transactionModel) async {
    TransactionEntity transactionEntity = transactionModel.toEntity();
    await _transactionsRepository.save(transactionEntity);
  }

  Future<void> deleteAll(List<ATransactionModel> transactions) async {
    List<TransactionEntity> transactionEntities = transactions.map((ATransactionModel transactionModel) => transactionModel.toEntity()).toList();
    await _transactionsRepository.deleteAll(transactionEntities);
  }

  Future<void> deleteByWallet(int walletId) async {
    await _transactionsRepository.deleteByWallet(walletId);
  }
}
