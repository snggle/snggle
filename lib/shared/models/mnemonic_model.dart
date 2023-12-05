import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MnemonicModel extends Equatable {
  final List<String> mnemonicList;

  const MnemonicModel(this.mnemonicList);

  factory MnemonicModel.generate() {
    String mnemonicString = bip39.generateMnemonic(strength: 256);
    return MnemonicModel.fromString(mnemonicString);
  }

  MnemonicModel.fromString(String mnemonicString, {String delimiter = ' '}) : mnemonicList = mnemonicString.split(delimiter);

  Future<Uint8List> calculateSeed({String passphrase = ''}) async {
    return compute(_computeMnemonicSeed, <String>[toString(), passphrase]);
  }

  bool get isValid => bip39.validateMnemonic(toString());

  @override
  String toString() {
    return mnemonicList.join(' ');
  }

  @override
  List<Object?> get props => <Object>[mnemonicList];
}

// This function is executed in a separated isolate, so it should be declared as a top-level function
Future<Uint8List> _computeMnemonicSeed(List<String> props) async {
  assert(props.length == 2, 'Using [_computeMnemonicSeed] method require list with two values <String>[mnemonic, passphrase]');
  return bip39.mnemonicToSeed(props[0], passphrase: props[1]);
}
