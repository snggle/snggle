import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../../utils/database_mock.dart';
import '../../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();
  late FilesystemStorageManager actualFilesystemStorageManager;

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.testEncryptedFilesystemMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

    actualFilesystemStorageManager = EncryptedFilesystemStorageManager(filesystemStorageKey: FilesystemStorageKey.test);
  });

  group('Tests of EncryptedFilesystemStorageManager.read()', () {
    test('Should [return decrypted file content] if [file path EXISTS] (1st depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read(FilesystemPath.fromString('id3'));

      // Assert
      String expectedFileContent = 'odszyfrowanawartoscdlasecretowwplikuid3.snggle';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [return decrypted file content] if [file path EXISTS] (2nd depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read(
        FilesystemPath.fromString('id1/id2'),
      );

      // Assert
      String expectedFileContent = 'odszyfrowanawartoscdlasecretowwplikuid2.snggle';

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
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('id1/not_exists')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EncryptedFilesystemStorageManager.write()', () {
    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(FilesystemPath.fromString('id1'), 'updated_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        'id1.snggle': 'updated_value',
        'id1': <String, dynamic>{
          'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('id1/id2'),
        'updated_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
        'id1': <String, dynamic>{
          'id2.snggle': 'updated_value',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('id4'),
        'new_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
        'id1': <String, dynamic>{
          'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
        },
        'id4.snggle': 'new_value',
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('id1/id4'),
        'new_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
        'id1': <String, dynamic>{
          'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
          'id4.snggle': 'new_value',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });
  });

  group('Tests of EncryptedFilesystemStorageManager.move()', () {
    test('Should [UPDATE file path] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.move(
        FilesystemPath.fromString('id3'),
        FilesystemPath.fromString('id1/id3'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
        'id1': <String, dynamic>{
          'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
          'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE file path] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.move(
        FilesystemPath.fromString('id1/id2'),
        FilesystemPath.fromString('id2'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
        'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.move(
          FilesystemPath.fromString('not_existing_path'),
          FilesystemPath.fromString('id1/not_existing_path'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.move(
          FilesystemPath.fromString('id1/not_existing_path'),
          FilesystemPath.fromString('not_existing_path'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EncryptedFilesystemStorageManager.delete()', () {
    test('Should [DELETE file] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await actualFilesystemStorageManager.delete(FilesystemPath.fromString('id3'));

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id1.snggle': 'ivLwwKeSXHFPJ0zn6Ho+p/GguNDqgiCY06q+m6yQtimC950HvCErT0Co2qvO883nlj63Sdtw3tZ+sPMmuAaxjuE0jTI=',
        'id1': <String, dynamic>{
          'id2.snggle': '+VFi5MHH4LjniKnYOVdUtB7Nqi+qMvAkn+X30T/L/WH/Co1WICQ4qSg9Hn2xKbl6AAzSAYY3/u+hXLbcVk/xLyFxzxs=',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [DELETE file] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.delete(FilesystemPath.fromString('id1/id2'));

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': 'ArG/y8mC0fAq4oB8bJrrLdiHhIJm+kv5JFueWL5+u2bc0YUb1QLlDKDkDPjwpSopHJOahBgqd8Z+ACAoiCusIQoQIE4=',
        'id1.snggle': 'ivLwwKeSXHFPJ0zn6Ho+p/GguNDqgiCY06q+m6yQtimC950HvCErT0Co2qvO883nlj63Sdtw3tZ+sPMmuAaxjuE0jTI=',
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
        () => actualFilesystemStorageManager.delete(FilesystemPath.fromString('id1/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}
