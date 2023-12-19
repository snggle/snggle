// "python-ecdsa" Copyright (c) 2010 Brian Warner

// Portions written in 2005 by Peter Pearson and placed in the public domain.

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

class ECPointUtils {
  /// Adds two points in projective coordinates on an elliptic curve and returns the result.
  static ECPoint addPoints(ECPoint point1, ECPoint point2) {
    if (point1.y == BigInt.zero || point1.z == BigInt.zero) {
      return point2;
    }
    if (point2.y == BigInt.zero || point2.z == BigInt.zero) {
      return point1;
    }
    if (point1.z == point2.z) {
      if (point1.z == BigInt.one) {
        return addPointsWithZ1(point1, point2);
      }
      return addPointsWithCommonZ(point1, point2);
    }
    if (point1.z == BigInt.one) {
      return addPointsWithZ2EqualOne(point1, point2);
    }
    if (point2.z == BigInt.one) {
      return addPointsWithZ2EqualOne(point1, point2);
    }
    return addPointsWithZNotEqual(point1, point2);
  }

  /// Adds two points in projective coordinates with z-coordinate equal to one
  /// on an elliptic curve and returns the result.
  static ECPoint addPointsWithZ1(ECPoint point1, ECPoint point2) {
    ECCurve curve = point1.curve;

    BigInt diff = point2.x - point1.x;
    BigInt diffSquare = diff * diff;

    BigInt I = (diffSquare * BigInt.from(4)) % curve.p;
    BigInt J = diff * I;

    BigInt scaledYDifference = (point2.y - point1.y) * BigInt.from(2);

    if (diff == BigInt.zero && scaledYDifference == BigInt.zero) {
      return doubleWithZ1(point1);
    }

    BigInt V = point1.x * I;
    BigInt x3 = (scaledYDifference * scaledYDifference - J - V * BigInt.from(2)) % curve.p;
    BigInt y3 = (scaledYDifference * (V - x3) - point1.y * J * BigInt.from(2)) % curve.p;
    BigInt z3 = diff * BigInt.from(2) % curve.p;

    return ECPoint(x: x3, y: y3, z: z3, n: point1.n, curve: curve);
  }

  /// Adds two points in projective coordinates with the same z-coordinate
  /// on an elliptic curve and returns the result.
  static ECPoint addPointsWithCommonZ(ECPoint point1, ECPoint point2) {
    ECCurve curve = point1.curve;

    BigInt A = (point2.x - point1.x).modPow(BigInt.from(2), curve.p);
    BigInt B = (point1.x * A) % curve.p;
    BigInt C = point2.x * A;
    BigInt D = (point2.y - point1.y).modPow(BigInt.from(2), curve.p);

    if (A == BigInt.zero && D == BigInt.zero) {
      return doublePoint(point1);
    }

    BigInt x3 = (D - B - C) % curve.p;
    BigInt y3 = ((point2.y - point1.y) * (B - x3) - point1.y * (C - B)) % curve.p;
    BigInt z3 = (point1.z * (point2.x - point1.x)) % curve.p;

    return ECPoint(x: x3, y: y3, z: z3, n: point1.n, curve: curve);
  }

  /// Adds two points in projective coordinates with z2 equal to one
  /// on an elliptic curve and returns the result.
  static ECPoint addPointsWithZ2EqualOne(ECPoint point1, ECPoint point2) {
    ECCurve curve = point1.curve;

    BigInt z1z1 = (point1.z * point1.z) % curve.p;
    BigInt u2 = (point2.x * z1z1) % curve.p;
    BigInt s2 = (point2.y * point1.z * z1z1) % curve.p;

    BigInt h = (u2 - point1.x) % curve.p;
    BigInt hh = (h * h) % curve.p;
    BigInt i = (BigInt.from(4) * hh) % curve.p;
    BigInt j = (h * i) % curve.p;
    BigInt r = (BigInt.from(2) * (s2 - point1.y)) % curve.p;

    if (r == BigInt.zero && h == BigInt.zero) {
      return doubleWithZ1(point2);
    }

    BigInt v = (point1.x * i) % curve.p;
    BigInt x3 = (r * r - j - BigInt.from(2) * v) % curve.p;
    BigInt y3 = (r * (v - x3) - BigInt.from(2) * point1.y * j) % curve.p;
    BigInt z3 = (((point1.z + h).modPow(BigInt.from(2), curve.p) - z1z1) - hh) % curve.p;

    return ECPoint(x: x3, y: y3, z: z3, n: point1.n, curve: curve);
  }

