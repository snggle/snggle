import 'package:snuggle/infra/entity/vaults/i_vault_secrets_entity.dart';
import 'package:snuggle/shared/models/vaults/vault_safe_secrets_model.dart';

abstract class IVaultSecretsModel {
  VaultSafeSecretsModel encrypt(String password);

  IVaultSecretsEntity mapToEntity();
}