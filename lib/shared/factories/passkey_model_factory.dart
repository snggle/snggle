import 'dart:typed_data';

import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/passkey_entity/passkey_entity.dart';
import 'package:snggle/infra/services/passkeys_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/models/passkeys/passkey_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasskeyModelFactory {
  final PasskeysService _passkeysService = globalLocator<PasskeysService>();
  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<PasskeyModel> createNewPasskey({
    required String rpId,
    required String rpName,
    required String userName,
    required String userDisplayName,
    required Uint8List userId,
    required Uint8List credentialId,
    required Uint8List privateKey,
  }) async {
    PasskeyModel passkeyModel = PasskeyModel(
      id: Isar.autoIncrement,
      encryptedBool: false,
      pinnedBool: false,
      filesystemPath: const FilesystemPath.empty(),
      name: rpName,
      rpId: rpId,
      rpName: rpName,
      userName: userName,
      userDisplayName: userDisplayName,
      userId: userId,
      credentialId: credentialId,
      algorithm: -7,
      signCount: 0,
    );

    int passkeyId = await _passkeysService.save(passkeyModel);

    try {
      passkeyModel = await _passkeysService.updateFilesystemPath(passkeyId);

      PasskeySecretsModel passkeySecretsModel = PasskeySecretsModel(
        filesystemPath: passkeyModel.filesystemPath,
        privateKey: privateKey,
      );

      await _secretsService.save(
        passkeySecretsModel,
        PasswordModel.defaultPassword(),
      );

      return passkeyModel;
    } catch (_) {
      await _passkeysService.deleteById(passkeyId);
      rethrow;
    }
  }

  List<PasskeyModel> createFromEntities(List<PasskeyEntity> entities) => entities.map(createFromEntity).toList();

  PasskeyModel createFromEntity(PasskeyEntity entity) {
    return PasskeyModel(
      id: entity.id,
      encryptedBool: entity.encryptedBool,
      pinnedBool: entity.pinnedBool,
      filesystemPath: entity.filesystemPath,
      name: entity.name,
      rpId: entity.rpId,
      rpName: entity.rpName,
      userName: entity.userName,
      userDisplayName: entity.userDisplayName,
      userId: Uint8List.fromList(entity.userId),
      credentialId: Uint8List.fromList(entity.credentialId),
      algorithm: entity.algorithm,
      signCount: entity.signCount,
    );
  }
}
