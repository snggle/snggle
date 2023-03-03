import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/salt_entity.dart';
import 'package:snggle/infra/repositories/salt_repository.dart';
import 'package:snggle/shared/models/salt_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

class AuthService {
  final SaltRepository _saltRepository = globalLocator<SaltRepository>();

  Future<bool> isAppPasswordExist() async {
    bool isSaltExistBool = await isSaltExist();
    if (isSaltExistBool) {
      SaltEntity saltEntity = await _saltRepository.getSaltEntity();
      return saltEntity.isDefaultPassword == false;
    } else {
      return false;
    }
  }

  Future<bool> isAppPasswordValid({required String hashedPassword}) async {
    SaltEntity saltEntity = await _saltRepository.getSaltEntity();
    bool isAppPasswordValidBool = Aes256.verifyPassword(hashedPassword, saltEntity.value);
    return isAppPasswordValidBool;
  }

  Future<bool> isSaltExist() async {
    return _saltRepository.isSaltExist();
  }

  Future<void> setSaltModel({required SaltModel saltModel}) async {
    SaltEntity saltEntity = SaltEntity.fromModel(saltModel);
    await _saltRepository.setSaltEntity(saltEntity: saltEntity);
  }
}
