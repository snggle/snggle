import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_totp_qr_page/scan_totp_qr_page_state.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';
import 'package:snggle/shared/utils/totp_secret_input_parser.dart';

class ScanTotpQRPageCubit extends Cubit<ScanTotpQRPageState> {
  final ValueNotifier<double> progressNotifier;
  final void Function(ReadTotpDataExceptionType type) _onError;

  ScanTotpQRPageCubit({
    required this._onError,
  }) : progressNotifier = ValueNotifier<double>(0),
       super(const ScanTotpQRPageState());

  void processQR(String data) {
    if (state.canReceiveQRCode() == false) {
      return;
    }

    try {
      String totpSecret = TotpSecretInputParser.fromInput(data, inputFromQrBool: true);
      _finishScanning(totpSecret);
    } on ReadTotpDataException catch (e) {
      _onError(e.readTotpDataExceptionType);
    } catch (e) {
      AppLogger().log(message: 'Camera received a QR code that could not be processed', logLevel: LogLevel.warning);
    }
  }

  void reset() {
    progressNotifier.value = 0;

    emit(const ScanTotpQRPageState());
  }

  Future<void> _finishScanning(String totpSecret) async {
    try {
      emit(ScanTotpQRPageState(processingQRBool: true, secret: totpSecret));
    } catch (_) {
      _onError(ReadTotpDataExceptionType.unsupported);
    }
  }
}
