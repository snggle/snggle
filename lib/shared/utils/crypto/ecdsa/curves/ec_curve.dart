import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';

class ECCurve extends Equatable {
  /// The coefficient b of the curve.
  final BigInt b;

  /// The coefficient a of the curve.
  final BigInt a;

  /// The cofactor h of the group of the curve.
  final BigInt h;

  /// Prime field
  final BigInt p;

  const ECCurve({
    required this.b,
    required this.a,
    required this.h,
    required this.p,
  });

  /// Get the length of the base point in the curve
  int get baselen => BigIntUtils.calculateByteLength(p);

  @override
  List<Object?> get props => <Object>[b, a, h, p];
}