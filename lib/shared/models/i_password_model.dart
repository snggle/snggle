import 'package:snggle/shared/models/multi_password_model.dart';
import 'package:snggle/shared/models/password_model.dart';

abstract interface class IPasswordModel {
  MultiPasswordModel extend(PasswordModel passwordModel);

  String encrypt({required String decryptedData});

  String decrypt({required String encryptedData});

  bool isValidForData(String encryptedData);
}