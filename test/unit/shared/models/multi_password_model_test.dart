import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/multi_password_model.dart';
import 'package:snggle/shared/models/password_model.dart';

void main() {
  String actualMainPasswordHash = 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ=';
  String actualChildPasswordHash1 = '3nYpLJdfLcmjo8w5eyQoDHJa05Est/B0mKD4KaKbo1I=';
  String actualChildPasswordHash2 = 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0=';
  String actualDefaultPasswordHash = 'NPm7bEvcQPfAKHyf3OgSyLSZnlmVmfoft41RlgJDV8A=';

  group('Tests of [MultiPasswordModel] constructors', () {
    group('Tests of MultiPasswordModel.fromPlaintext() constructor', () {
      test('Should [return MultiPasswordModel] containing provided password as main password', () {
        // Act
        MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('main_password');

        // Assert
        MultiPasswordModel expectedMultiPasswordModel = MultiPasswordModel(
          mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        );

        expect(actualMultiPasswordModel, expectedMultiPasswordModel);
      });
    });

    group('Tests of PasswordModel.defaultPassword() constructor', () {
      test('Should [return PasswordModel] containing default password as main password', () {
        // Act
        MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.defaultPassword();

        // Assert
        MultiPasswordModel expectedMultiPasswordModel = MultiPasswordModel(
          mainPasswordModel: PasswordModel(hashedPassword: actualDefaultPasswordHash),
        );

        expect(actualMultiPasswordModel, expectedMultiPasswordModel);
      });
    });
  });

  group('Tests of MultiPasswordModel.extend()', () {
    test('Should [return MultiPasswordModel] extended from parent MultiPasswordModel (single password)', () {
      // Arrange
      MultiPasswordModel actualParentMultiPasswordModel = MultiPasswordModel.fromPlaintext('main_password');

      // Act
      MultiPasswordModel actualExtendedMultiPasswordModel = actualParentMultiPasswordModel.extend(PasswordModel.fromPlaintext('child_password_1'));

      // Assert
      MultiPasswordModel expectedExtendedMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualChildPasswordHash1),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualMainPasswordHash),
        ],
      );

      expect(actualExtendedMultiPasswordModel, expectedExtendedMultiPasswordModel);
    });

    test('Should [return MultiPasswordModel] extended from parent MultiPasswordModel (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualChildPasswordHash2),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
        ],
      );

      // Act
      MultiPasswordModel actualExtendedMultiPasswordModel = actualMultiPasswordModel.extend(PasswordModel.fromPlaintext('main_password'));

      // Assert
      MultiPasswordModel expectedExtendedMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[PasswordModel(hashedPassword: actualChildPasswordHash1), PasswordModel(hashedPassword: actualChildPasswordHash2)],
      );

      expect(actualExtendedMultiPasswordModel, expectedExtendedMultiPasswordModel);
    });
  });

  group('Tests of MultiPasswordModel.encrypt()', () {
    test('Should [return Ciphertext] representing given data encrypted by MultiPasswordModel (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('main_password');

      // Act
      Ciphertext actualCiphertext = actualMultiPasswordModel.encrypt(decryptedData: 'decrypted_data');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode text
      String actualDecryptedData = AESDHKEV1().decrypt(actualMainPasswordHash, actualCiphertext);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [return Ciphertext] representing given data encrypted by MultiPasswordModel (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );

      // Act
      Ciphertext actualCiphertext = actualMultiPasswordModel.encrypt(decryptedData: 'decrypted_data');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode text
      Ciphertext actualDecryptedCiphertext;
      actualDecryptedCiphertext = Ciphertext.fromJsonString(AESDHKEV1().decrypt(actualChildPasswordHash1, actualCiphertext));
      actualDecryptedCiphertext = Ciphertext.fromJsonString(AESDHKEV1().decrypt(actualChildPasswordHash2, actualDecryptedCiphertext));

      String actualDecryptedData = AESDHKEV1().decrypt(actualMainPasswordHash, actualDecryptedCiphertext);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });
  });

  group('Tests of MultiPasswordModel.decrypt()', () {
    test('Should [return decrypted data] if used [MultiPasswordModel VALID] (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('main_password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64: 'uP2lpy2e5MTUbB0r34lzOKmr+HaQcWXec8nTKoFS+b3n/Psb',
      );

      // Act
      String actualDecryptedData = actualMultiPasswordModel.decrypt(ciphertext: actualCiphertext);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [return decrypted data] if used [MultiPasswordModel VALID] (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );

      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Act
      String actualDecryptedData = actualMultiPasswordModel.decrypt(ciphertext: actualCiphertext);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('invalid_password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64: 'uP2lpy2e5MTUbB0r34lzOKmr+HaQcWXec8nTKoFS+b3n/Psb',
      );

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(ciphertext: actualCiphertext),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (multiple passwords) (FIRST parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          const PasswordModel(hashedPassword: 'invalid_password'),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(ciphertext: actualCiphertext),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (multiple passwords) (NEXT parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          const PasswordModel(hashedPassword: 'invalid_password'),
        ],
      );
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(ciphertext: actualCiphertext),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (multiple passwords) (MAIN password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: const PasswordModel(hashedPassword: 'invalid_password'),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );

      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(ciphertext: actualCiphertext),
        throwsA(isA<InvalidPasswordException>()),
      );
    });
  });

  group('Tests of MultiPasswordModel.isValidForData()', () {
    test('Should [return TRUE] if MultiPasswordModel [CAN decrypt] given String (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('main_password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64: 'uP2lpy2e5MTUbB0r34lzOKmr+HaQcWXec8nTKoFS+b3n/Psb',
      );

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should [return TRUE] if MultiPasswordModel [CAN decrypt] given String (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );

      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('invalid_password');
      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64: 'uP2lpy2e5MTUbB0r34lzOKmr+HaQcWXec8nTKoFS+b3n/Psb',
      );

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, false);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (multiple passwords) (FIRST parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          const PasswordModel(hashedPassword: 'invalid_password'),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );

      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, false);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (multiple passwords) (NEXT parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: actualMainPasswordHash),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          const PasswordModel(hashedPassword: 'invalid_password'),
        ],
      );

      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, false);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (multiple passwords) (MAIN password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel(
        mainPasswordModel: const PasswordModel(hashedPassword: 'invalid_password'),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: actualChildPasswordHash1),
          PasswordModel(hashedPassword: actualChildPasswordHash2),
        ],
      );

      Ciphertext actualCiphertext = Ciphertext.fromBase64(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        base64:
            'IosSXT76BRG/KZt4JeSjyj1cHo8Vfn7OFcOy+DqbgWxFN8AiKsHoIrPrqlpMqnGlIQ8OEXkmQLF5f2XByvBkc16WRJlHMjcBNSyOzg7IMprJj2lAXVq3K+8G+HYHZBSOD4tyZVXLrUELAutFOBoGZiay6srU6e+qrv1M4mfq4xBZSC+e5yPPjwcDtTYSivkRRv2dTAJeXADor4tWtG+w67Q5UdXyPvY03oO09iYCbd/6Oa2AjznkAADSRbGweZz+0xvpSuBZakcJdCNJQ4fegxkhrdg=',
      );
      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualCiphertext);

      // Assert
      expect(actualPasswordValid, false);
    });
  });
}
