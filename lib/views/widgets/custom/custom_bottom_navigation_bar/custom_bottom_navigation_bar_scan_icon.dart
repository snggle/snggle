import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/tx_data_receive_page/tx_data_receive_page.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class CustomBottomNavigationBarScanIcon extends StatefulWidget {
  final Color? foregroundColor;

  const CustomBottomNavigationBarScanIcon({
    this.foregroundColor,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomBottomNavigationBarScanIconState();
}

class _CustomBottomNavigationBarScanIconState extends State<CustomBottomNavigationBarScanIcon> {
  final ActiveWalletController activeWalletController = globalLocator<ActiveWalletController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: IconButton(
        onPressed: _showTxDataReceivePage,
        icon: AssetIcon(AppIcons.bottom_navigation_scan, color: widget.foregroundColor ?? AppColors.darkGrey, size: 46),
      ),
    );
  }

  Future<void> _showTxDataReceivePage() async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return const TxDataReceivePage(walletAutoDetectionEnabledBool: true);
      },
    );

    activeWalletController.notifyTransactionSigned();
  }
}
