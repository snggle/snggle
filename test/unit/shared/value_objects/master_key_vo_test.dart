import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

void main() {
  group('Tests of MasterKeyVO.create()', () {
    test('Should [CREATE MasterKeyVO] from given MnemonicModel and encrypt it using given PasswordModel', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
      MnemonicModel actualMnemonicModel = MnemonicModel.fromString('card point display humble luxury detail exchange blast stage relax pear evolve');
      String actualPasswordHash = 'XohImNooBHFR0OVvjcYpJ3NgPQ1qq73WKhHvch0VQtg=';

      // Act
      MasterKeyVO actualMasterKeyVO = await MasterKeyVO.create(mnemonicModel: actualMnemonicModel, passwordModel: actualPasswordModel);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode masterKey hash
      String actualDecryptedMasterKey = Aes256.decrypt(actualPasswordHash, actualMasterKeyVO.encryptedMasterKey);

      // Assert
      String expectedDecryptedMasterKey = 'MbE9pafRXdsfe9m9488D27zqwXz2BOdy3FPjlW3M9+I=';

      expect(actualDecryptedMasterKey, expectedDecryptedMasterKey);
    });
  });

  group('Tests of MasterKeyVO.encryptedMasterKey getter', () {
    test('Should [return master key] from MasterKeyVO', () {
      // Arrange
      // @formatter:off
      MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: 'oEGBHJUZ6pw8dF2g6YAz4gmuhTj9x5MN8J2mZDzpoNQ1lDFEUl+hNklVnNJIEbhBXAtnrxo2ghNiiGuRC84LEff+AUEN8Na6+avqOVK+Csf6fS2JwjxJPRhD0mFuKP1QcGdV2g==');
      // @formatter:on

      // Act
      String actualEncryptedMasterKey = actualMasterKeyVO.encryptedMasterKey;

      // Assert
      String expectedEncryptedMasterKey =
          'oEGBHJUZ6pw8dF2g6YAz4gmuhTj9x5MN8J2mZDzpoNQ1lDFEUl+hNklVnNJIEbhBXAtnrxo2ghNiiGuRC84LEff+AUEN8Na6+avqOVK+Csf6fS2JwjxJPRhD0mFuKP1QcGdV2g==';

      expect(actualEncryptedMasterKey, expectedEncryptedMasterKey);
    });
  });

  group('Tests of MasterKeyVO.encrypt()', () {
    test('Should [return hash] representing given data encrypted by master key', () {
      // Arrange
      // @formatter:off
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
      MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: 'oEGBHJUZ6pw8dF2g6YAz4gmuhTj9x5MN8J2mZDzpoNQ1lDFEUl+hNklVnNJIEbhBXAtnrxo2ghNiiGuRC84LEff+AUEN8Na6+avqOVK+Csf6fS2JwjxJPRhD0mFuKP1QcGdV2g==');
      String actualDecryptedMasterKey = '31b13da5a7d15ddb1f7bd9bde3cf03dbbceac17cf604e772dc53e3956dccf7e2';
      // @formatter:on

      // Act
      String actualEncryptedData = actualMasterKeyVO.encrypt(appPasswordModel: actualPasswordModel, decryptedData: 'decrypted_data');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to encode and decode hash
      String actualDecryptedData = Aes256.decrypt(actualDecryptedMasterKey, actualEncryptedData);

      // Assert
      String expectedDecryptedData = 'decrypted_data';

      expect(actualDecryptedData, expectedDecryptedData);
    });

    group('Tests of MasterKeyVO.decrypt()', () {
      test('Should [return decrypted hash] if used [MasterKeyVO VALID]', () {
        // Arrange
        // @formatter:off
        PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
        MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: 'oEGBHJUZ6pw8dF2g6YAz4gmuhTj9x5MN8J2mZDzpoNQ1lDFEUl+hNklVnNJIEbhBXAtnrxo2ghNiiGuRC84LEff+AUEN8Na6+avqOVK+Csf6fS2JwjxJPRhD0mFuKP1QcGdV2g==');
        String actualEncryptedData = 'QcC813A2Pgt7bSkY3oGEueFIqlL4zg2oJamZXih+EEWjH4Xg';
        // @formatter:on

        // Act
        String actualDecryptedData = actualMasterKeyVO.decrypt(appPasswordModel: actualPasswordModel, encryptedData: actualEncryptedData);

        // Assert
        String expectedDecryptedData = 'decrypted_data';

        expect(actualDecryptedData, expectedDecryptedData);
      });

      test('Should [throw ArgumentError] if used [MasterKeyVO INVALID]', () {
        // Arrange
        // @formatter:off
        PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
        MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: 'EihTBi6rJuI0Kwn4Ksr71yBgnRpn8dMHAL6Qyswy6pMQ329nAHj7hv+mptMKq+JARFfVD7C4Iw7cXP8s8TGWDJEev/DBNAQxmICzTInECw2CVitdQbl6UNv63+2eJ94nJE/i4A==');
        String actualEncryptedData = 'QcC813A2Pgt7bSkY3oGEueFIqlL4zg2oJamZXih+EEWjH4Xg';
        // @formatter:on

        // Assert
        expect(
          () => actualMasterKeyVO.decrypt(appPasswordModel: actualPasswordModel, encryptedData: actualEncryptedData),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('Should [throw InvalidPasswordException] if used [PasswordModel INVALID]', () {
        // Arrange
        // @formatter:off
        PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');
        MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: 'oEGBHJUZ6pw8dF2g6YAz4gmuhTj9x5MN8J2mZDzpoNQ1lDFEUl+hNklVnNJIEbhBXAtnrxo2ghNiiGuRC84LEff+AUEN8Na6+avqOVK+Csf6fS2JwjxJPRhD0mFuKP1QcGdV2g==');
        String actualEncryptedData = 'QcC813A2Pgt7bSkY3oGEueFIqlL4zg2oJamZXih+EEWjH4Xg';
        // @formatter:on

        // Assert
        expect(
          () => actualMasterKeyVO.decrypt(appPasswordModel: actualPasswordModel, encryptedData: actualEncryptedData),
          throwsA(isA<InvalidPasswordException>()),
        );
      });
    });
  });
}
