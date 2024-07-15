import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

import '../../../utils/test_database.dart';

// ignore_for_file: avoid_dynamic_calls
void main() {
  late TestDatabase testDatabase;

  // @formatter:off
  String encryptedFileContent1 = 'hWEsUfhiLoss2jAySYeMfY8Co/n9o99sAgJQ2+tBUJSOfShhfvdKRG7zTJY4+62vIEgeBSWAT8C0bJyEEx3MlJp1y3c7htnrFVxfh8SkVf5/yeV9LHX2HgMi0agb7Xkiluqsid/OOuI+PIoGO5JAy4J05pNdFh23yRqD44L3IjoQFCmJdEfyQFY2BsqvE7nzh8AKB/lqqpWVZcBT8VUgZR01fWcbYbCVJMXcSnsAfGBFLh9+';
  String encryptedFileContent2 = 'KWAq9P3hNdlRuaO1YngolL1vlHOcaFrEeCdphsn/RcW7NoYgvAo/u9EuBnJWm0tiGVeLLz2kp4NbTAWLauXgPsY8uoXnFEo89sqYqtaauCBTgoqQu2Voz7DplRUAzTd0v7NQf8Bkq9IeO5XIPQZI0ekC5+XtRH8LK+f3O5G14EBe38KvIBT2Zys70Jqjd0woRWVwimRG3u9hoYXRXLdbVXMtxZP0qOmKk0m+EFz4obmSIP1e';

  String encryptedSecrets1 = '6JE+uoVp0BPkg2Kq8Gcs0Ofm4ntvI4K6Xe44nHB2SPM2nOzeQnZp2OVJp2IYAGMgbfUgDSgKVA97fkuP58dF0uU2hCqTpVh8r60zJcLjy7mQTVTZTmf0oph7TVhNCHSvhtMhAmnTupnO7pM7G2t+yzMWkZI=';
  String encryptedSecrets2 = 'Dlc3Noq0nDYlD7kQM2R7v9EiMb5hHUb9vQeylaGiZKN1rxzNxwL6o8x60S9U2MhA/9YUAhV9Ni5bABl1koVI/SKGjV0k0+11Pay1ggrLw2ZUWxBVQd4mMHnHr6voUxGtj44PxzJjbfL2LjPz+DSxHXqSy/A=';
  // @formatter:on

  setUp(() async {
    // @formatter:off
    testDatabase = TestDatabase(
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
      secureStorageContent: <String, String>{
        SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      },
      filesystemStorageContent: <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedFileContent1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedFileContent2,
        },
      },
    );
    // @formatter:on
  });

  group('Test of initial filesystem state', () {
    test('Should [return Map of files and their content] as [files EXIST] in database', () async {
      // Act
      Map<String, dynamic> actualFilesystemStructure = testDatabase.readRawFilesystem();

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedFileContent1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedFileContent2,
        },
      };

      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });
  });

  group('Tests of SecretsService.changePassword()', () {
    test('Should [UPDATE secrets password] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Act
      await globalLocator<SecretsService>().changePassword(
        FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
        PasswordModel.fromPlaintext('1111'),
        PasswordModel.defaultPassword(),
      );

      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem();

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualUpdatedFilesystemStructure['secrets']['5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle'] = PasswordModel.defaultPassword().decrypt(
        encryptedData: actualUpdatedFilesystemStructure['secrets']['5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle'] as String,
      );
      actualUpdatedFilesystemStructure['secrets']['9b282030-4c0f-482e-ba0d-524e10822f65.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['secrets']['9b282030-4c0f-482e-ba0d-524e10822f65.snggle'] as String,
      );

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"mnemonic":"shrimp final march bracket have lazy taste govern obey away someone glad"}',
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw InvalidPasswordException] if [secrets path EXISTS] in filesystem storage and [password INVALID]', () async {
      // Assert
      expect(
        () => globalLocator<SecretsService>().changePassword(
          FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
          PasswordModel.fromPlaintext('invalid_password'),
          PasswordModel.defaultPassword(),
        ),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in filesystem storage', () async {
      // Assert
      expect(
        () => globalLocator<SecretsService>().changePassword(
          FilesystemPath.fromString('invalid_path'),
          PasswordModel.fromPlaintext('1111'),
          PasswordModel.defaultPassword(),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.get()', () {
    test('Should [return ASecretsModel] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Arrange
      FilesystemPath filesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');

      // Act
      ASecretsModel actualSecretsModel = await globalLocator<SecretsService>().get<VaultSecretsModel>(
        filesystemPath,
        PasswordModel.fromPlaintext('1111'),
      );

      // Assert
      ASecretsModel expectedSecretsModel = VaultSecretsModel(
        filesystemPath: filesystemPath,
        mnemonicModel: MnemonicModel.fromString('load capable clerk afraid unveil cliff junk motor million leopard beauty chalk'),
      );

      expect(actualSecretsModel, expectedSecretsModel);
    });

    test('Should [throw InvalidPasswordException] if [secrets path EXIST] in filesystem storage and [password INVALID]', () {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');

      // Assert
      expect(
        () => globalLocator<SecretsService>().get(actualFilesystemPath, PasswordModel.fromPlaintext('invalid_password')),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5');

      // Assert
      expect(
        () => globalLocator<SecretsService>().get(actualFilesystemPath, PasswordModel.fromPlaintext('1111')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.save()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in collection', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      await globalLocator<SecretsService>().save(
        actualUpdatedSecretsModel,
        PasswordModel.fromPlaintext('1111'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem();

      actualUpdatedFilesystemStructure['secrets']['9b282030-4c0f-482e-ba0d-524e10822f65.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['secrets']['9b282030-4c0f-482e-ba0d-524e10822f65.snggle'] as String,
      );

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedSecrets1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXISTS] in collection', () async {
      // Arrange
      ASecretsModel actualNewSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      await globalLocator<SecretsService>().save(
        actualNewSecretsModel,
        PasswordModel.fromPlaintext('1111'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem();

      actualUpdatedFilesystemStructure['secrets']['a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle'] = PasswordModel.fromPlaintext('1111').decrypt(
        encryptedData: actualUpdatedFilesystemStructure['secrets']['a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle'] as String,
      );

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedSecrets1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedSecrets2,
          'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });
  });

  group('Tests of SecretsService.move()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in filesystem storage', () async {
      // Act
      await globalLocator<SecretsService>().move(
        FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
        FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65/5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedSecrets2,
          '9b282030-4c0f-482e-ba0d-524e10822f65': <String, dynamic>{
            '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedSecrets1,
          }
        },
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Assert
      expect(
        () => globalLocator<SecretsService>().move(
          FilesystemPath.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
          FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        ),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.delete()', () {
    test('Should [REMOVE secrets] if [secrets path EXISTS] in collection', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      await globalLocator<SecretsService>().delete(actualUpdatedSecretsModel.filesystemPath);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      Map<String, dynamic> actualUpdatedFilesystemStructure = testDatabase.readDecryptedFilesystem();

      // Assert
      Map<String, dynamic> expectedUpdatedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedSecrets1,
        }
      };

      expect(actualUpdatedFilesystemStructure, expectedUpdatedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => globalLocator<SecretsService>().delete(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.isPasswordValid()', () {
    test('Should [return TRUE] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');

      // Act
      bool actualPasswordValidBool = await globalLocator<SecretsService>().isPasswordValid(
        actualFilesystemPath,
        PasswordModel.fromPlaintext('1111'),
      );

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [secrets path EXISTS] in filesystem storage and [password INVALID]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');

      // Act
      bool actualPasswordValidBool = await globalLocator<SecretsService>().isPasswordValid(
        actualFilesystemPath,
        PasswordModel.fromPlaintext('invalid_password'),
      );

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in collection', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a');

      // Assert
      expect(
        () => globalLocator<SecretsService>().isPasswordValid(actualFilesystemPath, PasswordModel.fromPlaintext('1111')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDown(() {
    testDatabase.close();
  });
}