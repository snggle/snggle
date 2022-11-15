import 'package:snuggle/infra/dao/wallet/a_wallet_secrets_dao.dart';
import 'package:snuggle/shared/models/address_model.dart';
import 'package:snuggle/shared/models/vaults/vault_info_model.dart';
import 'package:snuggle/shared/models/wallet/a_wallet_secrets_model.dart';

class WalletModel {
  final String id;
  final String name;
  final AddressModel addressModel;
  final VaultInfoModel parentVaultInfoModel;
  final AWalletSecretsModel walletSecretsModel;

  WalletModel({
    required this.id,
    required this.name,
    required this.addressModel,
    required this.parentVaultInfoModel,
    required this.walletSecretsModel,
  });
}
