import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:snuggle/shared/model/mnemonic_model.dart';

class Bip39 {
  static MnemonicModel generateMnemonic() {
    String mnemonicString = bip39.generateMnemonic(strength: 256);
    return MnemonicModel.fromString(mnemonicString);
  }

  static Future<Uint8List> mnemonicToSeed({
    required String mnemonic,
    String passphrase = '',
  }) async {
    return compute(_mnemonicToSeed, <String>[mnemonic, passphrase]);
  }

  // This function is executed in a separate isolate
  static Future<Uint8List> _mnemonicToSeed(List<String> props) async {
    assert(props.length == 2, 'Using multithreading mnemonicToSeed requires 2 arguments');
    return bip39.mnemonicToSeed(props[0], passphrase: props[1]);
  }
}
