import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

void main() {
  group('Tests of [PasswordModel] constructors', () {
    group('Tests of PasswordModel.fromPlaintext() constructor', () {
      test('Should [return PasswordModel] containing hashed password provided via constructor', () {
        // Act
        PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');

        // Assert
        PasswordModel expectedPasswordModel = const PasswordModel(hashedPassword: 'XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg=');

        expect(actualPasswordModel, expectedPasswordModel);
      });
    });

    group('Tests of PasswordModel.defaultPassword() constructor', () {
      test('Should [return PasswordModel] containing hashed default password', () {
        // Act
        PasswordModel actualPasswordModel = PasswordModel.defaultPassword();

        // Assert
        PasswordModel expectedPasswordModel = const PasswordModel(hashedPassword: 'NPm7bEvcQPfAKHyf3OgSyLSZnlmVmfoft41RlgJDV8A=');

        expect(actualPasswordModel, expectedPasswordModel);
      });
    });
  });

  group('Tests of PasswordModel.isEncryptedWithCustomPassword()', () {
    test('Should [return TRUE] if data is [encrypted by CUSTOM password]', () async {
      // Arrange
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        base64: 'oEGBHJUZ6pw8dF2g6YAz4gmuhTj9x5MN8J2mZDzpoNQ1lDFEUl+hNklVnNJIEbhBXAtnrxo2ghNiiGuRC84LEff+AUEN8Na6+avqOVK+Csf6fS2JwjxJPRhD0mFuKP1QcGdV2g==',
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
      );

      // Act
      bool actualCustomPasswordBool = PasswordModel.isEncryptedWithCustomPassword(actualCiphertext);

      // Assert
      expect(actualCustomPasswordBool, true);
    });

    test('Should [return FALSE] if data is [encrypted by DEFAULT password]', () async {
      // Arrange
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        base64: 'hHbwgENri2fKNi4Lu3aZPQsaW5QIF5NAkcsBvyAzm7pZpJyx2gtdrN8wz1kdM8rbvnVzEvfzSc7ohJJ2wiO7sDOzVuk=',
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
      );

      // Act
      bool actualCustomPasswordBool = PasswordModel.isEncryptedWithCustomPassword(actualCiphertext);

      // Assert
      expect(actualCustomPasswordBool, false);
    });
  });

  group('Tests of PasswordModel.encrypt()', () {
    test('Should [return hash] representing given data encrypted by hashed password', () {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
      String actualPasswordHash = 'XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg=';

      // Act
      Ciphertext actualCiphertext = actualPasswordModel.encrypt(decryptedData: 'decrypted_data');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode text
      String actualDecryptedData = AESDHKEV1().decrypt(actualPasswordHash, actualCiphertext);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });
  });

  group('Tests of PasswordModel.decrypt()', () {
    test('Should [return decrypted hash] if used [PasswordModel VALID]', () {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        base64: 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB',
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
      );

      // Act
      String actualDecryptedData = actualPasswordModel.decrypt(ciphertext: actualCiphertext);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [throw InvalidPasswordException] if used [PasswordModel INVALID]', () {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        base64: 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB',
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
      );

      // Assert
      expect(
        () => actualPasswordModel.decrypt(ciphertext: actualCiphertext),
        throwsA(isA<InvalidPasswordException>()),
      );
    });
  });

  group('Tests of PasswordModel.isValidForData()', () {
    test('Should [return TRUE] if PasswordModel [CAN decrypt] given String', () {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        base64: 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB',
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
      );

      // Act
      bool actualPasswordValid = actualPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should [return FALSE] if PasswordModel [CANNOT decrypt] given String', () {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        base64: 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB',
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
      );

      // Act
      bool actualPasswordValid = actualPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, false);
    });
  });
}
