import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/parent_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import '../../../utils/test_utils.dart';

void main() {
  initLocator();

  DatabaseParentKey actualDatabaseEntryKey = DatabaseParentKey.test;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  globalLocator<MasterKeyController>().setPassword(actualAppPasswordModel);

  MasterKeyVO actualMasterKeyVO = MasterKeyVO(
    masterKeyCiphertext: Ciphertext.fromBase64(
      base64: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
    ),
  );

  String wrappedMasterKey = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg=='
  }, prettyPrintBool: true);

  String wrappedFilledChildKeysDatabase = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': 'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9'
  }, prettyPrintBool: true);

  Map<String, String> filledChildKeysDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: wrappedMasterKey,
    actualDatabaseEntryKey.name: wrappedFilledChildKeysDatabase,
  };

  Map<String, String> filledChildKeysWithoutMasterKeyDatabase = <String, String>{
    actualDatabaseEntryKey.name: wrappedFilledChildKeysDatabase,
  };

  Map<String, String> emptyStringChildKeyDatabaseJson = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: wrappedMasterKey,
    actualDatabaseEntryKey.name: '',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: wrappedMasterKey,
  };

  Map<String, String> emptyDatabase = <String, String>{};

  group('Tests of EncryptedDatabaseManager.containsKey()', () {
    test('Should [return TRUE] if [parent key EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Act
      bool actualParentKeyExistsBool = await actualEncryptedDatabaseManager.containsKey(databaseParentKey: actualDatabaseEntryKey);

      // Assert
      expect(actualParentKeyExistsBool, true);
    });

    test('Should [return FALSE] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Act
      bool actualParentKeyExistsBool = await actualEncryptedDatabaseManager.containsKey(databaseParentKey: actualDatabaseEntryKey);

      // Assert
      expect(actualParentKeyExistsBool, false);
    });
  });

  group('Tests of EncryptedDatabaseManager.read()', () {
    test('Should [return decrypted parent key value] if [parent key EXISTS], [master key EXISTS] in database and [app password SET]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Act
      String actualDecryptedParentKeyValue = await actualEncryptedDatabaseManager.read(databaseParentKey: actualDatabaseEntryKey);

      // Assert
      String expectedDecryptedParentKeyValue = '{"id_1":{"test":"value1"},"id_2":{"test":"value2"}}';
      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [throw ParentKeyNotFoundException] if [parent key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.read(databaseParentKey: actualDatabaseEntryKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });

    test('Should [throw FormatException] if [parent key EXISTS] in database but its [value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyStringChildKeyDatabaseJson));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.read(databaseParentKey: actualDatabaseEntryKey),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should [throw Exception] if [parent key EXISTS], [master key EXISTS] in database but [app password NOT SET]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager(masterKeyController: MasterKeyController());

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.read(databaseParentKey: actualDatabaseEntryKey),
        throwsA(isA<Exception>()),
      );
    });

    test('Should [throw ParentKeyKeyNotFoundException] if [parent key EXISTS], [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysWithoutMasterKeyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.read(databaseParentKey: actualDatabaseEntryKey),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EncryptedDatabaseManager.write()', () {
    test('Should [UPDATE parent key value] if [parent key EXISTS], [master key EXISTS] in database and [app password SET]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Act
      String? actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseEntryKey.name);

      // Assert
      TestUtils.printInfo('Should [return EXISTING VALUE] as [parent key EXISTS] in database');
      expect(actualEncryptedParentKeyValue, wrappedFilledChildKeysDatabase);

      // **************************************************************************************************************

      // Act
      await actualEncryptedDatabaseManager.write(databaseParentKey: actualDatabaseEntryKey, plaintextValue: 'updated_test_value');
      actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseEntryKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. Because of that we need to get the actual result and check if we can decrypt it.
      Ciphertext actualCiphertext = Ciphertext.fromJsonString(actualEncryptedParentKeyValue!);
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, ciphertext: actualCiphertext);

      // Assert
      String expectedDecryptedParentKeyValue = 'updated_test_value';

      TestUtils.printInfo('Should [return UPDATED VALUE] after saving it in database');
      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [SAVE parent key value] if [parent key NOT EXISTS], [master key EXISTS] in database and [app password SET]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Act
      String? actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseEntryKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as [parent key NOT EXISTS] in database');
      expect(actualEncryptedParentKeyValue, null);

      // **************************************************************************************************************

      // Act
      await actualEncryptedDatabaseManager.write(databaseParentKey: actualDatabaseEntryKey, plaintextValue: 'saved_test_value');
      actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseEntryKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. Because of that we need to get the actual result and check if we can decrypt it.
      Ciphertext actualCiphertext = Ciphertext.fromJsonString(actualEncryptedParentKeyValue!);
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, ciphertext: actualCiphertext);

      // Assert
      String expectedDecryptedParentKeyValue = 'saved_test_value';
      expect(actualDecryptedParentKeyValue, expectedDecryptedParentKeyValue);
    });

    test('Should [throw FormatException] if provided [parent key value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.write(databaseParentKey: actualDatabaseEntryKey, plaintextValue: ''),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should [throw Exception] if [app password NOT SET]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager(masterKeyController: MasterKeyController());

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.write(databaseParentKey: actualDatabaseEntryKey, plaintextValue: 'Test data'),
        throwsA(isA<Exception>()),
      );
    });

    test('Should [throw ParentKeyNotFoundException] if [master key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      EncryptedDatabaseManager actualEncryptedDatabaseManager = EncryptedDatabaseManager();

      // Assert
      expect(
        () => actualEncryptedDatabaseManager.write(databaseParentKey: actualDatabaseEntryKey, plaintextValue: 'Test data'),
        throwsA(isA<ParentKeyNotFoundException>()),
      );
    });
  });
}
