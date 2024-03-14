import 'package:flutter/material.dart';

class VaultListItemTemplate extends StatelessWidget {
  final Widget iconWidget;
  final Widget titleWidget;

  const VaultListItemTemplate({
    required this.iconWidget,
    required this.titleWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 76,
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
      ),
    );
  }
}
