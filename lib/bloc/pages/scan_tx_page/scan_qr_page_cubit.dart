import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/scan_qr_page_state.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class ScanQRPageCubit extends Cubit<ScanQRPageState> {
  final ValueNotifier<double> progressNotifier;
  final VoidCallback _unsupportedOperationCallback;

  URDecoder _urDecoder = URDecoder();

  ScanQRPageCubit({
    required void Function() unsupportedOperationCallback,
  })  : _unsupportedOperationCallback = unsupportedOperationCallback,
        progressNotifier = ValueNotifier<double>(0),
        super(const ScanQRPageState());

  void processQR(String data) {
    if (state.canReceiveQRCode() == false) {
      return;
    }

    try {
      _urDecoder.receivePart(data);
      progressNotifier.value = _urDecoder.progress;

      if (_urDecoder.isComplete) {
        _finishScanning();
      }
    } catch (e) {
      AppLogger().log(message: 'Camera received a QR code that could not be processed', logLevel: LogLevel.warning);
    }
  }

  void notifyViewLoaded(Widget view) {
    emit(state.copyWith(loadingBool: false, qrResultPage: view));
  }

  void reset() {
    _urDecoder = URDecoder();
    progressNotifier.value = 0;

    emit(const ScanQRPageState());
  }

  void _finishScanning() {
    try {
      ACborTaggedObject? cborTaggedObject = _urDecoder.buildCborTaggedObject();
      emit(ScanQRPageState(cborTaggedObject: cborTaggedObject, loadingBool: true));
    } catch (_) {
      _unsupportedOperationCallback();
    }
  }
}
