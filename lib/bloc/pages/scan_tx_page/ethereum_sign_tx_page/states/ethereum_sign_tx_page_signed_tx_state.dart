import 'package:codec_utils/codec_utils.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/a_ethereum_sign_tx_page_state.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';

class EthereumSignTxPageSignedTxState extends AEthereumSignTxPageState {
  final EthereumTransactionModel transactionModel;
  final CborEthSignature cborEthSignature;

  const EthereumSignTxPageSignedTxState({
    required this.transactionModel,
    required this.cborEthSignature,
  });

  @override
  List<Object?> get props => <Object?>[transactionModel, cborEthSignature];
}
