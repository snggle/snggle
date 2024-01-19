import 'package:crypto/crypto.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/i_password_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class MultiPasswordModel extends Equatable implements IPasswordModel {
  final PasswordModel _mainPasswordModel;
  final List<PasswordModel> _parentPasswordModels;

  const MultiPasswordModel({
    required PasswordModel mainPasswordModel,
    List<PasswordModel>? parentPasswordModels,
  })  : _mainPasswordModel = mainPasswordModel,
        _parentPasswordModels = parentPasswordModels ?? const <PasswordModel>[];

  factory MultiPasswordModel.fromPlaintext(String plaintextPassword) {
    PasswordModel passwordModel = PasswordModel.fromPlaintext(plaintextPassword);
    return MultiPasswordModel(mainPasswordModel: passwordModel);
  }

  factory MultiPasswordModel.defaultPassword() {
    return MultiPasswordModel.fromPlaintext(AppConfig.defaultPassword);
  }

  @override
  MultiPasswordModel extend(PasswordModel passwordModel) {
    return MultiPasswordModel(
      mainPasswordModel: passwordModel,
      parentPasswordModels: <PasswordModel>[..._parentPasswordModels, _mainPasswordModel],
    );
  }

  @override
  Ciphertext encrypt({required String decryptedData}) {
    late Ciphertext ciphertext;
    List<PasswordModel> reversedMergedPasswords = _mergedPasswords.reversed.toList();
    for (int i = 0; i < reversedMergedPasswords.length; i++) {
      PasswordModel passwordModel = reversedMergedPasswords.toList()[i];
      if (i == 0) {
        ciphertext = passwordModel.encrypt(decryptedData: decryptedData);
      } else {
        ciphertext = passwordModel.encrypt(decryptedData: ciphertext.toJsonString(prettyPrintBool: false));
      }
    }
    return ciphertext;
  }

  @override
  String decrypt({required Ciphertext ciphertext}) {
    Ciphertext decryptedCiphertext = ciphertext;
    String decryptedData = '';

    for (int i = 0; i < _mergedPasswords.length; i++) {
      PasswordModel passwordModel = _mergedPasswords[i];
      try {
        if (i < _mergedPasswords.length - 1) {
          decryptedData = passwordModel.decrypt(ciphertext: decryptedCiphertext);
          decryptedCiphertext = Ciphertext.fromJsonString(decryptedData);
        } else {
          decryptedData = passwordModel.decrypt(ciphertext: decryptedCiphertext);
        }
      } catch (e) {
        throw InvalidPasswordException('Password ${i + 1}/${_mergedPasswords.length} is invalid: $e');
      }
    }
    return decryptedData;
  }

  @override
  bool isValidForData(Ciphertext ciphertext) {
    try {
      decrypt(ciphertext: ciphertext);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<PasswordModel> get _mergedPasswords {
    return <PasswordModel>[..._parentPasswordModels, _mainPasswordModel];
  }

  @override
  List<Object> get props {
    String mergedPasswordsString = _mergedPasswords.map((PasswordModel e) => e.props).join();
    return <Object>[sha256.convert(mergedPasswordsString.codeUnits).toString()];
  }
}
