import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';

class Bip39 {
  static MnemonicModel generateMnemonic() {
    String mnemonicString = bip39.generateMnemonic(strength: 256);
    return MnemonicModel.fromString(mnemonicString);
  }

  static Future<Uint8List> mnemonicToSeed({
    required String mnemonic,
    String passphrase = '',
  }) async {
    return compute(_Bip39Thread.mnemonicToSeedThread, <String>[mnemonic, passphrase]);
  }
}

// TODO(dominik): Multi class file?
class _Bip39Thread {
  static Future<Uint8List> mnemonicToSeedThread(List<String> props) async {
    assert(props.length == 2, 'Using multithreading mnemonicToSeed requires 2 arguments');
    return bip39.mnemonicToSeed(props[0], passphrase: props[1]);
  }
}
