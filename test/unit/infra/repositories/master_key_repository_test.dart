import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';

import '../../../utils/test_utils.dart';

void main() {
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  MasterKeyRepository actualMasterKeyRepository = MasterKeyRepository();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.encryptedMasterKey;

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    actualDatabaseParentKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  group('Tests of MasterKeyRepository.isMasterKeyExists()', () {
    test('Should [return TRUE] if [master key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      bool actualSaltExistValue = await actualMasterKeyRepository.isMasterKeyExists();

      //  Assert
      expect(actualSaltExistValue, true);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      //  Act
      bool actualIsSaltExists = await actualMasterKeyRepository.isMasterKeyExists();

      // Assert
      expect(actualIsSaltExists, false);
    });
  });

  group('Tests of MasterKeyRepository.getMasterKey()', () {
    test('Should [return hash] if [master key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      String actualMasterKey = await actualMasterKeyRepository.getMasterKey();

      // Assert
      String expectedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      expect(actualMasterKey, expectedMasterKey);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Assert
      expect(
        () => actualMasterKeyRepository.getMasterKey(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of MasterKeyRepository.setMasterKey()', () {
    test('Should [SAVE hash] if [master key NOT EXISTS] in database', () async {
      // Act
      String? actualEncryptedMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as [master key NOT EXISTS] in database, hence data is empty/null');
      expect(actualEncryptedMasterKey, null);

      // ********************************************************************************************************************

      // Act
      await actualMasterKeyRepository.setMasterKey(
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');
      actualEncryptedMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedEncryptedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      TestUtils.printInfo('Should [return master key] after saving it in database');
      expect(actualEncryptedMasterKey, expectedEncryptedMasterKey);
    });

    test('Should [UPDATE hash] if [master key NOT EXISTS] in database', () async {
      // Arrange
      // @formatter:off
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        actualDatabaseParentKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      });
      // @formatter:on

      // Act
      String? actualMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      TestUtils.printInfo('Should [return master key] as [it already EXISTS] in database');
      expect(actualMasterKey, expectedMasterKey);

      // ********************************************************************************************************************

      // Act
      await actualMasterKeyRepository.setMasterKey(
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==');
      actualMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedMasterKey =
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==';

      TestUtils.printInfo('Should [return master key] after saving it in database');
      expect(actualMasterKey, expectedMasterKey);
    });
  });
}
