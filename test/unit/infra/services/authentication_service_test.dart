import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/entities/salt_entity.dart';
import 'package:snggle/infra/services/authentication_service.dart';
import 'package:snggle/shared/models/salt_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  AuthenticationService authenticationService = AuthenticationService();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of AuthenticationService.setSaltModel()', () {
    test('Should return value for [salt] database key', () async {
      // Act
      String? actualSaltValue = await flutterSecureStorage.read(key: DatabaseEntryKey.salt.name);

      // Assert
      TestUtils.printInfo('Should return null, as [salt] does not exist in database before it is setup up');
      expect(actualSaltValue, isNull);

      // ************************************************************************************************

      // Arrange
      SaltModel saltModel = await SaltModel.generateSalt(password: '0000', isDefaultPassword: true);

      // Act
      await authenticationService.setSaltModel(saltModel: saltModel);

      String? actualSaltString = await flutterSecureStorage.read(key: DatabaseEntryKey.salt.name);
      Map<String, dynamic> actualSaltJson = jsonDecode(actualSaltString!) as Map<String, dynamic>;
      SaltEntity actualSaltEntity = SaltEntity.fromJson(actualSaltJson);

      // Assert
      TestUtils.printInfo('Should return salt after setting up [salt] in database');
      expect(actualSaltEntity.value, saltModel.value);
    });
  });
}
