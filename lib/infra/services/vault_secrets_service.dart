import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';

/// Service for managing secrets associated with specific vault
///
/// [VaultModel] and [VaultSecretsModel] are saved separately in the database as they contains different information about vault with different access requirements
/// - [VaultModel] contains basic vault-data (uuid, name, ...) and can be accessed without providing additional password (for example, to display vaults list)
/// - [VaultSecretsModel] contains sensitive vault-data (mnemonic) and should be accessed only when it is necessary (for example, to derive new wallet)
///
class VaultSecretsService {
  final SecretsRepository _secretsRepository;

  VaultSecretsService({
    SecretsRepository? secretsRepository,
  }) : _secretsRepository = secretsRepository ?? globalLocator<SecretsRepository>();

  Future<VaultSecretsModel> getSecrets(String vaultUuid, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(vaultUuid);
    return VaultSecretsModel.decrypt(
      vaultUuid: vaultUuid,
      encryptedSecrets: encryptedSecrets,
      passwordModel: passwordModel,
    );
  }

  Future<bool> isSecretsPasswordValid(String vaultUuid, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(vaultUuid);
    return passwordModel.isValidForData(encryptedSecrets);
  }

  Future<void> saveSecrets(VaultSecretsModel vaultSecretsModel, PasswordModel passwordModel) async {
    String encryptedSecrets = vaultSecretsModel.encrypt(passwordModel);
    await _secretsRepository.saveEncryptedSecrets(vaultSecretsModel.vaultUUid, encryptedSecrets);
  }

  Future<void> deleteSecrets(String vaultUuid) async {
    await _secretsRepository.deleteSecrets(vaultUuid);
  }
}
