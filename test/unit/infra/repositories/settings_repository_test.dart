import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';

import '../../../utils/test_utils.dart';

void main() {
  SettingsRepository settingsRepository = SettingsRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Test of SettingsRepository.isSetupPinExist()', () {
    test('Should return false as [setupPinExistBool] does not exist on first launch', () async {
      // Act
      bool actualSetupPinExistBool = await settingsRepository.isSetupPinExist();

      // Assert
      expect(actualSetupPinExistBool, false);
    });
  });

  group('Test of SettingsRepository.isSetupPinVisible()', () {
    test('Should return value for [setupPinVisibleBool] database key', () async {
      // Arrange
      Exception expectedException = Exception('No data found for key: setupPinVisibleBool');

      try {
        // Act
        await settingsRepository.isSetupPinVisible();
      } on Exception catch (actualException) {
        // Assert
        TestUtils.printInfo('Should throw an Exception since [setupPinVisibleBool] key is not initialized and does not exist');
        expect(actualException.toString(), expectedException.toString());
      }

      // ********************************************************************************************************************

      //  Act
      await settingsRepository.setSetupPinVisible(value: true);
      String? actualSetupPinVisibleBool = await flutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return true after setting [setupPinVisibleBool] to true');
      expect(actualSetupPinVisibleBool, 'true');
    });
  });

  group('Test of SettingsRepository.setSetupPinVisible()', () {
    test('Should return value for [setupPinVisibleBool] database key', () async {
      // Act
      String? actualSetupPinVisibleBool = await flutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return null as storage data is empty, as it is not initialized or given any value');
      expect(actualSetupPinVisibleBool, null);

      // ********************************************************************************************************************

      // Act
      await settingsRepository.setSetupPinVisible(value: true);
      actualSetupPinVisibleBool = await flutterSecureStorage.read(key: DatabaseEntryKey.setupPinVisibleBool.name);

      // Assert
      TestUtils.printInfo('Should return true after setting [setupPinVisibleBool] to true');
      expect(actualSetupPinVisibleBool, 'true');
    });
  });
}
