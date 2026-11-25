import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/two_factor_options_page/two_factor_options_page_cubit.dart';
import 'package:snggle/bloc/pages/two_factor_options_page/two_factor_options_page_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/scan_totp_qr_page/scan_totp_qr_page.dart';
import 'package:snggle/views/pages/two_factor_options_page/two_factor_options_type.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';

@RoutePage()
class TwoFactorOptionsPage extends StatefulWidget {
  final EntryModel? entryModel;
  final FilesystemPath? parentFilesystemPath;

  const TwoFactorOptionsPage({
    this.entryModel,
    this.parentFilesystemPath,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TwoFactorOptionsPageState();
}

class _TwoFactorOptionsPageState extends State<TwoFactorOptionsPage> {
  late final TwoFactorOptionsPageCubit twoFactorOptionsPageCubit;
  bool _exportInProgressBool = false;

  @override
  void initState() {
    super.initState();
    twoFactorOptionsPageCubit = TwoFactorOptionsPageCubit(entryModel: widget.entryModel);
  }

  @override
  void dispose() {
    twoFactorOptionsPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TwoFactorOptionsPageCubit, TwoFactorOptionsPageState>(
      bloc: twoFactorOptionsPageCubit,
      builder: (BuildContext context, TwoFactorOptionsPageState state) {
        return CustomScaffold(
          title: '',
          actions: <Widget>[
            InkWell(
              onTap: () => _showDiscardDialog(context),
              child: const Padding(
                padding: EdgeInsets.only(right: 6),
                child: AssetIcon(AppIcons.app_bar_close),
              ),
            ),
          ],
          body: Column(
            children: <Widget>[
              const Text(
                '2FA OPTIONS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4,
                ),
              ),
              const Spacer(flex: 60),
              Center(
                child: TextButton(
                  onPressed: () => _handleScanQrCodePressed(context),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AssetIcon(AppIcons.connect_wallet_qr, size: 144),
                      SizedBox(height: 4),
                      Text('SCAN QR CODE', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 30),
              Center(
                child: TextButton(
                  onPressed: () => AutoRouter.of(context).pop(const TwoFactorOptionsType.manualSecretInput()),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AssetIcon(AppIcons.keyboard, size: 144),
                      SizedBox(height: 4),
                      Text('MANUAL SECRET INPUT', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 30),
              Center(
                child: TextButton(
                  onPressed: state.totpExportAvailableBool ? _handleExportPressed : null,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AssetIcon(AppIcons.export, size: 144),
                      SizedBox(height: 4),
                      Text('EXPORT TOTP SECRET', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 200),
            ],
          ),
        );
      },
    );
  }

  void _closeEntryFlow(BuildContext context) {
    Navigator.of(context, rootNavigator: true).popUntil(ModalRoute.withName(BottomNavigationRoute.name));
  }

  Future<void> _handleExportPressed() async {
    if (_exportInProgressBool) {
      return;
    }

    _exportInProgressBool = true;
    try {
      Uri? totpExportUri = await twoFactorOptionsPageCubit.getTotpExportUri();

      bool exportAvailableBool = totpExportUri != null;
      if (exportAvailableBool) {
        await _showTotpExport(context, totpExportUri);
      }
    } finally {
      _exportInProgressBool = false;
    }
  }

  Future<void> _handleScanQrCodePressed(BuildContext context) async {
    String? totpSecret = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return ScanTotpQRPage(
          entryModel: widget.entryModel,
        );
      },
    );

    bool scannedSecretAvailableBool = context.mounted && totpSecret != null;
    if (scannedSecretAvailableBool) {
      AutoRouter.of(context).pop(TwoFactorOptionsType.scanQrCode(totpSecret));
    }
  }

  Future<void> _showDiscardDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
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
            onPressed: () => _closeEntryFlow(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showTotpExport(BuildContext context, Uri totpExportUri) {
    return showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return QRResultScaffold.fromPlaintext(
          title: 'Export TOTP Secret',
          plaintext: totpExportUri.toString(),
          customPopCallback: () => Navigator.of(context).pop(),
          child: LabelWrapperVertical(
            label: '',
            bottomBorderVisibleBool: false,
            child: Text(totpExportUri.queryParameters['secret'].toString(), textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}
