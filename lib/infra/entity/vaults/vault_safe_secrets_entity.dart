import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/entity/vaults/i_vault_secrets_entity.dart';
import 'package:snuggle/shared/models/secrets_type.dart';
import 'package:snuggle/shared/models/vaults/vault_safe_secrets_model.dart';
import 'package:snuggle/shared/utils/enum_utils.dart';

class VaultSafeSecretsEntity extends Equatable implements IVaultSecretsEntity {
  final String hash;

  const VaultSafeSecretsEntity({
    required this.hash,
  });

  factory VaultSafeSecretsEntity.fromJson(Map<String, dynamic> json) {
    return VaultSafeSecretsEntity(
      hash: json['hash'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': EnumUtils.parseToString(type),
      'hash': hash,
    };
  }

  @override
  VaultSafeSecretsModel mapToModel() {
    return VaultSafeSecretsModel(
      hash: hash,
    );
  }

  @override
  SecretsType get type => SecretsType.encrypted;

  @override
  List<Object?> get props => <Object>[hash, type];
}
