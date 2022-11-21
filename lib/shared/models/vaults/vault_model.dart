import 'package:equatable/equatable.dart';
import 'package:snuggle/shared/models/vaults/i_vault_secrets_model.dart';
import 'package:snuggle/shared/models/vaults/vault_safe_secrets_model.dart';

class VaultModel extends Equatable {
  final String uuid;
  final String name;
  final IVaultSecretsModel vaultSecretsModel;

  const VaultModel({
    required this.uuid,
    required this.name,
    required this.vaultSecretsModel,
  });
  
  VaultModel copyWith({
    String? uuid,
    String? name,
    IVaultSecretsModel? vaultSecretsModel,
  }) {
    return VaultModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      vaultSecretsModel: vaultSecretsModel ?? this.vaultSecretsModel,
    );
  }
  
  bool get encrypted => vaultSecretsModel is VaultSafeSecretsModel;
  
  @override
  List<Object?> get props => <Object>[uuid, name, vaultSecretsModel];
}
