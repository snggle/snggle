import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/entity/vaults/vault_unsafe_secrets_entity.dart';
import 'package:snuggle/shared/models/vaults/i_vault_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_safe_secrets_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';

class VaultUnsafeSecretsModel extends Equatable implements IVaultSecretsModel {
  final Uint8List seed;

  const VaultUnsafeSecretsModel({
    required this.seed,
  });

  @override
  VaultSafeSecretsModel encrypt(String password) {
    VaultUnsafeSecretsEntity vaultUnsafeSecretsEntity = mapToEntity();
    Map<String, dynamic> secretsJson = vaultUnsafeSecretsEntity.toJson();
    
    String secretsJsonString = jsonEncode(secretsJson);
    String hash = Aes256.encrypt(password, secretsJsonString);
    VaultSafeSecretsModel vaultSafeSecretsModel = VaultSafeSecretsModel(hash: hash);
    return vaultSafeSecretsModel;
  }

  @override
  VaultUnsafeSecretsEntity mapToEntity() {
    return VaultUnsafeSecretsEntity(
      seed: seed,
    );
  }


  @override
  List<Object?> get props => <Object>[seed];
}
