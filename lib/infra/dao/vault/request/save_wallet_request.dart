import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/dao/wallet/wallet_dao.dart';

class SaveWalletRequest extends Equatable {
  final String vaultId;
  final WalletDao walletDao;

  const SaveWalletRequest({
    required this.vaultId,
    required this.walletDao,
  });
  
  @override
  List<Object?> get props => <Object>[vaultId, walletDao];
}
