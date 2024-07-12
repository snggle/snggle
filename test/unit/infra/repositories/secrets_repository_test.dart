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
  String encryptedFileContent1 = 'hWEsUfhiLoss2jAySYeMfY8Co/n9o99sAgJQ2+tBUJSOfShhfvdKRG7zTJY4+62vIEgeBSWAT8C0bJyEEx3MlJp1y3c7htnrFVxfh8SkVf5/yeV9LHX2HgMi0agb7Xkiluqsid/OOuI+PIoGO5JAy4J05pNdFh23yRqD44L3IjoQFCmJdEfyQFY2BsqvE7nzh8AKB/lqqpWVZcBT8VUgZR01fWcbYbCVJMXcSnsAfGBFLh9+';
  String encryptedFileContent2 = 'KWAq9P3hNdlRuaO1YngolL1vlHOcaFrEeCdphsn/RcW7NoYgvAo/u9EuBnJWm0tiGVeLLz2kp4NbTAWLauXgPsY8uoXnFEo89sqYqtaauCBTgoqQu2Voz7DplRUAzTd0v7NQf8Bkq9IeO5XIPQZI0ekC5+XtRH8LK+f3O5G14EBe38KvIBT2Zys70Jqjd0woRWVwimRG3u9hoYXRXLdbVXMtxZP0qOmKk0m+EFz4obmSIP1e';
  String encryptedFileContent3 = 'hWEsUfhiLoss2jAySYeMfY8Co/n9o99sAgJQ2+tBUJSOfShhfvdKRG7zTJY4+62vIEgeBSWAT8C0bJyEEx3MlJp1y3c7htnrFVxfh8SkVf5/yeV9LHX2HgMi0agb7Xkiluqsid/OOuI+PIoGO5JAy4J05pNdFh23yRqD44L3IjoQFCmJdEfyQFY2BsqvE7nzh8AKB/lqqpWVZcBT8VUgZR01fWcbYbCVJMXcSnsAfGBFLh9+';

  String encryptedSecrets1 = '6JE+uoVp0BPkg2Kq8Gcs0Ofm4ntvI4K6Xe44nHB2SPM2nOzeQnZp2OVJp2IYAGMgbfUgDSgKVA97fkuP58dF0uU2hCqTpVh8r60zJcLjy7mQTVTZTmf0oph7TVhNCHSvhtMhAmnTupnO7pM7G2t+yzMWkZI=';
  String encryptedSecrets2 = 'Dlc3Noq0nDYlD7kQM2R7v9EiMb5hHUb9vQeylaGiZKN1rxzNxwL6o8x60S9U2MhA/9YUAhV9Ni5bABl1koVI/SKGjV0k0+11Pay1ggrLw2ZUWxBVQd4mMHnHr6voUxGtj44PxzJjbfL2LjPz+DSxHXqSy/A=';
  String encryptedSecrets3 = '6JE+uoVp0BPkg2Kq8Gcs0Ofm4ntvI4K6Xe44nHB2SPM2nOzeQnZp2OVJp2IYAGMgbfUgDSgKVA97fkuP58dF0uU2hCqTpVh8r60zJcLjy7mQTVTZTmf0oph7TVhNCHSvhtMhAmnTupnO7pM7G2t+yzMWkZI=';
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
        'id1.snggle': 'updated_value',
        'id1': <String, dynamic>{
          'id2.snggle': encryptedSecrets2,
        },
        'id3.snggle': encryptedSecrets3,
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
        'id1.snggle': encryptedSecrets1,
        'id1': <String, dynamic>{
          'id2.snggle': 'updated_value',
        },
        'id3.snggle': encryptedSecrets3,
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXIST] in filesystem storage (1st depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id4');

      // Act
      await globalLocator<SecretsRepository>().saveEncrypted(actualFilesystemPath, 'new_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id1.snggle': encryptedSecrets1,
        'id1': <String, dynamic>{
          'id2.snggle': encryptedSecrets2,
        },
        'id3.snggle': encryptedSecrets3,
        'id4.snggle': 'new_value',
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('id1/id4');

      // Act
      await globalLocator<SecretsRepository>().saveEncrypted(actualFilesystemPath, 'new_value');

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem(path: 'secrets');

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'id1.snggle': encryptedSecrets1,
        'id1': <String, dynamic>{
          'id2.snggle': encryptedSecrets2,
          'id4.snggle': 'new_value',
        },
        'id3.snggle': encryptedSecrets3,
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
        'id1': <String, dynamic>{
          'id2.snggle': encryptedSecrets2,
          'id3.snggle': encryptedSecrets3,
        },
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
        'id1.snggle': encryptedSecrets1,
        'id2.snggle': encryptedSecrets2,
        'id3.snggle': encryptedSecrets3,
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
        'id1': <String, dynamic>{
          'id2.snggle': encryptedFileContent2,
        },
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
        'id1.snggle': encryptedFileContent1,
        'id3.snggle': encryptedFileContent3,
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