import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/settings_repository.dart';
import 'package:snuggle/infra/services/hash_mnemonic_service.dart';

void main() {
  initLocator();
  SettingsRepository settingsRepository = SettingsRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  HashMnemonicService hashMnemonicService = HashMnemonicService();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of hashMnemonicService.setupLater ', () {
    test('Should return true, to [is_initial_setup_visible] is equal to false, due to user deciding to setup later', () async {
      // Act
      await settingsRepository.setInitialSetupVisible(value: false);
      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();

      Map<String, String> expectedStorageData = <String, String>{'is_initial_setup_visible': 'false'};

      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });

  group('Tests of hashMnemonicService.storeAuthentication ', () {
    test('Should return true, as [is_initial_setup_visible] is false, due to user deciding to authenticate with a pin', () async {
      // Act
      await hashMnemonicService.storeAuthentication(pin: '00000');

      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
      bool actualSetupValue = actualStorageData['is_initial_setup_visible'] == 'true';
      bool expectSetupValue = false;

      // Assert
      expect(actualSetupValue, expectSetupValue);
    });
  });
}
