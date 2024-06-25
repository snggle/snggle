import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/string_utils.dart';

void main() {
  group('Tests of StringUtils.getShortHex()', () {
    test('Should [return short HEX string] if given [value IS HEX]', () {
      // Arrange
      String actualHex = '0x16980b3B4a3f9D89E33311B5aa8f80303E5ca4F8';

      // Act
      String actualShortHex = StringUtils.getShortHex(actualHex, 3);

      // Assert
      String expectedShortHex = '0x169...4F8';

      expect(actualShortHex, expectedShortHex);
    });

    test('Should [return input value] if given [value NOT HEX]', () {
      // Arrange
      String actualHex = 'Hello, World!';

      // Act
      String actualShortHex = StringUtils.getShortHex(actualHex, 3);

      // Assert
      String expectedShortHex = 'Hello, World!';

      expect(actualShortHex, expectedShortHex);
    });
  });
}
