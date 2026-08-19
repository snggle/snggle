import 'dart:convert';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/groups/group_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class SecretsService {
  final SecretsRepository _secretsRepository = globalLocator<SecretsRepository>();

  Future<void> changePassword(FilesystemPath filesystemPath, PasswordModel oldPasswordModel, PasswordModel newPasswordModel) async {
    String secrets = await _secretsRepository.getEncrypted(filesystemPath);

    String decryptedData = oldPasswordModel.decrypt(encryptedData: secrets);
    String encryptedData = newPasswordModel.encrypt(decryptedData: decryptedData);

    await _secretsRepository.saveEncrypted(filesystemPath, encryptedData);
  }

  Future<T> get<T extends ASecretsModel>(FilesystemPath filesystemPath, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncrypted(filesystemPath);
    String decryptedHash = passwordModel.decrypt(encryptedData: encryptedSecrets);
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(filesystemPath, json);
  }

  Future<FilesystemPath> getEncryptedPath(FilesystemPath filesystemPath) async {
    FilesystemPath encryptedFilesystemPath = filesystemPath;
    while (encryptedFilesystemPath.pathSegments.isNotEmpty) {
      bool defaultPasswordBool = await isPasswordValid(encryptedFilesystemPath, PasswordModel.defaultPassword());
      if (defaultPasswordBool) {
        encryptedFilesystemPath = encryptedFilesystemPath.pop();
      } else {
        return encryptedFilesystemPath;
      }
    }
    return encryptedFilesystemPath;
  }

  Future<void> save(ASecretsModel secretsModel, PasswordModel passwordModel) async {
    bool vaultBool = secretsModel is VaultSecretsModel;
    if (vaultBool) {
      await _verifyParentFilesystem(secretsModel);
    }

    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);
    String encryptedSecrets = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncrypted(secretsModel.filesystemPath, encryptedSecrets);
  }

  Future<void> move(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    await _secretsRepository.move(previousFilesystemPath, newFilesystemPath);
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    await _secretsRepository.delete(filesystemPath);
  }

  Future<bool> isPasswordValid(FilesystemPath filesystemPath, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncrypted(filesystemPath);
    return passwordModel.isValidForData(encryptedSecrets);
  }

  Future<void> _verifyParentFilesystem(ASecretsModel secretsModel) async {
    bool parentFilesystemStorageExistsBool = await _secretsRepository.isSecretExists(FilesystemPath.fromString('vaults'));
    if (parentFilesystemStorageExistsBool == false) {
      await _createParentFilesystemStorage(secretsModel.filesystemPath);
    }
  }

  Future<void> _createParentFilesystemStorage(FilesystemPath filesystemPath) async {
    FilesystemPath vaultsRootPath = FilesystemPath.fromString('vaults');

    GroupSecretsModel vaultsRootSecretsModel = GroupSecretsModel.generate(vaultsRootPath);
    String vaultsRootSecretsJsonString = jsonEncode(vaultsRootSecretsModel.toJson());
    String encryptedVaultsRootSecrets = PasswordModel.defaultPassword().encrypt(decryptedData: vaultsRootSecretsJsonString);

    await _secretsRepository.saveEncrypted(vaultsRootPath, encryptedVaultsRootSecrets);
  }
}
