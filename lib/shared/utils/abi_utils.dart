import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:snggle/shared/models/abi_chunk_type.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';

/// The [AbiUtils] class provides a simplified ABI decoding utility specifically for the "SNGGLE" application.
/// This implementation allows ABI function bytes to be processed without needing access to the contract ABI definition.
///
/// The simplified decoding process divides function bytes into 32-byte chunks. Each chunk is then
/// automatically interpreted with a default data type, which can be one of four types: Address, Hex, Text, or Number:
/// - If a chunk begins with bytes exclusively in the human-readable ASCII range (32-126), it defaults to String
/// - If a chunk ends with 20 non-zero bytes, it defaults to Address
/// - If a chunk is not an Address or String, it defaults to Hex
///
/// This decoding feature is tailored specifically for "SNGGLE" and is not exported to the "cryptography_utils" package,
/// as its methods and functionality are closely tied to application-specific requirements.
/// For example, the automatic detection of default data types in [AbiUtils] is customized to
/// meet the particular needs of "SNGGLE" and may not be universally applicable.
class AbiUtils {
  /// The default chunk size for ABI decoding
  static const int _abiChunkSize = 32;

  /// Splits the input [bytes] into chunks of 32 bytes
  static List<Uint8List> splitIntoChunks(Uint8List bytes) {
    List<Uint8List> abiChunks = <Uint8List>[];
    for (int start = 0; start < bytes.length; start += _abiChunkSize) {
      int end = start + _abiChunkSize;
      if (end > bytes.length) {
        end = bytes.length;
      }
      abiChunks.add(bytes.sublist(start, end));
    }
    return abiChunks;
  }

  /// Recognizes the type of the provided 32-byte [chunk] and returns the corresponding [AbiChunkType].
  /// - If the chunk can be decoded as human-readable ASCII text, it is classified as [AbiChunkType.text].
  /// - If the chunk is identified as an address (20 non-zero bytes at the end) it is classified as [AbiChunkType.address].
  /// - If neither of the above conditions are met, the chunk defaults to [AbiChunkType.hex].
  static AbiChunkType recognizeChunkType(Uint8List chunk) {
    String? stringValue = AbiUtils.parseChunkToString(chunk);
    String? addressValue = AbiUtils.parseChunkToAddress(chunk);

    bool textBool = stringValue != null;
    bool addressBool = addressValue != null && addressValue.startsWith('0x0') == false;

    if (textBool) {
      return AbiChunkType.text;
    } else if (addressBool) {
      return AbiChunkType.address;
    } else {
      return AbiChunkType.hex;
    }
  }

  /// Decodes a 32-byte chunk as an Address if the last 20 bytes are non-zero, returning the address
  /// as a hexadecimal string with a "0x" prefix. Returns null if the chunk cannot be decoded as an address.
  static String? parseChunkToAddress(Uint8List chunkBytes) {
    List<int> addressBytes = _removeLeadingZeros(chunkBytes, minLength: 20);

    if (addressBytes.length == 20) {
      return HexCodec.encode(addressBytes, includePrefixBool: true);
    } else {
      return null;
    }
  }

  /// Decodes a 32-byte chunk as a Number by interpreting it as a BigInt and returning the numerical
  /// representation as a string.
  static String parseChunkToNumber(Uint8List chunkBytes) {
    return BigIntUtils.decode(chunkBytes).toString();
  }

  /// Decodes a 32-byte chunk as Text if it contains only a human-readable ASCII characters (range 32-126)
  /// and has a minimum length of 3 characters. Returns null if the chunk does not meet these criteria.
  static String? parseChunkToString(Uint8List chunkBytes) {
    List<int> textBytes = _removeTrailingZeros(chunkBytes);

    bool humanReadableAsciiBool = textBytes.every((int byte) => byte >= 32 && byte <= 126);
    bool minStringLengthBool = textBytes.length >= 3;

    if (minStringLengthBool && humanReadableAsciiBool) {
      return String.fromCharCodes(textBytes);
    } else {
      return null;
    }
  }

  /// Utility method to remove leading zeroes from [bytes]
  static List<int> _removeLeadingZeros(List<int> bytes, {int minLength = 0}) {
    List<int> trimmedBytes = List<int>.from(bytes);
    while (trimmedBytes.length > minLength && trimmedBytes.first == 0) {
      trimmedBytes.removeAt(0);
    }
    return trimmedBytes;
  }

  /// Utility method to remove trailing zeroes from [bytes]
  static List<int> _removeTrailingZeros(List<int> bytes, {int minLength = 0}) {
    List<int> trimmedBytes = List<int>.from(bytes);
    while (trimmedBytes.length > minLength && trimmedBytes.last == 0) {
      trimmedBytes.removeLast();
    }
    return trimmedBytes;
  }
}
