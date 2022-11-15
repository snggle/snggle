import 'package:snuggle/infra/dao/wallet/a_wallet_secrets_dao.dart';
import 'package:snuggle/infra/dao/wallet/wallet_decrypted_secrets_dao.dart';
import 'package:snuggle/infra/dao/wallet/wallet_encrypted_secrets_dao.dart';
import 'package:snuggle/shared/models/wallet/a_wallet_secrets_model.dart';
import 'package:snuggle/shared/models/wallet/wallet_decrypted_secrets_model.dart';
import 'package:snuggle/shared/models/wallet/wallet_encrypted_secrets_model.dart';

class WalletSecretsMapper {
  static AWalletSecretsDao mapWalletSecretsModelToDao(AWalletSecretsModel walletSecretsModel) {
    if( walletSecretsModel is WalletEncryptedSecretsModel ) {
      return WalletEncryptedSecretsDao(
        hash: walletSecretsModel.hash,
      );
    } else if( walletSecretsModel is WalletDecryptedSecretsModel ) {
      return WalletDecryptedSecretsDao(
        privateKey: walletSecretsModel.privateKey,
      );
    } else {
      throw Exception('Unknown AWalletsSecretsModel type');
    }
  }
  
  static AWalletSecretsModel mapWalletSecretsDaoToModel(AWalletSecretsDao walletSecretsModel) {
    if( walletSecretsModel is WalletEncryptedSecretsDao ) {
      return WalletEncryptedSecretsModel(
        hash: walletSecretsModel.hash,
      );
    } else if( walletSecretsModel is WalletDecryptedSecretsDao) {
      return WalletDecryptedSecretsModel(
        privateKey: walletSecretsModel.privateKey,
      );
    } else {
      throw Exception('Unknown AWalletsSecretsDao type');
    }
  }
}