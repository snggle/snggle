import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/scan_totp_qr_page/scan_totp_qr_page_state.dart';

void main() {
  group('Tests of ScanTotpQRPageState.canReceiveQRCode()', () {
    test('Should [return TRUE] if [processingQRBool == FALSE] and [secret EMPTY]', () {
      // Arrange
      ScanTotpQRPageState actualScanTotpQRPageState = const ScanTotpQRPageState();

      // Act
      bool actualScanningEnabledBool = actualScanTotpQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, true);
    });

    test('Should [return FALSE] if [processingQRBool == TRUE]', () {
      // Arrange
      ScanTotpQRPageState actualScanTotpQRPageState = const ScanTotpQRPageState(processingQRBool: true);

      // Act
      bool actualScanningEnabledBool = actualScanTotpQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, false);
    });

    test('Should [return FALSE] if [secret HAS VALUE]', () {
      // Arrange
      ScanTotpQRPageState actualScanTotpQRPageState = const ScanTotpQRPageState(secret: 'jbswy3dpehpk3pxp');

      // Act
      bool actualScanningEnabledBool = actualScanTotpQRPageState.canReceiveQRCode();

      // Assert
      expect(actualScanningEnabledBool, false);
    });
  });

  group('Tests of ScanTotpQRPageState.shouldFinishScanning()', () {
    test('Should [return TRUE] if [processingQRBool == TRUE] and [secret HAS VALUE]', () {
      // Arrange
      ScanTotpQRPageState actualScanTotpQRPageState = const ScanTotpQRPageState(
        processingQRBool: true,
        secret: 'jbswy3dpehpk3pxp',
      );

      // Act
      bool actualFinishScanningBool = actualScanTotpQRPageState.shouldFinishScanning();

      // Assert
      expect(actualFinishScanningBool, true);
    });

    test('Should [return FALSE] if [processingQRBool == TRUE] and [secret EMPTY]', () {
      // Arrange
      ScanTotpQRPageState actualScanTotpQRPageState = const ScanTotpQRPageState(
        processingQRBool: true,
      );

      // Act
      bool actualFinishScanningBool = actualScanTotpQRPageState.shouldFinishScanning();

      // Assert
      expect(actualFinishScanningBool, false);
    });

    test('Should [return FALSE] if [processingQRBool == FALSE] and [secret HAS VALUE]', () {
      // Arrange
      ScanTotpQRPageState actualScanTotpQRPageState = const ScanTotpQRPageState(
        processingQRBool: false,
        secret: 'jbswy3dpehpk3pxp',
      );

      // Act
      bool actualFinishScanningBool = actualScanTotpQRPageState.shouldFinishScanning();

      // Assert
      expect(actualFinishScanningBool, false);
    });
  });
}
