import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/services/isar_database_version_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_database.dart';

/*void main() {
  final TestDatabase testDatabase = TestDatabase();

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.isarDatabaseVersion;

  // @formatter:off
  Map<String, String> filledIsarDatabaseVersionDatabase = <String, String>{
    actualSecureStorageKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of IsarDatabaseVersionService.getIsarDatabaseVersion()', () { // TODO(kamil): descs
    test('Should [return IsarDatabaseVersionVO] if [Isar database version EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledIsarDatabaseVersionDatabase);

      // Act
      IsarDatabaseVersionVO actualIsarDatabaseVersionVO = await globalLocator<IsarDatabaseVersionService>().getIsarDatabaseVersion();

      // Assert
      // @formatter:off
      IsarDatabaseVersionVO expectedIsarDatabaseVersionVO = const IsarDatabaseVersionVO(
        encryptedIsarDatabaseVersion: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );
      // @formatter:on

      expect(actualIsarDatabaseVersionVO, expectedIsarDatabaseVersionVO);
    });

    test('Should [throw ParentKeyNotFoundException] if [Isar database version NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
            () => globalLocator<IsarDatabaseVersionService>().getIsarDatabaseVersion(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of IsarDatabaseVersionService.isIsarDatabaseVersionExists()', () {
    test('Should [return TRUE] if [Isar database version EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledIsarDatabaseVersionDatabase);

      // Act
      bool actualIsarDatabaseVersionExistsBool = await globalLocator<IsarDatabaseVersionService>().isIsarDatabaseVersionExists();

      // Assert
      expect(actualIsarDatabaseVersionExistsBool, true);
    });

    test('Should [return FALSE] if [Isar database version NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      bool actualIsarDatabaseVersionExistsBool = await globalLocator<IsarDatabaseVersionService>().isIsarDatabaseVersionExists();

      // Assert
      expect(actualIsarDatabaseVersionExistsBool, false);
    });
  });

  group('Tests of IsarDatabaseVersionService.setIsarDatabaseVersion()', () {
    test('Should [UPDATE hash] in database if [Isar database version EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledIsarDatabaseVersionDatabase);

      IsarDatabaseVersionVO actualIsarDatabaseVersionVO = const IsarDatabaseVersionVO(
        encryptedIsarDatabaseVersion:
        'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==',
      );

      // Act
      await globalLocator<IsarDatabaseVersionService>().setIsarDatabaseVersion(actualIsarDatabaseVersionVO);
      String? actualIsarDatabaseVersion = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Assert
      String expectedIsarDatabaseVersion =
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==';

      expect(actualIsarDatabaseVersion, expectedIsarDatabaseVersion);
    });

    test('Should [SAVE hash] in database if [Isar database version NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      IsarDatabaseVersionVO actualIsarDatabaseVersionVO = const IsarDatabaseVersionVO(
        encryptedIsarDatabaseVersion:
        '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );

      // Act
      await globalLocator<IsarDatabaseVersionService>().setIsarDatabaseVersion(actualIsarDatabaseVersionVO);
      String? actualIsarDatabaseVersion = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Assert
      String expectedIsarDatabaseVersion =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      expect(actualIsarDatabaseVersion, expectedIsarDatabaseVersion);
    });
  });

  tearDown(testDatabase.close);
}*/
