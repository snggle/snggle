import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class ActiveWalletController extends ChangeNotifier {
  VoidCallback? _transactionSignedCallback;
  WalletModel? _walletModel;

  ActiveWalletController() : super();

  void notifyTransactionSigned() {
    _transactionSignedCallback?.call();
  }

  void setActiveWallet({required WalletModel walletModel, VoidCallback? transactionSignedCallback}) {
    _walletModel = walletModel;
    _transactionSignedCallback = transactionSignedCallback;
    notifyListeners();
  }

  void clearActiveWallet() {
    _walletModel = null;
    _transactionSignedCallback = null;
    notifyListeners();
  }

  bool get hasActiveWallet => walletModel != null;

  WalletModel? get walletModel => _walletModel;
}
