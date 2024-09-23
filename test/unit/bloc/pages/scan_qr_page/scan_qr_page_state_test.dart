import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/scan_tx_page/scan_qr_page_state.dart';

void main() {
  group('Tests of ScanQRPageState.canReceiveQRCode()', () {
    test('Should [return TRUE] if [loadingBool == FALSE], [urRegistryRecord EMPTY] and [qrResultPage EMPTY]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState();

      // Act
      bool actualScanningEnabledBool = actualScanQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(loadingBool: true);

      // Act
      bool actualScanningEnabledBool = actualScanQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, false);
    });

    test('Should [return FALSE] if [urRegistryRecord HAS VALUE]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(
        cborTaggedObject: CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        ),
      );

      // Act
      bool actualScanningEnabledBool = actualScanQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, false);
    });

    test('Should [return FALSE] if [qrResultPage HAS VALUE]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(qrResultPage: SizedBox());

      // Act
      bool actualScanningEnabledBool = actualScanQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, false);
    });
  });

  group('Tests of ScanQRPageState.shouldLoadResultPage()', () {
    test('Should [return TRUE] if [loadingBool == TRUE], [urRegistryRecord HAS VALUE] and [qrResultPage EMPTY]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(
        loadingBool: true,
        cborTaggedObject: CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        ),
      );

      // Act
      bool actualLoadResultBool = actualScanQRPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, true);
    });

    test('Should [return FALSE] if [loadingBool == TRUE], [urRegistryRecord HAS VALUE] and [qrResultPage HAS VALUES]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(
        loadingBool: true,
        cborTaggedObject: CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        ),
        qrResultPage: SizedBox(),
      );

      // Act
      bool actualLoadResultBool = actualScanQRPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, false);
    });

    test('Should [return FALSE] if [loadingBool == TRUE], [urRegistryRecord EMPTY] and [qrResultPage EMPTY]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(
        loadingBool: true,
      );

      // Act
      bool actualLoadResultBool = actualScanQRPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, false);
    });

    test('Should [return FALSE] if [loadingBool == FALSE], [urRegistryRecord HAS VALUE] and [qrResultPage EMPTY]', () {
      // Arrange
      ScanQRPageState actualScanQRPageState = const ScanQRPageState(
        loadingBool: false,
        cborTaggedObject: CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        ),
      );

      // Act
      bool actualLoadResultBool = actualScanQRPageState.shouldLoadResultPage();

      // Assert
      expect(actualLoadResultBool, false);
    });
  });
}
