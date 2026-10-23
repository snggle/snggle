import 'dart:math';
import 'dart:typed_data';

class PasskeyCredentialIdGenerator {
  static Uint8List generate() {
    Random random = Random.secure();
    Uint8List credentialId = Uint8List(32);

    for (int i = 0; i < credentialId.length; i++) {
      credentialId[i] = random.nextInt(256);
    }

    return credentialId;
  }
}