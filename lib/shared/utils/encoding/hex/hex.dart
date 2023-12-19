import 'dart:typed_data';

class Hex {
  static const int _invalidHexNibble = 256;

  /// Encode a bytes as a hex string.
  ///
  /// Input: data - the bytes to be encoded.
  ///        lowerCase - a flag indicating whether to use lowercase hexadecimal characters (default is true).
  /// Output: Returns a hex-encoded string.
  String encode(Uint8List data, {bool lowercaseBool = true}) {
    String s = '';
    for (int i = 0; i < data.length; i++) {
      int byte = data[i];
      if (byte < 0 || byte > 0xFF) {
        throw FormatException('Invalid byte ${byte.abs().toRadixString(16)}');
      }
      if (lowercaseBool) {
        s += _encodeNibbleLower(data[i] >> 4);
        s += _encodeNibbleLower(data[i] & 0x0F);
      } else {
        s += _encodeNibble(data[i] >> 4).toUpperCase();
        s += _encodeNibble(data[i] & 0x0F).toUpperCase();
      }
    }
    return s;
  }

  /// Decode a hex string into a Uint8Array.
  ///
  /// Input: hex - the hex string to be decoded.
  /// Output: Returns a bytes with data decoded from the hex string.
  ///
  /// Throws an error if the hex string length is not divisible by 2 or contains non-hex characters.
  Uint8List decode(String hex) {
    if (hex.isEmpty) {
      return Uint8List.fromList(List<int>.empty());
    }
    if (!hex.length.isEven) {
      throw const FormatException('Hex input string must be divisible by two');
    }
    final List<int> result = List<int>.filled(hex.length ~/ 2, 0);
    int haveBad = 0;
    for (int i = 0; i < hex.length; i += 2) {
      int v0 = _decodeNibble(hex.codeUnitAt(i));
      int v1 = _decodeNibble(hex.codeUnitAt(i + 1));
      result[i ~/ 2] = ((v0 << 4) | v1) & 0xFF;
      haveBad |= v0 & _invalidHexNibble;
      haveBad |= v1 & _invalidHexNibble;
    }
    if (haveBad != 0) {
      throw const FormatException('Incorrect characters for hex decoding');
    }
    return Uint8List.fromList(result);
  }

  String _encodeNibble(int b) {
    // b >= 0
    int result = b + 48;
    // b > 9
    result += ((9 - b) >> 8) & (-48 + 65 - 10);

    return String.fromCharCode(result);
  }

  String _encodeNibbleLower(int b) {
    int result = b + 48;
    // b > 9
    result += ((9 - b) >> 8) & (-48 + 97 - 10);

    return String.fromCharCode(result);
  }

  /// Decode a hexadecimal character to its integer value.
  ///
  /// Input: c - an integer representing the ASCII code of the character.
  /// Output: Returns the integer value of the hexadecimal character, or INVALID_HEX_NIBBLE for invalid characters.
  int _decodeNibble(int c) {
    int result = _invalidHexNibble;

    result += (((47 - c) & (c - 58)) >> 8) & (-_invalidHexNibble + c - 48);
    // A-F: c > 64 and c < 71
    result += (((64 - c) & (c - 71)) >> 8) & (-_invalidHexNibble + c - 65 + 10);
    // a-f: c > 96 and c < 103
    result += (((96 - c) & (c - 103)) >> 8) & (-_invalidHexNibble + c - 97 + 10);

    return result;
  }
}
