import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/decrypted_database_manager.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.test;

  // @formatter:off
  Map<String, String> filledChildKeysDatabase = <String, String>{
    DatabaseParentKey.test.name: 'test_value',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  group('Tests of DecryptedDatabaseManager.containsKey()', () {
    test('Should [return TRUE] if [parent key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      DecryptedDatabaseManager actualDecryptedDatabaseManager = DecryptedDatabaseManager();

      // Act
      bool actualParentKeyExistsBool = await actualDecryptedDatabaseManager.containsKey(databaseParentKey: actualDatabaseParentKey);

      // Assert
      expect(actualParentKeyExistsBool, true);
    });

    test('Should [return FALSE] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      DecryptedDatabaseManager actualDecryptedDatabaseManager = DecryptedDatabaseManager();

      // Act
      bool actualParentKeyExistsBool = await actualDecryptedDatabaseManager.containsKey(databaseParentKey: actualDatabaseParentKey);

      // Assert
      expect(actualParentKeyExistsBool, false);
    });
  });

  group('Tests of DecryptedDatabaseManager.read()', () {
    test('Should [return parent key value] if [parent key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      DecryptedDatabaseManager actualDecryptedDatabaseManager = DecryptedDatabaseManager();

      // Act
      String actualParentKeyValue = await actualDecryptedDatabaseManager.read(databaseParentKey: actualDatabaseParentKey);

      // Assert
      String expectedParentKeyValue = 'test_value';
      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [throw ParentKeyNotFoundException] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      DecryptedDatabaseManager actualDecryptedDatabaseManager = DecryptedDatabaseManager();

      // Assert
      expect(
        () => actualDecryptedDatabaseManager.read(databaseParentKey: actualDatabaseParentKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of DecryptedDatabaseManager.write()', () {
    test('Should [UPDATE parent key value] if [parent key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      DecryptedDatabaseManager actualDecryptedDatabaseManager = DecryptedDatabaseManager();

      // Act
      String? actualParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedParentKeyValue = 'test_value';

      TestUtils.printInfo('Should [return EXISTING VALUE] as [parent key EXISTS] in database');
      expect(actualParentKeyValue, expectedParentKeyValue);

      // ******************************************************************************************************************

      // Act
      await actualDecryptedDatabaseManager.write(databaseParentKey: actualDatabaseParentKey, plaintextValue: 'updated_test_value');

      actualParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      expectedParentKeyValue = 'updated_test_value';

      TestUtils.printInfo('Should [return UPDATED VALUE] after saving it in database');
      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [SAVE parent key value] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      DecryptedDatabaseManager actualDecryptedDatabaseManager = DecryptedDatabaseManager();

      // Act
      String? actualParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as [parent key NOT EXISTS] in database');
      expect(actualParentKeyValue, null);

      // ******************************************************************************************************************

      // Act
      await actualDecryptedDatabaseManager.write(databaseParentKey: actualDatabaseParentKey, plaintextValue: 'saved_test_value');

      actualParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      String expectedParentKeyValue = 'saved_test_value';

      TestUtils.printInfo('Should [return NEW VALUE] after saving it in database');
      expect(actualParentKeyValue, expectedParentKeyValue);
    });
  });
}
