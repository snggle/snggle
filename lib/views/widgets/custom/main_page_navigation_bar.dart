import 'package:flutter/material.dart';

class MainPageNavigationBar extends StatelessWidget {
  final int selectedIndex;

  final Function(int) onNavigationTabChanged;

  const MainPageNavigationBar({
    required this.selectedIndex,
    required this.onNavigationTabChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onNavigationTabChanged,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Vaults',
        ),
        NavigationDestination(
          icon: Icon(Icons.square_outlined),
          label: 'Secrets',
        ),
        NavigationDestination(
          icon: Icon(Icons.qr_code),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.apps_outlined),
          label: 'Apps',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
