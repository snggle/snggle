import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_scan_icon.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

@RoutePage(name: 'BottomNavigationRoute')
class BottomNavigationWrapper extends StatefulWidget {
  final String? successDialogMessage;

  const BottomNavigationWrapper({
    this.successDialogMessage,
    super.key,
  });

  static _BottomNavigationWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<_BottomNavigationWrapperState>()!;
  }

  @override
  State<BottomNavigationWrapper> createState() => _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  Widget? tooltipWidget;
  Animation<double>? _routeAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.successDialogMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _prepareSuccessDialog();
      });
    }
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_handleRouteAnimation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const <PageRouteInfo>[
        VaultsSectionWrapperRoute(),
        SecretsRoute(),
        SettingsRoute(),
      ],
      builder: (BuildContext context, Widget child) {
        TabsRouter tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(child: child),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:
                    tooltipWidget ??
                    ListenableBuilder(
                      listenable: tabsRouter,
                      builder: (BuildContext context, _) {
                        return CustomBottomNavigationBar(
                          bottomNavigationBarItems: <Widget>[
                            CustomBottomNavigationBarItem(
                              selectedBool: tabsRouter.activeIndex == 0,
                              assetIconData: AppIcons.bottom_navigation_crypto,
                              onTap: () => tabsRouter.setActiveIndex(0),
                            ),
                            CustomBottomNavigationBarItem(
                              selectedBool: tabsRouter.activeIndex == 1,
                              assetIconData: AppIcons.bottom_navigation_secrets,
                              onTap: () => tabsRouter.setActiveIndex(1),
                            ),
                            const CustomBottomNavigationBarScanIcon(),
                            CustomBottomNavigationBarItem(
                              selectedBool: tabsRouter.activeIndex == 2,
                              assetIconData: AppIcons.bottom_navigation_menu,
                              onTap: () => tabsRouter.setActiveIndex(2),
                            ),
                            CustomBottomNavigationBarItem(
                              selectedBool: false,
                              assetIconData: AppIcons.bottom_navigation_logout,
                              onTap: _logout,
                            ),
                          ],
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showTooltip(Widget tooltip) {
    setState(() {
      tooltipWidget = SafeArea(
        child: tooltip,
      );
    });
  }

  void hideTooltip() {
    setState(() {
      tooltipWidget = null;
    });
  }

  Future<void> _logout() async {
    AppService().logout();

    if (mounted == false) {
      return;
    }
    await context.router.root.replaceAll(
      <PageRouteInfo>[AppPinAuthRoute()],
    );
  }

  void _prepareSuccessDialog() {
    if (mounted == false) {
      return;
    }
    _routeAnimation = ModalRoute.of(context)?.animation;
    if (_routeAnimation == null || _routeAnimation!.status == AnimationStatus.completed) {
      _showSuccessDialog();
      return;
    }
    _routeAnimation!.addStatusListener(_handleRouteAnimation);
  }

  void _handleRouteAnimation(AnimationStatus animationStatus) {
    if (animationStatus != AnimationStatus.completed) {
      return;
    }
    _routeAnimation?.removeStatusListener(_handleRouteAnimation);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessDialog();
    });
  }

  Future<void> _showSuccessDialog() async {
    if (mounted == false) {
      return;
    }
    String? successDialogMessage = widget.successDialogMessage;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return CustomDialog(
          title: 'Success',
          content: Text(
            successDialogMessage!,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Done',
              autoCloseBool: false,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }
}
