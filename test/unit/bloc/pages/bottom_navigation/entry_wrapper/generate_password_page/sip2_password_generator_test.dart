import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/sip2_password_generator.dart';

void main() {
  group('Tests of Sip2PasswordGenerator.generate()', () {
    test('Should [throw ArgumentError] if requested length is [NEGATIVE]', () {
      // Arrange
      Sip2PasswordGenerator actualSip2PasswordGenerator = Sip2PasswordGenerator(random: Random.secure());

      // Assert
      expect(
        () => actualSip2PasswordGenerator.generate(-1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'Should [throw empty password] if requested length is [ZERO]',
      () {
        // Arrange
        Sip2PasswordGenerator actualSip2PasswordGenerator = Sip2PasswordGenerator(random: Random.secure());

        // Act
        Sip2GeneratedPassword actualGeneratedPassword = actualSip2PasswordGenerator.generate(0);

        // Assert
        expect(actualGeneratedPassword.password, '');
        expect(actualGeneratedPassword.randomCharacterCount, 0);
        expect(actualGeneratedPassword.checksumCharacterCount, 0);

        actualGeneratedPassword = actualSip2PasswordGenerator.generate(-1);

        expect(actualGeneratedPassword.password, '');
        expect(actualGeneratedPassword.randomCharacterCount, 0);
        expect(actualGeneratedPassword.checksumCharacterCount, 0);
      },
    );

    test(
      'Should [return one checksum character] if requested length is [1]',
      () {
        // Arrange
        Sip2PasswordGenerator actualSip2PasswordGenerator = Sip2PasswordGenerator(random: Random.secure());

        // Act
        Sip2GeneratedPassword actualGeneratedPassword = actualSip2PasswordGenerator.generate(1);

        // Assert
        expect(actualGeneratedPassword.password, 's');
        expect(actualGeneratedPassword.randomCharacterCount, 0);
        expect(actualGeneratedPassword.checksumCharacterCount, 1);
      },
    );

    test(
      'Should [return password] with random characters and one checksum character',
      () {
        // Arrange
        Sip2PasswordGenerator actualSip2PasswordGenerator = Sip2PasswordGenerator(random: Random.secure());

        // Act
        Sip2GeneratedPassword actualGeneratedPassword = actualSip2PasswordGenerator.generate(5);

        // Assert
        expect(actualGeneratedPassword.password, '!+-0p');
        expect(actualGeneratedPassword.randomCharacterCount, 4);
        expect(actualGeneratedPassword.checksumCharacterCount, 1);
      },
    );

    test(
      'Should [return password] with one checksum character if requested length is [20]',
      () {
        // Arrange
        Sip2PasswordGenerator actualSip2PasswordGenerator = Sip2PasswordGenerator(random: Random.secure());

        // Act
        Sip2GeneratedPassword actualGeneratedPassword = actualSip2PasswordGenerator.generate(20);

        // Assert
        expect(actualGeneratedPassword.password, '!+-0123456789=@ABCD4');
        expect(actualGeneratedPassword.randomCharacterCount, 19);
        expect(actualGeneratedPassword.checksumCharacterCount, 1);
      },
    );

    test(
      'Should [return password] with random characters and two checksum characters',
      () {
        // Arrange
        Sip2PasswordGenerator actualSip2PasswordGenerator = Sip2PasswordGenerator(random: Random.secure());

        // Act
        Sip2GeneratedPassword actualGeneratedPassword = actualSip2PasswordGenerator.generate(21);

        // Assert
        expect(actualGeneratedPassword.password, '!+-0123456789=@ABCD4r');
        expect(actualGeneratedPassword.randomCharacterCount, 19);
        expect(actualGeneratedPassword.checksumCharacterCount, 2);
      },
    );
  });
}
