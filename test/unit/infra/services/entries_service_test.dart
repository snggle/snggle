import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/entry_entity/entry_entity.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/entries_service.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.fullDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of EntriesService.getAllByParentPath()', () {
    test('Should [return List of EntryModel] if [given path HAS VALUES] (firstLevelBool == TRUE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<EntryModel> actualEntryModelList = await globalLocator<EntriesService>().getAllByParentPath(
        FilesystemPath.fromString('entries/group1'),
        firstLevelBool: true,
      );

      // Assert
      List<EntryModel> expectedEntryModelList = <EntryModel>[
        EntryModel(
          //'entry_user_2'
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/group1/entry2'),
          name: 'ENTRY 1',
          index: 1,
          website: 'https://snggle.com',
          usernameExistsBool: true,
        ),
        EntryModel(
          //'entry_user_2'
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/group1/entry3'),
          name: 'ENTRY 2',
          index: 2,
          website: 'https://snggle.com',
          emailExistsBool: true,
          passwordExistsBool: true,
        ),
      ];

      expect(actualEntryModelList, expectedEntryModelList);
    });

    test('Should [return List of EntryModel] if [given path HAS VALUES] (firstLevelBool == FALSE)', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<EntryModel> actualEntryModelList = await globalLocator<EntriesService>().getAllByParentPath(
        FilesystemPath.fromString('entries/group1'),
        firstLevelBool: false,
      );

      // Assert
      List<EntryModel> expectedEntryModelList = <EntryModel>[
        EntryModel(
          //'entry_user_2'
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/group1/entry2'),
          name: 'ENTRY 1',
          index: 1,
          website: 'https://snggle.com',
          usernameExistsBool: true,
        ),
        EntryModel(
          //'entry_user_2'
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/group1/entry3'),
          name: 'ENTRY 2',
          index: 2,
          website: 'https://snggle.com',
          emailExistsBool: true,
          passwordExistsBool: true,
        ),
      ];

      expect(actualEntryModelList, expectedEntryModelList);
    });

    test('Should [return EMPTY list] if [given path is EMPTY]', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      List<EntryModel> actualEntryModelList = await globalLocator<EntriesService>().getAllByParentPath(
        FilesystemPath.fromString('entries/not_existing_path'),
        firstLevelBool: false,
      );

      // Assert
      expect(actualEntryModelList, <EntryModel>[]);
    });
  });

  group('Tests of EntriesService.getById()', () {
    test(
      'Should [return EntryModel] if [entry EXISTS] in database',
      () async {
        // Arrange
        await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

        // Act
        EntryModel actualEntryModel = await globalLocator<EntriesService>().getById(1);

        // Assert
        EntryModel expectedEntryModel = EntryModel(
          //'entry_user_2'
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'ENTRY 0',
          index: 0,
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
        );

        expect(actualEntryModel, expectedEntryModel);
      },
    );

    test('Should [throw ChildKeyNotFoundException] if [entry NOT EXISTS] in database', () async {
      // Assert
      expect(
        () => globalLocator<EntriesService>().getById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EntriesService.move()', () {
    test('Should [MOVE entry] if [entry EXISTS] in database', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<EntriesService>().move(
        EntryModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'ENTRY 0',
          index: 0,
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
        ),
        FilesystemPath.fromString('entries/new/path/entry1'),
      );

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        const EntryEntity(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          index: 0,
          filesystemPathString: 'entries/new/path/entry1',
          name: 'ENTRY 0',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
          index: 1,
          filesystemPathString: 'entries/group1/entry2',
          name: 'ENTRY 1',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });
  });

  group('Tests of EntriesService.moveAllByParentPath()', () {
    test('Should [MOVE entries] starting with given path', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<EntriesService>().moveAllByParentPath(
        FilesystemPath.fromString('entries/group1'),
        FilesystemPath.fromString('entries/new/path/group1'),
      );

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        const EntryEntity(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          index: 0,
          filesystemPathString: 'entries/entry1',
          name: 'ENTRY 0',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
          index: 1,
          filesystemPathString: 'entries/new/path/group1/entry2',
          name: 'ENTRY 1',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/new/path/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });
  });

  group('Tests of EntriesService.save()', () {
    test('Should [UPDATE entry] if [entry EXISTS] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      EntryModel updatedEntryModel = EntryModel(
        id: 1,
        encryptedBool: true,
        pinnedBool: true,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'UPDATED ENTRY 0',
        website: 'https://updated-entry1.example',
        emailExistsBool: false,
        usernameExistsBool: true,
        passwordExistsBool: false,
      );

      // Act
      await globalLocator<EntriesService>().save(updatedEntryModel);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        EntryEntity.fromEntryModel(updatedEntryModel),
        const EntryEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
          index: 1,
          filesystemPathString: 'entries/group1/entry2',
          name: 'ENTRY 1',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });

    test('Should [SAVE entry] if [entry NOT EXISTS] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      EntryModel actualNewEntryModel = EntryModel(
        id: 999999,
        encryptedBool: true,
        pinnedBool: true,
        index: 999999,
        filesystemPath: FilesystemPath.fromString('entries/entry999999'),
        name: 'NEW ENTRY 1',
        website: 'https://new-entry.example',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
      );

      // Act
      await globalLocator<EntriesService>().save(actualNewEntryModel);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        const EntryEntity(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          index: 0,
          filesystemPathString: 'entries/entry1',
          name: 'ENTRY 0',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
          index: 1,
          filesystemPathString: 'entries/group1/entry2',
          name: 'ENTRY 1',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
        EntryEntity.fromEntryModel(actualNewEntryModel),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });
  });

  group('Tests of EntriesService.saveAll()', () {
    test('Should [UPDATE entries] if [entries EXIST] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<EntryModel> actualEntriesToUpdate = <EntryModel>[
        EntryModel(
          id: 1,
          encryptedBool: true,
          pinnedBool: true,
          index: 0,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'UPDATED ENTRY 0',
          website: 'https://updated-entry1.example',
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
        ),
        EntryModel(
          id: 2,
          encryptedBool: false,
          pinnedBool: true,
          index: 1,
          filesystemPath: FilesystemPath.fromString('entries/group1/entry2'),
          name: 'UPDATED ENTRY 1',
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: false,
        ),
      ];

      // Act
      await globalLocator<EntriesService>().saveAll(actualEntriesToUpdate);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        EntryEntity.fromEntryModel(actualEntriesToUpdate[0]),
        EntryEntity.fromEntryModel(actualEntriesToUpdate[1]),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });

    test('Should [SAVE entries] if [entries NOT EXIST] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      List<EntryModel> actualEntriesToSave = <EntryModel>[
        EntryModel(
          id: 99998,
          encryptedBool: true,
          pinnedBool: true,
          index: 99998,
          filesystemPath: FilesystemPath.fromString('entries/entry99998'),
          name: 'NEW ENTRY 1',
          website: '',
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: false,
        ),
        EntryModel(
          id: 99999,
          encryptedBool: false,
          pinnedBool: true,
          index: 99999,
          filesystemPath: FilesystemPath.fromString('entries/entry99999'),
          name: 'NEW ENTRY 2',
          website: 'https://new-entry2.example',
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: true,
        ),
      ];

      // Act
      await globalLocator<EntriesService>().saveAll(actualEntriesToSave);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        const EntryEntity(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          index: 0,
          filesystemPathString: 'entries/entry1',
          name: 'ENTRY 0',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
          index: 1,
          filesystemPathString: 'entries/group1/entry2',
          name: 'ENTRY 1',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
        EntryEntity.fromEntryModel(actualEntriesToSave[0]),
        EntryEntity.fromEntryModel(actualEntriesToSave[1]),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });
  });

  group('Tests of EntriesService.deleteAllByParentPath()', () {
    test('Should [REMOVE entries] if [entries with path EXISTS] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<EntriesService>().deleteAllByParentPath(FilesystemPath.fromString('entries/group1'));

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        const EntryEntity(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
          index: 0,
          filesystemPathString: 'entries/entry1',
          name: 'ENTRY 0',
          website: 'https://snggle.com',
        ),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });

    test('Should [REMOVE ALL entries] if [path EMPTY]', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<EntriesService>().deleteAllByParentPath(const FilesystemPath.empty());

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      expect(actualEntriesDatabaseValue, <EntryEntity>[]);
    });
  });

  group('Tests of EntriesService.deleteById()', () {
    test('Should [REMOVE entry] if [entry EXISTS] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      await globalLocator<EntriesService>().deleteById(1);

      List<EntryEntity> actualEntriesDatabaseValue = await globalLocator<IsarDatabaseManager>().perform((Isar isar) {
        return isar.entries.where().findAll();
      });

      // Assert
      List<EntryEntity> expectedEntriesDatabaseValue = <EntryEntity>[
        const EntryEntity(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
          index: 1,
          filesystemPathString: 'entries/group1/entry2',
          name: 'ENTRY 1',
          website: 'https://snggle.com',
        ),
        const EntryEntity(
          id: 3,
          encryptedBool: false,
          pinnedBool: false,
          emailExistsBool: true,
          usernameExistsBool: false,
          passwordExistsBool: true,
          index: 2,
          filesystemPathString: 'entries/group1/entry3',
          name: 'ENTRY 2',
          website: 'https://snggle.com',
        ),
      ];

      expect(actualEntriesDatabaseValue, expectedEntriesDatabaseValue);
    });

    test('Should [throw ChildKeyNotFoundException] if [entry NOT EXISTS] in database', () async {
      // Assert
      expect(
        () => globalLocator<EntriesService>().deleteById(99999),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EntriesService.getLastIndex()', () {
    test('Should [return last entry index] if [database NOT EMPTY]', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      int actualLastIndex = await globalLocator<EntriesService>().getLastIndex();

      // Assert
      int expectedLastIndex = 2;

      expect(actualLastIndex, expectedLastIndex);
    });

    test('Should [return -1] if [database EMPTY]', () async {
      // Arrange
      await testDatabase.updateDatabaseMock(DatabaseMock.masterKeyOnlyDatabaseMock);

      // Act
      int actualLastIndex = await globalLocator<EntriesService>().getLastIndex();

      // Assert
      expect(actualLastIndex, -1);
    });
  });

  group('Tests of EntriesService.updateFilesystemPath()', () {
    test('Should [return updated EntryModel] if [entry EXISTS] in database', () async {
      // Arrange

      await testDatabase.updateDatabaseMock(DatabaseMock.fullDatabaseMock);

      // Act
      EntryModel actualEntryModel = await globalLocator<EntriesService>().updateFilesystemPath(
        1,
        FilesystemPath.fromString('entries/new/path'),
      );

      // Assert
      EntryModel expectedEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/new/path/entry1'),
        name: 'ENTRY 0',
        website: 'https://snggle.com',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
      );

      expect(actualEntryModel, expectedEntryModel);
    });

    test('Should [throw ChildKeyNotFoundException] if [entry NOT EXISTS] in database', () async {
      // Assert
      expect(
        globalLocator<EntriesService>().updateFilesystemPath(99999, FilesystemPath.fromString('entries/new/path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
