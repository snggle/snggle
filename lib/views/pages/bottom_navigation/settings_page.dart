import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      title: 'Settings',
      popButtonVisible: false,
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}
