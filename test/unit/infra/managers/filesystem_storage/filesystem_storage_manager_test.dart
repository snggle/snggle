import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/test_utils.dart';

void main() {
  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'test': <String, dynamic>{
      '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
      '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
      '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
        'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
      }
    },
  };

  late String testSessionUUID;
  late FilesystemStorageManager actualFilesystemStorageManager;

  setUp(() async {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    actualFilesystemStorageManager = FilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: DatabaseParentKey.test,
    );
  });

  group('Tests of FilesystemStorageManager.read()', () {
    test('Should [return file content] if [file path EXISTS] (1st depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');

      // Assert
      String expectedFileContent = 'test1';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [return file content] if [file path EXISTS] (2nd depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093');

      // Assert
      String expectedFileContent = 'test3';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXISTS] (1st depth)', () async {
      // Assert
      expect(() => actualFilesystemStorageManager.read('not_exists'), throwsA(isA<ChildKeyNotFoundException>()));
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXISTS] (2nd depth)', () async {
      // Assert
      expect(() => actualFilesystemStorageManager.read('9b282030-4c0f-482e-ba0d-524e10822f65/not_exists'), throwsA(isA<ChildKeyNotFoundException>()));
    });
  });

  group('Tests of FilesystemStorageManager.write()', () {
    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

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

      TestUtils.printInfo('Should [return filesystem structure] as [files EXIST] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualFilesystemStorageManager.write('9b282030-4c0f-482e-ba0d-524e10822f65', 'updated_value');

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'updated_value',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          }
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

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

      TestUtils.printInfo('Should [return filesystem structure] as [files EXIST] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualFilesystemStorageManager.write('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093', 'updated_value');

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'updated_value',
          }
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

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

      TestUtils.printInfo('Should [return filesystem structure] as [files EXIST] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualFilesystemStorageManager.write('a99531ff-fd45-40c8-8ac1-6d723c305ee5', 'new_value');

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
          },
          'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': 'new_value',
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

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

      TestUtils.printInfo('Should [return filesystem structure] as [files EXIST] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualFilesystemStorageManager.write('9b282030-4c0f-482e-ba0d-524e10822f65/a99531ff-fd45-40c8-8ac1-6d723c305ee5', 'new_value');

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            'b1c2f688-85fc-43ba-9af1-52db40fa3093.snggle': 'test3',
            'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': 'new_value',
          }
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });
  });

  group('Tests of FilesystemStorageManager.delete()', () {
    test('Should [DELETE file] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

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

      TestUtils.printInfo('Should [return filesystem structure] as [files EXIST] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualFilesystemStorageManager.delete('9b282030-4c0f-482e-ba0d-524e10822f65');

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] without removed value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [DELETE file] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

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

      TestUtils.printInfo('Should [return filesystem structure] as [files EXIST] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualFilesystemStorageManager.delete('9b282030-4c0f-482e-ba0d-524e10822f65/b1c2f688-85fc-43ba-9af1-52db40fa3093');

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'test': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': 'test1',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': 'test2',
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{}
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] without removed value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.delete('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.delete('9b282030-4c0f-482e-ba0d-524e10822f65/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}
