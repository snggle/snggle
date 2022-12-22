import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/initial_service.dart';

void main() {
  initLocator();
  InitialService initialService = InitialService();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of InitialService.checkSetup', () {
    test('Should return true as on initial launch, setup is always true until user authenticates or decides to setup later', () async {
      bool actualSetupValue = await initialService.checkSetup();
      bool expectedSetupValue = true;
      expect(actualSetupValue, expectedSetupValue);
    });

    test('Should return true as on initial launch, setup is always true until user authenticates or decides to setup later', () async {
      Map<String, String> expectedStorageData = <String, String>{'setup': 'false'};
      FlutterSecureStorage.setMockInitialValues(expectedStorageData);

      await initialService.checkSetup();
      Map<String, String> actualStorageData = await storage.readAll();
      expect(actualStorageData, expectedStorageData);
    });
  });
}
