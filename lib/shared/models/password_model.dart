import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/i_password_model.dart';
import 'package:snggle/shared/models/multi_password_model.dart';

class PasswordModel extends Equatable implements IPasswordModel {
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

  @override
  MultiPasswordModel extend(PasswordModel passwordModel) {
    return MultiPasswordModel(
      mainPasswordModel: passwordModel,
      parentPasswordModels: <PasswordModel>[this],
    );
  }

  @override
  Ciphertext encrypt({required String decryptedData}) {
    return AESDHKEV1().encrypt(_hashedPassword, decryptedData);
  }

  @override
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

  @override
  bool isValidForData(Ciphertext ciphertext) {
    if (ciphertext.encryptionAlgorithmType != EncryptionAlgorithmType.aesdhke) {
      throw const FormatException('Invalid encryption algorithm type');
    }

    return AESDHKEV1().isPasswordValid(_hashedPassword, ciphertext);
  }

  @override
  List<Object> get props => <Object>[sha256.convert(_hashedPassword.codeUnits).toString()];
}
