import 'package:snuggle/shared/models/wallet/a_wallet_secrets_model.dart';

class WalletEncryptedSecretsModel extends AWalletSecretsModel {
  final String hash;

  WalletEncryptedSecretsModel({
    required this.hash,
  });
}