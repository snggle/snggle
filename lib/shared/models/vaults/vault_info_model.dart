import 'package:snuggle/shared/models/vaults/a_vault_secrets_model.dart';

class VaultInfoModel {
  final String id;
  final String name;
  final AVaultSecretsModel vaultsSecretsModel;

  VaultInfoModel({
    required this.id,
    required this.name,
    required this.vaultsSecretsModel,
  });
}
