import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/settings_service.dart';

void main() {
  initLocator();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  SettingsService settingsService = SettingsService();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of settingsService.checkInitialSetupVisible', () {
    test('Should return true as on first launch, boolean [is_initial_setup_visible] is always true until user authenticates or decides to setup later', () async {
      //  Act
      bool actualSetupValue = await settingsService.checkInitialSetupVisible();
      bool expectedSetupValue = true;

      // Assert
      expect(actualSetupValue, expectedSetupValue);
    });

    test('Should return true as the database storage [database] returns true to [is_initial_setup_visible] until user authenticates or decides to setup later', () async {
      // Arrange
      Map<String, String> expectedStorageData = <String, String>{'is_initial_setup_visible': 'false'};
      FlutterSecureStorage.setMockInitialValues(expectedStorageData);

      // Act
      await settingsService.checkInitialSetupVisible();
      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();

      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });
}
