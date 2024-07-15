import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/encrypted_secure_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late EncryptedSecureStorageManager actualEncryptedSecureStorageManager;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.test;
  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
    encryptedMasterKey:
        '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  );

  // @formatter:off
  Map<String, String> filledChildKeysDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualSecureStorageKey.name:'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9',
  };

  Map<String, String> filledChildKeysWithoutMasterKeyDatabase = <String, String>{
    actualSecureStorageKey.name:'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9',
  };

  Map<String, String> emptyStringChildKeyDatabaseJson = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualSecureStorageKey.name: '',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() {
    testDatabase = TestDatabase(appPasswordModel: PasswordModel.fromPlaintext('1111'));

    actualEncryptedSecureStorageManager = EncryptedSecureStorageManager();
  });

  group('Tests of EncryptedSecureStorageManager.containsKey()', () {
    test('Should [return TRUE] if [parent key EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      // Act
      bool actualParentKeyExistsBool = await actualEncryptedSecureStorageManager.containsKey(secureStorageKey: actualSecureStorageKey);

      // Assert
      expect(actualParentKeyExistsBool, true);
    });

    test('Should [return FALSE] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Act
      bool actualParentKeyExistsBool = await actualEncryptedSecureStorageManager.containsKey(secureStorageKey: actualSecureStorageKey);

      // Assert
      expect(actualParentKeyExistsBool, false);
    });
  });

  group('Tests of EncryptedSecureStorageManager.read()', () {
    test('Should [return decrypted parent key value] if [parent key EXISTS], [master key EXISTS] in database and [app password SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      // Act
      String actualDecryptedParentKeyValue = await actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey);

      // Assert
      String expectedDecryptedParentKeyValue = '{"id_1":{"test":"value1"},"id_2":{"test":"value2"}}';
      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [throw ParentKeyNotFoundException] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });

    test('Should [throw FormatException] if [parent key EXISTS] in database but its [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyStringChildKeyDatabaseJson);

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should [throw ParentKeyKeyNotFoundException] if [parent key EXISTS], [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysWithoutMasterKeyDatabase);

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.read(secureStorageKey: actualSecureStorageKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EncryptedSecureStorageManager.write()', () {
    test('Should [UPDATE parent key value] if [parent key EXISTS], [master key EXISTS] in database and [app password SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      // Act
      await actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'updated_test_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. Because of that we need to get the actual result and check if we can decrypt it.
      String? actualEncryptedParentKeyValue = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);

      // Assert
      String expectedDecryptedParentKeyValue = 'updated_test_value';

      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [SAVE parent key value] if [parent key NOT EXISTS], [master key EXISTS] in database and [app password SET]', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      // Act
      await actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'saved_test_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. Because of that we need to get the actual result and check if we can decrypt it.
      String? actualEncryptedParentKeyValue = await const FlutterSecureStorage().read(key: actualSecureStorageKey.name);
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);

      // Assert
      String expectedDecryptedParentKeyValue = 'saved_test_value';
      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [throw FormatException] if provided [parent key value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(masterKeyOnlyDatabase);

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: ''),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      // Assert
      expect(
        () => actualEncryptedSecureStorageManager.write(secureStorageKey: actualSecureStorageKey, plaintextValue: 'Test data'),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}