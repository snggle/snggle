import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/authentication/auth_service.dart';

void main() {
  initLocator();
  AuthService actualAuthService = AuthService();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of ActualAuthService.authenticateLater ', () {
    test('Should return a map of stored data this is made, after user decides to authenticate later', () async {
      // Arrange
      FlutterSecureStorage actualStorage = const FlutterSecureStorage();

      // Act
      await actualAuthService.authenticateLater();

      Map<String, String> expectedStorageData = <String, String>{
        'setup_pin_page': 'false',
        'is_authenticated': 'false',
      };
      Map<String, String> actualStorageData = await actualStorage.readAll();

      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });

  group('Tests of ActualAuthService.isAuthenticated ', () {
    test('Should return false, as no authentication exists on initial run', () async {
      // Act
      bool actualAuthenticatedValue = await actualAuthService.isAuthenticated();
      bool expectedAuthenticatedValue = false;

      // Assert
      expect(actualAuthenticatedValue, expectedAuthenticatedValue);
    });
  });

  group('Tests of ActualAuthService.isAuthenticated ', () {
    test('Should return false, as user decides to authenticate later, hence Authentication remains false', () async {
      // Act
      await actualAuthService.authenticateLater();
      bool actualAuthenticatedValue = await actualAuthService.isAuthenticated();
      bool expectedAuthenticatedValue = false;

      // Assert
      expect(actualAuthenticatedValue, expectedAuthenticatedValue);
    });
  });

  group('Tests of ActualAuthService.isAuthenticationSetup ', () {
    test('Should return false, as no authentication exists or setup on initial run', () async {
      // Act
      bool actualAuthenticatedSetupValue = await actualAuthService.isAuthenticationSetup();
      bool expectedAuthenticatedSetupValue = false;

      // Assert
      expect(actualAuthenticatedSetupValue, expectedAuthenticatedSetupValue);
    });
  });

  group('Tests of ActualAuthService.storeAuthentication ', () {
    test('Should return true, as authentication is setup and stored', () async {
      // Act
      await actualAuthService.storeAuthentication(pin: 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==');

      bool actualAuthenticatedValue = await actualAuthService.isAuthenticated();
      bool expectedAuthenticatedValue = true;

      // Assert
      expect(actualAuthenticatedValue, expectedAuthenticatedValue);
    });
  });

  group('Tests of ActualAuthService.verifyAuthentication ', () {
    test('Should return an exception, as verification is false due to no data is setup and stored (storeAuthentication) on initial run', () async {
      // Arrange
      Exception expectedException = Exception('No data found for key: encrypted_hash_mnemonic');
      try {
        // Act
        await actualAuthService.verifyAuthentication(pin: '0000');
      } on Exception catch (actualException) {
        // Assert
        expect(actualException.toString(), expectedException.toString());
      }
    });
    test('Should return true, as Authentication is setup and stored', () async {
      // Arrange
      Map<String, String> expectedStorageData = <String, String>{
        'encrypted_hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
      };
      FlutterSecureStorage.setMockInitialValues(expectedStorageData);

      // Act
      bool actualVerificatioNValue = await actualAuthService.verifyAuthentication(pin: '0000');
      bool expectedVerificationValue = true;

      // Assert
      expect(actualVerificatioNValue, expectedVerificationValue);
    });
  });
}
