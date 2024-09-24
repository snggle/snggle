import 'package:equatable/equatable.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_export_type.dart';

class WalletConnectPageState extends Equatable {
  final WalletExportType walletExportType;

  const WalletConnectPageState({
    this.walletExportType = WalletExportType.qr,
  });

  @override
  List<Object?> get props => <Object?>[walletExportType];
}
