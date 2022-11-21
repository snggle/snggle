import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/entity/i_collection_entity.dart';
import 'package:snuggle/infra/entity/vaults/i_vault_secrets_entity.dart';
import 'package:snuggle/shared/models/vaults/vault_model.dart';

class VaultEntity extends Equatable implements ICollectionEntity {
  final String uuid;
  final String name;
  final IVaultSecretsEntity vaultSecretsEntity;

  const VaultEntity({
    required this.uuid,
    required this.name,
    required this.vaultSecretsEntity,
  });
  
  factory VaultEntity.fromJson(Map<String, dynamic> json) {
    return VaultEntity(
      uuid: json['id'] as String,
      name: json['name'] as String,
      vaultSecretsEntity: IVaultSecretsEntity.fromJson(json['secrets'] as Map<String, dynamic>),
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': uuid,
      'name': name,
      'secrets': vaultSecretsEntity.toJson(),
    };
  }
  
  VaultModel mapToModel() {
    return VaultModel(
      uuid: uuid,
      name: name,
      vaultSecretsModel: vaultSecretsEntity.mapToModel(),
    );
  }
  
  @override
  List<Object?> get props => <Object>[uuid, name, vaultSecretsEntity];
}
