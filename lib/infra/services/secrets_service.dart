import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
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
    Ciphertext ciphertext = await _secretsRepository.getEncrypted(filesystemPath);

    String decryptedData = passwordModel.decrypt(ciphertext: ciphertext);
    Map<String, dynamic> json = jsonDecode(decryptedData) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(filesystemPath, json);
  }

  Future<void> save(ASecretsModel secretsModel, PasswordModel passwordModel) async {
    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);

    Ciphertext ciphertext = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncrypted(secretsModel.filesystemPath, ciphertext);
  }

  Future<void> move(FilesystemPath previousFilesystemPath, FilesystemPath newFilesystemPath) async {
    await _secretsRepository.move(previousFilesystemPath, newFilesystemPath);
  }

  Future<void> delete(FilesystemPath filesystemPath) async {
    await _secretsRepository.delete(filesystemPath);
  }

  Future<bool> isPasswordValid(FilesystemPath filesystemPath, PasswordModel passwordModel) async {
    Ciphertext ciphertext = await _secretsRepository.getEncrypted(filesystemPath);
    return passwordModel.isValidForData(ciphertext);
  }
}
