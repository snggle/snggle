import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/database_manager.dart';
import 'package:snggle/infra/repositories/private_key_repository.dart';

void main() {
  PrivateKeyRepository privateKeyRepository = PrivateKeyRepository();
  FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Test of PrivateKeyRepository.setPrivateKey()', () {
    test('Should return [privateKey] with value "HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg=="', () async {
      // Act
      await privateKeyRepository.setPrivateKey('HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==');
      String? actualPrivateKeyValue = await flutterSecureStorage.read(key: DatabaseEntryKey.privateKey.name);

      // Assert
      String? expectedPrivateKeyValue = 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==';
      
      expect(actualPrivateKeyValue, expectedPrivateKeyValue);
    });
  });
}
