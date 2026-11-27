import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/scan_totp_qr_page/scan_totp_qr_page.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class TwoFactorOptionsPage extends StatelessWidget {
  final bool totpExistsBool;
  final EntryModel? entryModel;
  final FilesystemPath? parentFilesystemPath;

  const TwoFactorOptionsPage({
    required this.totpExistsBool,
    this.entryModel,
    this.parentFilesystemPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          TextButton(
            onPressed: () => _handleScanQrCodePressed(context),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.connect_wallet_qr, size: 144),
                SizedBox(height: 4),
                Text('SCAN QR CODE'),
              ],
            ),
          ),
          const Spacer(flex: 30),
          TextButton(
            onPressed: () => _handleManualInputPressed(context),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AssetIcon(AppIcons.keyboard, size: 144),
                SizedBox(height: 4),
                Text('MANUAL SECRET INPUT'),
              ],
            ),
          ),
          const Spacer(flex: 200),
        ],
      ),
    );
  }

  Future<void> _handleManualInputPressed(BuildContext context) async {
    String? totpSecret = await AutoRouter.of(context).push<String>(TotpSecretRoute(totpExistsBool: totpExistsBool));

    bool newSecretPassedBool = context.mounted && totpSecret != null;
    if (newSecretPassedBool) {
      AutoRouter.of(context).pop<String>(totpSecret);
    }
  }

  Future<void> _handleScanQrCodePressed(BuildContext context) async {
    String? totpSecret = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return ScanTotpQRPage(
          entryModel: entryModel,
        );
      },
    );

    if (totpSecret != null) {
      AutoRouter.of(context).pop<String>(totpSecret);
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
          entryModel == null ? 'You will lose all data in this entry.' : 'You will lose all the changes made to this entry.',
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

  void _closeEntryFlow(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
      ..pop()
      ..pop();
  }
}
