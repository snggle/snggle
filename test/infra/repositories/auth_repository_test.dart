import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/repositories/auth_repository.dart';

void main() {
  AuthRepository actualAuthRepository = AuthRepository();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of AuthRepository.checkAuthentication ', () {
    test('Should return false as there is no data stored on Authentication, on initial setup', () async {
      // Arrange
      Exception expectedException = Exception('No data found for key: is_authenticated');

      try {
        // Act
        await actualAuthRepository.checkAuthentication();
      } on Exception catch (actualException) {
        // Assert
        expect(actualException.toString(), expectedException.toString());
      }
    });
  });

  group('Tests of AuthRepository.checkSetupPinPage and setSetupPinPageFalse', () {
    test('Should return false as there is no data stored on SetupPinPage, on initial setup ', () async {
      // Arrange
      Exception expectedException = Exception('No data found for key: setup_pin_page');
      //  Act
      try {
        await actualAuthRepository.checkSetupPinPage();
      } on Exception catch (actualException) {
        // Assert
        expect(actualException.toString(), expectedException.toString());
      }
    });

    test('Should return false after User has setup and navigated through SetupPinPage ', () async {
      //  Arrange
      FlutterSecureStorage.setMockInitialValues(<String, String>{
        'setup_pin_page': 'false',
      });

      // Act
      String? actualValue = await actualAuthRepository.checkSetupPinPage();
      String expectedValue = 'false';

      expect(actualValue, expectedValue);
    });
  });

  group('Tests of AuthRepository.setAuthenticationTrue and setAuthenticationFalse', () {
    test('Should return true after setting Authentication "is_authenticated" to true', () async {
      // Act
      await actualAuthRepository.setAuthenticationTrue();
      bool actualValue = await actualAuthRepository.checkAuthentication() == 'true';

      bool expectedValue = true;

      // Assert
      expect(actualValue, expectedValue);
    });

    test('Should return false after setting Authentication "is_authenticated" to false', () async {
      // Act
      await actualAuthRepository.setAuthenticationFalse();
      bool actualValue = await actualAuthRepository.checkAuthentication() == 'false';

      bool expectedValue = true;

      // Assert
      expect(actualValue, expectedValue);
    });
  });

  group('Tests of AuthRepository.setHashMnemonicPassword and AuthRepository.getHashMnemonicPassword', () {
    test('Should return true for Setting up and Storing HashMnemonicPassword, and checking if they match at the end', () async {
      // Arrange
      FlutterSecureStorage actualStorage = const FlutterSecureStorage();

      String expectedHashMnemonic = 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==';

      // Act
      await actualAuthRepository.setHashMnemonicPassword(expectedHashMnemonic);
      Map<String, String> expectedStorageData = <String, String>{'encrypted_hash_mnemonic': expectedHashMnemonic};
      Map<String, String> actualStorageData = await actualStorage.readAll();

      // Assert
      expect(actualStorageData, expectedStorageData);
    });
  });
}
