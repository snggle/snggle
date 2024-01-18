import 'dart:convert';
import 'dart:io';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/filesystem_storage/encrypted_filesystem_storage_manager.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.secrets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  MasterKeyVO actualMasterKeyVO = MasterKeyVO(
    masterKeyCiphertext: Ciphertext.fromBase64(
      base64: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
      encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
    ),
  );

  // @formatter:off
  String secretsCipher1 = '6JE+uoVp0BPkg2Kq8Gcs0Ofm4ntvI4K6Xe44nHB2SPM2nOzeQnZp2OVJp2IYAGMgbfUgDSgKVA97fkuP58dF0uU2hCqTpVh8r60zJcLjy7mQTVTZTmf0oph7TVhNCHSvhtMhAmnTupnO7pM7G2t+yzMWkZI=';
  String secretsCipher2 = 'Dlc3Noq0nDYlD7kQM2R7v9EiMb5hHUb9vQeylaGiZKN1rxzNxwL6o8x60S9U2MhA/9YUAhV9Ni5bABl1koVI/SKGjV0k0+11Pay1ggrLw2ZUWxBVQd4mMHnHr6voUxGtj44PxzJjbfL2LjPz+DSxHXqSy/A=';

  String wrappedSecretsCipher1 = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': secretsCipher1,
  }, prettyPrintBool: true);

  String wrappedSecretsCipher2 = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': secretsCipher2,
  }, prettyPrintBool: true);

  String wrappedFileContent1 = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': 'xUPduZnpsa4tQvz0XUO+faMzsGL+P+0w3HYlQIeWVTl3zAsZJq0kNor9ipBV3NudufSHsunXNNBGj4FomRK8N0pwMAdmxioU+WS4UsCHZPvG6v12SfMOJ53A3NThYkvZo6kkWLGfeprFTT5Vk047+SnAX02i4dCdYfpXmIdWxLAADvRa6aYJtMrH95xIk37kdQTgwH+37fYQkNXlfj6NVBCN5B8kHSwr+1TAwkE3w2Gqv+dRESojUQKXG4G7x29pzYhcwidXk1XQag5XXStUmveRyGazDSKzGQ4xuy0XdsR9qh46'
  }, prettyPrintBool: true);

  String wrappedFileContent2 = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': '/vo6KCDNSLm0/1AhtiBrIlT32dMO4AScKvfz0uL25sLMYsqxCVopMU6fGkAWoBUuxG/ihM90xh9b6lsy1sb2StZsK0xNlnCO4n67sPQdTF8LhGCPNPHpdgGjiV3km6NgnyijBHcFHE3Zvgyrve2v6TEnPDeeAgvMjm8VL84bcf4CedHdFeIktiBhOmqo2gTb6PXbIQ7uknCVfDJr4fuch++JAd5ILEvr4x3iLpFjFHq9JzmshtYmBcLqBiHUdEwhBiuZ2/XWyQkZXtpryc2dKImyxIFISqSPmss7XbrP2oo4xh0E'
  }, prettyPrintBool: true);

  String wrappedUpdatedSecretsCipher = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': base64Encode('updated_value'.codeUnits),
  }, prettyPrintBool: true);

  String wrappedNewSecretsCipher = MapUtils.parseJsonToString(<String, dynamic>{
    'algorithm': 'AES/DHKE',
    'data': base64Encode('new_value'.codeUnits),
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

  late SecretsRepository actualSecretsRepository;
  late String testSessionUUID;

  setUp(() async {
    testSessionUUID = const Uuid().v4();
    TestUtils.setupTmpFilesystemStructureFromJson(actualFilesystemStructure, path: testSessionUUID);

    FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
    EncryptedFilesystemStorageManager actualEncryptedFilesystemStorageManager = EncryptedFilesystemStorageManager(
      rootDirectory: () async => Directory('${TestUtils.testRootDirectory.path}/$testSessionUUID'),
      databaseParentKey: actualDatabaseParentKey,
    );

    actualSecretsRepository = SecretsRepository(filesystemStorageManager: actualEncryptedFilesystemStorageManager);
  });

  group('Tests of SecretsRepository.getEncryptedSecrets()', () {
    test('Should [return encrypted secrets] if [secrets UUID EXISTS] in filesystem storage (1st depth)', () async {
      // Act
      Ciphertext actualSecretsCiphertext = await actualSecretsRepository.getEncryptedSecrets('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');

      // Assert
      Ciphertext expectedSecretsCiphertext = Ciphertext(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        bytes: base64Decode(secretsCipher1),
      );

      expect(actualSecretsCiphertext, expectedSecretsCiphertext);
    });

    test('Should [return encrypted secrets] if [secrets UUID EXISTS] in filesystem storage (2nd depth)', () async {
      // Act
      Ciphertext actualSecretsCiphertext = await actualSecretsRepository.getEncryptedSecrets(
        '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65',
      );

      // Assert
      Ciphertext expectedSecretsCiphertext = Ciphertext(
        encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke,
        bytes: base64Decode(secretsCipher2),
      );

      expect(actualSecretsCiphertext, expectedSecretsCiphertext);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXISTS] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualSecretsRepository.getEncryptedSecrets('not_exists_secret_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXISTS] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualSecretsRepository.getEncryptedSecrets('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/not_exists_secret_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsRepository.saveEncryptedSecrets()', () {
    test('Should [UPDATE secrets] if [secrets UUID EXISTS] in filesystem storage (1st depth)', () async {
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
      await actualSecretsRepository.saveEncryptedSecrets(
        '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8',
        Ciphertext(encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke, bytes: 'updated_value'.codeUnits),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(testSessionUUID, actualMasterKeyVO, actualAppPasswordModel);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedUpdatedSecretsCipher,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedSecretsCipher2,
          },
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [UPDATE secrets] if [secrets UUID EXISTS] in filesystem storage (2nd depth)', () async {
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
      await actualSecretsRepository.saveEncryptedSecrets(
        '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65',
        Ciphertext(encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke, bytes: 'updated_value'.codeUnits),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(testSessionUUID, actualMasterKeyVO, actualAppPasswordModel);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedSecretsCipher1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedUpdatedSecretsCipher,
          },
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with updated value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets UUID NOT EXIST] in filesystem storage (1st depth)', () async {
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
      await actualSecretsRepository.saveEncryptedSecrets(
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5',
        Ciphertext(encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke, bytes: 'new_value'.codeUnits),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(testSessionUUID, actualMasterKeyVO, actualAppPasswordModel);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedSecretsCipher1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedSecretsCipher2,
          },
          'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': wrappedNewSecretsCipher,
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [SAVE secrets] if [secrets UUID NOT EXIST] in filesystem storage (2nd depth)', () async {
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
      await actualSecretsRepository.saveEncryptedSecrets(
        '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/a99531ff-fd45-40c8-8ac1-6d723c305ee5',
        Ciphertext(encryptionAlgorithmType: EncryptionAlgorithmType.aesdhke, bytes: 'new_value'.codeUnits),
      );

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualFilesystemStructure = TestUtils.readDecryptedTmpFilesystemStructureAsJson(testSessionUUID, actualMasterKeyVO, actualAppPasswordModel);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedSecretsCipher1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{
            '9b282030-4c0f-482e-ba0d-524e10822f65.snggle': wrappedSecretsCipher2,
            'a99531ff-fd45-40c8-8ac1-6d723c305ee5.snggle': wrappedNewSecretsCipher,
          },
        }
      };

      TestUtils.printInfo('Should [return decrypted filesystem structure] with new value');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });
  });

  group('Tests of SecretsRepository.deleteSecrets()', () {
    test('Should [REMOVE secrets] if [secrets UUID EXISTS] in filesystem storage (1st depth)', () async {
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
      await actualSecretsRepository.deleteSecrets('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8');
      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{'secrets': <String, dynamic>{}};

      TestUtils.printInfo('Should [return filesystem structure] without removed secret');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [REMOVE secrets] if [secrets UUID EXISTS] in filesystem storage (2nd depth)', () async {
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
      await actualSecretsRepository.deleteSecrets('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/9b282030-4c0f-482e-ba0d-524e10822f65');
      actualFilesystemStructure = TestUtils.readTmpFilesystemStructureAsJson(path: testSessionUUID);

      // Assert
      expectedFilesystemStructure = <String, dynamic>{
        'secrets': <String, dynamic>{
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8.snggle': wrappedFileContent1,
          '5b3fe074-4b3a-49ea-a9f9-cd286df8eed8': <String, dynamic>{},
        }
      };

      TestUtils.printInfo('Should [return filesystem structure] without removed secret');
      expect(actualFilesystemStructure, expectedFilesystemStructure);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in filesystem storage (1st depth)', () async {
      // Assert
      expect(
        () => actualSecretsRepository.deleteSecrets('5b3fe074-4b3a-49ea-a9f9-cd286df8eed8/7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in filesystem storage (2nd depth)', () async {
      // Assert
      expect(
        () => actualSecretsRepository.deleteSecrets('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  tearDownAll(() {
    TestUtils.testRootDirectory.delete(recursive: true);
  });
}
