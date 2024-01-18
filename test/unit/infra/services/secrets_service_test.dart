import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';
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
import 'package:snggle/shared/models/container_path.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.secrets;

  PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualPasswordModel);

  MasterKeyVO actualMasterKeyVO = MasterKeyVO(
    masterKeyCiphertext: Ciphertext.fromBase64(
      base64: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
    ),
  );

  // @formatter:off
  String wrappedFileContent1 = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': 'xUPduZnpsa4tQvz0XUO+faMzsGL+P+0w3HYlQIeWVTl3zAsZJq0kNor9ipBV3NudufSHsunXNNBGj4FomRK8N0pwMAdmxioU+WS4UsCHZPvG6v12SfMOJ53A3NThYkvZo6kkWLGfeprFTT5Vk047+SnAX02i4dCdYfpXmIdWxLAADvRa6aYJtMrH95xIk37kdQTgwH+37fYQkNXlfj6NVBCN5B8kHSwr+1TAwkE3w2Gqv+dRESojUQKXG4G7x29pzYhcwidXk1XQag5XXStUmveRyGazDSKzGQ4xuy0XdsR9qh46'
  }, prettyPrintBool: true);

  String wrappedFileContent2 = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': 'Jkrkl9efrN8zRLLhyiZjsSv0/lo5nWzhaaiBdokT4S2x5/hP5nMeZRRN3LHk4ZQ721qJ0vR4k2kWbAewGPhd1iUJQhN89YqgNZ+47P4IX5niq4WvKlZTYWbx+FlI9hKSF6gK4vBY73yaGgvu7uP4+uUwpHrRtp/h0gGWCC3HA9N/Ver/q18zMg8oIqpkLj+klHPWWCAgA+WXM6lGqXQ9wqcSIgI='
  }, prettyPrintBool: true);

  String wrappedMasterKey = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg=='
  }, prettyPrintBool: true);

  Map<String, dynamic> actualFilesystemStructure = <String, dynamic>{
    'secrets': <String, dynamic>{
      '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
      '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
        '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
      },
    },
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: wrappedMasterKey,
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

  group('Tests of SecretsService.getSecrets()', () {
    test('Should [return ASecretsModel] if [secrets UUID EXISTS] in filesystem storage and [password VALID] (1st depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      ASecretsModel actualSecretsModel = await actualSecretsService.getSecrets<VaultSecretsModel>(containerPathModel, actualPasswordModel);

      // Assert
      ASecretsModel expectedSecretsModel = VaultSecretsModel(
        containerPathModel: containerPathModel,
        mnemonicModel: MnemonicModel.fromString('load capable clerk afraid unveil cliff junk motor million leopard beauty chalk'),
      );

      expect(actualSecretsModel, expectedSecretsModel);
    });

    test('Should [return ASecretsModel] if [secrets UUID EXISTS] in filesystem storage and [password VALID] (2nd depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      ASecretsModel actualSecretsModel = await actualSecretsService.getSecrets<WalletSecretsModel>(containerPathModel, actualPasswordModel);

      // Assert
      ASecretsModel expectedSecretsModel = WalletSecretsModel(
        containerPathModel: containerPathModel,
        privateKey: Uint8List.fromList('private_key'.codeUnits),
      );

      expect(actualSecretsModel, expectedSecretsModel);
    });

    test('Should [throw InvalidPasswordException] if [secrets UUID EXIST] in filesystem storage and [password INVALID] (1st depth)', () {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Assert
      expect(
        () => actualSecretsService.getSecrets(containerPathModel, actualPasswordModel),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw InvalidPasswordException] if [secrets UUID EXIST] in filesystem storage and [password INVALID] (2nd depth)', () {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Assert
      expect(
        () => actualSecretsService.getSecrets(containerPathModel, actualPasswordModel),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in filesystem storage (1st depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualSecretsService.getSecrets(containerPathModel, actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/a99531ff-fd45-40c8-8ac1-6d723c305ee5');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualSecretsService.getSecrets(containerPathModel, actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.isSecretsPasswordValid()', () {
    test('Should [return TRUE] if [secrets UUID EXISTS] in filesystem storage and [password VALID] (1st depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      bool actualPasswordValidBool = await actualSecretsService.isSecretsPasswordValid(containerPathModel, actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return TRUE] if [secrets UUID EXISTS] in filesystem storage and [password VALID] (2nd depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65');
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      bool actualPasswordValidBool = await actualSecretsService.isSecretsPasswordValid(containerPathModel, actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [secrets UUID EXISTS] in filesystem storage and [password INVALID] (1st depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Act
      bool actualPasswordValidBool = await actualSecretsService.isSecretsPasswordValid(containerPathModel, actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [return FALSE] if [secrets UUID EXISTS] in filesystem storage and [password INVALID] (2nd depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65');
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Act
      bool actualPasswordValidBool = await actualSecretsService.isSecretsPasswordValid(containerPathModel, actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXISTS] in collection (1st depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualSecretsService.isSecretsPasswordValid(containerPathModel, actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXISTS] in collection (2nd depth)', () async {
      // Arrange
      ContainerPathModel containerPathModel = ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a');
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualSecretsService.isSecretsPasswordValid(containerPathModel, actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsService.saveSecrets()', () {
    test('Should [UPDATE secrets] if [secrets UUID EXISTS] in collection (1st depth)', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        containerPathModel: ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
          },
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as ["secrets" UUID EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.saveSecrets(actualUpdatedSecretsModel, actualPasswordModel);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(
        testSessionUUID,
        actualMasterKeyVO,
        actualPasswordModel,
        passwordBool: true,
      );

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}',
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"private_key": "707269766174655f6b6579"}',
          },
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [UPDATE secrets] if [secrets UUID EXISTS] in collection (2nd depth)', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = WalletSecretsModel(
        containerPathModel: ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65'),
        privateKey: Uint8List.fromList('updated_value'.codeUnits),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
          },
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as ["secrets" UUID EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.saveSecrets(actualUpdatedSecretsModel, actualPasswordModel);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(
        testSessionUUID,
        actualMasterKeyVO,
        actualPasswordModel,
        passwordBool: true,
      );

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"private_key":"757064617465645f76616c7565"}',
          },
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets UUID NOT EXISTS] in collection (1st depth)', () async {
      // Arrange
      ASecretsModel actualNewSecretsModel = VaultSecretsModel(
        containerPathModel: ContainerPathModel.fromString('a99531ff-fd45-40c8-8ac1-6d723c305ee5'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
          },
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as ["secrets" UUID EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.saveSecrets(actualNewSecretsModel, actualPasswordModel);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(
        testSessionUUID,
        actualMasterKeyVO,
        actualPasswordModel,
        passwordBool: true,
      );

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{'9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"private_key": "707269766174655f6b6579"}'},
          'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': '{"mnemonic":"mechanic win word session stamp pelican prison bachelor donate capital stuff love"}'
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets UUID NOT EXISTS] in collection (2nd depth)', () async {
      // Arrange
      ASecretsModel actualNewSecretsModel = WalletSecretsModel(
        containerPathModel: ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/a99531ff-fd45-40c8-8ac1-6d723c305ee5'),
        privateKey: Uint8List.fromList('updated_value'.codeUnits),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
          },
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as ["secrets" UUID EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.saveSecrets(actualNewSecretsModel, actualPasswordModel);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(
        testSessionUUID,
        actualMasterKeyVO,
        actualPasswordModel,
        passwordBool: true,
      );

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': '{"mnemonic":"load capable clerk afraid unveil cliff junk motor million leopard beauty chalk"}',
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': '{"private_key": "707269766174655f6b6579"}',
            'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': '{"private_key":"757064617465645f76616c7565"}',
          },
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });
  });

  group('Tests of SecretsService.deleteSecrets()', () {
    test('Should [REMOVE secrets] if [secrets UUID EXISTS] in collection (1st depth)', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        containerPathModel: ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
          },
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as ["secrets" UUID EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.deleteSecrets(actualUpdatedSecretsModel.containerPathModel);

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{'secrets': <String, dynamic>{}};

      TestUtils.printInfo('Should [return decrypted filesystem structure] without removed value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [REMOVE secrets] if [secrets UUID EXISTS] in collection (2nd depth)', () async {
      // Arrange
      ASecretsModel actualUpdatedSecretsModel = VaultSecretsModel(
        containerPathModel: ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65'),
        mnemonicModel: MnemonicModel.fromString(
          'mechanic win word session stamp pelican prison bachelor donate capital stuff love',
        ),
      );

      // Act
      Map<String, dynamic> actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      Map<String, dynamic> expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedFileContent2,
          },
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] as ["secrets" UUID EXISTS] in filesystem storage');
      expect(actualFilesystemStructure, expectedFilesystemStructure);

      // ************************************************************************************************

      // Act
      await actualSecretsService.deleteSecrets(actualUpdatedSecretsModel.containerPathModel);

      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{},
        },
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] without removed value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualSecretsService.deleteSecrets(ContainerPathModel.fromString('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualSecretsService.deleteSecrets(ContainerPathModel.fromString('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a')),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}