import 'dart:typed_data';

import 'package:snuggle/shared/models/wallet/a_wallet_secrets_model.dart';

class WalletDecryptedSecretsModel extends AWalletSecretsModel {
  final Uint8List privateKey;

  WalletDecryptedSecretsModel({
    required this.privateKey,
  });
}
