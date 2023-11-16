import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_complete_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_error_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_initial_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_received_state.dart';
import 'package:snggle/bloc/qr_code_scan_page/states/qr_code_scan_page_time_out_state.dart';
import 'package:snggle/shared/models/multi_qr_code_item_model.dart';
import 'package:snggle/shared/utils/app_logger.dart';

part 'a_qr_code_scan_page_state.dart';

class QrCodeScanPageCubit extends Cubit<AQrCodeScanPageState> {
  final MobileScannerController? cameraController;
  final List<Duration> averageStopWatchTimeDuration = <Duration>[];
  List<MultiQrCodeItemModel> multiQrCodeItemModelList = <MultiQrCodeItemModel>[];

  final Duration scanPageDuration = const Duration(seconds: 10);
  Timer? scanPageTimer;
  final Stopwatch scanStopWatch = Stopwatch();

  QrCodeScanPageCubit({required this.cameraController}) : super(QrCodeScanPageInitialState()) {
    refreshTimer();
  }

  Future<void> cancelQrCodeScan() async {
    averageStopWatchTimeDuration.clear();
    multiQrCodeItemModelList.clear();
    scanStopWatch.stop();
    refreshTimer();
    emit(QrCodeScanPageInitialState());
  }

  @override
  Future<void> close() {
    scanPageTimer?.cancel();
    return super.close();
  }

  void refreshTimer() {
    scanPageTimer?.cancel();
    scanPageTimer = Timer(
      scanPageDuration,
      () => emit(const QrCodeScanPageTimeOutState()),
    );
  }

  void resumeState({required AQrCodeScanPageState qrcodeScanPageState}) {
    if (qrcodeScanPageState is QrCodeScanPageReceivedState) {
      emit(QrCodeScanPageReceivedState(multiQrCodeItemModelList: multiQrCodeItemModelList, scanTimes: averageStopWatchTimeDuration));
    } else if (qrcodeScanPageState is QrCodeScanPageInitialState) {
      emit(QrCodeScanPageInitialState());
    }
  }

  void verifyBarcode(Barcode receivedBarcode) {
    _resetScanTimeStopWatch();
    try {
      MultiQrCodeItemModel scannedMultiQrCodeItemModel = _decodeJsonBarcode(receivedBarcode);
      _receiveQrCodeItemModel(scannedMultiQrCodeItemModel);
    } catch (error) {
      AppLogger().log(message: 'Error verifying barcode with value: ${receivedBarcode.rawValue}. Exception: ${error}');
    }
  }

  void _resetScanTimeStopWatch() {
    if (scanStopWatch.isRunning == false) {
      scanStopWatch.start();
    }
    averageStopWatchTimeDuration.add(Duration(milliseconds: scanStopWatch.elapsedMilliseconds));
    scanStopWatch.reset();
  }

  MultiQrCodeItemModel _decodeJsonBarcode(Barcode receivedBarcode) {
    if (receivedBarcode.rawValue == null) {
      AppLogger().log(message: 'Barcode data is null');
    }
    List<dynamic> decodedJson = json.decode(receivedBarcode.rawValue!) as List<dynamic>;
    return MultiQrCodeItemModel.fromJson(decodedJson);
  }

  Future<void> _receiveQrCodeItemModel(MultiQrCodeItemModel scannedMultiQrCodeItemModel) async {
    bool qrCodeScannedBeforeBool = multiQrCodeItemModelList.contains(scannedMultiQrCodeItemModel);

    if (qrCodeScannedBeforeBool == false) {
      refreshTimer();
      multiQrCodeItemModelList = <MultiQrCodeItemModel>[...multiQrCodeItemModelList, scannedMultiQrCodeItemModel];
      multiQrCodeItemModelList.sort((MultiQrCodeItemModel a, MultiQrCodeItemModel b) => a.pageNumber.compareTo(b.pageNumber));
      _updateState();
    }
  }

  void _updateState() {
    QrCodeScanPageReceivedState qrcodeScanPageState = QrCodeScanPageReceivedState(
      multiQrCodeItemModelList: multiQrCodeItemModelList,
      scanTimes: averageStopWatchTimeDuration,
    );
    emit(qrcodeScanPageState);
    if (qrcodeScanPageState.percentageScanned >= 1.0) {
      _finalizeScan();
    }
  }

  void _finalizeScan() {
    try {
      multiQrCodeItemModelList.sort((MultiQrCodeItemModel a, MultiQrCodeItemModel b) => a.pageNumber.compareTo(b.pageNumber));

      String encodedReceivedValue = multiQrCodeItemModelList.map((MultiQrCodeItemModel multiQrCodeItemModel) => multiQrCodeItemModel.data).join();
      String decodedString = utf8.decode(base64Decode(encodedReceivedValue));

      // TODO(Knight): Add feature to handle QRcodeScan.type to different services Snggle app offers and handle state navigation to those service pages using states.
      // State is temporary since it depends on the type of service, to which page we navigate or the error messages we show.
      // Showing a page of Error Message will be temporary again, just like showing a page with base64 decoded message.

      // Better to spend time on finishing branches and getting to the implementing part of this method, than creating temporary examples, and figuring how to handle it and stuffs.
      emit(QrCodeScanPageCompleteState(decodedString: decodedString));
    } catch (error) {
      AppLogger().log(message: 'Failed to decode QrCode and handle the service type requirement. Error: $error');
      emit(QrCodeScanPageErrorState());
    }
  }
}
