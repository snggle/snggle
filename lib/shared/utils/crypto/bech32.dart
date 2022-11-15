import 'dart:typed_data';

import 'package:bech32/bech32.dart' as bech32;

class Bech32Pair {
  final String hrp;
  final Uint8List data;

  Bech32Pair({
    required this.hrp,
    required this.data,
  });
}

/// Allows to easily encode into Bech32 some data using a
/// given human readable part.
class Bech32 {
  /// Encodes the given data using the Bech32 encoding with the
  /// given human readable part
  static String encode(String humanReadablePart, Uint8List data) {
    Uint8List convertedData = _convertBits(data, 8, 5);

    return bech32.bech32.encode(bech32.Bech32(humanReadablePart, convertedData));
  }

  /// Encodes the given data using the Bech32 encoding with the
  /// given human readable part
  static Bech32Pair decode(String bechAddress) {
    bech32.Bech32 decoded = bech32.bech32.decode(bechAddress);
    Uint8List program = _convertBits(decoded.data, 5, 8, pad: false);

    return Bech32Pair(data: Uint8List.fromList(program), hrp: decoded.hrp);
  }

  /// for bech32 coding
  static Uint8List _convertBits(
    List<int> data,
    int from,
    int to, {
    bool pad = true,
  }) {
    int acc = 0;
    int bits = 0;
    final List<int> result = <int>[];
    final int maxv = (1 << to) - 1;

    for (final int v in data) {
      if (v < 0 || (v >> from) != 0) {
        throw Exception();
      }
      acc = (acc << from) | v;
      bits += from;
      while (bits >= to) {
        bits -= to;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (to - bits)) & maxv);
      }
    } else if (bits >= from) {
      throw Exception('illegal zero padding');
    } else if (((acc << (to - bits)) & maxv) != 0) {
      throw Exception('non zero');
    }

    return Uint8List.fromList(result);
  }
}
