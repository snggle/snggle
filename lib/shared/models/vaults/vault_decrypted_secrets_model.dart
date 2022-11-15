import 'dart:typed_data';

import 'package:snuggle/shared/models/vaults/a_vault_secrets_model.dart';

class VaultDecryptedSecretsModel extends AVaultSecretsModel {
  final Uint8List seed;

  VaultDecryptedSecretsModel({
    required this.seed,
  });
}
