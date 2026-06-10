import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_scan_icon.dart';

@RoutePage(name: 'BottomNavigationRoute')
class BottomNavigationWrapper extends StatefulWidget {
  const BottomNavigationWrapper({super.key});

  static _BottomNavigationWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<_BottomNavigationWrapperState>()!;
  }

  @override
  State<BottomNavigationWrapper> createState() => _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  Widget? tooltipWidget;

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: <PageRouteInfo>[
        const VaultsSectionWrapperRoute(),
        EntriesSectionWrapperRoute(readOnlyBool: false),
        const AppsRoute(),
        const SettingsRoute(),
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
                child: tooltipWidget ??
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
                              assetIconData: AppIcons.bottom_navigation_apps,
                              onTap: () => tabsRouter.setActiveIndex(2),
                            ),
                            CustomBottomNavigationBarItem(
                              selectedBool: tabsRouter.activeIndex == 3,
                              assetIconData: AppIcons.bottom_navigation_menu,
                              onTap: () => tabsRouter.setActiveIndex(3),
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
      tooltipWidget = tooltip;
    });
  }

  void hideTooltip() {
    setState(() {
      tooltipWidget = null;
    });
  }
}
