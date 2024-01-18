import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/container_path.dart';
import 'package:snggle/shared/models/password_model.dart';

class SecretsService {
  final SecretsRepository _secretsRepository;

  SecretsService({
    SecretsRepository? secretsRepository,
  }) : _secretsRepository = secretsRepository ?? globalLocator<SecretsRepository>();

  Future<T> getSecrets<T extends ASecretsModel>(ContainerPathModel containerPath, PasswordModel passwordModel) async {
    Ciphertext ciphertext = await _secretsRepository.getEncryptedSecrets(containerPath.path);

    String decryptedData = passwordModel.decrypt(ciphertext: ciphertext);
    Map<String, dynamic> json = jsonDecode(decryptedData) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(containerPath, json);
  }

  Future<bool> isSecretsPasswordValid(ContainerPathModel containerPath, PasswordModel passwordModel) async {
    Ciphertext ciphertext = await _secretsRepository.getEncryptedSecrets(containerPath.path);
    return passwordModel.isValidForData(ciphertext);
  }

  Future<void> saveSecrets(ASecretsModel secretsModel, PasswordModel passwordModel) async {
    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);

    Ciphertext ciphertext = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncryptedSecrets(secretsModel.containerPathModel.path, ciphertext);
  }

  Future<void> deleteSecrets(ContainerPathModel containerPath) async {
    await _secretsRepository.deleteSecrets(containerPath.path);
  }
}
