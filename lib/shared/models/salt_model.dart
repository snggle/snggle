import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

class SaltModel {
  final bool isDefaultPassword;
  final String value;

  SaltModel({
    required this.isDefaultPassword,
    required this.value,
  });

  // This method only used for authentication. Authentication into App, Vault, Wallet and more.
  // Method is called for setting up a new password.
  // Randomness is introduced via SHA256, and mnemonic which offers 2^256 different combinations.

  static Future<SaltModel> generateSalt({required String password, required bool isDefaultPassword}) async {
    List<int> passwordBytes = utf8.encode(password);
    String hashedPassword = sha256.convert(passwordBytes).toString();

    MnemonicModel mnemonicModel = MnemonicModel.generate();
    Uint8List mnemonicSeed = await mnemonicModel.calculateSeed();
    Digest hashedMnemonic = sha256.convert(mnemonicSeed);

    String saltString = Aes256.encrypt(hashedPassword, hashedMnemonic.toString());
    SaltModel saltModel = SaltModel(value: saltString, isDefaultPassword: isDefaultPassword);
    return saltModel;
  }
}
