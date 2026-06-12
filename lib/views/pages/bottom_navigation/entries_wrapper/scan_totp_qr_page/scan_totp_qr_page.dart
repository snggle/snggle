import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:snggle/bloc/pages/scan_totp_qr_page/scan_totp_qr_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_totp_qr_page/scan_totp_qr_page_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_msgs.dart';
import 'package:snggle/shared/exceptions/read_totp_data_exception_type.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/qr/qr_camera_scaffold.dart';

class ScanTotpQRPage extends StatefulWidget {
  final EntryModel? entryModel;

  const ScanTotpQRPage({
    required this.entryModel,
    super.key,
  });

  @override
  _ScanTotpQRPageState createState() => _ScanTotpQRPageState();
}

class _ScanTotpQRPageState extends State<ScanTotpQRPage> {
  late final ScanTotpQRPageCubit scanTotpQRPageCubit = ScanTotpQRPageCubit(
    onError: _showErrorDialog,
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
        listener: (BuildContext context, ScanTotpQRPageState scanTotpQRPageState) {
          if (scanTotpQRPageState.shouldFinishScanning()) {
            Navigator.of(context).pop(scanTotpQRPageState.secret);
          }
        },
        builder: (BuildContext context, ScanTotpQRPageState scanTotpQRPageState) {
          return QRCameraScaffold(
            title: 'SCAN',
            progressNotifier: scanTotpQRPageCubit.progressNotifier,
            onQRScanned: _handleQRScanned,
            actions: <Widget>[
              InkWell(
                onTap: _showDiscardDialog,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: AssetIcon(
                    AppIcons.app_bar_close,
                    color: AppColors.body2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showErrorDialog(ReadTotpDataExceptionType scanQrExceptionType) async {
    if (errorDialogVisibleBool) {
      return;
    }
    errorDialogVisibleBool = true;
    await showDialog(
      context: context,
      barrierColor: AppColors.body2.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return CustomDialog(
          backgroundColor: AppColors.body2.withValues(alpha: 0.5),
          title: ReadTotpDataExceptionMsgs.getTitle(scanQrExceptionType),
          content: Text(
            ReadTotpDataExceptionMsgs.getDescriptionForQR(scanQrExceptionType),
            textAlign: TextAlign.center,
          ),
          onPopInvoked: (bool didPop, Object? _) {
            if (didPop) {
              return;
            }
            scanTotpQRPageCubit.reset();
          },
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

  Future<void> _showDiscardDialog() async {
    await showDialog(
      context: context,
      barrierColor: AppColors.body2.withValues(alpha: 0.3),
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        backgroundColor: AppColors.body2.withValues(alpha: 0.5),
        title: 'Discard changes?',
        content: Text(
          widget.entryModel == null ? 'You will lose all data in this entry.' : 'You will lose all the changes made to this entry.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          CustomDialogOption(
            label: 'Discard',
            onPressed: _closeEntry,
          ),
        ],
      ),
    );
  }

  void _closeEntry() {
    Navigator.of(context, rootNavigator: true)
      ..pop()
      ..pop()
      ..pop();
  }

  void _handleQRScanned(Barcode barcode) {
    if (barcode.code != null) {
      scanTotpQRPageCubit.processQR(barcode.code!);
    }
  }
}
