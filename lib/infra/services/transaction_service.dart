import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/transaction_entity/transaction_entity.dart';
import 'package:snggle/infra/repositories/transactions_repository.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';

class TransactionsService {
  final TransactionsRepository _transactionsRepository = globalLocator<TransactionsRepository>();

  Future<List<TransactionModel>> getByWallet(int walletId) async {
    List<TransactionEntity> transactionEntity = await _transactionsRepository.getByWallet(walletId);
    return transactionEntity.map(TransactionModel.fromEntity).toList();
  }

  Future<void> save(TransactionModel transactionModel) async {
    TransactionEntity transactionEntity = transactionModel.toEntity();
    await _transactionsRepository.save(transactionEntity);
  }

  Future<void> deleteAll(List<TransactionModel> transactions) async {
    List<TransactionEntity> transactionEntities = transactions.map((TransactionModel transactionModel) => transactionModel.toEntity()).toList();
    await _transactionsRepository.deleteAll(transactionEntities);
  }

  Future<void> deleteByWallet(int walletId) async {
    await _transactionsRepository.deleteByWallet(walletId);
  }
}
