import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:snggle/bloc/pages/scan_totp_page/scan_totp_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_totp_page/scan_totp_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/infra/services/totp_service.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_msgs.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/qr/qr_camera_scaffold.dart';

class ScanTotpQRPage extends StatefulWidget {
  final EntryModel? entryModel;
  final Future<void> Function(TotpConfig config)? onTotpScanned;

  const ScanTotpQRPage({
    required this.entryModel,
    this.onTotpScanned,
    super.key,
  });

  @override
  _ScanTotpQRPageState createState() => _ScanTotpQRPageState();
}

class _ScanTotpQRPageState extends State<ScanTotpQRPage> {
  late final ScanTotpQRPageCubit scanTotpQRPageCubit = ScanTotpQRPageCubit(
    unsupportedOperationCallback: () => _showErrorDialog(ScanQrExceptionType.unsupported),
    onFinished: () => Navigator.of(context).pop(true),
    entryModel: widget.entryModel,
    onTotpScanned: widget.onTotpScanned,
  );

  bool errorDialogVisibleBool = false;

  @override
  void dispose() {
    scanTotpQRPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocConsumer<ScanTotpQRPageCubit, ScanTotpQRPageState>(
        bloc: scanTotpQRPageCubit,
        listener: (BuildContext context, ScanTotpQRPageState scanTotpQRPageState) {},
        builder: (BuildContext context, ScanTotpQRPageState scanTotpQRPageState) {
          /*if (scanTotpQRPageState.qrResultPage != null) {
            return scanTotpQRPageState.qrResultPage!;
          }*/
          return QRCameraScaffold(
            title: 'SCAN',
            progressNotifier: scanTotpQRPageCubit.progressNotifier,
            onQRScanned: _handleQRScanned,
          );
        },
      ),
    );
  }

  Future<void> _showErrorDialog(ScanQrExceptionType scanQrExceptionType) async {
    if (errorDialogVisibleBool) {
      return;
    }
    errorDialogVisibleBool = true;
    await showDialog(
      context: context,
      barrierColor: AppColors.body2.withOpacity(0.3),
      builder: (BuildContext context) {
        return CustomDialog(
          backgroundColor: AppColors.body2.withOpacity(0.5),
          title: ScanQrExceptionMsgs.getTitle(scanQrExceptionType),
          content: Text(
            ScanQrExceptionMsgs.getDescription(scanQrExceptionType),
            textAlign: TextAlign.center,
          ),
          onPopInvoked: (_) => scanTotpQRPageCubit.reset(),
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Confirm',
              onPressed: () {},
            ),
          ],
        );
      },
    );
    errorDialogVisibleBool = false;
  }

  void _handleQRScanned(Barcode barcode) {
    if (barcode.code != null) {
      scanTotpQRPageCubit.processQR(barcode.code!);
    }
  }
}
