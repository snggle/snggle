import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';

void main() {
  // Arrange
  // Actual values for tests
  String actualPassword = 'kiraTest123';
  String actualTextToEncrypt = 'kiratest';
  String actualTextToDecrypt = 'wEQo23Uy93RU8EMf1tip5iKnq1VOdUO03cDu3X/l92xEcRLx';

  // Expected values for tests
  String expectedDecryptedString = 'kiratest';

  group('Tests of Aes256.encrypt()', () {
    // Output is always random String because method HAS changing initialization vector using Random Secure
    // and we cannot match the hardcoded expected result.
    // That`s why we check whether it is possible to encode and decode text
    test('Should correctly encrypt given string via AES256 algorithm and check with decrypt method', () async {
      // Act
      String actualEncryptedString = Aes256.encrypt(actualPassword, actualTextToEncrypt);
      String actualDecryptedString = Aes256.decrypt(actualPassword, actualEncryptedString);

      // Assert
      expect(actualDecryptedString, expectedDecryptedString);
    });
  });

  group('Tests of Aes256.decrypt()', () {
    test('Should correctly decrypt given string via AES256 algorithm', () async {
      // Act
      String actualDecryptedString = Aes256.decrypt(actualPassword, actualTextToDecrypt);

      // Assert
      expect(actualDecryptedString, expectedDecryptedString);
    });
    
    test('Should throw ArgumentError if password is`t correct', (){
      // Act
      // ignore: prefer_function_declarations_over_variables
      Function actualDecryptFunction = () => Aes256.decrypt('Incorrect password', actualTextToDecrypt);

      // Assert
      expect(actualDecryptFunction, throwsA(isA<ArgumentError>()));
    });
  });

  group('Tests of Aes256.verifyPassword()', () {
    test('Should return true if the password is correct', () async {
      // Act
      bool actualPasswordValid = Aes256.verifyPassword(actualPassword, actualTextToDecrypt);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should return false if the password isn`t correct', () async {
      // Act
      bool actualPasswordValid = Aes256.verifyPassword('incorrect password', actualTextToDecrypt);

      // Assert
      expect(actualPasswordValid, false);
    });
  });
}