  /// Adds two points in projective coordinates with different z-coordinates
  /// on an elliptic curve and returns the result.
  static ECPoint addPointsWithZNotEqual(ECPoint point1, ECPoint point2) {
    ECCurve curve = point1.curve;

    BigInt z1z1 = (point1.z * point1.z) % curve.p;
    BigInt z2z2 = (point2.z * point2.z) % curve.p;
    BigInt u1 = (point1.x * z2z2) % curve.p;
    BigInt u2 = (point2.x * z1z1) % curve.p;
    BigInt s1 = (point1.y * point2.z * z2z2) % curve.p;
    BigInt s2 = (point2.y * point1.z * z1z1) % curve.p;

    BigInt h = (u2 - u1) % curve.p;
    BigInt i = (BigInt.from(4) * h * h) % curve.p;
    BigInt j = (h * i) % curve.p;
    BigInt r = (BigInt.from(2) * (s2 - s1)) % curve.p;

    if (h == BigInt.zero && r == BigInt.zero) {
      return doublePoint(point1);
    }

    BigInt v = (u1 * i) % curve.p;
    BigInt x3 = (r * r - j - BigInt.from(2) * v) % curve.p;
    BigInt y3 = (r * (v - x3) - BigInt.from(2) * s1 * j) % curve.p;
    BigInt z3 = (((point1.z + point2.z).modPow(BigInt.from(2), curve.p) - z1z1 - z2z2) * h) % curve.p;

    return ECPoint(x: x3, y: y3, z: z3, n: point1.n, curve: curve);
  }

  /// Doubles a point in projective coordinates on an elliptic curve, returning the resulting point.
  static ECPoint doublePoint(ECPoint point) {
    if (point.z == BigInt.one) {
      return doubleWithZ1(point);
    }

    if (point.y == BigInt.zero || point.z == BigInt.zero) {
      return ECPoint.infinityFrom(point);
    }

    BigInt xSquared = (point.x * point.x) % point.curve.p;
    BigInt ySquared = (point.y * point.y) % point.curve.p;

    if (ySquared == BigInt.zero) {
      return ECPoint.infinityFrom(point);
    }

    BigInt ySquaredSquared = (ySquared * ySquared) % point.curve.p;
    BigInt zSquared = (point.z * point.z) % point.curve.p;

    BigInt s = (BigInt.two * ((point.x + ySquared) * (point.x + ySquared) - xSquared - ySquaredSquared)) % point.curve.p;
    BigInt m = (BigInt.from(3) * xSquared + point.curve.a * zSquared * zSquared) % point.curve.p;
    BigInt t = (m * m - BigInt.from(2) * s) % point.curve.p;

    BigInt yResult = (m * (s - t) - BigInt.from(8) * ySquaredSquared) % point.curve.p;
    BigInt zResult = ((point.y + point.z) * (point.y + point.z) - ySquared - zSquared) % point.curve.p;

    return ECPoint(x: t, y: yResult, z: zResult,  n: point.n, curve: point.curve);
  }

  static ECPoint doubleWithZ1(ECPoint point) {
    BigInt xSquared = (point.x * point.x) % point.curve.p;
    BigInt ySquared = (point.y * point.y) % point.curve.p;

    if (ySquared == BigInt.zero) {
      return ECPoint.infinityFrom(point);
    }

    BigInt ySquaredSquared = (ySquared * ySquared) % point.curve.p;

    BigInt s = (BigInt.two * ((point.x + ySquared) * (point.x + ySquared) - xSquared - ySquaredSquared)) % point.curve.p;
    BigInt m = (BigInt.from(3) * xSquared + point.curve.a) % point.curve.p;
    BigInt t = (m * m - BigInt.from(2) * s) % point.curve.p;

    BigInt yResult = (m * (s - t) - BigInt.from(8) * ySquaredSquared) % point.curve.p;
    BigInt zResult = (BigInt.two * point.y) % point.curve.p;

    return ECPoint(x: t, y: yResult, z: zResult,  n: point.n, curve: point.curve);
  }
}