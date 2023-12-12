import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  DatabaseParentKey actualDatabaseParentKey = DatabaseParentKey.secrets;

  PasswordModel actualAppPasswordModel = PasswordModel.fromPlaintext('1111');
  globalLocator<AuthSingletonCubit>().setAppPassword(actualAppPasswordModel);

  // @formatter:off
  MasterKeyVO actualMasterKeyVO = const MasterKeyVO(encryptedMasterKey: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==');

  String expectedEncryptedSecrets1 = '6JE+uoVp0BPkg2Kq8Gcs0Ofm4ntvI4K6Xe44nHB2SPM2nOzeQnZp2OVJp2IYAGMgbfUgDSgKVA97fkuP58dF0uU2hCqTpVh8r60zJcLjy7mQTVTZTmf0oph7TVhNCHSvhtMhAmnTupnO7pM7G2t+yzMWkZI=';
  String expectedEncryptedSecrets2 = 'Dlc3Noq0nDYlD7kQM2R7v9EiMb5hHUb9vQeylaGiZKN1rxzNxwL6o8x60S9U2MhA/9YUAhV9Ni5bABl1koVI/SKGjV0k0+11Pay1ggrLw2ZUWxBVQd4mMHnHr6voUxGtj44PxzJjbfL2LjPz+DSxHXqSy/A=';

  Map<String, String> filledSecretsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'LnQmXEiiQamCB+iTQMtl0vD5CQPEznpIBDa1/4iBk2Gx6msgHcAFC6G0UmFritOHnaU/bFzYRuBQk+xw/zocKFuUZyoHT9NdWZF86x8S/vmTxmUN/Pxkzf4LZAYNPhxO4NkkRUCDCo3YaBn3DZqVNn3HU3g89nxHmfpj3fP5cBm+YJhvX0x3VZCNVIWOjon2TkWVsWB+hkkvPKS9eKszJhFHOgmBMfW1hyM5nEVlkBAzxEBEilZrlKPnqKxG5cVMwIfsZqBRYIyRbLDMTwqWi8w2x9ot354RkIjhRXbixkgOYOmsRFSlXFrsSe3SEDfPWt1hXwTUbuaJtFc+vM+IfGSD2+JqKgk/ViCIpJthxtDWK/uhAn0Afv/0H+nWmS0LkXk5pqGk0xVsHzDzeD2KyvlI9ffJu8ruTt7qVgHQ2IafugYz9//S3V9IFkqAwOFaKJQlwMtntqN6t+y5BuPkZdyUGUyMsYe9riIq66eOH2gv41DpBubs0xq9oatiVrI9NtuvBIH/S+0Nd1czf9YPNwG2859zO8H+6W34NYezInwSNBcb',
  };

  Map<String, String> emptySecretsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };

  Map<String, String> masterKeyOnlyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  group('Tests of SecretsRepository.getEncryptedSecrets()', () {
    test('Should [return encrypted secrets] if [secrets UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Act
      String actualEncryptedSecrets = await actualSecretsRepository.getEncryptedSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5');

      // Assert
      expect(actualEncryptedSecrets, expectedEncryptedSecrets1);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Assert
      expect(
        () => actualSecretsRepository.getEncryptedSecrets('not_exists_secret_id'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of SecretsRepository.saveEncryptedSecrets()', () {
    test('Should [UPDATE secrets] if [secrets UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Act
      String? actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedSecretsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      Map<String, dynamic> actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': expectedEncryptedSecrets1,
        'e3548cb0-06b0-4b35-8616-4b2df7d31daf': expectedEncryptedSecrets2,
      };

      TestUtils.printInfo('Should [return Map of secrets] as ["secrets" key EXISTS] in database');
      expect(actualSecretsMap, expectedSecretsMap);

      // ************************************************************************************************

      // Act
      await actualSecretsRepository.saveEncryptedSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5', 'updated_value');
      actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedSecretsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': 'updated_value',
        'e3548cb0-06b0-4b35-8616-4b2df7d31daf': expectedEncryptedSecrets2,
      };

      TestUtils.printInfo('Should [return Map of secrets] with updated value');
      expect(actualSecretsMap, expectedSecretsMap);
    });

    test('Should [SAVE secrets] if [secrets UUID NOT EXIST] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptySecretsDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Act
      String? actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedSecretsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      Map<String, dynamic> actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedSecretsMap = <String, dynamic>{};

      TestUtils.printInfo('Should [return EMPTY map] as ["secrets" key value is EMPTY]');
      expect(actualSecretsMap, expectedSecretsMap);

      // ************************************************************************************************

      // Act
      await actualSecretsRepository.saveEncryptedSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5', 'new_value');
      actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedSecretsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': 'new_value',
      };

      TestUtils.printInfo('Should [return Map of secrets] with new value');
      expect(actualSecretsMap, expectedSecretsMap);
    });

    test('Should [SAVE secrets] if ["secrets" key NOT EXISTS] in database', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(masterKeyOnlyDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Act
      String? actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Assert
      TestUtils.printInfo('Should [return NULL] as ["secrets" key NOT EXISTS] in database');
      expect(actualEncryptedSecretsKeyValue, null);

      // ************************************************************************************************

      // Act
      await actualSecretsRepository.saveEncryptedSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5', 'new_value');
      actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedSecrets = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      Map<String, dynamic> actualSecretsMap = jsonDecode(actualDecryptedSecrets) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': 'new_value',
      };

      TestUtils.printInfo('Should [return Map of secrets] with new value');
      expect(actualSecretsMap, expectedSecretsMap);
    });
  });

  group('Tests of SecretsRepository.deleteSecrets()', () {
    test('Should [REMOVE secrets] if [secrets UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Act
      String? actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      String actualDecryptedSecretsKeyValue =
          actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      Map<String, dynamic> actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;

      // Assert
      Map<String, dynamic> expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': expectedEncryptedSecrets1,
        'e3548cb0-06b0-4b35-8616-4b2df7d31daf': expectedEncryptedSecrets2,
      };

      TestUtils.printInfo('Should [return Map of secrets] as ["secrets" key EXISTS] in database');
      expect(actualSecretsMap, expectedSecretsMap);

      // ************************************************************************************************

      // Act
      await actualSecretsRepository.deleteSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5');
      actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedSecretsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;

      // Assert
      expectedSecretsMap = <String, dynamic>{
        'e3548cb0-06b0-4b35-8616-4b2df7d31daf': expectedEncryptedSecrets2,
      };

      TestUtils.printInfo('Should [return Map of secrets] without removed secrets');
      expect(actualSecretsMap, expectedSecretsMap);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      SecretsRepository actualSecretsRepository = SecretsRepository();

      // Assert
      expect(
        () => actualSecretsRepository.deleteSecrets('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}