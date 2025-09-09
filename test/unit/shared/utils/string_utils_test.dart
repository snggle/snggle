import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/string_utils.dart';

void main() {
  group('Tests of StringUtils.getShortPublicAddress()', () {
    test('Should [return short public address HEX string] if given [value IS HEX (Ethereum address)]', () {
      // Arrange
      String actualPublicAddressHex = '0x16980b3B4a3f9D89E33311B5aa8f80303E5ca4F8';

      // Act
      String actualShortPublicAddressHex = StringUtils.getShortPublicAddress(actualPublicAddressHex, 3);

      // Assert
      String expectedShortPublicAddressHex = '0x169...4F8';

      expect(actualShortPublicAddressHex, expectedShortPublicAddressHex);
    });

    test('Should [return short public address text string] if given [value NOT HEX (Solana address)]', () {
      // Arrange
      String actualPublicAddress = '2xGD7cWtwpmCpW2NvT9EJt96eDavS3suVgQNVaBU4A19';

      // Act
      String actualShortPublicAddress = StringUtils.getShortPublicAddress(actualPublicAddress, 3);

      // Assert
      String expectedShortPublicAddress = '2xG...A19';

      expect(actualShortPublicAddress, expectedShortPublicAddress);
    });

    test('Should [return short public address text string] if given [value NOT HEX (Bitcoin address)]', () {
      // Arrange
      String actualPublicAddress = 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh';

      // Act
      String actualShortPublicAddress = StringUtils.getShortPublicAddress(actualPublicAddress, 3);

      // Assert
      String expectedShortPublicAddress = 'bc1...wlh';

      expect(actualShortPublicAddress, expectedShortPublicAddress);
    });

    test('Should [return short text string] if given [value NOT HEX (String)]', () {
      // Arrange
      String actualString = 'Hello, World!';

      // Act
      String actualShortString = StringUtils.getShortPublicAddress(actualString, 3);

      // Assert
      String expectedShortString = 'Hel...ld!';

      expect(actualShortString, expectedShortString);
    });
  });

  group('Tests of StringUtils.getTextSize()', () {
    test('Should [return text size] if [text EMPTY]', () {
      // Arrange
      String actualText = '';
      TextStyle actualTextStyle = const TextStyle(fontSize: 16);

      // Act
      Size actualTextSize = StringUtils.getTextSize(actualText, actualTextStyle, textScaler: TextScaler.noScaling);

      // Assert
      Size expectedTextSize = const Size(0, 16);

      expect(actualTextSize, expectedTextSize);
    });

    test('Should [return text size] if [text NOT EMPTY]', () {
      // Arrange
      String actualText = 'Hello World!';
      TextStyle actualTextStyle = const TextStyle(fontSize: 16);

      // Act
      Size actualTextSize = StringUtils.getTextSize(actualText, actualTextStyle, textScaler: TextScaler.noScaling);

      // Assert
      Size expectedTextSize = const Size(192.0, 16);

      expect(actualTextSize, expectedTextSize);
    });
  });
}
