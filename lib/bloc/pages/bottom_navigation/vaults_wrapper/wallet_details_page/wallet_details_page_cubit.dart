import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletDetailsPageCubit extends Cubit<WalletDetailsPageState> {
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();

  final WalletModel _walletModel;

  WalletDetailsPageCubit({
    required WalletModel walletModel,
  })  : _walletModel = walletModel,
        super(const WalletDetailsPageState.loading());

  Future<void> refresh() async {
    List<TransactionModel> transactions = await _transactionsService.getByWallet(_walletModel.id);
    emit(WalletDetailsPageState(transactions: transactions..sort((TransactionModel a, TransactionModel b) => b.creationDate.compareTo(a.creationDate))));
  }

  Future<void> deleteSelected() async {
    List<TransactionModel> allTransactions = state.transactions;
    List<TransactionModel> selectedTransactions = state.selectedTransactions;

    await _transactionsService.deleteAll(selectedTransactions);

    allTransactions.removeWhere((TransactionModel transactionModel) => selectedTransactions.contains(transactionModel));
    emit(state.copyWith(forceOverrideBool: true, transactions: allTransactions, selectionModel: null));
  }

  void toggleSelection(TransactionModel transactionModel) {
    if (state.selectionModel == null) {
      select(transactionModel);
    } else {
      if (state.selectionModel!.selectedItems.contains(transactionModel)) {
        unselect(transactionModel);
      } else {
        select(transactionModel);
      }
    }
  }

  void select(TransactionModel transactionModel) {
    int allTransactionsCount = state.transactions.length;

    List<TransactionModel> selectedItems = List<TransactionModel>.from(state.selectedTransactions, growable: true)..add(transactionModel);
    emit(state.copyWith(selectionModel: SimpleSelectionModel<TransactionModel>(selectedItems: selectedItems, allItemsCount: allTransactionsCount)));
  }

  void selectAll() {
    int allTransactionsCount = state.transactions.length;
    emit(state.copyWith(
      selectionModel: SimpleSelectionModel<TransactionModel>(
        allItemsCount: allTransactionsCount,
        selectedItems: state.transactions,
      ),
    ));
  }

  void unselectAll() {
    int allTransactionsCount = state.transactions.length;
    emit(state.copyWith(
      selectionModel: SimpleSelectionModel<TransactionModel>.empty(allItemsCount: allTransactionsCount),
    ));
  }

  void unselect(TransactionModel transactionModel) {
    int allTransactionsCount = state.transactions.length;

    List<TransactionModel> selectedItems = List<TransactionModel>.from(state.selectedTransactions, growable: true)..remove(transactionModel);
    emit(state.copyWith(selectionModel: SimpleSelectionModel<TransactionModel>(selectedItems: selectedItems, allItemsCount: allTransactionsCount)));
  }

  void disableSelection() {
    emit(state.copyWith(forceOverrideBool: true, selectionModel: null));
  }
}
