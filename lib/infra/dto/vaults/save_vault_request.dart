import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/entity/vaults/vault_entity.dart';
import 'package:snuggle/shared/models/vaults/i_vault_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_model.dart';

class SaveVaultRequest extends Equatable {
  final String uuid;
  final String name;
  final IVaultSecretsModel vaultSecretsModel;

  const SaveVaultRequest({
    required this.uuid,
    required this.name,
    required this.vaultSecretsModel,
  });
  
  factory SaveVaultRequest.fromVaultModel(VaultModel vaultModel) {
    return SaveVaultRequest(
      uuid: vaultModel.uuid,
      name: vaultModel.name,
      vaultSecretsModel: vaultModel.vaultSecretsModel,
    );
  }

  VaultEntity mapToEntity() {
    return VaultEntity(
      uuid: uuid,
      name: name,
      vaultSecretsEntity: vaultSecretsModel.mapToEntity(),
    );
  }

  @override
  List<Object?> get props => <Object>[uuid, name, vaultSecretsModel];
}
