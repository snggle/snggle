import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';

class PasswordModel extends Equatable {
  final String _hashedPassword;

  const PasswordModel({required String hashedPassword}) : _hashedPassword = hashedPassword;

  factory PasswordModel.fromPlaintext(String plaintextPassword) {
    List<int> hashedPasswordBytes = sha256.convert(plaintextPassword.codeUnits).bytes;
    String hashedPassword = base64.encode(hashedPasswordBytes);
    return PasswordModel(hashedPassword: hashedPassword);
  }

  factory PasswordModel.defaultPassword() {
    return PasswordModel.fromPlaintext(AppConfig.defaultPassword);
  }

  static bool isEncryptedWithCustomPassword(Ciphertext ciphertext) {
    PasswordModel defaultPasswordModel = PasswordModel.defaultPassword();
    bool defaultPasswordBool = defaultPasswordModel.isValidForData(ciphertext);
    return defaultPasswordBool == false;
  }

  Ciphertext encrypt({required String decryptedData}) {
    return AESDHKEV1().encrypt(_hashedPassword, decryptedData);
  }

  String decrypt({required Ciphertext ciphertext}) {
    if (ciphertext.encryptionAlgorithmType != EncryptionAlgorithmType.aesdhke) {
      throw const FormatException('Invalid encryption algorithm type');
    }

    bool passwordValidBool = isValidForData(ciphertext);
    if (passwordValidBool == false) {
      throw InvalidPasswordException('Cannot decrypt: ${ciphertext.base64}');
    }
    return AESDHKEV1().decrypt(_hashedPassword, ciphertext);
  }

  bool isValidForData(Ciphertext ciphertext) {
    if (ciphertext.encryptionAlgorithmType != EncryptionAlgorithmType.aesdhke) {
      throw const FormatException('Invalid encryption algorithm type');
    }

    return AESDHKEV1().isPasswordValid(_hashedPassword, ciphertext);
  }

  @override
  List<Object> get props => <Object>[_hashedPassword];
}
