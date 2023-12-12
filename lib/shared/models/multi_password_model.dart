import 'package:crypto/crypto.dart';
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
  String encrypt({required String decryptedData}) {
    String encryptedData = decryptedData;
    for (PasswordModel passwordModel in _mergedPasswords.reversed) {
      encryptedData = passwordModel.encrypt(decryptedData: encryptedData);
    }
    return encryptedData;
  }

  @override
  String decrypt({required String encryptedData}) {
    String decryptedData = encryptedData;
    for (int i = 0; i < _mergedPasswords.length; i++) {
      PasswordModel passwordModel = _mergedPasswords[i];
      if (passwordModel.isValidForData(decryptedData) == false) {
        throw InvalidPasswordException('Password ${i + 1}/${_mergedPasswords.length} is invalid');
      }
      decryptedData = passwordModel.decrypt(encryptedData: decryptedData);
    }
    return decryptedData;
  }

  @override
  bool isValidForData(String encryptedData) {
    try {
      decrypt(encryptedData: encryptedData);
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
