import 'dart:convert';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/i_password_model.dart';

class SecretsService {
  final SecretsRepository _secretsRepository;

  SecretsService({
    SecretsRepository? secretsRepository,
  }) : _secretsRepository = secretsRepository ?? globalLocator<SecretsRepository>();

  Future<void> changeParentPassword(String containerPathPattern, IPasswordModel oldPasswordModel, IPasswordModel newPasswordModel) async {
    Map<String, String> allSecrets = await _secretsRepository.getAllMapped();

    for (String path in allSecrets.keys) {
      if (path.startsWith(containerPathPattern)) {
        String currentEncryptedSecrets = allSecrets[path]!;
        String decryptedSecrets = oldPasswordModel.decrypt(encryptedData: currentEncryptedSecrets);
        String encryptedNewSecrets = newPasswordModel.encrypt(decryptedData: decryptedSecrets);

        await _secretsRepository.saveEncryptedSecrets(path, encryptedNewSecrets);
      }
    }
  }

  Future<T> getSecrets<T extends ASecretsModel>(String containerPath, IPasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(containerPath);
    String decryptedHash = passwordModel.decrypt(encryptedData: encryptedSecrets);
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(containerPath, json);
  }
  
  Future<bool> isSecretsPasswordValid(String containerPath, IPasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(containerPath);
    return passwordModel.isValidForData(encryptedSecrets);
  }

  Future<void> saveSecrets(ASecretsModel secretsModel, IPasswordModel passwordModel) async {
    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);
    String encryptedSecrets = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncryptedSecrets(secretsModel.path, encryptedSecrets);
  }

  Future<void> deleteSecrets(String containerPath) async {
    await _secretsRepository.deleteSecrets(containerPath);
  }
}
