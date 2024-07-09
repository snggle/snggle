import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_manager.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late SecureStorageManager actualSecureStorageManager;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.test;

  // @formatter:off
  Map<String, String> filledChildKeysDatabase = <String, String>{
    SecureStorageKey.test.name: 'test_value',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() {
    testDatabase = TestDatabase(appPasswordModel: PasswordModel.fromPlaintext('1111'));

    actualSecureStorageManager = SecureStorageManager();
  });

  group('Tests of SecureStorageManager.containsKey()', () {
    test('Should [return TRUE] if [parent key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      // Act
      bool actualParentKeyExistsBool = await actualSecureStorageManager.containsKey(secureStorageKey: actualSecureStorageKey);

      // Assert
      expect(actualParentKeyExistsBool, true);
    });

    test('Should [return FALSE] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      bool actualParentKeyExistsBool = await actualSecureStorageManager.containsKey(secureStorageKey: actualSecureStorageKey);

      // Assert
      expect(actualParentKeyExistsBool, false);
    });
  });

  group('Tests of SecureStorageManager.read()', () {
    test('Should [return parent key value] if [parent key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      // Act
      String actualParentKeyValue = await actualSecureStorageManager.read(secureStorageKey: actualSecureStorageKey);

      // Assert
      String expectedParentKeyValue = 'test_value';
      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [throw ParentKeyNotFoundException] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
        () => actualSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecureStorageManager.write()', () {
    test('Should [UPDATE parent key value] if [parent key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      // Act
      await actualSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'updated_test_value');

      String? actualParentKeyValue = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Assert
      String expectedParentKeyValue = 'updated_test_value';

      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [SAVE parent key value] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      await actualSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'saved_test_value');

      String? actualParentKeyValue = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);

      // Assert
      String expectedParentKeyValue = 'saved_test_value';

      expect(actualParentKeyValue, expectedParentKeyValue);
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}
