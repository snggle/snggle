import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/services/settings_service.dart';

import '../../../utils/test_utils.dart';

void main() {
  initLocator();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  SettingsService settingsService = SettingsService();

  group('Tests of SettingsService.isSetupPinVisible()', () {
    test('Should return true as on first launch, [setupPinExistBool] is always true until user authenticates or decides to setup later', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      
      // Act
      bool actualSetupPinValue = await settingsService.isSetupPinVisible();

      // Assert
      expect(actualSetupPinValue, true);
    });

    test('Should return true as [setupPinVisibleBool] is set to true, until user authenticates or decides to setup later', () async {
      // Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{DatabaseEntryKey.setupPinVisibleBool.name: 'true'});

      // Act
      await settingsService.isSetupPinVisible();
      String? actualSetupPinVisibleBool = await flutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      expect(actualSetupPinVisibleBool, 'true');
    });
  });

  group('Test of SettingsService.setSetupPinVisible()', () {
    test('Should return value for [setupPinVisibleBool] database key', () async {
      // Arrange 
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      
      // Act
      String? actualSetupPinVisibleBool = await flutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return null as storage data is not initialized or given any value, hence the storage data is empty/null');
      expect(actualSetupPinVisibleBool, null);

      // ********************************************************************************************************************
      
      // Act
      await settingsService.setSetupPinVisible(value: true);
      actualSetupPinVisibleBool = await flutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return true after setting [setupPinVisibleBool] to true');
      expect(actualSetupPinVisibleBool, 'true');
    });
  });
}
