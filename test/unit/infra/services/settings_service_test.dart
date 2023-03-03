import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/services/auth_service.dart';
import 'package:snggle/infra/services/settings_service.dart';
import 'package:snggle/shared/models/salt_model.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage actualFlutterSecureStorage = const FlutterSecureStorage();
  SettingsService actualSettingsService = SettingsService();
  AuthService actualAuthService = AuthService();

  group('Tests of SettingsService.isSetupPinVisible()', () {
    test('Should return true as [setupPinVisibleBool] is set to true, until user authenticates or decides to setup later', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{DatabaseEntryKey.setupPinVisibleBool.name: 'true'});

      // Act
      await actualSettingsService.isSetupPinVisible();
      String? actualSetupPinVisibleBool = await actualFlutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      expect(actualSetupPinVisibleBool, 'true');
    });
  });

  group('Test of SettingsService.setSetupPinVisible()', () {
    test('Should return value for [setupPinVisibleBool] database key', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{});

      // Act
      String? actualSetupPinVisibleBool = await actualFlutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return null as storage data is not initialized or given any value, hence the storage data is empty/null');
      expect(actualSetupPinVisibleBool, null);

      // ********************************************************************************************************************

      // Act
      SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: AppConfig.defaultPassword, isDefaultPassword: true);
      await actualSettingsService.setSetupPinVisible(value: true);
      await actualAuthService.setSaltModel(saltModel: actualSaltModel);
      actualSetupPinVisibleBool = await actualFlutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return true after setting [setupPinVisibleBool] to true');
      expect(actualSetupPinVisibleBool, 'true');
    });
  });
}
