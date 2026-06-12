import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/scan_totp_qr_page/scan_totp_qr_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_totp_qr_page/scan_totp_qr_page_state.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';

void main() {
  late ScanTotpQRPageCubit actualScanTotpQRPageCubit;
  late ReadTotpDataExceptionType? actualReadTotpDataExceptionType;

  group('Test of ScanTotpQRPageCubit process (scanning supported TOTP QR)', () {
    setUpAll(() {
      actualReadTotpDataExceptionType = null;

      actualScanTotpQRPageCubit = ScanTotpQRPageCubit(
        onError: (ReadTotpDataExceptionType type) {
          actualReadTotpDataExceptionType = type;
        },
      );
    });

    test('Should [return ScanTotpQRPageState] with initial values', () {
      // Act
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, null);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });

    test('Should [return ScanTotpQRPageState] with decoded value', () {
      // Act
      actualScanTotpQRPageCubit.processQR('otpauth://totp/Example:user@example.com?secret=JBSW%20Y3DP%20EHPK3PXP&issuer=Example');
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState(
        processingQRBool: true,
        secret: 'jbswy3dpehpk3pxp',
      );

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, null);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });

    test('Should [return ScanTotpQRPageState] with reset values', () {
      // Act
      actualScanTotpQRPageCubit.reset();
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, null);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });
  });

  group('Test of ScanTotpQRPageCubit process (scanning unsupported TOTP QR configuration)', () {
    setUpAll(() {
      actualReadTotpDataExceptionType = null;

      actualScanTotpQRPageCubit = ScanTotpQRPageCubit(
        onError: (ReadTotpDataExceptionType type) {
          actualReadTotpDataExceptionType = type;
        },
      );
    });

    test('Should [return ScanTotpQRPageState] with initial values', () {
      // Act
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, null);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });

    test('Should [return ScanTotpQRPageState] with unsupported configuration error', () {
      // Act
      actualScanTotpQRPageCubit.processQR('otpauth://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP&algorithm=SHA256');
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, ReadTotpDataExceptionType.unsupportedTotpConfiguration);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });

    test('Should [return ScanTotpQRPageState] with reset values', () {
      // Act
      actualScanTotpQRPageCubit.reset();
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, ReadTotpDataExceptionType.unsupportedTotpConfiguration);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });
  });

  group('Test of ScanTotpQRPageCubit process (scanning unsupported TOTP QR)', () {
    setUpAll(() {
      actualReadTotpDataExceptionType = null;

      actualScanTotpQRPageCubit = ScanTotpQRPageCubit(
        onError: (ReadTotpDataExceptionType type) {
          actualReadTotpDataExceptionType = type;
        },
      );
    });

    test('Should [return ScanTotpQRPageState] with initial values', () {
      // Act
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, null);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });

    test('Should [return ScanTotpQRPageState] with unsupported QR error', () {
      // Act
      actualScanTotpQRPageCubit.processQR('https://totp/Example:user@example.com?secret=JBSWY3DPEHPK3PXP');
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, ReadTotpDataExceptionType.unsupported);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });

    test('Should [return ScanTotpQRPageState] with reset values', () {
      // Act
      actualScanTotpQRPageCubit.reset();
      ScanTotpQRPageState actualScanTotpQRPageState = actualScanTotpQRPageCubit.state;

      // Assert
      ScanTotpQRPageState expectedScanTotpQRPageState = const ScanTotpQRPageState();

      expect(actualScanTotpQRPageCubit.progressNotifier.value, 0);
      expect(actualReadTotpDataExceptionType, ReadTotpDataExceptionType.unsupported);
      expect(actualScanTotpQRPageState, expectedScanTotpQRPageState);
    });
  });
}
