import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

class AppAuthService {
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();

  Future<bool> isCustomPasswordSet() async {
    bool masterKeyExistsBool = await _masterKeyService.isMasterKeyExists();
    if (masterKeyExistsBool) {
      MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
      return PasswordModel.isEncryptedWithCustomPassword(masterKeyVO.masterKeyCiphertext);
    } else {
      return false;
    }
  }

  Future<bool> isPasswordValid(PasswordModel appPasswordModel) async {
    MasterKeyVO masterKeyVO = await _masterKeyService.getMasterKey();
    return appPasswordModel.isValidForData(masterKeyVO.masterKeyCiphertext);
  }
}
