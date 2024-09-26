import 'dart:typed_data';

import 'package:snggle/shared/utils/abi_utils.dart';

enum ChunksPreviewListItemType {
  address,
  hex,
  number,
  text;

  factory ChunksPreviewListItemType.fromAbiChunk(Uint8List chunk) {
    String? stringValue = AbiUtils.parseChunkToString(chunk);
    if (stringValue != null) {
      return text;
    }

    String? addressValue = AbiUtils.parseChunkToAddress(chunk);
    if (addressValue != null && addressValue.startsWith('0x0') == false) {
      return address;
    }

    return hex;
  }
}
