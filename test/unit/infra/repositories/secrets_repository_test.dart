import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  final TestDatabase testDatabase = TestDatabase();

  // @formatter:off
  String encryptedSecrets1 = '3bqZheymtcYvUbKASR55Y2kxoD9iXYznIUTjpYxALM820UqAUAQvirWIk1sSTsXBoIX+qQzmrNgLvPkE8rYdnFrRnjl2py9Lql+Xw0NB5PTwPjBsdU+IwZAoPszHmWp/vddUwStzRfq6rFMkCCX8zJ46vm4=';
  String encryptedSecrets2 = 'OvNnlxduUz14vtjPlu+PYIwkItJSJ7TVpXGeCkwa84ZgeXGaoKLunDk39zNKeDLUD2W4Lz5ii5bARxPoIfYXF4j7eTqCWLqCNYdl64ooearXVU6KU5JLF0m9QtEsgwCKZ/uJJsgcXNlvQq4cTuOmbnNuiqs=';
  String encryptedSecrets3 = '9Kw28uVK7Hbvdh+58TPzfpDeApW3c91CMdZSMms24eV9S1TAmpobfoCboj/Tv9B+sLKj63ApHycABXM4YiyNXw+PG6PhlxfzMe6bV10XK5fQZh/3OD3Dx+QmijVFWce62WjeVkLVgKUNbd5dcawef7M9KME=';
  String encryptedSecrets4 = 'YSSiNeFbvtX6afWMus5YwDuHDcKZLQYM00sdkV5y90m/VpmMSqHTNVXIj6CR1sE906vigo17wyjp9tQq7yA9KnAvqL43GzwhMcUkGiUFvuMs0WPHgVLpBHrLF2Ej3HhkZmFAiv5Dny71DTM+oCzO3uk3P8s=';

  String encryptedFileContent1 = 'whB2abfEqvhUSoclUD6zEZ2gR78aYA6DYvi6xt1cR9OEtJ+X3j17pfKMoBzTwzAHa0T665Jpwm3Mw/KLvolNsDyEUPweHaV1YSOhBbp3LJ8QBfIzFvoNARNKPQfKUttmpCP/i5F64yNXQLeY47K0vJkbD0/nOrbztCI0Nj3ToO4DBKHn2vupQe6D6EN/zYdHO9dKcQoG/VKhYHKey58lA/z6mSR/u682S1L+yyoIM18TanFe';
  String encryptedFileContent2 = 'L4H7xI7i1vtIzQrxeo/rcbyaiqLyNCi6jJjB8fGEGhKUqhXy+I7F8BlNQ79V18n+QDFHhFVPdgxVveRxcjnqaAqxOQPmwCG2MplM6VWhtxosNCXYz52ldGuVx3vJHZNkvX7zgqQgn9SuhlD2Wxp6hrojS1zwqJG0e3Fn69ozK1RnlHproIoAAyv3OFo+418z6RN+fs8PMIHQYcida47MMsfeUMOctlck84OpLSU9pr0ziTnB';
  String encryptedFileContent3 = 'XZLhjzICVmPCeWBGnkfmu97OckmOnRywgrME3dUbR5RDFxKcIEPfPBfg5vWiQ4WpMjMBkYfLN+a+ww4r70IVI6aNOX41+E4evSJxo5o4SN5WePq00SvTqwkHdQ2dG5zo0MgkmWJujW0CKQHQg21KlVnnIenGkesUQezvsAcvsib38Tdw4/XXONvJ/mb6+K3zqwu4CuxDh9yIxXDJpx4cyW744Q6Ea/tuPxDJll4VgbgEnssv';
  String encryptedFileContent4 = 'QPsq8t6mRaxRaAKtYRMGdtthvJRHZmGZfB4gbYGJ+1lameKepC43YBRKY9lsZI1ZyqNcqrUccRe9SSXqTATboUM0Ppkp+9hUsA+sOy7DnniR/Gnab4e5lE5ACfWZQclwQYRKNO7srYOF4NPsOHycftKhcqOIPdW9iqoMcQK4LP33jadKc7mp+KCAhAzxls1DnZDN93Udr8+th+FwT3kXySDjykPrwfsEdiOGPEpwMFdijgEY';
  // @formatter:on

  setUp(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.testSecretsMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of SecretsRepository.getEncrypted()', () {
    test('Should [return encrypted secrets] if [secrets path EXISTS] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1');

      // Act
      String actualEncryptedSecrets = await globalLocator<SecretsRepository>().getEncrypted(actualFilesystemPath);

      // Assert
      String expectedEncryptedSecrets = encryptedSecrets1;

      expect(actualEncryptedSecrets, expectedEncryptedSecrets);
    });

    test('Should [return encrypted secrets] if [secrets path EXISTS] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/id2');

      // Act
      String actualEncryptedSecrets = await globalLocator<SecretsRepository>().getEncrypted(actualFilesystemPath);

      // Assert
      String expectedEncryptedSecrets = encryptedSecrets2;

      expect(actualEncryptedSecrets, expectedEncryptedSecrets);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsRepository>().getEncrypted(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsRepository>().getEncrypted(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsRepository.saveEncrypted()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1');

      // Act
      await globalLocator<SecretsRepository>().saveEncrypted(actualFilesystemPath, 'updated_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedSecrets3,
        'id1.snggle': 'updated_value',
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id1': <String, String>{'id2.snggle': encryptedSecrets2},
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE secrets] if [secrets path EXISTS] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/id2');

      // Act
      await globalLocator<SecretsRepository>().saveEncrypted(actualFilesystemPath, 'updated_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedSecrets3,
        'id1.snggle': encryptedSecrets1,
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id1': <String, String>{'id2.snggle': 'updated_value'}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id99999');

      // Act
      await globalLocator<SecretsRepository>().saveEncrypted(actualFilesystemPath, 'new_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedSecrets3,
        'id1.snggle': encryptedSecrets1,
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id99999.snggle': 'new_value',
        'id1': <String, String>{'id2.snggle': encryptedSecrets2}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/id99999');

      // Act
      await globalLocator<SecretsRepository>().saveEncrypted(actualFilesystemPath, 'new_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedSecrets3,
        'id1.snggle': encryptedSecrets1,
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id1': <String, String>{
          'id99999.snggle': 'new_value',
          'id2.snggle': encryptedSecrets2,
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });
  });

  group('Tests of SecretsRepository.move()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      await globalLocator<SecretsRepository>().move(
        FilesystemPath.fromString('id3'),
        FilesystemPath.fromString('id1/id3'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id1.snggle': encryptedSecrets1,
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id1': <String, String>{
          'id3.snggle': encryptedSecrets3,
          'id2.snggle': encryptedSecrets2,
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [UPDATE secrets] if [secrets path EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      await globalLocator<SecretsRepository>().move(
        FilesystemPath.fromString('id1/id2'),
        FilesystemPath.fromString('id2'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedSecrets3,
        'id1.snggle': encryptedSecrets1,
        'id3': <String, String>{'id4.snggle': encryptedSecrets4},
        'id2.snggle': encryptedSecrets2,
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => globalLocator<SecretsRepository>().move(
          FilesystemPath.fromString('not_existing_path'),
          FilesystemPath.fromString('id1/not_existing_path'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => globalLocator<SecretsRepository>().move(
          FilesystemPath.fromString('id1/not_existing_path'),
          FilesystemPath.fromString('not_existing_path'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsRepository.delete()', () {
    test('Should [REMOVE secrets] if [secrets path EXISTS] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id3');

      // Act
      await globalLocator<SecretsRepository>().delete(actualFilesystemPath);
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id1.snggle': encryptedFileContent1,
        'id3': <String, String>{'id4.snggle': encryptedFileContent4},
        'id1': <String, String>{'id2.snggle': encryptedFileContent2}
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [REMOVE secrets] if [secrets path EXISTS] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/id2');

      // Act
      await globalLocator<SecretsRepository>().delete(actualFilesystemPath);
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readRawFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id3.snggle': encryptedFileContent3,
        'id1.snggle': encryptedFileContent1,
        'id3': <String, String>{'id4.snggle': encryptedFileContent4},
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsRepository>().delete(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsRepository>().delete(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(testDatabase.close);
}