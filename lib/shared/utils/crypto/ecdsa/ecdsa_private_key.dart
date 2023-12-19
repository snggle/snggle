import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

class ECDSAPrivateKey extends Equatable {
  static const int _privateKeyByteLen = 32;
  
  /// Generator curve point
  final ECPoint G;

  /// ECC's "d" private parameter, known also as a Secret Exponent
  final BigInt d;

  const ECDSAPrivateKey(this.G, this.d);

  factory ECDSAPrivateKey.fromBytes(List<int> bytes, ECPoint G) {
    if (bytes.length != G.curve.baselen) {
      throw const FormatException('Invalid length of private key');
    }

    BigInt d = BigIntUtils.buildFromBytes(bytes);
    return ECDSAPrivateKey(G, d);
  }

  Uint8List get bytes {
    return BigIntUtils.changeToBytes(d, length: G.curve.baselen);
  }

  int get length => _privateKeyByteLen;

  @override
  List<Object?> get props => <Object>[G, d];
}