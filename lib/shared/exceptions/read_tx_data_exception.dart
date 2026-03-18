import 'package:equatable/equatable.dart';
import 'package:snggle/shared/exceptions/read_tx_data_exception_type.dart';

class ReadTxDataException extends Equatable implements Exception {
  final ReadTxDataExceptionType readTxDataExceptionType;

  const ReadTxDataException(this.readTxDataExceptionType);

  @override
  List<Object> get props => <Object>[readTxDataExceptionType];
}
