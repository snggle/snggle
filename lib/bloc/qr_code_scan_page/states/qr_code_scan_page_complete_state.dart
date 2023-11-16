import 'package:snggle/bloc/qr_code_scan_page/qr_code_scan_page_cubit.dart';

class QrCodeScanPageCompleteState extends AQrCodeScanPageState {
  final String decodedString;

  const QrCodeScanPageCompleteState({
    required this.decodedString,
  });

  @override
  List<Object> get props => <Object>[decodedString];
}
