import 'dart:convert';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/container_path.dart';
import 'package:snggle/shared/models/i_password_model.dart';

class SecretsService {
  final SecretsRepository _secretsRepository;

  SecretsService({
    SecretsRepository? secretsRepository,
  }) : _secretsRepository = secretsRepository ?? globalLocator<SecretsRepository>();

  Future<void> changeParentPassword(ContainerPathModel containerPath, IPasswordModel oldPasswordModel, IPasswordModel newPasswordModel) async {
    Map<String, String> allSecrets = await _secretsRepository.getAllMapped(containerPath.parentPath);

    for (String path in allSecrets.keys) {
      if (path.startsWith(containerPath.path)) {
        Ciphertext ciphertext = Ciphertext.fromJsonString(allSecrets[path]!);
        String decryptedSecrets = oldPasswordModel.decrypt(ciphertext: ciphertext);
        Ciphertext newSecretCiphertext = newPasswordModel.encrypt(decryptedData: decryptedSecrets);

        await _secretsRepository.saveEncryptedSecrets(path, newSecretCiphertext);
      }
    }
  }

  Future<T> getSecrets<T extends ASecretsModel>(ContainerPathModel containerPath, IPasswordModel passwordModel) async {
    Ciphertext ciphertext = await _secretsRepository.getEncryptedSecrets(containerPath.path);

    String decryptedHash = passwordModel.decrypt(ciphertext: ciphertext);
    print('decryptedHash: $decryptedHash');
    Map<String, dynamic> json = jsonDecode(decryptedHash) as Map<String, dynamic>;
    return ASecretsModel.fromJson<T>(containerPath, json);
  }

  Future<bool> isSecretsPasswordValid(ContainerPathModel containerPath, IPasswordModel passwordModel) async {
    Ciphertext ciphertext = await _secretsRepository.getEncryptedSecrets(containerPath.path);
    return passwordModel.isValidForData(ciphertext);
  }

  Future<void> saveSecrets(ASecretsModel secretsModel, IPasswordModel passwordModel) async {
    Map<String, dynamic> secretsJson = secretsModel.toJson();
    String secretsJsonString = jsonEncode(secretsJson);

    Ciphertext ciphertext = passwordModel.encrypt(decryptedData: secretsJsonString);
    await _secretsRepository.saveEncryptedSecrets(secretsModel.containerPathModel.path, ciphertext);
  }

  Future<void> deleteSecrets(ContainerPathModel containerPath) async {
    await _secretsRepository.deleteSecrets(containerPath.path);
  }
}
