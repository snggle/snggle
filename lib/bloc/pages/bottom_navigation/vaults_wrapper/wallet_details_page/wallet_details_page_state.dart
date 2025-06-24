import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/simple_selection_model.dart';
import 'package:snggle/shared/models/transactions/a_transaction_model.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';

class WalletDetailsPageState extends Equatable {
  final List<ATransactionModel> transactions;
  final bool loadingBool;
  final SimpleSelectionModel<ATransactionModel>? selectionModel;

  const WalletDetailsPageState({
    required this.transactions,
    this.selectionModel,
    this.loadingBool = false,
  });

  const WalletDetailsPageState.loading()
      : transactions = const <ATransactionModel>[],
        loadingBool = true,
        selectionModel = null;

  WalletDetailsPageState copyWith({
    bool forceOverrideBool = false,
    List<ATransactionModel>? transactions,
    SimpleSelectionModel<ATransactionModel>? selectionModel,
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

  List<ATransactionModel> get selectedTransactions {
    return selectionModel?.selectedItems ?? <ATransactionModel>[];
  }

  @override
  List<Object?> get props {
    return <Object?>[loadingBool, transactions, selectionModel.hashCode];
  }
}
