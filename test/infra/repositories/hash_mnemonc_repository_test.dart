import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/infra/repositories/hash_mnemonic_repository.dart';

void main() {
  HashMnemonicRepository hashMnemonicRepository = HashMnemonicRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Test of hashMnemonicRepository.setHashMnemonic', () {
    test('Should return true, to setting [hash_mnemonic] to "HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg=="', () async {
      // Act
      await hashMnemonicRepository.setHashMnemonic('HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==');
      Map<String, String> actualStorageData = await flutterSecureStorage.readAll();
      String? actualKeyValue = actualStorageData['hash_mnemonic'];
      String? expectedKeyValue = 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==';

      // Assert
      expect(actualKeyValue, expectedKeyValue);
    });
  });
}
