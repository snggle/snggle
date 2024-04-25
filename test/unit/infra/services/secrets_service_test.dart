import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.secrets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  String encryptedFileContent1 = 'hWEsUfhiLoss2jAySYeMfY8Co/n9o99sAgJQ2+tBUJSOfShhfvdKRG7zTJY4+62vIEgeBSWAT8C0bJyEEx3MlJp1y3c7htnrFVxfh8SkVf5/yeV9LHX2HgMi0agb7Xkiluqsid/OOuI+PIoGO5JAy4J05pNdFh23yRqD44L3IjoQFCmJdEfyQFY2BsqvE7nzh8AKB/lqqpWVZcBT8VUgZR01fWcbYbCVJMXcSnsAfGBFLh9+';
  String encryptedFileContent2 = 'KWAq9P3hNdlRuaO1YngolL1vlHOcaFrEeCdphsn/RcW7NoYgvAo/u9EuBnJWm0tiGVeLLz2kp4NbTAWLauXgPsY8uoXnFEo89sqYqtaauCBTgoqQu2Voz7DplRUAzTd0v7NQf8Bkq9IeO5XIPQZI0ekC5+XtRH8LK+f3O5G14EBe38KvIBT2Zys70Jqjd0woRWVwimRG3u9hoYXRXLdbVXMtxZP0qOmKk0m+EFz4obmSIP1e';

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedFileContent1,
      '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedFileContent2,
    },
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  late SecretsService actualSecretsService;
  late String testSessionUUID;

  setUp(() async {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: actualDatabaseParentKey,
    );

    SecretsRepository actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
    actualSecretsService = SecretsService(secretsRepository: actualSecretsRepository);
  });

  group('Tests of SecretsService.get()', () {
    test('Should [return ASecretsModel] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Arrange
      FilesystemPath filesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      ASecretsModel actualSecretsModel = await actualSecretsService.get<VaultSecretsModel>(filesystemPath, actualPasswordModel);

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
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Assert
      expect(
        () => actualSecretsService.get(actualFilesystemPath, actualPasswordModel),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualSecretsService.get(actualFilesystemPath, actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.save()', () {
    test('Should [UPDATE secrets] if [secrets path EXISTS] in collection', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedFileContent1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedFileContent2,
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as [secrets path EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.save(actualUpdatedSecretsModel, actualPasswordModel);

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = <String, dynamic>{
        'secrets': (actualFilesystemStructure['secrets'] as Map<String, dynamic>).map((String key, dynamic value) {
          return MapEntry<String, dynamic>(
            key,
            actualPasswordModel.decrypt(encryptedData: actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: value as String)),
          );
        }),
      };

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets path NOT EXISTS] in collection', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
      ASecretsModel actualNewSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedFileContent1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedFileContent2,
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as [secrets path EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.save(actualNewSecretsModel, actualPasswordModel);
      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = <String, dynamic>{
        'secrets': (actualFilesystemStructure['secrets'] as Map<String, dynamic>).map((String key, dynamic value) {
          return MapEntry<String, dynamic>(
            key,
            actualPasswordModel.decrypt(encryptedData: actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: value as String)),
          );
        }),
      };

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"mnemonic":"shrimp final march bracket have lazy taste govern obey away someone glad"}',
          'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });
  });

  group('Tests of SecretsService.delete()', () {
    test('Should [REMOVE secrets] if [secrets path EXISTS] in collection', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        filesystemPath: FilesystemPath.fromString('9b282030-4c0f-482e-ba0d-524e10822f65'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': encryptedFileContent1,
          '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': encryptedFileContent2,
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as [secrets path EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.delete(actualUpdatedSecretsModel.filesystemPath);

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = <String, dynamic>{
        'secrets': (actualFilesystemStructure['secrets'] as Map<String, dynamic>).map((String key, dynamic value) {
          return MapEntry<String, dynamic>(
            key,
            actualPasswordModel.decrypt(encryptedData: actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: value as String)),
          );
        }),
      };

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] without removed value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXIST] in filesystem storage', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('not_existing_path');

      // Assert
      expect(
        () => actualSecretsService.delete(actualFilesystemPath),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.isPasswordValid()', () {
    test('Should [return TRUE] if [secrets path EXISTS] in filesystem storage and [password VALID]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      bool actualPasswordValidBool = await actualSecretsService.isPasswordValid(actualFilesystemPath, actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [secrets path EXISTS] in filesystem storage and [password INVALID]', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Act
      bool actualPasswordValidBool = await actualSecretsService.isPasswordValid(actualFilesystemPath, actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets path NOT EXISTS] in collection', () async {
      // Arrange
      FilesystemPath actualFilesystemPath = FilesystemPath.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualSecretsService.isPasswordValid(actualFilesystemPath, actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}