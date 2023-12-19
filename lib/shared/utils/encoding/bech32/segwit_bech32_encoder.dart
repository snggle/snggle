import 'package:bech32/bech32.dart';

class SegwitBech32Encoder {
  static String encode(String hrp, int witnessVersion, List<int> witnessProgram) {
    return SegwitEncoder().convert(Segwit(hrp, witnessVersion, witnessProgram));
  }
}
