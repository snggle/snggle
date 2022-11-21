import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/secure_collection_manager.dart';
import '../../../utils/test_utils.dart';
import 'mocks/mock_collection_entity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  String actualCollectionKey = 'mocked_collection';
  String actualSeedHash = '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0';

  late SecureCollectionManager<MockCollectionEntity> actualSecureCollectionManager;
  
  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of SecureCollectionManager.saveById() method', () {
    test('Should save new entities in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      actualSecureCollectionManager = SecureCollectionManager<MockCollectionEntity>(
        entityJsonFactory: MockCollectionEntity.fromJson,
        password: actualSeedHash,
        storageKey: actualCollectionKey,
      );

      // Act
      await actualSecureCollectionManager.saveById('1', MockCollectionEntity(id: '1', name: 'name1'));
      Map<String, MockCollectionEntity>  actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      Map<String, String> actualStorage = await flutterSecureStorage.readAll();

      // Assert
      Map<String, MockCollectionEntity> expectedCollectionCache = <String, MockCollectionEntity>{
        '1': MockCollectionEntity(id: '1', name: 'name1'),
      };
      Map<String, String> expectedStorage = <String, String>{
        actualCollectionKey: '{"1":{"id":"1","name":"name1"}}',
      };

      TestUtils.printInfo('Should return map with one collection entity as String after add one entity');
      expect(actualCollectionCache, expectedCollectionCache);

      // Output is always random String because our hashing method changing initialization vector using Random Secure and we cannot match the hardcoded expected result.
      // Because of that we check that the result is not equal decrypted value
      expect(actualStorage, isNot(expectedStorage));

      // Act
      await actualSecureCollectionManager.saveById('2', MockCollectionEntity(id: '2', name: 'name2'));
      actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      actualStorage = await flutterSecureStorage.readAll();

      // Assert
      expectedCollectionCache = <String, MockCollectionEntity>{
        '1': MockCollectionEntity(id: '1', name: 'name1'),
        '2': MockCollectionEntity(id: '2', name: 'name2'),
      };
      expectedStorage = <String, String>{
        actualCollectionKey: '{"1":{"id":"1","name":"name1"},"2":{"id":"2","name":"name2"}}',
      };

      TestUtils.printInfo('Should return map with two collection entities as String after add one more entity');
      expect(actualCollectionCache, expectedCollectionCache);

      // Output is always random String because our hashing method changing initialization vector using Random Secure and we cannot match the hardcoded expected result.
      // Because of that we check that the result is not equal decrypted value
      expect(actualStorage, isNot(expectedStorage));
    });
  });

  group('Tests of SecureCollectionManager.deleteById() method', () {
    test('Should remove entities from database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        actualCollectionKey: 'xwz4rCDleCG99y5Vd+ltDYkrrlkfNCCs3TncwRjPrwHbGWGYT4wqdSLIekjFJVxDIC/WAUulE2HKdEEsEmQf7H7HnhgzMQ2JBE7yf/PeQLlWYZyt',
      });
      actualSecureCollectionManager = SecureCollectionManager<MockCollectionEntity>(
        entityJsonFactory: MockCollectionEntity.fromJson,
        password: actualSeedHash,
        storageKey: actualCollectionKey,
      );
      // Await for storage initialization
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      Map<String, MockCollectionEntity> actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      Map<String, String> actualStorage = await flutterSecureStorage.readAll();

      // Assert
      Map<String, MockCollectionEntity> expectedCollectionCache = <String, MockCollectionEntity>{
        '1': MockCollectionEntity(id: '1', name: 'name1'),
        '2': MockCollectionEntity(id: '2', name: 'name2'),
      };
      Map<String, String> expectedStorage = <String, String>{
        actualCollectionKey: 'xwz4rCDleCG99y5Vd+ltDYkrrlkfNCCs3TncwRjPrwHbGWGYT4wqdSLIekjFJVxDIC/WAUulE2HKdEEsEmQf7H7HnhgzMQ2JBE7yf/PeQLlWYZyt',
      };

      TestUtils.printInfo('Should return filled map if collection is initialized');
      expect(actualCollectionCache, expectedCollectionCache);
      expect(actualStorage, expectedStorage);

      // Act
      await actualSecureCollectionManager.deleteById('1');
      actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      actualStorage = await flutterSecureStorage.readAll();

      // Assert
      expectedCollectionCache = <String, MockCollectionEntity>{
        '2': MockCollectionEntity(id: '2', name: 'name2'),
      };
      expectedStorage = <String, String>{
        actualCollectionKey: '{"2":{"id":"2","name":"name2"}}',
      };

      TestUtils.printInfo('Should return map with one collection entity as String after delete one entity');
      expect(actualCollectionCache, expectedCollectionCache);

      // Output is always random String because our hashing method changing initialization vector using Random Secure and we cannot match the hardcoded expected result.
      // Because of that we check that the result is not equal decrypted value
      expect(actualStorage, isNot(expectedStorage));

      // Act
      await actualSecureCollectionManager.deleteById('2');
      actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      actualStorage = await flutterSecureStorage.readAll();

      // Assert
      expectedCollectionCache = <String, MockCollectionEntity>{};
      expectedStorage = <String, String>{'mocked_collection': '{}'};

      TestUtils.printInfo('Should return empty map after delete all entities');
      expect(actualCollectionCache, expectedCollectionCache);

      // Output is always random String because our hashing method changing initialization vector using Random Secure and we cannot match the hardcoded expected result.
      // Because of that we check that the result is not equal decrypted value
      expect(actualStorage, isNot(expectedStorage));
    });
  });

  group('Tests of SecureCollectionManager.getById() method', () {
    test('Should return entities by provided ids', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        actualCollectionKey: 'xwz4rCDleCG99y5Vd+ltDYkrrlkfNCCs3TncwRjPrwHbGWGYT4wqdSLIekjFJVxDIC/WAUulE2HKdEEsEmQf7H7HnhgzMQ2JBE7yf/PeQLlWYZyt',
      });
      actualSecureCollectionManager = SecureCollectionManager<MockCollectionEntity>(
        entityJsonFactory: MockCollectionEntity.fromJson,
        password: actualSeedHash,
        storageKey: actualCollectionKey,
      );
      // Await for storage initialization
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      Map<String, MockCollectionEntity> actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      Map<String, String> actualStorage = await flutterSecureStorage.readAll();

      // Assert
      Map<String, MockCollectionEntity> expectedCollectionCache = <String, MockCollectionEntity>{
        '1': MockCollectionEntity(id: '1', name: 'name1'),
        '2': MockCollectionEntity(id: '2', name: 'name2'),
      };
      Map<String, String> expectedStorage = <String, String>{
        actualCollectionKey: 'xwz4rCDleCG99y5Vd+ltDYkrrlkfNCCs3TncwRjPrwHbGWGYT4wqdSLIekjFJVxDIC/WAUulE2HKdEEsEmQf7H7HnhgzMQ2JBE7yf/PeQLlWYZyt',
      };

      TestUtils.printInfo('Should return filled map if collection is initialized');
      expect(actualCollectionCache, expectedCollectionCache);
      expect(actualStorage, expectedStorage);

      // Act
      MockCollectionEntity? actualMockCollectionEntity = await actualSecureCollectionManager.getById('1');

      // Assert
      MockCollectionEntity? expectedMockCollectionEntity = MockCollectionEntity(id: '1', name: 'name1');

      TestUtils.printInfo('Should return entity with id 1');
      expect(actualMockCollectionEntity, expectedMockCollectionEntity);

      // Act
      actualMockCollectionEntity = await actualSecureCollectionManager.getById('2');

      // Assert
      expectedMockCollectionEntity = MockCollectionEntity(id: '2', name: 'name2');

      TestUtils.printInfo('Should return entity with id 2');
    });
  });

  group('Tests of SecureCollectionManager.readAll() method', () {
    test('Should return all entities from database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        actualCollectionKey: 'xwz4rCDleCG99y5Vd+ltDYkrrlkfNCCs3TncwRjPrwHbGWGYT4wqdSLIekjFJVxDIC/WAUulE2HKdEEsEmQf7H7HnhgzMQ2JBE7yf/PeQLlWYZyt',
      });
      actualSecureCollectionManager = SecureCollectionManager<MockCollectionEntity>(
        entityJsonFactory: MockCollectionEntity.fromJson,
        password: actualSeedHash,
        storageKey: actualCollectionKey,
      );
      // Await for storage initialization
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Act
      Map<String, MockCollectionEntity> actualCollectionCache = actualSecureCollectionManager.decryptedCollectionCache;
      Map<String, String> actualStorage = await flutterSecureStorage.readAll();

      // Assert
      Map<String, MockCollectionEntity> expectedCollectionCache = <String, MockCollectionEntity>{
        '1': MockCollectionEntity(id: '1', name: 'name1'),
        '2': MockCollectionEntity(id: '2', name: 'name2'),
      };
      Map<String, String> expectedStorage = <String, String>{
        actualCollectionKey: 'xwz4rCDleCG99y5Vd+ltDYkrrlkfNCCs3TncwRjPrwHbGWGYT4wqdSLIekjFJVxDIC/WAUulE2HKdEEsEmQf7H7HnhgzMQ2JBE7yf/PeQLlWYZyt',
      };

      TestUtils.printInfo('Should return filled map if collection is initialized');
      expect(actualCollectionCache, expectedCollectionCache);
      expect(actualStorage, expectedStorage);

      // Act
      List<MockCollectionEntity> actualMockCollectionEntities = await actualSecureCollectionManager.readAll();

      // Assert
      List<MockCollectionEntity> expectedMockCollectionEntities = <MockCollectionEntity>[
        MockCollectionEntity(id: '1', name: 'name1'),
        MockCollectionEntity(id: '2', name: 'name2'),
      ];

      TestUtils.printInfo('Should return list of entities');
      expect(actualMockCollectionEntities, expectedMockCollectionEntities);
    });
  });
}
