import 'dart:typed_data';

import 'package:bech32/bech32.dart';

class Bech32Encoder {
  static String encode(String hrp, List<int> data) {
    Uint8List convertedData = _convertBits(data, 8, 5);
    // TODO(dominik): Implement own bech32 encoder
    return bech32.encode(Bech32(hrp, convertedData));
  }

  static Uint8List _convertBits(
    List<int> data,
    int startBitIndex,
    int endBitIndex, {
    bool padBool = true,
  }) {
    int acc = 0;
    int bits = 0;
    final List<int> result = <int>[];
    final int maxV = (1 << endBitIndex) - 1;

    for (final int v in data) {
      if (v < 0 || (v >> startBitIndex) != 0) {
        throw Exception('Got address byte smaller than zero or greater than 2^startBitIndex');
      }
      acc = (acc << startBitIndex) | v;
      bits += startBitIndex;
      while (bits >= endBitIndex) {
        bits -= endBitIndex;
        result.add((acc >> bits) & maxV);
      }
    }

    if (padBool) {
      if (bits > 0) {
        result.add((acc << (endBitIndex - bits)) & maxV);
      }
    } else if (bits >= startBitIndex) {
      throw Exception('Illegal zero padding');
    } else if (((acc << (endBitIndex - bits)) & maxV) != 0) {
      throw Exception('Non zero');
    }

    return Uint8List.fromList(result);
  }
}
