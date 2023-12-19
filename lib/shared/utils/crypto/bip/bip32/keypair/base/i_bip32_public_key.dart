import 'dart:typed_data';

abstract interface class IBip32PublicKey {
  Uint8List get compressed;

  Uint8List get uncompressed;
}
