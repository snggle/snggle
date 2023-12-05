import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  MasterKeyService actualMasterKeyService = MasterKeyService();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.encryptedMasterKey;

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    actualDatabaseParentKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  group('Tests of MasterKeyService.getMasterKey()', () {
    test('Should [return MasterKeyVO] if [master key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      MasterKeyVO actualMasterKeyVO = await actualMasterKeyService.getMasterKey();

      // Assert
      // @formatter:off
      MasterKeyVO expectedMasterKeyVO = const MasterKeyVO(
        encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );
      // @formatter:on

      expect(actualMasterKeyVO, expectedMasterKeyVO);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Assert
      expect(
        () => actualMasterKeyService.getMasterKey(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of MasterKeyService.isMasterKeyExists()', () {
    test('Should [return TRUE] if [master key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      bool actualMasterKeyExistsBool = await actualMasterKeyService.isMasterKeyExists();

      // Assert
      expect(actualMasterKeyExistsBool, true);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Act
      bool actualMasterKeyExistsBool = await actualMasterKeyService.isMasterKeyExists();

      // Assert
      expect(actualMasterKeyExistsBool, false);
    });
  });

  group('Tests of MasterKeyService.setDefaultMasterKey()', () {
    test('Should [CREATE and SAVE default master key] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Act
      String? actualEncryptedMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as [master key NOT EXISTS] in database, hence data is empty/null');
      expect(actualEncryptedMasterKey, null);

      // ********************************************************************************************************************

      // Act
      await actualMasterKeyService.setDefaultMasterKey();
      actualEncryptedMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Since result of setDefaultMasterKey() method is always random, we are not able to predict the expected value of "encryptedMasterKey".
      // However, generated data should be encrypted via default password, so we can check if we can decrypt hash using this password.
      bool actualDefaultPasswordValid = PasswordModel.defaultPassword().isValidForData(actualEncryptedMasterKey!);

      // Assert
      TestUtils.printInfo('Should [return TRUE] if default password is valid for master key');
      expect(actualDefaultPasswordValid, true);
    });
  });

  group('Tests of MasterKeyService.setMasterKey()', () {
    test('Should [UPDATE hash] in database if [master key EXISTS] in database', () async {
      // Arrange
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      String? actualMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      TestUtils.printInfo('Should [return hash] as [master key EXISTS] in database');
      expect(actualMasterKey, expectedMasterKey);

      // ********************************************************************************************************************

      // Arrange
      // @formatter:off
      MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
        encryptedMasterKey: 'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==',
      );
      // @formatter:on

      // Act
      await actualMasterKeyService.setMasterKey(actualMasterKeyVO);
      actualMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedMasterKey =
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==';

      TestUtils.printInfo('Should [return master key] after saving it in database');
      expect(actualMasterKey, expectedMasterKey);
    });

    test('Should [SAVE hash] in database if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Act
      String? actualMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as [master key NOT EXISTS] in database, hence data is empty/null');
      expect(actualMasterKey, null);

      // ********************************************************************************************************************

      // Arrange
      MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
        encryptedMasterKey:
            '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );

      // Act
      await actualMasterKeyService.setMasterKey(actualMasterKeyVO);
      actualMasterKey = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      TestUtils.printInfo('Should [return master key] after saving it in database');
      expect(actualMasterKey, expectedMasterKey);
    });
  });
}
