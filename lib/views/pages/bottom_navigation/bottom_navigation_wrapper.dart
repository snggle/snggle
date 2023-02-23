import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/router/router.gr.dart';

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
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: routes.values.toList(),
      builder: (BuildContext context, Widget child, Animation<double> animation) {
        return Scaffold(
          body: child,
          bottomNavigationBar: ValueListenableBuilder<int>(
              valueListenable: activeIndexNotifier,
              builder: (BuildContext context, int activeIndex, _) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: activeIndex,
                  onTap: _tapNavigationItem,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      label: 'Vaults',
                      icon: Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.square_outlined,
                      ),
                      label: 'Secrets',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.qr_code,
                      ),
                      label: 'Scan',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.apps_outlined,
                      ),
                      label: 'Apps',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings_outlined,
                      ),
                      label: 'Settings',
                    ),
                  ],
                );
              }),
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
