import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/repositories/commons_repository.dart';

import '../../utils/test_utils.dart';

void main() {
  CommonRepository commonsRepository = CommonRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group(
    'Test of CommonsRepository.isInitialSetupVisibleExist',
    () {
      test(
        'Should return false, as initially InitialSetupVisible variable does not exist',
        () async {
          // Act
          bool actualInitialSetupVisibleExistValue = await commonsRepository.isInitialSetupVisibleExist();
          bool expectedInitialSetupVisibleExistValue = false;

          expect(actualInitialSetupVisibleExistValue, expectedInitialSetupVisibleExistValue);

          // Assert
        },
      );
    },
  );
  group(
    'Test of CommonsRepository.setInitialSetupVisible',
    () {
      test(
        'Should return true for setting setInitialSetupVisible to True',
        () async {
          // Act
          Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
          Map<String, String> expectedStorageData = <String, String>{};

          // Assert
          TestUtils.printInfo('Should return true, as storage data is not initialized or given any value, hence the data is empty/null');
          expect(actualStorageData, expectedStorageData);

          // Act
          await commonsRepository.setInitialSetupVisible(value: true);

          actualStorageData = await flutterSecureStorage.readAll();
          expectedStorageData = <String, String>{'isInitialSetupVisible': 'true'};

          // Assert
          expect(actualStorageData, expectedStorageData);
        },
      );
    },
  );

  group(
    'Test of CommonsRepository.getInitialSetupVisible',
    () {
      test(
        'Should return true for retrieving InitialSetupVisible value',
        () async {
          // Act

          Exception expectedException = Exception('No data found for key: isInitialSetupVisible');

          try {
            // Act
            await commonsRepository.getInitialSetupVisible();
          } on Exception catch (actualException) {
            // Assert
            TestUtils.printInfo('Should return true, as Exception is thrown as InitialSetupVisible key is not initialized and does not exist');
            expect(actualException.toString(), expectedException.toString());
          }

          //  Act
          await commonsRepository.setInitialSetupVisible(value: true);

          Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
          String? actualInitialSetupVisibleValue = actualStorageData['isInitialSetupVisible'];
          String expectedInitialSetupVisibleValue = 'true';

          // Assert
          expect(actualInitialSetupVisibleValue, expectedInitialSetupVisibleValue);
        },
      );
    },
  );
}
