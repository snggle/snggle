import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';

void main() {
  MnemonicModel actualMnemonicModel = MnemonicModel.fromString('surge approve another sort unit inner educate east section stone artist service');

  group('Tests of VaultSecretsModel.decrypt() constructor', () {
    test('Should [return VaultSecretsModel] and [password VALID]', () {
      // Arrange
      // @formatter:off
      String actualEncryptedSecrets = 'eV9CAxtWoWgN4LSX9HEI+HiuGg/Q/FbNTjp78u4/cX3jzvn2BwXwqBiu9jqpUpLIQ380Yt00ueXlO4fXv691ckLTJxcIEp1d/jGY5mN3n5QycKk88Ct9JW2xkcRkL3Ll/5YBydZWbBeH55iN6NZGkBt7XeU=';
      // @formatter:on

      // Act
      VaultSecretsModel actualVaultSecretsModel = VaultSecretsModel.decrypt(
        vaultUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        passwordModel: PasswordModel.fromPlaintext('1111'),
        encryptedSecrets: actualEncryptedSecrets,
      );

      // Assert
      VaultSecretsModel expectedVaultSecretsModel = VaultSecretsModel(
        vaultUUid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        mnemonicModel: actualMnemonicModel,
      );

      expect(actualVaultSecretsModel, expectedVaultSecretsModel);
    });

    test('Should [throw InvalidPasswordException] if [password INVALID]', () {
      // Arrange
      // @formatter:off
      String actualEncryptedSecrets = 'eV9CAxtWoWgN4LSX9HEI+HiuGg/Q/FbNTjp78u4/cX3jzvn2BwXwqBiu9jqpUpLIQ380Yt00ueXlO4fXv691ckLTJxcIEp1d/jGY5mN3n5QycKk88Ct9JW2xkcRkL3Ll/5YBydZWbBeH55iN6NZGkBt7XeU=';
      // @formatter:on

      // Assert
      expect(
        () => VaultSecretsModel.decrypt(
          vaultUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
          passwordModel: PasswordModel.fromPlaintext('invalid_password'),
          encryptedSecrets: actualEncryptedSecrets,
        ),
        throwsA(isA<InvalidPasswordException>()),
      );
    });
  });

  group('Tests of VaultSecretsModel.encrypt()', () {
    test('Should [return encrypted secrets] from VaultSecretsModel', () {
      // Arrange
      VaultSecretsModel actualVaultSecretsModel = VaultSecretsModel(
        vaultUUid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        mnemonicModel: actualMnemonicModel,
      );

      // Act
      String actualEncryptedSecrets = actualVaultSecretsModel.encrypt(PasswordModel.fromPlaintext('1111'));

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedSecrets = PasswordModel.fromPlaintext('1111').decrypt(encryptedData: actualEncryptedSecrets);

      // Assert
      String expectedDecryptedSecrets = '{"mnemonic":"surge approve another sort unit inner educate east section stone artist service"}';

      expect(actualDecryptedSecrets, expectedDecryptedSecrets);
    });
  });
}
