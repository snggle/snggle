import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_complete_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_initial_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';
import 'package:snggle/config/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLocator();
  MobileScannerController? actualCameraController;

  group('Tests of QrCodeScanPageCubit States: ', () {
    test('Should return initial state of [QrCodeScanPageInitialState]', () {
      // Arrange
      QrCodeScanPageCubit actualQrcodeScanPageCubit = QrCodeScanPageCubit(cameraController: actualCameraController);

      // Assert
      expect(actualQrcodeScanPageCubit.state, QrCodeScanPageInitialState());
    });

    test('Should return state of [QrCodeScanPageInitialState] after user scans and then cancels scanning', () async {
      // Act
      QrCodeScanPageCubit actualQrcodeScanPageCubit = QrCodeScanPageCubit(cameraController: actualCameraController)
        ..verifyBarcode(Barcode(rawValue: '["","",4,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",1,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",2,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",3,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",4,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",1,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",2,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",3,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",4,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",1,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",2,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'))
        ..verifyBarcode(Barcode(rawValue: '["","",3,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));

      await actualQrcodeScanPageCubit.cancelQrCodeScan();
      // Assert
      expect(actualQrcodeScanPageCubit.state, QrCodeScanPageInitialState());
    });

    test('Should return state of [QrCodeScanPageReceivedState] when user scans a QR Barcode', () async {
      // Act
      QrCodeScanPageCubit actualQrcodeScanPageCubit = QrCodeScanPageCubit(cameraController: actualCameraController)
        ..verifyBarcode(Barcode(rawValue: '["","",4,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));

      QrCodeScanPageReceivedState expectedReceivedState = actualQrcodeScanPageCubit.state as QrCodeScanPageReceivedState;

      // Assert
      expect(
        actualQrcodeScanPageCubit.state,
        QrCodeScanPageReceivedState(
          scanTimes: expectedReceivedState.scanTimes,
          multiQrCodeItemModelList: expectedReceivedState.multiQrCodeItemModelList,
        ),
      );
    });

    test('Should return state of [QrCodeScanPageCompleteState] after scanning a complete QR set of data', () async {
      // Act
      QrCodeScanPageCubit actualQrcodeScanPageCubit = QrCodeScanPageCubit(cameraController: actualCameraController);
      await Future<dynamic>.delayed(const Duration(microseconds: 1000));
      actualQrcodeScanPageCubit.verifyBarcode(Barcode(rawValue: '["","",4,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));
      await Future<dynamic>.delayed(const Duration(microseconds: 1000));
      actualQrcodeScanPageCubit.verifyBarcode(Barcode(rawValue: '["","",1,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));
      await Future<dynamic>.delayed(const Duration(microseconds: 1000));
      actualQrcodeScanPageCubit.verifyBarcode(Barcode(rawValue: '["","",2,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));
      await Future<dynamic>.delayed(const Duration(microseconds: 1000));
      actualQrcodeScanPageCubit.verifyBarcode(Barcode(rawValue: '["","",3,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));
      await Future<dynamic>.delayed(const Duration(microseconds: 1000));
      actualQrcodeScanPageCubit.verifyBarcode(Barcode(rawValue: '["","",5,5,"aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg"]'));

      // Assert
      expect(actualQrcodeScanPageCubit.state.runtimeType, QrCodeScanPageCompleteState);
    });

    test('Should throw exception for scanning incorrect data', () async {
      // Arrange
      Exception expectedException = Exception('Unexpected character');

      try {
        // Act
        QrCodeScanPageCubit(cameraController: actualCameraController)
            .verifyBarcode(Barcode(rawValue: 'aWEgZXJvcyBlZ2V0IHNjZWxlcmlzcXVlIGhlbmRyZXJpdC5WaXZhbXVzIHNlbXBlciBzZW0gc2l0IGFtZXQgZGlhbSBpYWN1bGlzIGFsaXF1ZXQuIERvbmVjIGN1cnN1cyBwb3J0dGl0b3IgYWNjdW1zYW4uIFN1c3BlbmRpc3NlIHF1YW0gbnVsbGEsIHJob25jdXMg'));
      } on Exception catch (actualException) {
        // Assert
        expect(actualException.toString(), expectedException.toString());
      }
    });

    test('Should throw exception for scanning incorrect data that is null', () async {
      // Arrange
      Exception expectedException = Exception('Barcode is null');

      try {
        // Act
        QrCodeScanPageCubit(cameraController: actualCameraController).verifyBarcode(Barcode(rawValue: null));
      } on Exception catch (actualException) {
        // Assert
        expect(actualException.toString(), expectedException.toString());
      }
    });
  });
}
