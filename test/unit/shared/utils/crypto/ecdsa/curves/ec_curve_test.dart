import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve.dart';

void main() {
  group('Tests of ECCurve.baselen getter', () {
    test('Should [return length] of the base point in the curve (secp256k1)', () {
      // Arrange
      ECCurve actualECCurve = Curves.curveSecp256k1;

      // Act
      int actualBaseLen = actualECCurve.baselen;

      // Assert
      expect(actualBaseLen, 32);
    });
  });
}
