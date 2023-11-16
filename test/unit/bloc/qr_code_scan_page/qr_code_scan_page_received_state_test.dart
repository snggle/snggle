import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';
import 'package:snggle/shared/models/multi_qr_code_item_model.dart';
import 'package:snggle/shared/utils/file_utils.dart';

import '../../../utils/test_utils.dart';

void main() {
  late List<MultiQrCodeItemModel> actualMultiQrCodeItemModelList;
  late List<Duration> actualScanTimes;

  setUp(() {
    actualMultiQrCodeItemModelList = <MultiQrCodeItemModel>[
      const MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 1, data: 'abcd'),
      const MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 2, data: 'efgh'),
      const MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 3, data: 'ijkl'),
    ];
    actualScanTimes = <Duration>[
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 1200),
      const Duration(milliseconds: 1500),
    ];
  });

  group('Tests of QrCodeScanPageReceivedState.estimatedTotalDataLength', () {
    test('Should return correct value of estimatedTotalDataLength', () {
      //  Arrange
      QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: const <MultiQrCodeItemModel>[],
        scanTimes: actualScanTimes,
      );

      //  Assert
      TestUtils.printInfo('Should return 0 for an empty list');
      expect(actualQrCodeScanPageReceivedState.estimatedTotalDataLength, 0);

      // ********************************************************************************************************************

      // Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: actualScanTimes,
      );
      //  Assert
      expect(actualQrCodeScanPageReceivedState.estimatedTotalDataLength, 16);
    });
  });

  group('Tests of QrCodeScanPageReceivedState.estimatedTimeToCompletion', () {
    test('Should return correct estimations for when all pages are scanned', () {
      //  Arrange
      QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: const <MultiQrCodeItemModel>[],
        scanTimes: actualScanTimes,
      );

      //  Assert
      TestUtils.printInfo('Should return correct value when given empty multiQrCodeItemModelList');
      expect(actualQrCodeScanPageReceivedState.estimatedTimeToCompletion, 'Unknown');

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: const <Duration>[],
      );

      //  Assert

      TestUtils.printInfo('Should return correct value when given empty scanTimes');
      expect(actualQrCodeScanPageReceivedState.estimatedTimeToCompletion, 'Unknown');

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = const QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: <MultiQrCodeItemModel>[],
        scanTimes: <Duration>[],
      );

      //  Assert
      TestUtils.printInfo('Should not throw exception when empty values are provided');
      expect(() => actualQrCodeScanPageReceivedState.estimatedTimeToCompletion, returnsNormally);

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: actualScanTimes,
      );

      //  Assert
      TestUtils.printInfo('Should return correct estimation for estimated time');
      expect(actualQrCodeScanPageReceivedState.estimatedTimeToCompletion, '1');

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: const <MultiQrCodeItemModel>[
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 1, data: 'abcd'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 2, data: 'efgh'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 3, data: 'ijkl'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 4, data: 'mnop'),
        ],
        scanTimes: actualScanTimes,
      );

      //  Assert
      expect(actualQrCodeScanPageReceivedState.estimatedTimeToCompletion, '0');
    });
  });

  group('Tests of QrCodeScanPageReceivedState.estimatedDataTransferRate', () {
    test('Should return correct value when scanTimes is empty', () {
      // Arrange
      final QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: const <Duration>[],
      );

      //  Assert
      TestUtils.printInfo('Should not throw an exception for when estimatedDataTransferRate is called');
      expect(
        () => actualQrCodeScanPageReceivedState.estimatedDataTransferRate,
        returnsNormally,
      );

      //  Assert
      String actualValue = FileUtils.estimateDataSize(
        actualQrCodeScanPageReceivedState.estimatedDataTransferRate.toInt(),
      );
      expect(actualValue, '0 B');
    });

    test('Should return correct value when multiQrCodeItemModelList is empty', () {
      // Arrange
      final QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: const <MultiQrCodeItemModel>[],
        scanTimes: actualScanTimes,
      );

      //  Assert
      TestUtils.printInfo('Should not throw an exception for when estimatedDataTransferRate is called');
      expect(() => actualQrCodeScanPageReceivedState.estimatedDataTransferRate, returnsNormally);

      // ********************************************************************************************************************

      //  Assert
      String actualValue = FileUtils.estimateDataSize(actualQrCodeScanPageReceivedState.estimatedDataTransferRate.toInt());
      expect(actualValue, '0 B');
    });

    test('Should return correct estimation data size for when all pages are scanned', () {
      // Arrange
      final QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: actualScanTimes,
      );

      //  Assert
      TestUtils.printInfo('Should not throw an exception for when estimateDataTransferRate is called');
      expect(() => actualQrCodeScanPageReceivedState.estimatedDataTransferRate, returnsNormally);

      // ********************************************************************************************************************

      //  Assert
      String actualValue = FileUtils.estimateDataSize(actualQrCodeScanPageReceivedState.estimatedDataTransferRate.toInt());
      expect(actualValue, '4.00 B');
    });
  });

  group('Tests of QrCodeScanPageReceivedState.percentageScanned', () {
    test('Should returns correct value for percentage scanned when all pages are scanned', () {
      //  Arrange
      QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = const QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: <MultiQrCodeItemModel>[],
        scanTimes: <Duration>[],
      );

      //  Assert
      TestUtils.printInfo('Should not throw an exception for when empty multiQrCodeItemModelList & scanTimes is provided');
      expect(() => actualQrCodeScanPageReceivedState.percentageScanned, returnsNormally);

      // ********************************************************************************************************************

      //  Assert
      TestUtils.printInfo('Should returns correct value for when no pages are scanned');
      expect(actualQrCodeScanPageReceivedState.percentageScanned, 0.0);

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: actualScanTimes,
      );

      //  Assert
      TestUtils.printInfo('Should returns correct value for partial pages scanned');
      expect(actualQrCodeScanPageReceivedState.percentageScanned, 0.75);

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: const <MultiQrCodeItemModel>[
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 1, data: 'abcd'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 2, data: 'efgh'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 3, data: 'ijkl'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 4, data: 'mnop'),
        ],
        scanTimes: actualScanTimes,
      );

      //  Assert
      expect(actualQrCodeScanPageReceivedState.percentageScanned, 1.0);
    });
  });

  group('Tests of QrCodeScanPageReceivedState.scannedPagesCount', () {
    test('Should return correct count for when all pages are scanned', () {
      //  Arrange
      QrCodeScanPageReceivedState actualQrCodeScanPageReceivedState = const QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: <MultiQrCodeItemModel>[],
        scanTimes: <Duration>[],
      );

      //  Assert
      TestUtils.printInfo('Should not throw an exception for when empty multiQrCodeItemModelList & scanTimes is provided');
      expect(() => actualQrCodeScanPageReceivedState.percentageScanned, returnsNormally);

      // ********************************************************************************************************************

      //  Assert
      TestUtils.printInfo('Should return correct count when zero pages are scanned');
      expect(actualQrCodeScanPageReceivedState.scannedPagesCount, 0);

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: actualMultiQrCodeItemModelList,
        scanTimes: actualScanTimes,
      );

      TestUtils.printInfo('Should return correct count when partial pages are scanned');
      expect(actualQrCodeScanPageReceivedState.scannedPagesCount, 3);

      // ********************************************************************************************************************

      //  Arrange
      actualQrCodeScanPageReceivedState = QrCodeScanPageReceivedState(
        multiQrCodeItemModelList: const <MultiQrCodeItemModel>[
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 1, data: 'abcd'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 2, data: 'efgh'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 3, data: 'ijkl'),
          MultiQrCodeItemModel(name: '', type: '', maxPages: 4, pageNumber: 4, data: 'mnop'),
        ],
        scanTimes: actualScanTimes,
      );

      //  Assert
      expect(actualQrCodeScanPageReceivedState.percentageScanned, 1.0);
    });
  });
}
