import 'dart:typed_data';

abstract interface class IBip32PrivateKey {
  Uint8List get chainCodeBytes;

  Uint8List get bytes;

  int get length;
}