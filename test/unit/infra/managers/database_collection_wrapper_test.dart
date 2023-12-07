import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();

  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  DatabaseCollectionWrapper<Map<String, dynamic>> actualDatabaseCollectionWrapper;

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.test;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(
      encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  Map<String, String> filledChildKeysDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'OWkmZ2+DccpOdfFHb8ZZQyreGhwj3LEuUViDzTYky9WsbHxQPd8gGfk4nkW/OfFrKHEqsiWaaVh9x0l76h/LbIHcpcT6F2ifeHIoywYwfPeYs2a9',
  };

  Map<String, String> emptyChildKeysDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };

  Map<String, String> emptyDatabase = <String, String>{};
  // @formatter:on

  group('Tests of [DatabaseCollectionWrapper] constructor with different initial conditions', () {
    test('Should [return FILLED map] if [parent key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );
      await actualDatabaseCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, Map<String, dynamic>> actualCollectionCacheMap = actualDatabaseCollectionWrapper.collectionCacheMap;

      // Assert
      Map<String, Map<String, dynamic>> expectedCollectionCacheMap = <String, Map<String, dynamic>>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      expect(actualCollectionCacheMap, expectedCollectionCacheMap);
    });

    test('Should [return EMPTY map] if [parent key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );
      await actualDatabaseCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, Map<String, dynamic>> actualCollectionCacheMap = actualDatabaseCollectionWrapper.collectionCacheMap;

      // Assert
      Map<String, Map<String, dynamic>> expectedCollectionCacheMap = <String, Map<String, dynamic>>{};

      expect(actualCollectionCacheMap, expectedCollectionCacheMap);
    });

    test('Should [return EMPTY map] if [parent key NOT EXISTS] in database (parent key should not be created in database)', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );
      await actualDatabaseCollectionWrapper.collectionCacheInitCompleter.future;

      // Act
      Map<String, Map<String, dynamic>> actualCollectionCacheMap = actualDatabaseCollectionWrapper.collectionCacheMap;

      // Assert
      Map<String, Map<String, dynamic>> expectedCollectionCacheMap = <String, Map<String, dynamic>>{};

      TestUtils.printInfo('Should [return EMPTY map] as [child key NOT EXISTS] in database');
      expect(actualCollectionCacheMap, expectedCollectionCacheMap);

      // ********************************************************************************************************************

      // Act
      String? actualEncryptedDatabaseEntryValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL], because database should not be modified during initialization');
      expect(actualEncryptedDatabaseEntryValue, null);
    });
  });

  group('Tests of DatabaseCollectionWrapper.containsId()', () {
    test('Should [return TRUE] if [child key EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      bool actualChildKeyExistsBool = await actualDatabaseCollectionWrapper.containsId('id_1');

      // Assert
      expect(actualChildKeyExistsBool, true);
    });

    test('Should [return FALSE] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      bool actualChildKeyExistsBool = await actualDatabaseCollectionWrapper.containsId('id_3');

      // Assert
      expect(actualChildKeyExistsBool, false);
    });
  });

  group('Tests of DatabaseCollectionWrapper.getAll()', () {
    test('Should [return ALL records] if [parent key EXISTS] in database and [HAS VALUES]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      List<Map<String, dynamic>> actualParentKeyValue = await actualDatabaseCollectionWrapper.getAll();

      // Assert
      List<Map<String, dynamic>> expectedParentKeyValue = <Map<String, dynamic>>[
        <String, dynamic>{'test': 'value1'},
        <String, dynamic>{'test': 'value2'},
      ];

      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [return EMPTY list] if [parent key EXISTS] in database and [value EMPTY]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      List<Map<String, dynamic>> actualParentKeyValue = await actualDatabaseCollectionWrapper.getAll();

      // Assert
      List<Map<String, dynamic>> expectedParentKeyValue = <Map<String, dynamic>>[];

      expect(actualParentKeyValue, expectedParentKeyValue);
    });

    test('Should [return EMPTY list] if [parent key NOT EXIST] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      List<Map<String, dynamic>> actualParentKeyValue = await actualDatabaseCollectionWrapper.getAll();

      // Assert
      List<Map<String, dynamic>> expectedParentKeyValue = <Map<String, dynamic>>[];

      expect(actualParentKeyValue, expectedParentKeyValue);
    });
  });

  group('Tests of DatabaseCollectionWrapper.getById()', () {
    test('Should [return child key value] if [child key EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      Map<String, dynamic> actualChildKeyValue = await actualDatabaseCollectionWrapper.getById('id_1');

      // Assert
      Map<String, dynamic> expectedChildKeyValue = <String, dynamic>{'test': 'value1'};

      expect(actualChildKeyValue, expectedChildKeyValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Assert
      expect(
        () => actualDatabaseCollectionWrapper.getById('id_3'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of DatabaseCollectionWrapper.saveWithId()', () {
    test('Should [UPDATE child key value] if [child key EXISTS] in collection', () async {
      // Arrange
      Map<String, dynamic> newChildKeyValue = <String, dynamic>{'updated': 'value1'};

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));

      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      String? actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);
      Map<String, dynamic> actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      TestUtils.printInfo('Should [return Map of records] as [parent key EXISTS] in database');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);

      // ********************************************************************************************************************

      // Act
      await actualDatabaseCollectionWrapper.saveWithId('id_1', newChildKeyValue);
      actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);
      actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'updated': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      TestUtils.printInfo('Should [return Map of records] with updated child key value');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });

    test('Should [CREATE child key value] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      Map<String, dynamic> newChildKeyValue = <String, dynamic>{'new_key': 'nev_value'};

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      String? actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);
      Map<String, dynamic> actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      TestUtils.printInfo('Should [return Map of records] as [parent key value is NOT EMPTY] in database');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);

      // ********************************************************************************************************************

      // Act
      await actualDatabaseCollectionWrapper.saveWithId('new_id', newChildKeyValue);
      actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);
      actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
        'new_id': <String, dynamic>{'new_key': 'nev_value'},
      };

      TestUtils.printInfo('Should [return Map of records] with saved record');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });

    test('Should [CREATE child key value] if [parent key NOT EXISTS] in collection', () async {
      // Arrange
      Map<String, dynamic> newChildKeyValue = <String, dynamic>{'new_key': 'nev_value'};

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      String? actualParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as [parent key NOT EXISTS] in database');
      expect(actualParentKeyValue, null);

      // ********************************************************************************************************************

      // Act
      await actualDatabaseCollectionWrapper.saveWithId('new_id', newChildKeyValue);
      actualParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualParentKeyValue!);
      Map<String, dynamic> actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'new_id': <String, dynamic>{'new_key': 'nev_value'},
      };

      TestUtils.printInfo('Should [return Map of records] with saved record');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });
  });

  group('Tests of DatabaseCollectionWrapper.deleteById()', () {
    test('Should [REMOVE child key] if [child key EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Act
      String? actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);
      Map<String, dynamic> actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_1': <String, dynamic>{'test': 'value1'},
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      TestUtils.printInfo('Should [return Map of records] as [parent key value is NOT EMPTY] in database');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);

      // ********************************************************************************************************************

      // Act
      await actualDatabaseCollectionWrapper.deleteById('id_1');
      actualEncryptedParentKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedParentKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedParentKeyValue!);
      actualDecryptedParentKeyValueMap = jsonDecode(actualDecryptedParentKeyValue) as Map<String, dynamic>;

      // Assert
      expectedDecryptedParentKeyValueMap = <String, dynamic>{
        'id_2': <String, dynamic>{'test': 'value2'},
      };

      TestUtils.printInfo('Should [return Map of records] without removed record');
      expect(actualDecryptedParentKeyValueMap, expectedDecryptedParentKeyValueMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [child key NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptyChildKeysDatabase));
      actualDatabaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
        databaseParentKey: actualDatabaseParentKey,
        databaseManager: EncryptedDatabaseManager(),
      );

      // Assert
      expect(
        () => actualDatabaseCollectionWrapper.deleteById('id_3'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}
