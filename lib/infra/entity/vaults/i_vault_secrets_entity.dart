import 'package:snuggle/infra/entity/vaults/vault_safe_secrets_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_unsafe_secrets_entity.dart';
import 'package:snuggle/shared/models/secrets_type.dart';
import 'package:snuggle/shared/models/vaults/i_vault_secrets_model.dart';
import 'package:snuggle/shared/utils/enum_utils.dart';

abstract class IVaultSecretsEntity {
  static IVaultSecretsEntity fromJson(Map<String, dynamic> json) {
    String jsonType = json['type'] as String;
    final SecretsType secretsType = EnumUtils.parseFromString(SecretsType.values, jsonType);

    switch (secretsType) {
      case SecretsType.decrypted:
        return VaultUnsafeSecretsEntity.fromJson(json);
      case SecretsType.encrypted:
        return VaultSafeSecretsEntity.fromJson(json);
    }
  }

  IVaultSecretsModel mapToModel();
  
  Map<String, dynamic> toJson();

  SecretsType get type;
}
