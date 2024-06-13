import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class ActiveWalletController extends ChangeNotifier {
  WalletModel? _walletModel;
  PasswordModel? _walletPasswordModel;

  ActiveWalletController() : super();

  void setActiveWallet({required WalletModel walletModel, required PasswordModel walletPasswordModel}) {
    _walletModel = walletModel;
    _walletPasswordModel = walletPasswordModel;
    notifyListeners();
  }

  void clearActiveWallet() {
    _walletModel = null;
    _walletPasswordModel = null;
    notifyListeners();
  }

  bool get hasActiveWallet => walletModel != null;

  WalletModel? get walletModel => _walletModel;

  PasswordModel? get walletPasswordModel => _walletPasswordModel;
}
