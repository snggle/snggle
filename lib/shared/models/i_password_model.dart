import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/shared/models/multi_password_model.dart';
import 'package:snggle/shared/models/password_model.dart';

abstract interface class IPasswordModel {
  MultiPasswordModel extend(PasswordModel passwordModel);

  Ciphertext encrypt({required String decryptedData});

  String decrypt({required Ciphertext ciphertext});

  bool isValidForData(Ciphertext ciphertext);
}