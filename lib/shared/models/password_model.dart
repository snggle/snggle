import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';

class PasswordModel extends Equatable {
  final String _hashedPassword;

  const PasswordModel({required String hashedPassword}) : _hashedPassword = hashedPassword;

  factory PasswordModel.fromPlaintext(String plaintextPassword) {
    List<int> hashedPasswordBytes = Sha256().convert(plaintextPassword.codeUnits).byteList;
    String hashedPassword = base64.encode(hashedPasswordBytes);
    return PasswordModel(hashedPassword: hashedPassword);
  }

  factory PasswordModel.defaultPassword() {
    return PasswordModel.fromPlaintext(AppConfig.defaultPassword);
  }

  static bool isEncryptedWithCustomPassword(String encryptedData) {
    PasswordModel defaultPasswordModel = PasswordModel.defaultPassword();
    bool defaultPasswordBool = defaultPasswordModel.isValidForData(encryptedData);
    return defaultPasswordBool == false;
  }

  String encrypt({required String decryptedData}) {
    return AES256Randomized.encrypt(_hashedPassword, decryptedData);
  }

  String decrypt({required String encryptedData}) {
    bool passwordValidBool = isValidForData(encryptedData);
    if (passwordValidBool == false) {
      throw InvalidPasswordException();
    }

    return AES256Randomized.decrypt(_hashedPassword, encryptedData);
  }

  bool isValidForData(String encryptedData) {
    return AES256Randomized.isPasswordValid(_hashedPassword, encryptedData);
  }

  @override
  List<Object> get props => <Object>[_hashedPassword];
}
