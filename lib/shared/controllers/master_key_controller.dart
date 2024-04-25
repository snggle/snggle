import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

class MasterKeyController {
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  PasswordModel? _masterKeyPasswordModel;

  void setPassword(PasswordModel passwordModel) {
    _masterKeyPasswordModel = passwordModel;
  }

  Future<String> encrypt(String plaintextValue) async {
    if (_masterKeyPasswordModel == null) {
      throw Exception('[MasterKeyController] does not contain password which is required to encrypt data with MasterKey');
    }

    if (plaintextValue.isEmpty) {
      throw const FormatException('Provided [plaintextValue] is empty. AES256 encryption does not support empty strings');
    }

    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();

    String encryptedValue = masterKeyVO.encrypt(appPasswordModel: _masterKeyPasswordModel!, decryptedData: plaintextValue);
    return encryptedValue;
  }

  Future<String> decrypt(String encryptedValue) async {
    if (_masterKeyPasswordModel == null) {
      throw Exception('[MasterKeyController] does not contain password which is required to decrypt data with MasterKey');
    }

    if (encryptedValue.isEmpty) {
      throw const FormatException('Provided [plaintextValue] is empty. AES256 encryption does not support empty strings');
    }

    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
    String decryptedValue = masterKeyVO.decrypt(appPasswordModel: _masterKeyPasswordModel!, encryptedData: encryptedValue);
    return decryptedValue;
  }
}
