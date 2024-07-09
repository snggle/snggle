import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/encrypted_secure_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_collection_wrapper.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late SecureStorageCollectionWrapper<Map<String, dynamic>> actualSecureStorageCollectionWrapper;

  SecureStorageKey actualSecureStorageKey = SecureStorageKey.test;

  // @formatter:off
  Map<String, String> filledChildKeysDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualSecureStorageKey.name:'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9',
  };

  Map<String, String> emptyChildKeysDatabase = <String, String>{
    SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualSecureStorageKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  setUp(() {
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      secureStorageContent: <String, dynamic>{},
    );
  });

  group('Tests of [SecureStorageCollectionWrapper] constructor with different initial conditions', () {
    test('Should [return FILLED map] if [parent key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, Map<String, dynamic>> actualCollectionCacheMap = actualSecureStorageCollectionWrapper.collectionCacheMap;

      // Assert
      Map<String, Map<String, dynamic>> expectedCollectionCacheMap = <String, Map<String, dynamic>>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      expect(actualCollectionCacheMap, expectedCollectionCacheMap);
    });

    test('Should [return EMPTY map] if [parent key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, Map<String, dynamic>> actualCollectionCacheMap = actualSecureStorageCollectionWrapper.collectionCacheMap;

      // Assert
      Map<String, Map<String, dynamic>> expectedCollectionCacheMap = <String, Map<String, dynamic>>{};

      expect(actualCollectionCacheMap, expectedCollectionCacheMap);
    });

    test('Should [return EMPTY map] if [parent key NOT EXISTS] in database (parent key should not be created in database)', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, Map<String, dynamic>> actualCollectionCacheMap = actualSecureStorageCollectionWrapper.collectionCacheMap;

      // Assert
      Map<String, Map<String, dynamic>> expectedCollectionCacheMap = <String, Map<String, dynamic>>{};

      expect(actualCollectionCacheMap, expectedCollectionCacheMap);
    });
  });

  group('Tests of SecureStorageCollectionWrapper.containsId()', () {
    test('Should [return TRUE] if [child key EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      bool actualChildKeyExistsBool = await actualSecureStorageCollectionWrapper.containsId('id_1');

      // Assert
      expect(actualChildKeyExistsBool, true);
    });

    test('Should [return FALSE] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      bool actualChildKeyExistsBool = await actualSecureStorageCollectionWrapper.containsId('id_3');

      // Assert
      expect(actualChildKeyExistsBool, false);
    });
  });

  group('Tests of SecureStorageCollectionWrapper.getAll()', () {
    test('Should [return ALL records] if [parent key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      List<Map<String, dynamic>> actualParentKeyValue = await actualSecureStorageCollectionWrapper.getAll();

      // Assert
      List<Map<String, dynamic>> expectedParentKeyValue = <Map<String, dynamic>>[
        <String, dynamic>{'test': 'value1'},
        <String, dynamic>{'test': 'value2'},
      ];

      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [return EMPTY list] if [parent key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      List<Map<String, dynamic>> actualParentKeyValue = await actualSecureStorageCollectionWrapper.getAll();

      // Assert
      List<Map<String, dynamic>> expectedParentKeyValue = <Map<String, dynamic>>[];

      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [return EMPTY list] if [parent key NOT EXIST] in database', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      List<Map<String, dynamic>> actualParentKeyValue = await actualSecureStorageCollectionWrapper.getAll();

      // Assert
      List<Map<String, dynamic>> expectedParentKeyValue = <Map<String, dynamic>>[];

      expect(actualParentKeyValue, expectedParentKeyValue);
    });
  });

  group('Tests of SecureStorageCollectionWrapper.getById()', () {
    test('Should [return child key value] if [child key EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, dynamic> actualChildKeyValue = await actualSecureStorageCollectionWrapper.getById('id_1');

      // Assert
      Map<String, dynamic> expectedChildKeyValue = <String, dynamic>{'test': 'value1'};

      expect(actualChildKeyValue, expectedChildKeyValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Assert
      expect(
        () => actualSecureStorageCollectionWrapper.getById('id_3'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecureStorageCollectionWrapper.saveWithId()', () {
    test('Should [UPDATE child key value] if [child key EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      Map<String, dynamic> newChildKeyValue = <String, dynamic>{'updated': 'value1'};

      // Act
      await actualSecureStorageCollectionWrapper.saveWithId('id_1', newChildKeyValue);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualDecryptedParentKeyValueMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'updated': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });

    test('Should [CREATE child key value] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      Map<String, dynamic> newChildKeyValue = <String, dynamic>{'new_key': 'nev_value'};

      // Act
      await actualSecureStorageCollectionWrapper.saveWithId('new_id', newChildKeyValue);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualDecryptedParentKeyValueMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
        'new_id': <String, dynamic>{'new_key': 'nev_value'},
      };

      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });

    test('Should [CREATE child key value] if [parent key NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(emptyChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      Map<String, dynamic> newChildKeyValue = <String, dynamic>{'new_key': 'nev_value'};

      // Act
      await actualSecureStorageCollectionWrapper.saveWithId('new_id', newChildKeyValue);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualDecryptedParentKeyValueMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'new_id': <String, dynamic>{'new_key': 'nev_value'},
      };

      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });
  });

  group('Tests of SecureStorageCollectionWrapper.deleteById()', () {
    test('Should [REMOVE child key] if [child key EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      await actualSecureStorageCollectionWrapper.deleteById('id_1');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualDecryptedParentKeyValueMap = await testDatabase.readEncryptedSecureStorage(actualSecureStorageKey);

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      testDatabase.updateSecureStorage(filledChildKeysDatabase);

      actualSecureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
        secureStorageKey: actualSecureStorageKey,
        secureStorageManager: EncryptedSecureStorageManager(),
      );
      await actualSecureStorageCollectionWrapper.collectionCacheInitCompleter.future;

      // Assert
      expect(
        () => actualSecureStorageCollectionWrapper.deleteById('id_3'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}
