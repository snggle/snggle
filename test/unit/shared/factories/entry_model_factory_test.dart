import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/entry_entity/entry_entity.dart';
import 'package:snggle/shared/factories/entry_model_factory.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of EntryModelFactory.createNewEntry()', () {
    test('Should [return EntryModel] with initial values (database EMPTY)', () async {
      // Act
      EntryModel actualEntryModel = await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
      );

      // Assert
      EntryModel expectedEntryModel = EntryModel(
        id: 1,
        index: 0,
        pinnedBool: false,
        encryptedBool: false,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'ENTRY 0',
        website: 'https://snggle.com',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
      );

      expect(actualEntryModel, expectedEntryModel);
    });

    test('Should [return EntryModel] with initial values (database NOT EMPTY)', () async {
      // Arrange
      await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries'),
        'ENTRY 0',
        'https://snggle.com',
        'entry1@example.com',
        'entry_user_1',
        'entry_password_1',
      );

      // Act
      EntryModel actualEntryModel = await globalLocator<EntryModelFactory>().createNewEntry(
        FilesystemPath.fromString('entries/group1'),
        'ENTRY 1',
        'https://snggle.com',
        '',
        'entry_user_2',
        '',
      );

      // Assert
      EntryModel expectedEntryModel = EntryModel(
        id: 2,
        index: 1,
        pinnedBool: false,
        encryptedBool: false,
        filesystemPath: FilesystemPath.fromString('entries/group1/entry2'),
        name: 'ENTRY 1',
        website: 'https://snggle.com',
        emailExistsBool: false,
        usernameExistsBool: true,
        passwordExistsBool: false,
      );

      expect(actualEntryModel, expectedEntryModel);
    });
  });

  group('Tests of EntryModelFactory.createFromEntities()', () {
    test('Should [return List of EntryModel] from given List of EntryEntity', () async {
      // Arrange
      List<EntryEntity> actualEntryEntityList = <EntryEntity>[
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
      ];

      // Act
      List<EntryModel> actualEntryModelList = await globalLocator<EntryModelFactory>().createFromEntities(actualEntryEntityList);

      // Assert
      List<EntryModel> expectedEntryModelList = <EntryModel>[
        EntryModel(
          id: 1,
          encryptedBool: false,
          pinnedBool: false,
          index: 0,
          filesystemPath: FilesystemPath.fromString('entries/entry1'),
          name: 'ENTRY 0',
          website: 'https://snggle.com',
          emailExistsBool: true,
          usernameExistsBool: true,
          passwordExistsBool: true,
        ),
        EntryModel(
          id: 2,
          encryptedBool: false,
          pinnedBool: false,
          index: 1,
          filesystemPath: FilesystemPath.fromString('entries/group1/entry2'),
          name: 'ENTRY 1',
          website: 'https://snggle.com',
          emailExistsBool: false,
          usernameExistsBool: true,
          passwordExistsBool: false,
        ),
      ];

      expect(actualEntryModelList, expectedEntryModelList);
    });
  });

  group('Tests of EntryModelFactory.createFromEntity()', () {
    test('Should [return EntryModel] from given EntryEntity', () async {
      // Arrange
      EntryEntity actualEntryEntity = const EntryEntity(
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
      );

      // Act
      EntryModel actualEntryModel = await globalLocator<EntryModelFactory>().createFromEntity(actualEntryEntity);

      // Assert
      EntryModel expectedEntryModel = EntryModel(
        id: 1,
        encryptedBool: false,
        pinnedBool: false,
        index: 0,
        filesystemPath: FilesystemPath.fromString('entries/entry1'),
        name: 'ENTRY 0',
        website: 'https://snggle.com',
        emailExistsBool: true,
        usernameExistsBool: true,
        passwordExistsBool: true,
      );

      expect(actualEntryModel, expectedEntryModel);
    });
  });

  tearDown(testDatabase.close);
}
