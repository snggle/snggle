import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/entity/vaults/i_vault_secrets_entity.dart';
import 'package:snuggle/shared/models/secrets_type.dart';
import 'package:snuggle/shared/models/vaults/vault_unsafe_secrets_model.dart';
import 'package:snuggle/shared/utils/enum_utils.dart';

class VaultUnsafeSecretsEntity extends Equatable implements IVaultSecretsEntity {
  final Uint8List seed;

  const VaultUnsafeSecretsEntity({
    required this.seed,
  });

  factory VaultUnsafeSecretsEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic> unparsedSeed = json['seed'] as List<dynamic>;
    return VaultUnsafeSecretsEntity(
      seed: Uint8List.fromList(unparsedSeed.map((dynamic e) => e as int).toList()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': EnumUtils.parseToString(type),
      'seed': seed,
    };
  }

  @override
  VaultUnsafeSecretsModel mapToModel() {
    return VaultUnsafeSecretsModel(
      seed: seed,
    );
  }

  @override
  SecretsType get type => SecretsType.decrypted;

  @override
  List<Object?> get props => <Object>[seed, type];
}
