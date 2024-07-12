import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/repositories/master_key_repository.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  const SecureStorageKey actualSecureStorageKey = SecureStorageKey.encryptedMasterKey;
  const FlutterSecureStorage actualFlutterSecureStorage = FlutterSecureStorage();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of MasterKeyRepository.isMasterKeyExists()', () {
    test('Should [return TRUE] if [master key EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      bool actualSaltExistValue = await globalLocator<MasterKeyRepository>().isMasterKeyExists();

      //  Assert
      expect(actualSaltExistValue, true);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      //  Act
      bool actualIsSaltExists = await globalLocator<MasterKeyRepository>().isMasterKeyExists();

      // Assert
      expect(actualIsSaltExists, false);
    });
  });

  group('Tests of MasterKeyRepository.getMasterKey()', () {
    test('Should [return hash] if [master key EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      String actualMasterKey = await globalLocator<MasterKeyRepository>().getMasterKey();

      // Assert
      String expectedMasterKey = 'FhSf0rK3enK3orHHM4McWIYhZ8YiT0V3mn6rTyWScdPYgaO+McvLXYtcGAX2CGNFQYLdYsEzwXO/DcMGjSICqa0nFdE=';

      expect(actualMasterKey, expectedMasterKey);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
        () => globalLocator<MasterKeyRepository>().getMasterKey(),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of MasterKeyRepository.setMasterKey()', () {
    test('Should [UPDATE hash] if [master key EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

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

    test('Should [SAVE hash] if [master key NOT EXISTS] in secure storage', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

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

  tearDown(testDatabase.close);
}
