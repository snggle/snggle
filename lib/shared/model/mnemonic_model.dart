import 'dart:typed_data';

import 'package:snuggle/shared/utils/crypto/bip39.dart';

class MnemonicModel {
  final List<String> mnemonicArray;

  Uint8List? _seed;

  MnemonicModel(this.mnemonicArray);

  MnemonicModel.fromString(String mnemonicString, {String delimiter = ' '}) : mnemonicArray = mnemonicString.split(delimiter);

  String get value => mnemonicArray.join(' ');

  Future<Uint8List> calculateSeed() async {
    if (_seed != null) {
      return _seed!;
    } else {
      return Bip39.mnemonicToSeed(mnemonic: value);
    }
  }
}
