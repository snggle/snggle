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
    required FilesystemPath parentFilesystemPath,
    required String name,
    required String rpId,
    required String rpName,
    required String userName,
    required String userDisplayName,
    required Uint8List userId,
    required Uint8List credentialId,
    required Uint8List privateKey,
    required PasswordModel passwordModel,
    int algorithm = -7,
  }) async {
    if (privateKey.length != 32 || credentialId.isEmpty || userId.isEmpty || rpId.isEmpty || algorithm != -7) {
      throw ArgumentError('Invalid ES256 passkey data');
    }

    PasskeyModel item = PasskeyModel(
      id: Isar.autoIncrement,
      encryptedBool: false,
      pinnedBool: false,
      filesystemPath: const FilesystemPath.empty(),
      name: name,
      rpId: rpId,
      rpName: rpName,
      userName: userName,
      userDisplayName: userDisplayName,
      userId: Uint8List.fromList(userId),
      credentialId: Uint8List.fromList(credentialId),
      algorithm: algorithm,
      signCount: 0,
    );

    int id = await _passkeysService.save(item);
    try {
      item = await _passkeysService.updateFilesystemPath(id, parentFilesystemPath);
      PasskeySecretsModel secrets = PasskeySecretsModel(
        filesystemPath: item.filesystemPath,
        privateKey: Uint8List.fromList(privateKey),
      );
      await _secretsService.save(secrets, passwordModel);
      return item;
    } catch (_) {
      // Best-effort cleanup; the original exception remains available.
      try {
        await _passkeysService.deleteById(id);
      } catch (_) {}
      rethrow;
    }
  }

  List<PasskeyModel> createFromEntities(List<PasskeyEntity> entities) =>
      entities.map(createFromEntity).toList();

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
