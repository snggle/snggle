import 'package:equatable/equatable.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';

class ReadTotpDataException extends Equatable implements Exception {
  final ReadTotpDataExceptionType readTotpDataExceptionType;

  const ReadTotpDataException(this.readTotpDataExceptionType);

  @override
  List<Object> get props => <Object>[readTotpDataExceptionType];
}
