import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/entity/vaults/vault_safe_secrets_entity.dart';
import 'package:snuggle/infra/entity/vaults/vault_unsafe_secrets_entity.dart';
import 'package:snuggle/shared/models/vaults/i_vault_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_unsafe_secrets_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';

class VaultSafeSecretsModel extends Equatable implements IVaultSecretsModel {
  final String hash;

  const VaultSafeSecretsModel({
    required this.hash,
  });

  @override
  VaultSafeSecretsModel encrypt(String password) {
    VaultSafeSecretsModel vaultSafeSecretsModel = VaultSafeSecretsModel(
      hash: Aes256.encrypt(password, hash),
    );
    return vaultSafeSecretsModel;
  }

  VaultUnsafeSecretsModel decrypt(String password) {
    try {
      String decryptedHash = Aes256.decrypt(password, hash);
      Map<String, dynamic> decryptedHashJson = jsonDecode(decryptedHash) as Map<String, dynamic>;
      VaultUnsafeSecretsEntity vaultUnsafeSecretsEntity = VaultUnsafeSecretsEntity.fromJson(decryptedHashJson);
      return vaultUnsafeSecretsEntity.mapToModel();
    } catch (_) {
      throw Exception('Invalid password');
    }
  }

  @override
  VaultSafeSecretsEntity mapToEntity() {
    return VaultSafeSecretsEntity(
      hash: hash,
    );
  }

  @override
  List<Object?> get props => <Object>[hash];
}
