import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/multi_password_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

void main() {
  group('Tests of [MultiPasswordModel] constructors', () {
    group('Tests of MultiPasswordModel.fromPlaintext() constructor', () {
      test('Should [return MultiPasswordModel] containing provided password as main password', () {
        // Act
        MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('password');

        // Assert
        MultiPasswordModel expectedMultiPasswordModel = const MultiPasswordModel(
          mainPasswordModel: PasswordModel(hashedPassword: 'XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg='),
        );

        expect(actualMultiPasswordModel, expectedMultiPasswordModel);
      });
    });

    group('Tests of PasswordModel.defaultPassword() constructor', () {
      test('Should [return PasswordModel] containing default password as main password', () {
        // Act
        MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.defaultPassword();

        // Assert
        MultiPasswordModel expectedMultiPasswordModel = const MultiPasswordModel(
          mainPasswordModel: PasswordModel(hashedPassword: 'NPm7bEvcQPfAKHyf3OgSyLSZnlmVmfoft41RlgJDV8A='),
        );

        expect(actualMultiPasswordModel, expectedMultiPasswordModel);
      });
    });
  });

  group('Tests of MultiPasswordModel.extend()', () {
    test('Should [return MultiPasswordModel] extended from parent MultiPasswordModel (single password)', () {
      // Arrange
      MultiPasswordModel actualParentMultiPasswordModel = MultiPasswordModel.fromPlaintext('parent_password');

      // Act
      MultiPasswordModel actualExtendedMultiPasswordModel = actualParentMultiPasswordModel.extend(PasswordModel.fromPlaintext('child_password_1'));

      // Assert
      MultiPasswordModel expectedExtendedMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: '3nYpLJdfLcmjo8w5eyQoDHJa05Est/B0mKD4KaKbo1I='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'MlTfCSnflNF3BnDIzgT6TBDeC+a4s1k4o2bLVkGw2uk='),
        ],
      );

      expect(actualExtendedMultiPasswordModel, expectedExtendedMultiPasswordModel);
    });

    test('Should [return MultiPasswordModel] extended from parent MultiPasswordModel (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
        ],
      );

      // Act
      MultiPasswordModel actualExtendedMultiPasswordModel = actualMultiPasswordModel.extend(PasswordModel.fromPlaintext('main_password'));

      // Assert
      MultiPasswordModel expectedExtendedMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0=')
        ],
      );

      expect(actualExtendedMultiPasswordModel, expectedExtendedMultiPasswordModel);
    });
  });

  group('Tests of MultiPasswordModel.encrypt()', () {
    test('Should [return encrypted data] representing given data encrypted by MultiPasswordModel (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('password');

      // Act
      String actualEncryptedData = actualMultiPasswordModel.encrypt(decryptedData: 'decrypted_data');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode text
      String actualDecryptedData = Aes256.decrypt('XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg=', actualEncryptedData);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [return encrypted data] representing given data encrypted by MultiPasswordModel (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );

      // Act
      String actualEncryptedData = actualMultiPasswordModel.encrypt(decryptedData: 'decrypted_data');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode text
      String actualDecryptedData = actualEncryptedData;
      actualDecryptedData = Aes256.decrypt('iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY=', actualDecryptedData);
      actualDecryptedData = Aes256.decrypt('KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0=', actualDecryptedData);
      actualDecryptedData = Aes256.decrypt('f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ=', actualDecryptedData);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });
  });

  group('Tests of MultiPasswordModel.decrypt()', () {
    test('Should [return decrypted data] if used [MultiPasswordModel VALID] (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('password');
      String actualEncryptedData = 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB';

      // Act
      String actualDecryptedData = actualMultiPasswordModel.decrypt(encryptedData: actualEncryptedData);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [return decrypted data] if used [MultiPasswordModel VALID] (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Act
      String actualDecryptedData = actualMultiPasswordModel.decrypt(encryptedData: actualEncryptedData);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('invalid_password');
      String actualEncryptedData = 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB';

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(encryptedData: actualEncryptedData),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (multiple passwords) (FIRST parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'invalid_password'),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(encryptedData: actualEncryptedData),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (multiple passwords) (NEXT parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'invalid_password'),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(encryptedData: actualEncryptedData),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if used [MultiPasswordModel INVALID] (multiple passwords) (MAIN password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'invalid_password'),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Assert
      expect(
        () => actualMultiPasswordModel.decrypt(encryptedData: actualEncryptedData),
        throwsA(isA<InvalidPasswordException>()),
      );
    });
  });

  group('Tests of MultiPasswordModel.isValidForData()', () {
    test('Should [return TRUE] if MultiPasswordModel [CAN decrypt] given String (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('password');
      String actualEncryptedData = 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB';

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualEncryptedData);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should [return TRUE] if MultiPasswordModel [CAN decrypt] given String (multiple passwords)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualEncryptedData);

      // Assert
      expect(actualPasswordValid, true);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (single password)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = MultiPasswordModel.fromPlaintext('invalid_password');
      String actualEncryptedData = 'gk8RMwEXLBF8Z1tY7O938VO7XxqvshT29Uky/EVE215vm1zB';

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualEncryptedData);

      // Assert
      expect(actualPasswordValid, false);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (multiple passwords) (FIRST parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'invalid_password'),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualEncryptedData);

      // Assert
      expect(actualPasswordValid, false);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (multiple passwords) (NEXT parent password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'f0FVWnH9w8uXEpcX2Br1cx0Yz39xqWFPuQOkKoPfgCQ='),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'invalid_password'),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualEncryptedData);

      // Assert
      expect(actualPasswordValid, false);
    });

    test('Should [return FALSE] if MultiPasswordModel [CANNOT decrypt] given String (multiple passwords) (MAIN password invalid)', () {
      // Arrange
      MultiPasswordModel actualMultiPasswordModel = const MultiPasswordModel(
        mainPasswordModel: PasswordModel(hashedPassword: 'invalid_password'),
        parentPasswordModels: <PasswordModel>[
          PasswordModel(hashedPassword: 'iBAe5t+zEAt77Dk0vwzQS9l8yGFHXx7zzApdv5xvWTY='),
          PasswordModel(hashedPassword: 'KfBIwCY8CBjO2TMavzoNzcqykOPMLJydZ1myYOyvpx0='),
        ],
      );
      String actualEncryptedData =
          '1yzffzMJSgPc7dSYBnL0eldJyf1zHm1Vmf7P+OCb5/7zRbBZK1cD6urUIEMgpJNci+849Vwlilet8WS6yoTr8vlXuVRISUArDWYYvAO4D2Hn+V7xJ/lUpD/LM2FLOuZYFGx7lj3TbjEFfZ+twfZvsxZYzS6ECvS3Z6nDLZtDCT1XhRiGFOp9SSExGHX5xxKCVGlpFA==';

      // Act
      bool actualPasswordValid = actualMultiPasswordModel.isValidForData(actualEncryptedData);

      // Assert
      expect(actualPasswordValid, false);
    });
  });
}
