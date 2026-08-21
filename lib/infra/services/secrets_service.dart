import 'dart:convert';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
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
    await _verifyParentFilesystemStorage(secretsModel);

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

  Future<void> _verifyParentFilesystemStorage(ASecretsModel secretsModel) async {
    FilesystemPath? parentFilesystemPath = switch (secretsModel) {
      VaultSecretsModel() => FilesystemPath.fromString('vaults'),
      EntrySecretsModel() => FilesystemPath.fromString('entries'),
      _ => null,
    };

    if (parentFilesystemPath == null) {
      return;
    }

    bool parentFilesystemStorageExistsBool = await _secretsRepository.isSecretExists(parentFilesystemPath);
    if (parentFilesystemStorageExistsBool == false) {
      await _createParentFilesystemStorage(parentFilesystemPath);
    }
  }

  Future<void> _createParentFilesystemStorage(FilesystemPath parentFilesystemPath) async {
    GroupSecretsModel parentSecretsModel = GroupSecretsModel.generate(parentFilesystemPath);
    String parentSecretsJsonString = jsonEncode(parentSecretsModel.toJson());
    String encryptedParentSecrets = PasswordModel.defaultPassword().encrypt(decryptedData: parentSecretsJsonString);

    await _secretsRepository.saveEncrypted(parentFilesystemPath, encryptedParentSecrets);
  }
}
