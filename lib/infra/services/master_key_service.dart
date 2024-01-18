import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

class MasterKeyService {
  final MasterKeyRepository _masterKeyRepository = globalLocator<MasterKeyRepository>();

  Future<MasterKeyVO> getMasterKey() async {
    Ciphertext ciphertext = await _masterKeyRepository.getMasterKey();
    return MasterKeyVO(masterKeyCiphertext: ciphertext);
  }

  Future<bool> isMasterKeyExists() async {
    return _masterKeyRepository.isMasterKeyExists();
  }

  Future<void> setDefaultMasterKey() async {
    MnemonicModel mnemonicModel = MnemonicModel.generate();
    MasterKeyVO masterKeyVO = await MasterKeyVO.create(passwordModel: PasswordModel.defaultPassword(), mnemonicModel: mnemonicModel);
    await setMasterKey(masterKeyVO);
  }

  Future<void> setMasterKey(MasterKeyVO masterKeyVO) async {
    Ciphertext ciphertext = masterKeyVO.masterKeyCiphertext;
    await _masterKeyRepository.setMasterKey(ciphertext);
  }
}
