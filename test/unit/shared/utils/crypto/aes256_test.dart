import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

void main() {
  // Arrange
  // Actual values for tests
  String actualPassword = 'kiraTest123';
  String actualStringToEncrypt = 'kiratest';
  String actualStringToDecrypt = 'wEQo23Uy93RU8EMf1tip5iKnq1VOdUO03cDu3X/l92xEcRLx';

  // Expected values for tests
  String expectedDecryptedString = 'kiratest';

  group('Tests of Aes256.encrypt()', () {
    // Output is always a random string because AES changes the initialization vector with Random Secure
    // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode text
    test('Should correctly encrypt given string via AES256 algorithm and check with decrypt method', () async {
      // Act
      String actualEncryptedString = Aes256.encrypt(actualPassword, actualStringToEncrypt);
      String actualDecryptedString = Aes256.decrypt(actualPassword, actualEncryptedString);

      // Assert
      expect(actualDecryptedString, expectedDecryptedString);
    });
  });

  group('Tests of Aes256.decrypt()', () {
    test('Should [return STRING] decrypted from given hash via AES256 algorithm', () async {
      // Act
      String actualDecryptedString = Aes256.decrypt(actualPassword, actualStringToDecrypt);

      // Assert
      expect(actualDecryptedString, expectedDecryptedString);
    });

    test('Should [throw ArgumentError] if password is not correct', () {
      // Assert
      expect(
        () => Aes256.decrypt('incorrect_password', actualStringToDecrypt),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Tests of Aes256.isPasswordValid()', () {
    test('Should [return TRUE] if [password CORRECT]', () async {
      // Act
      bool actualPasswordValid = Aes256.isPasswordValid(actualPassword, actualStringToDecrypt);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should [return FALSE] if [password INCORRECT]', () async {
      // Act
      bool actualPasswordValid = Aes256.isPasswordValid('incorrect_password', actualStringToDecrypt);

      // Assert
      expect(actualPasswordValid, false);
    });
  });
}
