import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snggle/bloc/widgets/scan_icon_cubit/scan_icon_cubit.dart';
import 'package:snggle/bloc/widgets/scan_icon_cubit/scan_icon_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/views/pages/bottom_navigation/vaults_wrapper/scan_qr_page/scan_qr_page.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/permission_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
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
  final ScanIconCubit _scanIconCubit = ScanIconCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanIconCubit, ScanIconState>(
        bloc: _scanIconCubit,
        builder: (BuildContext context, ScanIconState scanIconState) {
          return SizedBox(
            height: 64,
            child: IconButton(
              onPressed: () => _checkPermissions(_scanIconCubit, scanIconState),
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
        });
  }

  Future<void> _checkPermissions(ScanIconCubit scanIconCubit, ScanIconState scanIconState) async {
    await scanIconCubit.init();
    PermissionStatus? assignedCameraPermissionStatus = scanIconState.assignedCameraPermissionStatus;
    if (assignedCameraPermissionStatus == null) {
      PermissionStatus initialStatus = scanIconState.initialCameraPermissionStatus;
      print('INITIAL permanently denied: ${initialStatus.isPermanentlyDenied}');
      print('INITIAL granted: ${initialStatus.isGranted}');
      print('INITIAL denied: ${initialStatus.isDenied}');
      print('INITIAL limited: ${initialStatus.isLimited}');
      print('INITIAL provisional: ${initialStatus.isProvisional}');
      print('INITIAL restricted: ${initialStatus.isRestricted}');
      // if the app is reinstalled, the status is "denied"
      // if the app has "always ask" camera setting, the status is "Permanently denied"

      if (initialStatus.isPermanentlyDenied || initialStatus.isDenied) {
        PermissionStatus newStatus = await Permission.camera.request();
        scanIconCubit.assignPermission(newStatus);
        print('ASSIGNED permanently denied: ${newStatus.isPermanentlyDenied}');
        print('ASSIGNED granted: ${newStatus.isGranted}');
        print('ASSIGNED denied: ${newStatus.isDenied}');
        print('ASSIGNED limited: ${newStatus.isLimited}');
        print('ASSIGNED provisional: ${newStatus.isProvisional}');
        print('ASSIGNED restricted: ${newStatus.isRestricted}');
        if (newStatus.isGranted) {
          await _showScanQRPage();
        }
      }
    } else {
      if (assignedCameraPermissionStatus.isGranted) {
        await _showScanQRPage();
      } else {
        await _showPermissionDialog();
      }
    }
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return CustomDialog(
          backgroundColor: AppColors.body2.withOpacity(1),
          title: 'Allow camera',
          content: const Text('In order to scan, you need to allow camera permission'),
          options: const <CustomDialogOption>[
            CustomDialogOption(
              label: 'Go to settings',
              onPressed: openAppSettings,
            ),
          ],
        );
      },
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
  }

  void _closeDialog() {
    Navigator.pop(context);
  }
}
