import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';

class WalletDetailsPageState extends Equatable {
  final List<TransactionModel> transactions;
  final bool loadingBool;
  final SimpleSelectionModel<TransactionModel>? selectionModel;

  const WalletDetailsPageState({
    required this.transactions,
    this.selectionModel,
    this.loadingBool = false,
  });

  const WalletDetailsPageState.loading()
      : transactions = const <TransactionModel>[],
        loadingBool = true,
        selectionModel = null;

  WalletDetailsPageState copyWith({
    bool forceOverrideBool = false,
    List<TransactionModel>? transactions,
    SimpleSelectionModel<TransactionModel>? selectionModel,
  }) {
    return WalletDetailsPageState(
      transactions: transactions ?? this.transactions,
      selectionModel: forceOverrideBool ? selectionModel : selectionModel ?? this.selectionModel,
    );
  }

  bool get isSelectionEnabled {
    return selectionModel != null;
  }

  bool get isScrollDisabled {
    return isEmpty || loadingBool;
  }

  bool get isEmpty {
    return transactions.isEmpty;
  }

  List<TransactionModel> get selectedTransactions {
    return selectionModel?.selectedItems ?? <TransactionModel>[];
  }

  @override
  List<Object?> get props {
    return <Object?>[loadingBool, transactions, selectionModel.hashCode];
  }
}
