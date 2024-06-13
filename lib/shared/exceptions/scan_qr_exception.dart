import 'package:equatable/equatable.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';

class ScanQrException extends Equatable implements Exception {
  final ScanQrExceptionType scanQrExceptionType;

  const ScanQrException(this.scanQrExceptionType);

  @override
  List<Object> get props => <Object>[scanQrExceptionType];
}
