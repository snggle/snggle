import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/scan_qr_page.dart';
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
        onPressed: _showScanQRPage,
        icon: ListenableBuilder(
          listenable: activeWalletController,
          builder: (BuildContext context, _) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AssetIcon(AppIcons.bottom_navigation_scan, color: widget.foregroundColor ?? AppColors.darkGrey, size: 46),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: activeWalletController.walletModel != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1, top: 1),
                            child: ClipOval(
                              child: SvgPicture.string(
                                Blockies(seed: activeWalletController.walletModel!.address).toSvg(size: 19),
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showScanQRPage() async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return const ScanQRPage();
      },
    );

    activeWalletController.notifyTransactionSigned();
  }
}
