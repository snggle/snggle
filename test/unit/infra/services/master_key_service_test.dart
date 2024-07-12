import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.encryptedMasterKey;

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    actualSecureStorageKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of MasterKeyService.getMasterKey()', () {
    test('Should [return MasterKeyVO] if [master key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      MasterKeyVO actualMasterKeyVO = await globalLocator<MasterKeyService>().getMasterKey();

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
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
        () => globalLocator<MasterKeyService>().getMasterKey(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of MasterKeyService.isMasterKeyExists()', () {
    test('Should [return TRUE] if [master key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      bool actualMasterKeyExistsBool = await globalLocator<MasterKeyService>().isMasterKeyExists();

      // Assert
      expect(actualMasterKeyExistsBool, true);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      bool actualMasterKeyExistsBool = await globalLocator<MasterKeyService>().isMasterKeyExists();

      // Assert
      expect(actualMasterKeyExistsBool, false);
    });
  });

  group('Tests of MasterKeyService.setDefaultMasterKey()', () {
    test('Should [CREATE and SAVE default master key] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      await globalLocator<MasterKeyService>().setDefaultMasterKey();
      String? actualEncryptedMasterKey = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Since result of setDefaultMasterKey() method is always random, we are not able to predict the expected value of "encryptedMasterKey".
      // However, generated data should be encrypted via default password, so we can check if we can decrypt hash using this password.
      bool actualDefaultPasswordValid = PasswordModel.defaultPassword().isValidForData(actualEncryptedMasterKey!);

      // Assert
      expect(actualDefaultPasswordValid, true);
    });
  });

  group('Tests of MasterKeyService.setMasterKey()', () {
    test('Should [UPDATE hash] in database if [master key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
        encryptedMasterKey:
            'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==',
      );

      // Act
      await globalLocator<MasterKeyService>().setMasterKey(actualMasterKeyVO);
      String? actualMasterKey = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Assert
      String expectedMasterKey =
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==';

      expect(actualMasterKey, expectedMasterKey);
    });

    test('Should [SAVE hash] in database if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
        encryptedMasterKey:
            '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );

      // Act
      await globalLocator<MasterKeyService>().setMasterKey(actualMasterKeyVO);
      String? actualMasterKey = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Assert
      String expectedMasterKey =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      expect(actualMasterKey, expectedMasterKey);
    });
  });

  tearDown(testDatabase.close);
}
