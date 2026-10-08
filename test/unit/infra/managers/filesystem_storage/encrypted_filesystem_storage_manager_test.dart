import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/exceptions/invalid_filesystem_path_exception.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_manager.dart';
import 'package:snggle/infra/managers/filesystem_storage/filesystem_storage_root_dir.dart';
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

    actualFilesystemStorageManager = EncryptedFilesystemStorageManager(filesystemStorageRootDir: FilesystemStorageRootDir.test);
  });

  group('Tests of EncryptedFilesystemStorageManager.read()', () {
    test('Should [throw InvalidFilesystemPathException] if [file path EXISTS] (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('vaults')),
        throwsA(isA<InvalidFilesystemPathException>()),
      );
    });

    test('Should [return decrypted file content] if [file path EXISTS] (2nd depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read(FilesystemPath.fromString('vaults/id3'));

      // Assert
      String expectedFileContent = 'odszyfrowanawartoscdlasecretowwplikuid3.snggle';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [return decrypted file content] if [file path EXISTS] (3rd depth)', () async {
      // Act
      String actualFileContent = await actualFilesystemStorageManager.read(
        FilesystemPath.fromString('vaults/id1/id2'),
      );

      // Assert
      String expectedFileContent = 'odszyfrowanawartoscdlasecretowwplikuid2.snggle';

      expect(actualFileContent, expectedFileContent);
    });

    test('Should [throw InvalidFilesystemPathException] if [file path NOT EXISTS] (1st depth)', () async {
      // Assert

      expect(
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('not_existing_path')),
        throwsA(isA<InvalidFilesystemPathException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXISTS] (2nd depth)', () async {
      // Assert

      expect(
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('vaults/not_existing_path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [file path NOT EXISTS] (3rd depth)', () async {
      // Assert

      expect(
        () => actualFilesystemStorageManager.read(FilesystemPath.fromString('vaults/id1/not_existing_path')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of EncryptedFilesystemStorageManager.write()', () {
    test('Should [throw InvalidFilesystemPathException] if [file path EXISTS] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.write(
          FilesystemPath.fromString('vaults'),
          'updated_value',
        ),
        throwsA(isA<InvalidFilesystemPathException>()),
      );
    });

    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('vaults/id1'),
        'updated_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'vaults': <String, dynamic>{
          'id1': <String, dynamic>{
            'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
          },
          'id1.snggle': 'updated_value',
          'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE file content] if [file path EXISTS] in filesystem storage (3rd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('vaults/id1/id2'),
        'updated_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'vaults': <String, dynamic>{
          'id1': <String, dynamic>{
            'id2.snggle': 'updated_value',
          },
          'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
          'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw InvalidFilesystemPathException] if [file path NOT EXISTS] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualFilesystemStorageManager.write(
          FilesystemPath.fromString('not_existing_path'),
          'new_value',
        ),
        throwsA(isA<InvalidFilesystemPathException>()),
      );
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('vaults/id4'),
        'new_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'vaults': <String, dynamic>{
          'id1': <String, dynamic>{
            'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
          },
          'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
          'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
          'id4.snggle': 'new_value',
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE file] if [file path NOT EXIST] in filesystem storage (3rd depth)', () async {
      // Act
      await actualFilesystemStorageManager.write(
        FilesystemPath.fromString('vaults/id1/id4'),
        'new_value',
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'test');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'vaults': <String, dynamic>{
          'id1': <String, dynamic>{
            'id2.snggle': 'odszyfrowanawartoscdlasecretowwplikuid2.snggle',
            'id4.snggle': 'new_value',
          },
          'id1.snggle': 'odszyfrowanawartoscdlasecretowwplikuid1.snggle',
          'id3.snggle': 'odszyfrowanawartoscdlasecretowwplikuid3.snggle',
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });
  });

  tearDown(testDatabase.close);
}
