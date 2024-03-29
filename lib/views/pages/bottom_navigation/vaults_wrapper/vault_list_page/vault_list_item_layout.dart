import 'package:flutter/material.dart';

class VaultListItemLayout extends StatelessWidget {
  final Widget iconWidget;
  final Widget titleWidget;

  const VaultListItemLayout({
    required this.iconWidget,
    required this.titleWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Material(child: iconWidget),
          ),
          const SizedBox(height: 11),
          titleWidget,
        ],
      ),
    );
  }
}
