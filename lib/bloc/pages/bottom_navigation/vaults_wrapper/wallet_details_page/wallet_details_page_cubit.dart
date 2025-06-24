import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_details_page/wallet_details_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletDetailsPageCubit extends Cubit<WalletDetailsPageState> {
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();

  final WalletModel _walletModel;

  WalletDetailsPageCubit({
    required WalletModel walletModel,
  })  : _walletModel = walletModel,
        super(const WalletDetailsPageState.loading());

  Future<void> refresh() async {
    List<ATransactionModel> transactions = await _transactionsService.getByWallet(_walletModel.id);
    emit(WalletDetailsPageState(transactions: transactions..sort((ATransactionModel a, ATransactionModel b) => b.creationDate.compareTo(a.creationDate))));
  }

  Future<void> deleteSelected() async {
    List<ATransactionModel> allTransactions = state.transactions;
    List<ATransactionModel> selectedTransactions = state.selectedTransactions;

    await _transactionsService.deleteAll(selectedTransactions);

    allTransactions.removeWhere((ATransactionModel transactionModel) => selectedTransactions.contains(transactionModel));
    emit(state.copyWith(forceOverrideBool: true, transactions: allTransactions, selectionModel: null));
  }

  void toggleSelection(ATransactionModel transactionModel) {
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

  void select(ATransactionModel transactionModel) {
    int allTransactionsCount = state.transactions.length;

    List<ATransactionModel> selectedItems = List<ATransactionModel>.from(state.selectedTransactions, growable: true)..add(transactionModel);
    emit(state.copyWith(selectionModel: SimpleSelectionModel<ATransactionModel>(selectedItems: selectedItems, allItemsCount: allTransactionsCount)));
  }

  void selectAll() {
    int allTransactionsCount = state.transactions.length;
    emit(state.copyWith(
      selectionModel: SimpleSelectionModel<ATransactionModel>(
        allItemsCount: allTransactionsCount,
        selectedItems: state.transactions,
      ),
    ));
  }

  void unselectAll() {
    int allTransactionsCount = state.transactions.length;
    emit(state.copyWith(
      selectionModel: SimpleSelectionModel<ATransactionModel>.empty(allItemsCount: allTransactionsCount),
    ));
  }

  void unselect(ATransactionModel transactionModel) {
    int allTransactionsCount = state.transactions.length;

    List<ATransactionModel> selectedItems = List<ATransactionModel>.from(state.selectedTransactions, growable: true)..remove(transactionModel);
    emit(state.copyWith(selectionModel: SimpleSelectionModel<ATransactionModel>(selectedItems: selectedItems, allItemsCount: allTransactionsCount)));
  }

  void disableSelection() {
    emit(state.copyWith(forceOverrideBool: true, selectionModel: null));
  }
}
