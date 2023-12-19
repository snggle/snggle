import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

class ECDSAPublicKey extends Equatable {
  /// Generator curve point
  final ECPoint G;
  
  /// Public key point
  final ECPoint Q;

  const ECDSAPublicKey(this.G, this.Q);

  Uint8List get compressed {
    return Q.toBytes(compressedBool: true);
  }

  Uint8List get uncompressed {
    return Q.toBytes(compressedBool: false);
  }

  @override
  List<Object?> get props => <Object>[G, Q];
}