import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/salt_entity.dart';
import 'package:snggle/infra/managers/database_entry_key.dart';
import 'package:snggle/infra/services/auth_service.dart';
import 'package:snggle/shared/models/salt_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  String hashedPassword0000 = '9AF15B336E6A9619928537DF30B2E6A2376569FCF9D7E773ECCEDE65606529A0';
  String hashedPassword0001 = '888B19A43B151683C87895F6211D9F8640F97BDC8EF32F03DBE057C8F5E56D32';

  AuthService actualAuthService = AuthService();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of AuthService.isAppPasswordExist()', () {
    test('Should return false for authentication, as it does not exist in database', () async {
      //  Act
      bool actualIsAppPasswordExist = await actualAuthService.isAppPasswordExist();

      // Assert
      bool expectedIsAppPasswordExist = false;
      expect(actualIsAppPasswordExist, expectedIsAppPasswordExist);
    });

    test('Should return true for authentication, as it does exist in database', () async {
      //  Act
      SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: hashedPassword0001, isDefaultPassword: false);
      await actualAuthService.setSaltModel(saltModel: actualSaltModel);

      bool actualIsAppPasswordExist = await actualAuthService.isAppPasswordExist();
      // Assert
      bool expectedIsAppPasswordExist = true;
      expect(actualIsAppPasswordExist, expectedIsAppPasswordExist);
    });
  });

  group('Tests of AuthService.isAppPasswordValid()', () {
    test('Should return true, for verifying password to be valid', () async {
      //  Act
      SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: hashedPassword0001, isDefaultPassword: false);
      await actualAuthService.setSaltModel(saltModel: actualSaltModel);
      bool actualIsPasswordValid = await actualAuthService.isAppPasswordValid(hashedPassword: hashedPassword0001);

      // Assert
      bool expectedIsPasswordValid = true;
      expect(actualIsPasswordValid, expectedIsPasswordValid);
    });

    test('Should return false, for verifying password to be invalid', () async {
      //  Act
      SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: hashedPassword0000, isDefaultPassword: false);
      await actualAuthService.setSaltModel(saltModel: actualSaltModel);
      bool actualIsPasswordValid = await actualAuthService.isAppPasswordValid(hashedPassword: hashedPassword0001);

      // Assert
      bool expectedIsPasswordValid = false;
      expect(actualIsPasswordValid, expectedIsPasswordValid);
    });
  });

  group('Tests of AuthService.isSaltExist()', () {
    test('Should return false for [salt], as it does not exist in database', () async {
      // Act
      bool actualIsSaltExist = await actualAuthService.isSaltExist();

      // Assert
      bool expectedIsSaltExist = false;
      expect(actualIsSaltExist, expectedIsSaltExist);
    });

    test('Should return true for [salt],as it does exist in database', () async {
      //  Act
      SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: AppConfig.defaultPassword, isDefaultPassword: true);
      await actualAuthService.setSaltModel(saltModel: actualSaltModel);
      bool actualIsSaltExist = await actualAuthService.isSaltExist();

      // Assert
      bool expectedIsSaltExist = true;
      expect(actualIsSaltExist, expectedIsSaltExist);
    });
  });

  group('Tests of AuthService.setSaltModel()', () {
    test('Should return value of [salt] that is stored in database', () async {
      // Act
      String? actualSaltValue = await actualFlutterSecureStorage.read(key: DatabaseEntryKey.salt.name);

      // Assert
      TestUtils.printInfo('Should return null, as [salt] does not exist in database and not setup up');
      expect(actualSaltValue, isNull);

      // ************************************************************************************************

      // Arrange
      SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: AppConfig.defaultPassword, isDefaultPassword: true);

      // Act
      await actualAuthService.setSaltModel(saltModel: actualSaltModel);

      String? actualSaltString = await actualFlutterSecureStorage.read(key: DatabaseEntryKey.salt.name);
      Map<String, dynamic> actualSaltJson = jsonDecode(actualSaltString!) as Map<String, dynamic>;
      SaltEntity actualSaltEntity = SaltEntity.fromJson(actualSaltJson);

      // Assert
      expect(actualSaltEntity.value, actualSaltModel.value);
    });
  });
}
