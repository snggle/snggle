import 'dart:convert';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/password_model.dart';

class SecretsService {
  final SecretsRepository _secretsRepository;

  SecretsService({
    SecretsRepository? secretsRepository,
  }) : _secretsRepository = secretsRepository ?? globalLocator<SecretsRepository>();

  Future<void> changePassword(ContainerPathModel containerPathModel, PasswordModel oldPasswordModel, PasswordModel newPasswordModel) async {
    String secrets = await _secretsRepository.getEncryptedSecrets(containerPathModel.fullPath);

    String decryptedData = oldPasswordModel.decrypt(encryptedData: secrets);
    String encryptedData = newPasswordModel.encrypt(decryptedData: decryptedData);

    await _secretsRepository.saveEncryptedSecrets(containerPathModel.fullPath, encryptedData);
  }

  Future<T> getSecrets<T extends ASecretsModel>(ContainerPathModel containerPath, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(containerPath.fullPath);
    String decryptedHash = passwordModel.decrypt(encryptedData: encryptedSecrets);
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(containerPath, json);
  }

  Future<bool> isSecretsPasswordValid(ContainerPathModel containerPath, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(containerPath.fullPath);
    return passwordModel.isValidForData(encryptedSecrets);
  }

  Future<void> saveSecrets(ASecretsModel secretsModel, PasswordModel passwordModel) async {
    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);
    String encryptedSecrets = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncryptedSecrets(secretsModel.containerPathModel.fullPath, encryptedSecrets);
  }

  Future<void> moveSecrets(ContainerPathModel previousContainerPath, ContainerPathModel newContainerPath) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(previousContainerPath.fullPath);
    await deleteSecrets(previousContainerPath);
    await _secretsRepository.saveEncryptedSecrets(newContainerPath.fullPath, encryptedSecrets);
  }

  Future<void> deleteSecrets(ContainerPathModel containerPath) async {
    await _secretsRepository.deleteSecrets(containerPath.fullPath);
  }
}
