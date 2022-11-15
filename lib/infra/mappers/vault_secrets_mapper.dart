import 'package:snuggle/infra/dao/vault/a_vault_secrets_dao.dart';
import 'package:snuggle/infra/dao/vault/vault_decrypted_secrets_dao.dart';
import 'package:snuggle/infra/dao/vault/vault_encrypted_secrets_dao.dart';
import 'package:snuggle/shared/models/vaults/a_vault_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_decrypted_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_encrypted_secrets_model.dart';

class VaultSecretsMapper {
  static AVaultSecretsDao mapVaultSecretsModelToDao(AVaultSecretsModel vaultSecretsModel) {
    if( vaultSecretsModel is VaultEncryptedSecretsModel ) {
      return VaultEncryptedSecretsDao(
        hash: vaultSecretsModel.hash,
      );
    } else if( vaultSecretsModel is VaultDecryptedSecretsModel ) {
      return VaultDecryptedSecretsDao(
        seed: vaultSecretsModel.seed,
      );
    } else {
      throw Exception('Unknown AVaultsSecretsModel type');
    }
  }
  
  static AVaultSecretsModel mapVaultSecretsDaoToModel(AVaultSecretsDao vaultSecretsDao) {
    if( vaultSecretsDao is VaultEncryptedSecretsDao ) {
      return VaultEncryptedSecretsModel(
        hash: vaultSecretsDao.hash,
      );
    } else if( vaultSecretsDao is VaultDecryptedSecretsDao) {
      return VaultDecryptedSecretsModel(
        seed: vaultSecretsDao.seed,
      );
    } else {
      throw Exception('Unknown AVaultsSecretsDao type');
    }
  }
}