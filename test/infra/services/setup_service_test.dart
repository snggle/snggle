import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/commons_repository.dart';
import 'package:snuggle/infra/services/setup_service.dart';

import '../../utils/test_utils.dart';

void main() {
  initLocator();
  CommonRepository commonsRepository = CommonRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  SetupService setupService = SetupService();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of SetupService.setupLater ', () {
    test('Should return true, as isInitialSetupVisible is false as user has decided to setup later', () async {
      // Act
      await commonsRepository.setInitialSetupVisible(value: false);
      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();

      Map<String, String> expectedStorageData = <String, String>{'isInitialSetupVisible': 'false'};

      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });

  group('Tests of SetupService.storeAuthentication ', () {
    test('Should return true, as isInitialSetupVisible is false, as user decides authenticate with a pin', () async {
      // Act
      await setupService.storeAuthentication(pin: '00000');

      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
      bool actualSetupValue = actualStorageData['isInitialSetupVisible'] == 'true';
      bool expectSetupValue = false;

      // Assert
      TestUtils.printInfo('Should return false as SetupPinPage is no longer needed and user has authenticated, hence isInitialSetupVisible is set to false');
      expect(actualSetupValue, expectSetupValue);

      TestUtils.printInfo('Should return false as by deciding to authenticate, is_authenticated is set to true');

      bool actualAuthenticatedValue = actualStorageData['is_authenticated'] == 'true';
      bool expectedAuthenticatedValue = true;

      // Assert
      expect(actualAuthenticatedValue, expectedAuthenticatedValue);
    });
  });
}
