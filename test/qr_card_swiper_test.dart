import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/views/widgets/qr_card/qr_card.dart';

import 'utils/test_utils.dart';

void main() {
  group('Tests of QRCard widget:', () {
    test('Should return true if the data matches after it is split into 100 character per QrCard, as set by default', () {
      // Arrange
      final List<String> qrData = <String>['data1', 'data2', 'data3'];

      // Act
      final QrCard qrCard = QrCard(qrData: qrData);
      const int expectedCharPerCard = 100;
      const String expectedSplitData = 'data1data2data3';

      // Assert
      TestUtils.printInfo('Should return true if QrCard is initialized to 100 characters per QrCard');
      expect(qrCard.charactersPerCard, expectedCharPerCard);

      TestUtils.printInfo('Should return true after sample data is correctly put into 100 character per QrCard');
      expect(qrCard.qrSplitCardData, hasLength(1));

      expect(qrCard.qrSplitCardData[0], equals(expectedSplitData));
    });

    test('Should return true if the data matches after it is not split into 100 character per QrCard, as set by default', () {
      // Arrange
      final List<String> qrData = <String>['data1', 'data2', 'data3'];

      // Act
      final QrCard qrCard = QrCard(qrData: qrData, splitQrData: false);
      final List<String> expectedData = <String>['data1', 'data2', 'data3'];

      // Assert

      TestUtils.printInfo('Should return true as sample data is not split and should maintain it same length');
      expect(qrCard.qrData, hasLength(3));

      expect(qrCard.qrData, equals(expectedData));
    });

    test('Should return true if the data matches and is split into the defined amount of Character per QrCard (2)', () {
      // Arrange
      final List<String> qrData = <String>['data1', 'data2', 'data3'];

      // Act
      final QrCard qrCard = QrCard(qrData: qrData, charactersPerCard: 2);

      // Assert
      expect(qrCard.qrSplitCardData, hasLength(8));
      expect(qrCard.qrSplitCardData[0], equals('da'));
      expect(qrCard.qrSplitCardData[1], equals('ta'));
      expect(qrCard.qrSplitCardData[2], equals('1d'));
      expect(qrCard.qrSplitCardData[3], equals('at'));
      expect(qrCard.qrSplitCardData[4], equals('a2'));
      expect(qrCard.qrSplitCardData[5], equals('da'));
      expect(qrCard.qrSplitCardData[6], equals('ta'));
      expect(qrCard.qrSplitCardData[7], equals('3'));
    });

    test('Should return true if the data matches and is split into the defined amount of Character per QrCard (2)', () {
      // Arrange
      final List<String> qrData = <String>['data1', 'data2', 'data3'];

      // Act
      final QrCard qrCard = QrCard(qrData: qrData, charactersPerCard: 2);

      // Assert
      expect(qrCard.qrSplitCardData, hasLength(8));
      expect(qrCard.qrSplitCardData[0], equals('da'));
      expect(qrCard.qrSplitCardData[1], equals('ta'));
      expect(qrCard.qrSplitCardData[2], equals('1d'));
      expect(qrCard.qrSplitCardData[3], equals('at'));
      expect(qrCard.qrSplitCardData[4], equals('a2'));
      expect(qrCard.qrSplitCardData[5], equals('da'));
      expect(qrCard.qrSplitCardData[6], equals('ta'));
      expect(qrCard.qrSplitCardData[7], equals('3'));
    });
  });
}
