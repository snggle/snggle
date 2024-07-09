import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late FilesystemStorageManager actualFilesystemStorageManager;

  setUp(() async {
    // @formatter:off
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      secureStorageContent: <String, String>{
        SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      },
      filesystemStorageContent: <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          }
        },
      },
    );
    // @formatter:on

    actualFilesystemStorageManager = FilesystemStorageManager(filesystemStorageKey: FilesystemStorageKey.test);
  });

  group('Test of initial filesystem state', () {
    test('Should [return Map of files and their content] as [files EXIST] in database', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          }
        }
      };

      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });
  });

  group('Tests of FilesystemStorageManager.read()', () {
    test('Should [return file content] if [file path EXISTS] (1st depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read(FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'));

      // Assert
      String expectedFileContent = 'test1';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [return file content] if [file path EXISTS] (2nd depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read(
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093'),
      );

      // Assert
      String expectedFileContent = 'test3';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXISTS] (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('not_exists')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXISTS] (2nd depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/not_exists')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of FilesystemStorageManager.write()', () {
    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65'),
        'updated_value',
      );

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'updated_value',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          }
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093'),
        'updated_value',
      );

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'updated_value',
          }
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5'),
        'new_value',
      );

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          },
          'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': 'new_value',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/a99531ff-fd45-40c8-8ac1-6d723c305ee5'),
        'new_value',
      );

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
            'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': 'new_value',
          }
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });
  });

  group('Tests of FilesystemStorageManager.move()', () {
    test('Should [UPDATE file path] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.move(
        FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          }
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE file path] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.move(
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093'),
        FilesystemPath.fromString('b1c2f688-85fc-43ba-9af1-52db40fa3093'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.move(
          FilesystemPath.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
          FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.move(
          FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
          FilesystemPath.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of FilesystemStorageManager.delete()', () {
    test('Should [DELETE file] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.delete(FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'));

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          },
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [DELETE file] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.delete(FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093'));

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.delete(FilesystemPath.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.delete(FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}
