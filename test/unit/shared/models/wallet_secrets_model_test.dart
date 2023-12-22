import 'dart:typed_data';

import 'package:blockchain_utils/hex/hex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

void main() {
  Uint8List actualPrivateKey = Uint8List.fromList(hex.decode('8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241'));

  group('Tests of WalletSecretsModel.decrypt() constructor', () {
    test('Should [return WalletSecretsModel] if [password VALID]', () {
      // Arrange
      // @formatter:off
      String actualEncryptedSecrets = 'U2LiXf9j9H81WxfBL+qAwAVeU/H3EEjO8rxQ/Mt56//dxo309k0Gf8Ng8+0cweeuQSgXMCbIhX7v7vexvJSSaTa2xoCely/SUQPIZD03IZ3JVjO7EJ2JOD2tFumuhI9Ildy9V6MPRlAGu1ZOVn0FWdCqYfY=';
      // @formatter:on

      // Act
      WalletSecretsModel actualWalletSecretsModel = WalletSecretsModel.decrypt(
        walletUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        passwordModel: PasswordModel.fromPlaintext('1111'),
        encryptedSecrets: actualEncryptedSecrets,
      );

      // Assert
      WalletSecretsModel actualNewWalletSecretsModel = WalletSecretsModel(
        walletUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        privateKey: Uint8List.fromList(hex.decode('8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241')),
      );

      expect(actualWalletSecretsModel, actualNewWalletSecretsModel);
    });

    test('Should [throw InvalidPasswordException] if [password INVALID]', () {
      // Arrange
      // @formatter:off
      String actualEncryptedSecrets = 'U2LiXf9j9H81WxfBL+qAwAVeU/H3EEjO8rxQ/Mt56//dxo309k0Gf8Ng8+0cweeuQSgXMCbIhX7v7vexvJSSaTa2xoCely/SUQPIZD03IZ3JVjO7EJ2JOD2tFumuhI9Ildy9V6MPRlAGu1ZOVn0FWdCqYfY=';
      // @formatter:on

      // Assert
      expect(
        () => WalletSecretsModel.decrypt(
          walletUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
          passwordModel: PasswordModel.fromPlaintext('invalid_password'),
          encryptedSecrets: actualEncryptedSecrets,
        ),
        throwsA(isA<InvalidPasswordException>()),
      );
    });
  });

  group('Tests of WalletSecretsModel.encrypt()', () {
    test('Should [return encrypted secrets] from WalletSecretsModel', () {
      // Arrange
      WalletSecretsModel actualWalletSecretsModel = WalletSecretsModel(
        walletUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        privateKey: actualPrivateKey,
      );

      // Act
      String actualEncryptedSecrets = actualWalletSecretsModel.encrypt(PasswordModel.fromPlaintext('1111'));

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedSecrets = PasswordModel.fromPlaintext('1111').decrypt(encryptedData: actualEncryptedSecrets);

      // Assert
      String expectedDecryptedSecrets = '{"private_key":"8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241"}';

      expect(actualDecryptedSecrets, expectedDecryptedSecrets);
    });
  });
}
