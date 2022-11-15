import 'package:snuggle/shared/models/vaults/a_vault_secrets_model.dart';

class VaultEncryptedSecretsModel extends AVaultSecretsModel {
  final String hash;

  VaultEncryptedSecretsModel({
    required this.hash,
  });
}
