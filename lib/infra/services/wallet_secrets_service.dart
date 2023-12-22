import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class WalletSecretsService {
  final SecretsRepository _secretsRepository;

  WalletSecretsService({
    SecretsRepository? secretsRepository,
  }) : _secretsRepository = secretsRepository ?? globalLocator<SecretsRepository>();

  Future<WalletSecretsModel> getSecrets(String walletUuid, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(walletUuid);
    return WalletSecretsModel.decrypt(
      walletUuid: walletUuid,
      encryptedSecrets: encryptedSecrets,
      passwordModel: passwordModel,
    );
  }

  Future<bool> isSecretsPasswordValid(String walletUuid, PasswordModel passwordModel) async {
    String encryptedSecrets = await _secretsRepository.getEncryptedSecrets(walletUuid);
    return passwordModel.isValidForData(encryptedSecrets);
  }

  Future<void> saveSecrets(WalletSecretsModel walletSecretsModel, PasswordModel passwordModel) async {
    String encryptedSecrets = walletSecretsModel.encrypt(passwordModel);
    await _secretsRepository.saveEncryptedSecrets(walletSecretsModel.walletUuid, encryptedSecrets);
  }

  Future<void> deleteSecrets(String walletUuid) async {
    await _secretsRepository.deleteSecrets(walletUuid);
  }
}
