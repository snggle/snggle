import 'package:codec_utils/codec_utils.dart';

class StringUtils {
  static String getShortHex(String hex, int length) {
    if (HexCodec.isHex(hex)) {
      return '${hex.substring(0, length + 2)}...${hex.substring(hex.length - length)}';
    } else {
      return hex;
    }
  }
}
