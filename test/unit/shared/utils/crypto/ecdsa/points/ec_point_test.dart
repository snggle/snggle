import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  ECCurve actualECCurve = ECCurve(
    b: BigInt.from(7),
    a: BigInt.zero,
    h: BigInt.one,
    p: BigInt.parse('115792089237316195423570985008687907853269984665640564039457584007908834671663'),
  );

  group('Tests of ECPoint.infinityFrom() constructor', () {
    test('Should [return infinity ECPoint] basing on other ECPoint params (curve and order)', () {
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798', radix: 16),
        y: BigInt.parse('483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8', radix: 16),
        z: BigInt.one,
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      ECPoint actualInfinityECPoint = ECPoint.infinityFrom(actualECPoint);

      // Assert
      ECPoint expectedInfinityECPoint = ECPoint(
        x: BigInt.zero,
        y: BigInt.zero,
        z: BigInt.one,
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      expect(actualInfinityECPoint, expectedInfinityECPoint);
    });
  });

  group('Tests of ECPoint - (negation) operator overload', () {
    test('Should [return ECPoint] with negated y coordinate', () {
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      ECPoint actualNegatedECPoint = -actualECPoint;

      // Assert
      ECPoint expectedNegatedECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('-93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      expect(actualNegatedECPoint, expectedNegatedECPoint);
    });
  });

  group('Tests of ECPoint * (multiplication) operator overload', () {
    test('Should [return ECPoint] multiplicated by given scalar', () {
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      ECPoint actualMultipliedECPoint = actualECPoint * BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643');

      // Assert
      ECPoint expectedMultipliedECPoint = ECPoint(
        x: BigInt.parse('52659634787550369708387590610632544125095539949942882538329891106798572607270'),
        y: BigInt.parse('107331144082566646093235576885864105124833962202338653524803423955903371062333'),
        z: BigInt.parse('23104110703327938328957906634340614657838296092781414960111073621683973006153'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      expect(actualMultipliedECPoint, expectedMultipliedECPoint);
    });

    test('Should [return infinity ECPoint] if given [scalar equal ZERO]', () {
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      ECPoint actualMultipliedECPoint = actualECPoint * BigInt.zero;

      // Assert
      ECPoint expectedMultipliedECPoint = ECPoint(
        x: BigInt.zero,
        y: BigInt.zero,
        z: BigInt.one,
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      expect(actualMultipliedECPoint, expectedMultipliedECPoint);
    });

    test('Should [return infinity ECPoint] if multiplied ECPoint has [y EQUAL ZERO]', (){
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.zero,
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      ECPoint actualMultipliedECPoint = actualECPoint * BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643');

      // Assert
      ECPoint expectedMultipliedECPoint = ECPoint(
        x: BigInt.zero,
        y: BigInt.zero,
        z: BigInt.one,
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      expect(actualMultipliedECPoint, expectedMultipliedECPoint);
    });

    test('Should [return ECPoint] without changes if given [scalar EQUAL ONE]', () {
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      ECPoint actualMultipliedECPoint = actualECPoint * BigInt.one;

      // Assert
      ECPoint expectedMultipliedECPoint = actualECPoint;

      expect(actualMultipliedECPoint, expectedMultipliedECPoint);
    });
  });

  group('Tests of ECPoint.toBytes()', (){
    test('Should [return COMPRESSED bytes] from given ECPoint', (){
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      Uint8List actualCompressedBytes = actualECPoint.toBytes(compressedBool: true);

      // Assert
      Uint8List expectedCompressedBytes = base64Decode('Ar+tLoQUarMHBlWt2YHvheCerhvBi3VacJya8XNUx2Yj');

      expect(actualCompressedBytes, expectedCompressedBytes);
    });

    test('Should [return UNCOMPRESSED bytes] from given ECPoint', (){
      // Arrange
      ECPoint actualECPoint = ECPoint(
        x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
        y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
        z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: actualECCurve,
      );

      // Act
      Uint8List actualCompressedBytes = actualECPoint.toBytes(compressedBool: false);

      // Assert
      Uint8List expectedCompressedBytes = base64Decode('BL+tLoQUarMHBlWt2YHvheCerhvBi3VacJya8XNUx2YjRdh4yvIJvEV4shNwcx/bJI+WUme3DGfy1SuRlBmPA4o=');

      expect(actualCompressedBytes, expectedCompressedBytes);
    });
  });
}
