import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/shared/models/password_model.dart';

void main() {
  initLocator();
  AppAuthService actualAppAuthService = AppAuthService();

  PasswordModel actualPasswordModel1111 = PasswordModel.fromPlaintext('1111');
  PasswordModel actualPasswordModel9999 = PasswordModel.fromPlaintext('9999');

  String wrappedMasterKey = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg=='
  }, prettyPrintBool: true);

  Map<String, String> filledMasterKeyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: wrappedMasterKey,
  };

  Map<String, String> emptyDatabase = <String, String>{};

  group('Tests of AppAuthService.isCustomPasswordSet()', () {
    test('Should [return TRUE] if [master key EXISTS] in database and [encrypted with CUSTOM PASSWORD]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      bool actualPasswordSetBool = await actualAppAuthService.isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, true);
    });

    test('Should [return FALSE] if [master key EXISTS] in database and [encrypted with DEFAULT PASSWORD]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Act
      bool actualPasswordSetBool = await actualAppAuthService.isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, false);
    });

    test('Should [return FALSE] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Act
      bool actualPasswordSetBool = await actualAppAuthService.isCustomPasswordSet();

      // Assert
      expect(actualPasswordSetBool, false);
    });
  });

  group('Tests of AppAuthService.isPasswordValid()', () {
    test('Should [return TRUE] if [master key EXISTS] in database and given [password VALID]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      bool actualPasswordValidBool = await actualAppAuthService.isPasswordValid(actualPasswordModel1111);

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [master key EXISTS] in database and given [password INVALID]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));

      // Act
      bool actualPasswordValidBool = await actualAppAuthService.isPasswordValid(actualPasswordModel9999);

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));

      // Assert
      expect(
        () => actualAppAuthService.isPasswordValid(actualPasswordModel9999),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });
}
