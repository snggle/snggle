import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item_model.dart';

@RoutePage(name: 'BottomNavigationRoute')
class BottomNavigationWrapper extends StatefulWidget {
  const BottomNavigationWrapper({super.key});

  @override
  State<BottomNavigationWrapper> createState() => _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  final ValueNotifier<int> activeIndexNotifier = ValueNotifier<int>(0);
  final Map<int, PageRouteInfo> routes = <int, PageRouteInfo>{
    0: const VaultListRoute(),
    1: const SecretsRoute(),
    3: const AppsRoute(),
    4: const SettingsRoute(),
  };

  @override
  void dispose() {
    activeIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: routes.values.toList(),
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(child: child),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: activeIndexNotifier,
                  builder: (BuildContext context, int activeIndex, _) {
                    return CustomBottomNavigationBar(
                      selectedIndex: activeIndex,
                      onChanged: _tapNavigationItem,
                      bottomNavigationBarItems: const <CustomBottomNavigationBarItemModel>[
                        CustomBottomNavigationBarItemModel(
                          iconPath: 'assets/icons/menu_vaults.svg',
                        ),
                        CustomBottomNavigationBarItemModel(
                          iconPath: 'assets/icons/menu_secrets.svg',
                        ),
                        CustomBottomNavigationBarItemModel(
                          iconPath: 'assets/icons/menu_scan.svg',
                          largeBool: true,
                        ),
                        CustomBottomNavigationBarItemModel(
                          iconPath: 'assets/icons/menu_apps.svg',
                        ),
                        CustomBottomNavigationBarItemModel(
                          iconPath: 'assets/icons/menu_other.svg',
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

  void _tapNavigationItem(int index) {
    if (routes[index] != null) {
      AutoRouter.of(context).navigate(routes[index]!);
      activeIndexNotifier.value = index;
    }
  }
}
