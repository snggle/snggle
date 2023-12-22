import 'dart:convert';
import 'dart:typed_data';

import 'package:blockchain_utils/hex/hex.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/repositories/secrets_repository.dart';
import 'package:snggle/infra/services/wallet_secrets_service.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
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
  String expectedEncryptedSecrets1 = 'xAohg0Q0yPeRx3wegUlGFPdYCQ5nPip5rvbdxtw2HgHQbQQZwb7LnhpvjdduF8jbWniPi+1X9QIZ3Bfw5k76DH6QaDMEp8446WVk59rM2OImPu6QPK/2nhu61feAHnCKA2jYaLmdjneEeXJKrYX4UxkknG8=';
  String expectedEncryptedSecrets2 = 'MikH9YX1QYmnLB/dudq71ckTGZ132n4WoVwskH/oH59fqXdx0/lRWoZzusbwINRnNtGc9BsJeZxui2WzjG+ObNzgYOey0poZvOe6TB30SgdVd4/uSIRpFOFCOnTME8MRBH1nYWDtKwmh3ak0h71aFiD5MMU=';

  Map<String, String> filledSecretsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name:'TeDLix7Fw5el5wFZdvFN2fBW52/JRQEg7WVomvccH9RkDxytWoOuJQP+Od4K6o+S3aKThsV01r/suyJoMxBSsvNke+09OQGC3SHXy2CGsWil1H4QH0S3hPQ+snjWS+hq5dOO7Ob6L9cPJtqDMggPy8zyg4idOc8QNBRmjzn39IfbAOykpoeBpDHTl4gU32H/ylJSFNuxNX5eWd3FAz8SjHJX6gmXwfKetLiyw+S5tvQ+ya2mdtx0slJyOp5YLQEBsQvz6Yx//gxE0oBvHcqOOij0rTu86/gIkmBAksqanlVQYGkCe6uNgwcdeKUKfT4eg+BMDCD+hMXzsXbaJ7HIs6lZYb3G/ZQNF6mfJj2NfZztbksf5r2EwB6x0XcX7G+ZPIk2Mpr7ZdPKY8BcGZqIHOrEWhvmZBpirHIy6ISEtsOEKQC7xpsfRLnhd1lNH07UctOIEEQdaRlpQOY+BQszpBD/B5Gdp3PlIx3HCCTeqazIxjZcIV2TIF1OrDbncrx27aGrC/5GC6/XoXnD0b+GbwrMIcdXJkA0RnxX/u+iIcfU3YWg',
  };

  Map<String, String> emptySecretsDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
    actualDatabaseParentKey.name: 'L8uo+Q4teE3WrID1Cnhcopjcv9XJnZFFUBK6X/GfhuW2IFAm',
  };
  // @formatter:on

  group('Tests of WalletSecretsService.getSecrets()', () {
    test('Should [return WalletSecretsModel] if [secrets UUID EXISTS] in collection and [password VALID]', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

      // Act
      WalletSecretsModel actualWalletSecretsModel = await actualWalletSecretsService.getSecrets('e3548cb0-06b0-4b35-8616-4b2df7d31daf', actualPasswordModel);

      // Assert
      WalletSecretsModel expectedWalletSecretsModel = WalletSecretsModel(
        walletUuid: 'e3548cb0-06b0-4b35-8616-4b2df7d31daf',
        privateKey: Uint8List.fromList(hex.decode('7d92932269942b38263649110abc72cc5807b65a3d92150f1b820d60dca32569')),
      );

      expect(actualWalletSecretsModel, expectedWalletSecretsModel);
    });

    test('Should [throw InvalidPasswordException] if [secrets UUID EXIST] in collection and [password INVALID]', () {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

      // Assert
      expect(
        () => actualWalletSecretsService.getSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5', actualPasswordModel),
        throwsA(isA<InvalidPasswordException>()),
      );
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXIST] in collection', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptySecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

      // Assert
      expect(
        () => actualWalletSecretsService.getSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5', actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletSecretsService.isSecretsPasswordValid()', () {
    test('Should [return TRUE] if [secrets UUID EXISTS] in collection and [password VALID]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());
      PasswordModel actualValidPasswordModel = PasswordModel.fromPlaintext('1111');

      // Act
      bool actualPasswordValidBool = await actualWalletSecretsService.isSecretsPasswordValid('e3548cb0-06b0-4b35-8616-4b2df7d31daf', actualValidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, true);
    });

    test('Should [return FALSE] if [secrets UUID EXISTS] in collection and [password INVALID]', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());
      PasswordModel actualInvalidPasswordModel = PasswordModel.fromPlaintext('invalid_password');

      // Act
      bool actualPasswordValidBool =
          await actualWalletSecretsService.isSecretsPasswordValid('e3548cb0-06b0-4b35-8616-4b2df7d31daf', actualInvalidPasswordModel);

      // Assert
      expect(actualPasswordValidBool, false);
    });

    test('Should [throw ChildKeyNotFoundException] if [secrets UUID NOT EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptySecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');

      // Assert
      expect(
        () => actualWalletSecretsService.isSecretsPasswordValid('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a', actualPasswordModel),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });

  group('Tests of WalletSecretsService.saveSecrets()', () {
    test('Should [UPDATE secrets] if [secrets UUID EXISTS] in collection', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
      WalletSecretsModel actualNewWalletSecretsModel = WalletSecretsModel(
        walletUuid: 'a99531ff-fd45-40c8-8ac1-6d723c305ee5',
        privateKey: Uint8List.fromList(hex.decode('8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241')),
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

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
      await actualWalletSecretsService.saveSecrets(actualNewWalletSecretsModel, actualPasswordModel);
      actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedSecretsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;
      actualSecretsMap =
          actualSecretsMap.map((String key, dynamic value) => MapEntry<String, dynamic>(key, actualPasswordModel.decrypt(encryptedData: value.toString())));

      // Assert
      expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': '{"private_key":"8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241"}',
        'e3548cb0-06b0-4b35-8616-4b2df7d31daf': '{"private_key":"7d92932269942b38263649110abc72cc5807b65a3d92150f1b820d60dca32569"}',
      };

      TestUtils.printInfo('Should [return Map of secrets] with updated value');
      expect(actualSecretsMap, expectedSecretsMap);
    });

    test('Should [SAVE secrets] if [secrets UUID NOT EXISTS] in collection', () async {
      // Arrange
      PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('1111');
      WalletSecretsModel actualNewWalletSecretsModel = WalletSecretsModel(
        walletUuid: 'a99531ff-fd45-40c8-8ac1-6d723c305ee5',
        privateKey: Uint8List.fromList(hex.decode('8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241')),
      );

      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(emptySecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

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
      await actualWalletSecretsService.saveSecrets(actualNewWalletSecretsModel, actualPasswordModel);
      actualEncryptedSecretsKeyValue = await actualFlutterSecureStorage.read(key: actualDatabaseParentKey.name);

      // Output is always a random string because AES changes the initialization vector with Random Secure
      // and we cannot match the hardcoded expected result. That's why we check whether it is possible to decode database value
      actualDecryptedSecretsKeyValue = actualMasterKeyVO.decrypt(appPasswordModel: actualAppPasswordModel, encryptedData: actualEncryptedSecretsKeyValue!);
      actualSecretsMap = jsonDecode(actualDecryptedSecretsKeyValue) as Map<String, dynamic>;
      actualSecretsMap =
          actualSecretsMap.map((String key, dynamic value) => MapEntry<String, dynamic>(key, actualPasswordModel.decrypt(encryptedData: value.toString())));

      // Assert
      expectedSecretsMap = <String, dynamic>{
        'a99531ff-fd45-40c8-8ac1-6d723c305ee5': '{"private_key":"8f682dc033e2d45478fe62c41940313f74b290e5a1d7fbe215c9cfd48fafb241"}',
      };

      TestUtils.printInfo('Should [return Map of secrets] with saved secrets');
      expect(actualSecretsMap, expectedSecretsMap);
    });
  });

  group('Tests of WalletSecretsService.deleteSecrets()', () {
    test('Should [REMOVE secrets] if [secrets UUID EXISTS] in collection', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledSecretsDatabase));
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

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
      await actualWalletSecretsService.deleteSecrets('a99531ff-fd45-40c8-8ac1-6d723c305ee5');
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
      WalletSecretsService actualWalletSecretsService = WalletSecretsService(secretsRepository: SecretsRepository());

      // Assert
      expect(
        () => actualWalletSecretsService.deleteSecrets('7ff2abaa-e943-4b9c-8745-fa7e874d7a6a'),
        throwsA(isA<ChildKeyNotFoundException>()),
      );
    });
  });
}