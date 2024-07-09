import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.encryptedMasterKey;
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    actualSecureStorageKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() {
    testDatabase = TestDatabase(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of initial database state', () {
    test('Should [return encrypted master key] as ["encryptedMasterKey" key value EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await const FlutterSecureStorage().readAll();

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{
        'encryptedMasterKey':
            '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      };

      expect(actualGroupsMap, expectedGroupsMap);
    });

    test('Should [return EMPTY map] as ["encryptedMasterKey" key value is EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualGroupsMap = await const FlutterSecureStorage().readAll();

      // Assert
      Map<String, dynamic> expectedGroupsMap = <String, dynamic>{};

      expect(actualGroupsMap, expectedGroupsMap);
    });
  });

  group('Tests of MasterKeyRepository.isMasterKeyExists()', () {
    test('Should [return TRUE] if [master key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      bool actualSaltExistValue = await globalLocator<MasterKeyRepository>().isMasterKeyExists();

      //  Assert
      expect(actualSaltExistValue, true);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      //  Act
      bool actualIsSaltExists = await globalLocator<MasterKeyRepository>().isMasterKeyExists();

      // Assert
      expect(actualIsSaltExists, false);
    });
  });

  group('Tests of MasterKeyRepository.getMasterKey()', () {
    test('Should [return hash] if [master key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      String actualMasterKey = await globalLocator<MasterKeyRepository>().getMasterKey();

      // Assert
      String expectedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      expect(actualMasterKey, expectedMasterKey);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
        () => globalLocator<MasterKeyRepository>().getMasterKey(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of MasterKeyRepository.setMasterKey()', () {
    test('Should [UPDATE hash] if [master key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      await globalLocator<MasterKeyRepository>().setMasterKey(
        'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==',
      );
      String? actualMasterKey = await actualFlutterSecureStorage.read(key: actualSecureStorageKey.name);

      // Assert
      String expectedMasterKey =
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==';

      expect(actualMasterKey, expectedMasterKey);
    });

    test('Should [SAVE hash] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      await globalLocator<MasterKeyRepository>().setMasterKey(
        '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );
      String? actualEncryptedMasterKey = await actualFlutterSecureStorage.read(key: actualSecureStorageKey.name);

      // Assert
      String expectedEncryptedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      expect(actualEncryptedMasterKey, expectedEncryptedMasterKey);
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}
