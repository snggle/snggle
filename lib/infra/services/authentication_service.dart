import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/salt_entity.dart';
import 'package:snggle/infra/repositories/salt_repository.dart';
import 'package:snggle/shared/models/salt_model.dart';

class AuthenticationService {
  final SaltRepository _saltRepository = globalLocator<SaltRepository>();

  Future<void> setSaltModel({required SaltModel saltModel}) async {
    SaltEntity saltEntity = SaltEntity.fromModel(saltModel);
    await _saltRepository.setSaltEntity(saltEntity: saltEntity);
  }
}
