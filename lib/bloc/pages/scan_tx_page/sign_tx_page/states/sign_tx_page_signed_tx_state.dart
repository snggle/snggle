import 'package:codec_utils/codec_utils.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';

class SignTxPageSignedTxState extends ASignTxPageState {
  final TransactionModel transactionModel;
  final CborSolSignature cborSolSignature;

  const SignTxPageSignedTxState({
    required this.transactionModel,
    required this.cborSolSignature,
  });

  @override
  List<Object?> get props => <Object?>[transactionModel, cborSolSignature];
}
