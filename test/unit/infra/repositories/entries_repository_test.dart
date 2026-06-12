import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/entry_entity/entry_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/repositories/entries_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(appPasswordModel: PasswordModel.fromPlaintext('1111'));
  });

  group('Tests of EntriesRepository.getLastIndex()', () {
    test('Should [return last entry index] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<EntriesRepository>().getLastIndex();

      // Assert
      expect(actualLastIndex, 2);
    });

    test('Should [return NULL] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      int? actualLastIndex = await globalLocator<EntriesRepository>().getLastIndex();

      // Assert
      expect(actualLastIndex, null);
    });
  });

  group('Tests of EntriesRepository.getAll()', () {
    test('Should [return List of EntryEntity] if [database NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<EntryEntity> actualEntryEntityList = await globalLocator<EntriesRepository>().getAll();

      // Assert
      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 1, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 0, filesystemPathString: 'entries/entry1', name: 'ENTRY 0', website: 'https://snggle.com'),
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: false, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        // @formatter:on
      ];

      expect(actualEntryEntityList, expectedEntryEntityList);
    });

    test('Should [return EMPTY list] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<EntryEntity> actualEntryEntityList = await globalLocator<EntriesRepository>().getAll();

      // Assert
      expect(actualEntryEntityList, <EntryEntity>[]);
    });
  });

  group('Tests of EntriesRepository.getAllByParentPath()', () {
    test('Should [return List of EntryEntity] if [entries with specified path NOT EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<EntryEntity> actualEntryEntityList =
      await globalLocator<EntriesRepository>().getAllByParentPath(FilesystemPath.fromString('entries/group1'));

      // Assert

      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: false, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        // @formatter:on
      ];

      expect(actualEntryEntityList, expectedEntryEntityList);
    });

    test('Should [return EMPTY list] if [entries with specified path EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Act
      List<EntryEntity> actualEntryEntityList =
      await globalLocator<EntriesRepository>().getAllByParentPath(FilesystemPath.fromString('entries/group1'));

      // Assert
      expect(actualEntryEntityList, <EntryEntity>[]);
    });
  });

  group('Tests of EntriesRepository.getById()', () {
    test('Should [return EntryEntity] if [entry EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      EntryEntity actualEntryEntity = await globalLocator<EntriesRepository>().getById(1);

      // Assert
      // @formatter:off
      const EntryEntity expectedEntryEntity = EntryEntity(id: 1, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 0, filesystemPathString: 'entries/entry1', name: 'ENTRY 0', website: 'https://snggle.com');
      // @formatter:on

      expect(actualEntryEntity, expectedEntryEntity);
    });

    test('Should [throw ChildKeyNotFoundException] if [entry NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
            () => globalLocator<EntriesRepository>().getById(99999999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EntriesRepository.save()', () {
    test('Should [UPDATE entry] if [entry EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // @formatter:off
      EntryEntity actualUpdatedEntryEntity = const EntryEntity(id: 1, encryptedBool: false, pinnedBool: true, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 0, filesystemPathString: 'entries/entry1', name: 'UPDATED ENTRY 0', website: 'https://updated-entry1.example');
      // @formatter:on

      // Act
      await globalLocator<EntriesRepository>().save(actualUpdatedEntryEntity);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 1, encryptedBool: false, pinnedBool: true, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 0, filesystemPathString: 'entries/entry1', name: 'UPDATED ENTRY 0', website: 'https://updated-entry1.example'),
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: false, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        // @formatter:on
      ];

      expect(actualEntriesDatabaseValue, expectedEntryEntityList);
    });

    test('Should [SAVE entry] if [entry NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // @formatter:off
      EntryEntity actualNewEntryEntity = const EntryEntity(id: 999999, encryptedBool: true, pinnedBool: true, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 999999, filesystemPathString: 'entries/entry999999', name: 'NEW ENTRY 1', website: 'https://new-entry.example',);
      // @formatter:on

      // Act
      await globalLocator<EntriesRepository>().save(actualNewEntryEntity);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 1, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 0, filesystemPathString: 'entries/entry1', name: 'ENTRY 0', website: 'https://snggle.com'),
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: false, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        EntryEntity(id: 999999, encryptedBool: true, pinnedBool: true, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 999999, filesystemPathString: 'entries/entry999999', name: 'NEW ENTRY 1', website: 'https://new-entry.example'),
        // @formatter:on
      ];

      expect(actualEntriesDatabaseValue, expectedEntryEntityList);
    });
  });

  group('Tests of EntriesRepository.saveAll()', () {
    test('Should [UPDATE entries] if [entries EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      const List<EntryEntity> actualEntriesToUpdate = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 1, encryptedBool: false, pinnedBool: true, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 0, filesystemPathString: 'entries/entry1', name: 'UPDATED ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: true, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'UPDATED ENTRY 2', website: 'https://snggle.com'),
        // @formatter:on
      ];

      // Act
      await globalLocator<EntriesRepository>().saveAll(actualEntriesToUpdate);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 1, encryptedBool: false, pinnedBool: true, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 0, filesystemPathString: 'entries/entry1', name: 'UPDATED ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: true, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'UPDATED ENTRY 2', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        // @formatter:on
      ];

      expect(actualEntriesDatabaseValue, expectedEntryEntityList);
    });

    test('Should [SAVE entries] if [entries NOT EXIST] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      const List<EntryEntity> actualEntriesToSave = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 999998, encryptedBool: true, pinnedBool: true, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: false, index: 999998, filesystemPathString: 'entries/entry999998', name: 'NEW ENTRY 1', website: ''),
        EntryEntity(id: 999999, encryptedBool: false, pinnedBool: true, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: true, index: 999999, filesystemPathString: 'entries/entry999999', name: 'NEW ENTRY 2', website: 'https://new-entry2.example'),
        // @formatter:on
      ];

      // Act
      await globalLocator<EntriesRepository>().saveAll(actualEntriesToSave);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 1, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: true, passwordExistsBool: true, index: 0, filesystemPathString: 'entries/entry1', name: 'ENTRY 0', website: 'https://snggle.com'),
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: false, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        EntryEntity(id: 999998, encryptedBool: true, pinnedBool: true, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: false, index: 999998, filesystemPathString: 'entries/entry999998', name: 'NEW ENTRY 1', website: ''),
        EntryEntity(id: 999999, encryptedBool: false, pinnedBool: true, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: true, index: 999999, filesystemPathString: 'entries/entry999999', name: 'NEW ENTRY 2', website: 'https://new-entry2.example'),
        // @formatter:on
      ];

      expect(actualEntriesDatabaseValue, expectedEntryEntityList);
    });
  });

  group('Tests of EntriesRepository.deleteById()', () {
    test('Should [REMOVE entry] if [entry EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<EntriesRepository>().deleteById(1);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      const List<EntryEntity> expectedEntryEntityList = <EntryEntity>[
        // @formatter:off
        EntryEntity(id: 2, encryptedBool: false, pinnedBool: false, emailExistsBool: false, usernameExistsBool: true, passwordExistsBool: false, index: 1, filesystemPathString: 'entries/group1/entry2', name: 'ENTRY 1', website: 'https://snggle.com'),
        EntryEntity(id: 3, encryptedBool: false, pinnedBool: false, emailExistsBool: true, usernameExistsBool: false, passwordExistsBool: true, index: 2, filesystemPathString: 'entries/group1/entry3', name: 'ENTRY 2', website: 'https://snggle.com'),
        // @formatter:on
      ];

      expect(actualEntriesDatabaseValue, expectedEntryEntityList);
    });

    test('Should [throw ChildKeyNotFoundException] if [entry NOT EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.emptyDatabaseMock);

      // Assert
      expect(
            () => globalLocator<EntriesRepository>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(testDatabase.close);
}
