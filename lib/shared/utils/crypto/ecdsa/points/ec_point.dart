import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point_utils.dart';

class ECPoint extends Equatable {
  /// The x coordinate of the generator G of the group of the curve.
  final BigInt x;

  /// The y coordinate of the generator G of the group of the curve.
  final BigInt y;

  /// The z coordinate of the generator G of the group of the curve.
  final BigInt z;

  /// Order
  final BigInt n;

  final ECCurve curve;

  ECPoint({
    required this.n,
    required this.curve,
    BigInt? x,
    BigInt? y,
    BigInt? z,
  })  : x = x ?? BigInt.zero,
        y = y ?? BigInt.zero,
        z = z ?? BigInt.one;

  factory ECPoint.infinityFrom(ECPoint ecPoint) {
    return ECPoint(n: ecPoint.n, curve: ecPoint.curve);
  }

  ECPoint copyWith({BigInt? x, BigInt? y, BigInt? z, BigInt? n, ECCurve? curve}) {
    return ECPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      n: n ?? this.n,
      curve: curve ?? this.curve,
    );
  }

  ECPoint operator -() {
    return copyWith(y: -y);
  }

  ECPoint operator *(BigInt scalar) {
    if (y == BigInt.zero || scalar == BigInt.zero) {
      return ECPoint.infinityFrom(this);
    }
    if (scalar == BigInt.one) {
      return this;
    }
    BigInt modScalar = scalar % (n * BigInt.two);

    ECPoint scaledPoint = _scale();
    ECPoint multipliedPoint = ECPoint.infinityFrom(this);

    List<BigInt> nafList = BigIntUtils.computeNAF(modScalar);
    for (int i = nafList.length - 1; i >= 0; i--) {
      multipliedPoint = ECPointUtils.doublePoint(multipliedPoint);

      if (nafList[i] < BigInt.zero) {
        multipliedPoint = ECPointUtils.addPoints(multipliedPoint, -scaledPoint);
      } else if (nafList[i] > BigInt.zero) {
        multipliedPoint = ECPointUtils.addPoints(multipliedPoint, scaledPoint);
      }
    }

    if (multipliedPoint.y == BigInt.zero || multipliedPoint.z == BigInt.zero) {
      return ECPoint.infinityFrom(this);
    }

    return multipliedPoint;
  }

  Uint8List toBytes({required bool compressedBool}) {
    if (compressedBool == false) {
      return Uint8List.fromList(<int>[0x04, ..._encode()]);
    } else {
      return _encodeCompressed();
    }
  }

  ECPoint _scale() {
    if (z == BigInt.one) {
      return copyWith();
    }
    return copyWith(x: _scaledX, y: _scaledY, z: BigInt.one);
  }
  
  List<int> _encode() {
    final List<int> xBytes = BigIntUtils.changeToBytes(_scaledX, length: BigIntUtils.calculateByteLength(curve.p));
    final List<int> yBytes = BigIntUtils.changeToBytes(_scaledY, length: BigIntUtils.calculateByteLength(curve.p));
    return List<int>.from(<int>[...xBytes, ...yBytes]);
  }

  Uint8List _encodeCompressed() {
    List<int> xStr = BigIntUtils.changeToBytes(_scaledX, length: BigIntUtils.calculateByteLength(curve.p));
    List<int> prefix;
    if (_scaledY & BigInt.one != BigInt.zero) {
      prefix = List<int>.from(<int>[0x03]);
    } else {
      prefix = List<int>.from(<int>[0x02]);
    }

    List<int> result = List<int>.filled(prefix.length + xStr.length, 0)
      ..setAll(0, prefix)
      ..setAll(prefix.length, xStr);

    return Uint8List.fromList(result);
  }

  BigInt get _scaledX {
    if (z == BigInt.one) {
      return x;
    }

    BigInt zInverse = z.modInverse(curve.p);
    return (x * zInverse * zInverse) % curve.p;
  }

  BigInt get _scaledY {
    if (z == BigInt.one) {
      return y;
    }

    BigInt zInverse = z.modInverse(curve.p);
    return (y * zInverse * zInverse * zInverse) % curve.p;
  }

  @override
  List<Object?> get props => <Object?>[x, y, z, n, curve];
}
