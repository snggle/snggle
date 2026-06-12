import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';
import 'package:snggle/shared/utils/totp_secret_input_parser.dart';

void main() {
  group('Tests of TotpSecretInputParser.fromInput() for plain input', () {
    test('Should [return normalized secret] for plain input with spaces and uppercase characters', () {
      // Arrange
      String actualInput = '  JBSW Y3DP EH PK3PXP  ';

      // Act
      String actualSecret = TotpSecretInputParser.fromInput(actualInput);

      // Assert
      String expectedSecret = 'jbswy3dpehpk3pxp';

      expect(actualSecret, expectedSecret);
    });
  });

  group('Tests of TotpSecretInputParser.fromInput() for QR input', () {
    test('Should [return normalized secret] for supported otpauth URI', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?secret=JBSW%20Y3DP%20EHPK3PXP&issuer=Example';

      // Act
      String actualSecret = TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true);

      // Assert
      String expectedSecret = 'jbswy3dpehpk3pxp';

      expect(actualSecret, expectedSecret);
    });

    test('Should [return normalized secret] for supported otpauth URI with mixed-case query keys', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?SeCrEt=ABCD1234&AlGoRiThM=SHA1&DiGiTs=6&PeRiOd=30';

      // Act
      String actualSecret = TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true);

      // Assert
      String expectedSecret = 'abcd1234';

      expect(actualSecret, expectedSecret);
    });

    test('Should [throw ReadTotpDataException.unsupported] if URI scheme is not supported', () {
      // Arrange
      String actualInput = 'https://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.unsupported,
          ),
        ),
      );
    });

    test('Should [throw ReadTotpDataException.unsupported] if URI host is not supported', () {
      // Arrange
      String actualInput = 'otpauth://hotp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.unsupported,
          ),
        ),
      );
    });

    test('Should [throw ReadTotpDataException.unsupportedTotpConfiguration] if algorithm is not supported', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP&algorithm=SHA256';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.unsupportedTotpConfiguration,
          ),
        ),
      );
    });

    test('Should [throw ReadTotpDataException.unsupportedTotpConfiguration] if digits are not supported', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP&digits=8';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.unsupportedTotpConfiguration,
          ),
        ),
      );
    });

    test('Should [throw ReadTotpDataException.unsupportedTotpConfiguration] if period is not supported', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP&period=60';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.unsupportedTotpConfiguration,
          ),
        ),
      );
    });

    test('Should [throw ReadTotpDataException.secretNotFound] if secret parameter is missing', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?issuer=Example';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.secretNotFound,
          ),
        ),
      );
    });

    test('Should [throw ReadTotpDataException.secretNotFound] if secret parameter is empty after normalization', () {
      // Arrange
      String actualInput = 'otpauth://totp/Example:user@example.com?secret=%20%20%20';

      // Assert
      expect(
        () => TotpSecretInputParser.fromInput(actualInput, inputFromQrBool: true),
        throwsA(
          isA<ReadTotpDataException>().having(
            (ReadTotpDataException e) => e.readTotpDataExceptionType,
            'readTotpDataExceptionType',
            ReadTotpDataExceptionType.secretNotFound,
          ),
        ),
      );
    });
  });
}
