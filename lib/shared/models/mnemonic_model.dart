import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MnemonicModel extends Equatable {
  final List<String> mnemonicList;

  const MnemonicModel(this.mnemonicList);

  factory MnemonicModel.generate([MnemonicSize? mnemonicSize]) {
    Mnemonic mnemonic = Mnemonic.generate(mnemonicSize: mnemonicSize ?? MnemonicSize.words24);

    return MnemonicModel(mnemonic.mnemonicList);
  }

  MnemonicModel.fromString(String mnemonicString, {String delimiter = ' '}) : mnemonicList = mnemonicString.split(delimiter);

  Future<Uint8List> calculateSeed({String passphrase = ''}) async {
    return compute(_computeMnemonicSeed, _ComputeMnemonicSeedProps(passphrase, toString()));
  }

  bool get isValid => Mnemonic.isValidMnemonic(mnemonicList);

  @override
  String toString() {
    return mnemonicList.join(' ');
  }

  @override
  List<Object?> get props => <Object>[mnemonicList];
}

// The second class is in the file since it is used to define parameters for a separate isolate, which is a top-level function
class _ComputeMnemonicSeedProps {
  final String mnemonic;
  final String password;

  const _ComputeMnemonicSeedProps(this.mnemonic, this.password);
}

// This function is executed in a separated isolate, so it should be declared as a top-level function
Future<Uint8List> _computeMnemonicSeed(_ComputeMnemonicSeedProps computeMnemonicSeedProps) async {
  Uint8List passwordBytes = utf8.encode(computeMnemonicSeedProps.password);
  Uint8List saltBytes = utf8.encode('mnemonic${computeMnemonicSeedProps.mnemonic}');

  return PBKDF2().process(passwordBytes, saltBytes);
}
