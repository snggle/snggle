import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/repositories/isar_database_version_repository.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final TestDatabase testDatabase = TestDatabase();
  const SecureStorageKey actualSecureStorageKey = SecureStorageKey.isarDatabaseVersion;
  const FlutterSecureStorage actualFlutterSecureStorage = FlutterSecureStorage();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of IsarDatabaseVersionRepository.isIsarDatabaseVersionExists()', () {
    /*test('Should [return TRUE] if [Isar database version EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool actualSaltExistValue = await globalLocator<IsarDatabaseVersionRepository>().isIsarDatabaseVersionExists();

      //  Assert
      expect(actualSaltExistValue, true);
    });*/

    test('Should [return FALSE] if [Isar database version NOT EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      //  Act
      bool actualIsSaltExists = await globalLocator<IsarDatabaseVersionRepository>().isIsarDatabaseVersionExists();

      // Assert
      expect(actualIsSaltExists, false);
    });
  });

  /*group('Tests of IsarDatabaseVersionRepository.getIsarDatabaseVersion()', () {
    test('Should [return hash] if [Isar database version EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      String actualIsarDatabaseVersion = await globalLocator<IsarDatabaseVersionRepository>().getIsarDatabaseVersion();

      // Assert
      String expectedIsarDatabaseVersion = 'FhSf0rK3enK3orHHM4McWIYhZ8YiT0V3mn6rTyWScdPYgaO+McvLXYtcGAX2CGNFQYLdYsEzwXO/DcMGjSICqa0nFdE=';

      expect(actualIsarDatabaseVersion, expectedIsarDatabaseVersion);
    });

    test('Should [throw ParentKeyNotFoundException] if [Isar database version NOT EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
            () => globalLocator<IsarDatabaseVersionRepository>().getIsarDatabaseVersion(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of IsarDatabaseVersionRepository.setIsarDatabaseVersion()', () {
    test('Should [UPDATE hash] if [Isar database version EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<IsarDatabaseVersionRepository>().setIsarDatabaseVersion(
        'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==',
      );
      String? actualIsarDatabaseVersion = await actualFlutterSecureStorage.read(key: actualSecureStorageKey.name);

      // Assert
      String expectedIsarDatabaseVersion =
          'CvujNlKB9l03/Aw2f5+9TW0RxG6ZmNgjmjNJaL48bAY+xn8WiMQJZjposoDQfrB3ZVZwIANxSC5A/EOYto5OFgGRTWVheYH3p8j/w2mMm/lztuoCTie6rddSm4iwY03JWWXK4w==';

      expect(actualIsarDatabaseVersion, expectedIsarDatabaseVersion);
    });

    test('Should [SAVE hash] if [Isar database version NOT EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      await globalLocator<IsarDatabaseVersionRepository>().setIsarDatabaseVersion(
        '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      );
      String? actualEncryptedIsarDatabaseVersion = await actualFlutterSecureStorage.read(key: actualSecureStorageKey.name);

      // Assert
      String expectedEncryptedIsarDatabaseVersion =
          '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==';

      expect(actualEncryptedIsarDatabaseVersion, expectedEncryptedIsarDatabaseVersion);
    });
  });*/

  tearDown(testDatabase.close);
}
