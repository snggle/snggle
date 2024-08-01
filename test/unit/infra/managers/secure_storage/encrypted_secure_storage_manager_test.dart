import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/encrypted_secure_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  SecureStorageKey actualSecureStorageKey = SecureStorageKey.test;

  // @formatter:off
  Map<String, String> filledSecureStorage = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualSecureStorageKey.name:'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9',
  };

  Map<String, String> filledWithoutMasterKeySecureStorage = <String, String>{
    actualSecureStorageKey.name:'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9',
  };

  Map<String, String> emptyStringSecureStorage = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualSecureStorageKey.name: '',
  };

  Map<String, String> masterKeyOnlySecureStorage = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptySecureStorage = <String, String>{};
  // @formatter:on

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of EncryptedSecureStorageManager.containsKey()', () {
    test('Should [return TRUE] if [key EXISTS] in secure storage', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledSecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Act
      bool actualParentKeyExistsBool = await actualEncryptedSecureStorageManager.containsKey(secureStorageKey: actualSecureStorageKey);

      // Assert
      expect(actualParentKeyExistsBool, true);
    });

    test('Should [return FALSE] if [key NOT EXISTS] in secure storage', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Act
      bool actualParentKeyExistsBool = await actualEncryptedSecureStorageManager.containsKey(secureStorageKey: actualSecureStorageKey);

      // Assert
      expect(actualParentKeyExistsBool, false);
    });
  });

  group('Tests of EncryptedSecureStorageManager.read()', () {
    test('Should [return decrypted value] if [key EXISTS], [master key EXISTS] in secure storage and [app password SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledSecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Act
      String actualDecryptedParentKeyValue = await actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey);

      // Assert
      String expectedDecryptedParentKeyValue = '{"id_1":{"test":"value1"},"id_2":{"test":"value2"}}';
      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [throw ParentKeyNotFoundException] if [key NOT EXISTS] in secure storage', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });

    test('Should [throw FormatException] if [key EXISTS] in secure storage but its [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyStringSecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should [throw Exception] if [key EXISTS], [master key EXISTS] in secure storage but [app password NOT SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledSecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager(masterKeyController: MasterKeyController());

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<Exception>()),
      );
    });

    test('Should [throw ParentKeyKeyNotFoundException] if [key EXISTS], [master key NOT EXISTS] in secure storage', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledWithoutMasterKeySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EncryptedSecureStorageManager.write()', () {
    test('Should [UPDATE value] if [key EXISTS], [master key EXISTS] in secure storage and [app password SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledSecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Act
      await actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: '{"test_key":"test value"}');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. Because of that we need to get the actual result and check if we can decrypt it.
      Map<String, dynamic>? actualDecryptedParentKeyValue = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValue = <String, dynamic>{
        'test_key': 'test value',
      };

      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [SAVE value] if [key NOT EXISTS], [master key EXISTS] in secure storage and [app password SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Act
      await actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: '{"test_key":"test value"}');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. Because of that we need to get the actual result and check if we can decrypt it.
      Map<String, dynamic>? actualDecryptedParentKeyValue = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValue = <String, dynamic>{
        'test_key': 'test value',
      };

      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [throw FormatException] if provided [key value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: ''),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should [throw Exception] if [app password NOT SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager(masterKeyController: MasterKeyController());

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'Test data'),
        throwsA(isA<Exception>()),
      );
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in secure storage', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptySecureStorage);
      EncryptedSecureStorageManager actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'Test data'),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}