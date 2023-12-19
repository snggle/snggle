import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class DerivationPathElement extends Equatable {
  static const List<String> _hardenedChars = <String>["'"];
  static const int _keyIndexByteLength = 4;
  static const int _keyIndexHardenedBitNum = 31;

  final bool _hardenedBool;
  final int index;
  final String value;

  const DerivationPathElement({
    required bool hardenedBool,
    required this.index,
    required this.value,
  }) : _hardenedBool = hardenedBool;

  factory DerivationPathElement.parse(String pathElement) {
    String parsedPathElement = pathElement;

    bool hardenedBool = _hardenedChars.where(parsedPathElement.endsWith).isNotEmpty;
    if (hardenedBool) {
      parsedPathElement = parsedPathElement.substring(0, pathElement.length - 1);
    }

    int? index = int.tryParse(parsedPathElement, radix: 10);
    if (index == null) {
      throw FormatException('Invalid BIP32 derivation path element ($pathElement)');
    } else if (hardenedBool) {
      index = index | (1 << _keyIndexHardenedBitNum);
    } else {
      index = index & ~(1 << _keyIndexHardenedBitNum);
    }

    return DerivationPathElement(hardenedBool: hardenedBool, index: index, value: pathElement);
  }

  bool get isHardened => _hardenedBool;

  List<int> toBytes() {
    return Uint8List(_keyIndexByteLength)..buffer.asByteData().setInt32(0, index, Endian.big);
  }

  @override
  String toString() => value;

  @override
  List<Object?> get props => <Object>[value];
}
