import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/setup_service.dart';

import '../../utils/test_utils.dart';

void main() {
  initLocator();
  SetupService setupService = SetupService();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of SetupService.setupLater ', () {
    test('Should return true, as setup is failed as user has decided to setup later', () async {
      // Act
      await setupService.setupLater();
      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();

      Map<String, String> expectedStorageData = <String, String>{'setup': 'false'};

      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });

  group('Tests of SetupService.storeAuthentication ', () {
    test('Should return true, as setup is false, as user decides authenticate with a pin', () async {
      // Act
      await setupService.storeAuthentication(pin: '00000');

      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
      bool actualSetupValue = actualStorageData['setup'] == 'true';
      bool expectSetupValue = false;

      // Assert
      TestUtils.printInfo('Should return false as SetupPinPage is no longer needed and user has authenticated, hence setup is set to false');
      expect(actualSetupValue, expectSetupValue);

      TestUtils.printInfo('Should return false as by deciding to authenticate, is_authenticated is set to true');

      bool isAuthenticated = actualStorageData['is_authenticated'] == 'true';
      bool expectedIsAuthenticatedValue = true;

      // Assert
      expect(isAuthenticated, expectedIsAuthenticatedValue);
    });
  });
}
