import 'dart:typed_data';
import 'package:bip32/bip32.dart' as bip32;
import 'package:snuggle/shared/models/mnemonic_model.dart';

class Bip32 {
  static Future<Uint8List> derivePrivateKey({
    required MnemonicModel mnemonicModel,
    required String derivationPath,
  }) async {
    Uint8List mnemonicSeed = await mnemonicModel.calculateSeed();

    // Convert the mnemonic seed to a BIP32 instance
    final bip32.BIP32 root = bip32.BIP32.fromSeed(mnemonicSeed);

    // Get the node from the derivation path
    final bip32.BIP32 derivedNode = root.derivePath(derivationPath);

    // Get the private key
    final Uint8List privateKeyBytes = derivedNode.privateKey!;
    return privateKeyBytes;
  }
}
