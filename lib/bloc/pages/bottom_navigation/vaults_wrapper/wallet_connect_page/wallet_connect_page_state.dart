import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/wallets/wallet_connect_option.dart';

class WalletConnectPageState extends Equatable {
  final WalletConnectOption walletConnectOption;

  const WalletConnectPageState({
    this.walletConnectOption = WalletConnectOption.qr,
  });

  @override
  List<Object?> get props => <Object?>[walletConnectOption];
}
