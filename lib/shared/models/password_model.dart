import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/i_password_model.dart';
import 'package:snggle/shared/models/multi_password_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

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
  String encrypt({required String decryptedData}) {
    return Aes256.encrypt(_hashedPassword, decryptedData);
  }

  @override
  String decrypt({required String encryptedData}) {
    bool passwordValidBool = isValidForData(encryptedData);
    if (passwordValidBool == false) {
      throw InvalidPasswordException();
    }
    return Aes256.decrypt(_hashedPassword, encryptedData);
  }

  @override
  bool isValidForData(String encryptedData) {
    return Aes256.isPasswordValid(_hashedPassword, encryptedData);
  }

  @override
  List<Object> get props => <Object>[sha256.convert(_hashedPassword.codeUnits).toString()];
}
