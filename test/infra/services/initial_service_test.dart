import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/initial_service.dart';

void main() {
  initLocator();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  InitialService initialService = InitialService();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of InitialService.checkInitialVisibleSetup', () {
    test('Should return true as on initial launch, boolean [isInitialSetupVisible] is always true until user authenticates or decides to setup later', () async {
      //  Act
      bool actualSetupValue = await initialService.checkInitialVisibleSetup();
      bool expectedSetupValue = true;
      // Assert
      expect(actualSetupValue, expectedSetupValue);
    });

    test('Should return true as the database stored returns true as [isInitialSetupVisible] is true until user authenticate or decides to setup later', () async {
      // Arrange
      Map<String, String> expectedStorageData = <String, String>{'isInitialSetupVisible': 'false'};
      FlutterSecureStorage.setMockInitialValues(expectedStorageData);
      // Act
      await initialService.checkInitialVisibleSetup();
      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });
}
