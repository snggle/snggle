import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/repositories/initial_repository.dart';

import '../../utils/test_utils.dart';

void main() {
  InitialRepository initialRepository = InitialRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });
  group('Test of InitialRepository.CheckSetup', () {
    test('Should return true as CheckSetup sets [setup] true unless user authenticates or setup later ', () async {
      //  Act
      Map<String, String> actualStorageValues = await flutterSecureStorage.readAll();
      await initialRepository.checkSetup();

      bool actualSetupKeyExistValue = actualStorageValues.containsKey('setup');
      bool expectedSetupKeyExistsValue = true;

      //  Assert
      TestUtils.printInfo('Should return true to verify [setup] key exists');

      expect(actualSetupKeyExistValue, expectedSetupKeyExistsValue);

      String expectedStorageValueSetup = 'true';

      expect(actualStorageValues['setup'], expectedStorageValueSetup);
    });
  });
}
