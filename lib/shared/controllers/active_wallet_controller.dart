import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class ActiveWalletController extends ChangeNotifier {
  VoidCallback? _transactionSignedCallback;
  WalletModel? _walletModel;
  PasswordModel? _walletPasswordModel;

  ActiveWalletController() : super();

  void notifyTransactionSigned() {
    _transactionSignedCallback?.call();
  }

  void setActiveWallet({required WalletModel walletModel, required PasswordModel walletPasswordModel, VoidCallback? transactionSignedCallback}) {
    _walletModel = walletModel;
    _walletPasswordModel = walletPasswordModel;
    _transactionSignedCallback = transactionSignedCallback;
    notifyListeners();
  }

  void clearActiveWallet() {
    _walletModel = null;
    _walletPasswordModel = null;
    _transactionSignedCallback = null;
    notifyListeners();
  }

  bool get hasActiveWallet => walletModel != null;

  WalletModel? get walletModel => _walletModel;

  PasswordModel? get walletPasswordModel => _walletPasswordModel;
}
