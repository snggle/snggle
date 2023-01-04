import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/repositories/settings_repository.dart';

import '../../utils/test_utils.dart';

void main() {
  SettingsRepository settingsRepository = SettingsRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group(
    'Test of SettingsRepository.isInitialSetupVisibleExist',
    () {
      test(
        'Should return false, as [is_initial_setup_visible] variable does not exist, on first launch',
        () async {
          // Act
          bool actualInitialSetupVisibleExistValue = await settingsRepository.isInitialSetupVisibleExist();
          bool expectedInitialSetupVisibleExistValue = false;

          // Assert
          expect(actualInitialSetupVisibleExistValue, expectedInitialSetupVisibleExistValue);
        },
      );
    },
  );
  group(
    'Test of SettingsRepository.setInitialSetupVisible',
    () {
      test(
        'Should return true for calling method setInitialSetupVisible and setting to true',
        () async {
          // Act
          Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
          Map<String, String> expectedStorageData = <String, String>{};

          // Assert
          TestUtils.printInfo('Should return true, as storage data is not initialized or given any value, hence the storage data is empty/null');
          expect(actualStorageData, expectedStorageData);

          // Act
          await settingsRepository.setInitialSetupVisible(value: true);

          actualStorageData = await flutterSecureStorage.readAll();
          expectedStorageData = <String, String>{'is_initial_setup_visible': 'true'};

          // Assert
          expect(actualStorageData, expectedStorageData);
        },
      );
    },
  );

  group(
    'Test of SettingsRepository.getInitialSetupVisible',
    () {
      test(
        'Should return true for retrieving [is_initial_setup_visible] value',
        () async {
          // Act

          Exception expectedException = Exception('No data found for key: is_initial_setup_visible');

          try {
            // Act
            await settingsRepository.getInitialSetupVisible();
          } on Exception catch (actualException) {
            // Assert
            TestUtils.printInfo('Should return true, as Exception is expected to be thrown as [is_initial_setup_visible] key is not initialized and does not exist');
            expect(actualException.toString(), expectedException.toString());
          }

          //  Act
          await settingsRepository.setInitialSetupVisible(value: true);

          Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
          String? actualInitialSetupVisibleValue = actualStorageData['is_initial_setup_visible'];
          String expectedInitialSetupVisibleValue = 'true';

          // Assert
          expect(actualInitialSetupVisibleValue, expectedInitialSetupVisibleValue);
        },
      );
    },
  );
}
