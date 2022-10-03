import 'package:flutter/material.dart';

class ActionLayoutNavigation extends StatelessWidget {
  final List<Widget> navigationWidgets;

  const ActionLayoutNavigation({
    required this.navigationWidgets,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navigationWidgets,
      ),
    );
  }
}
