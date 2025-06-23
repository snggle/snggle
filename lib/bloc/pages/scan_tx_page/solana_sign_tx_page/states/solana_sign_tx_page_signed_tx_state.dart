import 'package:codec_utils/codec_utils.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/a_solana_sign_tx_page_state.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';

class SolanaSignTxPageSignedTxState extends ASolanaSignTxPageState {
  final TransactionModel transactionModel;
  final CborSolSignature cborSolSignature;

  const SolanaSignTxPageSignedTxState({
    required this.transactionModel,
    required this.cborSolSignature,
  });

  @override
  List<Object?> get props => <Object?>[transactionModel, cborSolSignature];
}
