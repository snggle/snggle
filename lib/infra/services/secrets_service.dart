import 'dart:convert';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class SecretsService {
  final SecretsRepository _secretsRepository = globalLocator<SecretsRepository>();

  Future<T> get<T extends ASecretsModel>(FilesystemPath filesystemPath, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncrypted(filesystemPath);
    String decryptedHash = passwordModel.decrypt(encryptedData: encryptedSecrets);
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(filesystemPath, json);
  }

  Future<void> save(ASecretsModel secretsModel, PasswordModel passwordModel) async {
    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);
    String encryptedSecrets = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncrypted(secretsModel.filesystemPath, encryptedSecrets);
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    await _secretsRepository.delete(filesystemPath);
  }

  Future<bool> isPasswordValid(FilesystemPath filesystemPath, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncrypted(filesystemPath);
    return passwordModel.isValidForData(encryptedSecrets);
  }
}
