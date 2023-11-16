import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/file_utils.dart';

void main() {
  group('Tests of FileUtils.estimateDataSize', () {
    test('Should return the data size of 0 B for size string is lower or equal to zero bytes', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(0);
      String expectedFileSize = '0 B';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for 1 byte', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(1);
      String expectedFileSize = '1.00 B';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for 1 kilobyte', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(pow(1024, 1).toInt());
      String expectedFileSize = '1.00 KB';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for 1 megabyte', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(pow(1024, 2).toInt());
      String expectedFileSize = '1.00 MB';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for 1 gigabyte', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(pow(1024, 3).toInt());
      String expectedFileSize = '1.00 GB';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for 1 terabyte', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(pow(1024, 4).toInt());
      String expectedFileSize = '1.00 TB';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should throws an assertion error for negative file size', () {
      //  Assert
      expect(() => FileUtils.estimateDataSize(-1), throwsA(isA<AssertionError>()));
    });

    test('Should return the correct size string for a very large file', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(pow(1024, 6).toInt());
      String expectedFileSize = '1.00 EB';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for a very small file', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize((1 / pow(1024, 5)).floor());
      String expectedFileSize = '0 B';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should return the correct size string for a fractional file size', () {
      //  Assert
      String actualFileSize = FileUtils.estimateDataSize(pow(1024, 1).toInt() + 500);
      String expectedFileSize = '1.49 KB';
      expect(actualFileSize, expectedFileSize);
    });

    test('Should throw a format exception for invalid string input', () {
      //  Assert
      try {
        FileUtils.estimateDataSize(int.parse('foo')).runtimeType;
      } catch (actualException) {
        TypeMatcher<FormatException> expectedException = isA<FormatException>();
        expect(actualException, expectedException);
      }
    });
  });
}
