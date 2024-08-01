import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  PasswordModel actualPasswordModel1111 = PasswordModel.fromPlaintext('1111');
  PasswordModel actualPasswordModel9999 = PasswordModel.fromPlaintext('9999');

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of AppAuthService.isCustomPasswordSet()', () {
    test('Should [return TRUE] if [master key EXISTS] in database and [encrypted with CUSTOM PASSWORD]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      bool actualPasswordSetBool = await globalLocator<AppAuthService>().isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, true);
    });

    test('Should [return FALSE] if [master key EXISTS] in database and [encrypted with DEFAULT PASSWORD]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      bool actualPasswordSetBool = await globalLocator<AppAuthService>().isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, false);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      bool actualPasswordSetBool = await globalLocator<AppAuthService>().isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, false);
    });
  });

  group('Tests of AppAuthService.isPasswordValid()', () {
    test('Should [return TRUE] if [master key EXISTS] in database and given [password VALID]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      bool actualPasswordValidBool = await globalLocator<AppAuthService>().isPasswordValid(actualPasswordModel1111);

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [master key EXISTS] in database and given [password INVALID]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledMasterKeyDatabase);

      // Act
      bool actualPasswordValidBool = await globalLocator<AppAuthService>().isPasswordValid(actualPasswordModel9999);

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
        () => globalLocator<AppAuthService>().isPasswordValid(actualPasswordModel9999),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
